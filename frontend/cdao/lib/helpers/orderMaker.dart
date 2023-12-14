import 'dart:convert';
import 'package:cdao/models/mintResponseModel.dart';
import 'package:cdao/models/orderConstructorModel.dart';
import 'package:cdao/providers/firebaseRTDBProvider.dart';
import 'package:cdao/providers/firestoreProvider.dart';
import 'package:js/js.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js_util';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

@JS()
external purchaseFrontStart(premium, nftId, wallet);

// This class constructs and places the order.
class OrderMaker {
  bool premium;
  String nftId;
  String arweaveId;
  String wallet;
  String name;
  String street1;
  String street2;
  String city;
  String state;
  String zip;
  String phone;
  String email;
  String? hash;
  // late FirebaseAuth _firebaseAuth;
  late final DB _db;
  late final FirestoreService _firestore;
  late MintResponseModel mr;
  late OrderConstructorModel oc;

  OrderMaker(
      this.premium,
      this.nftId,
      this.arweaveId,
      this.wallet,
      this.name,
      this.street1,
      this.street2,
      this.city,
      this.state,
      this.zip,
      this.phone,
      this.email,
      this._firestore,
      this._db);

  var logger = Logger();

  // Updates the NFT Firestore entry
  Future<void> updateNftDB(status) async {
    await _db.updateNft(premium, nftId, false, status);
  }

  // Updates the sold counter in the Realtime Database
  Future<void> updateSoldCount(available, status) async {
    await _db.incrementSold(1, premium);
  }

  // Sends the order too the Lucid service worker frontend/cdao/web/lucidFunc.js for tx creation and partial sign by user wallet
  Future<OrderConstructorModel> signTx() async {
    var promise =
        purchaseFrontStart(premium.toString(), arweaveId, wallet.toLowerCase());
    var resp = await promiseToFuture(promise);
    return OrderConstructorModel.fromMap(json.decode(resp));
  }

  // Sends the order too the Maestro cloud run instance backend/cloudRun/cloudRunMaestro where the dao signs the transaction and the transaction is sent to Maestro
  Future<MintResponseModel> sendTx(OrderConstructorModel oc) async {
    http.Response resp = await http.post(
        Uri.parse('https://maestro-52otiiaapq-uc.a.run.app/mint'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'witness': oc.witness as String,
          'tx': oc.tx as String
        }));
    return MintResponseModel.fromMap(json.decode(resp.body));
  }

  // Sends the pending order to the Firestore orders collection
  Future<bool> sendOrderToStore(MintResponseModel mr) async {
    try {
      return await _firestore.sendOrderForm(
          name: name,
          street1: street1,
          street2: street2,
          city: city,
          state: state,
          zip: zip,
          phone: phone,
          email: email,
          hash: hash!,
          nft: nftId,
          status: 'placed');
    } catch (e) {
      await _firestore.sendError(
          error: 'updateOrderStore Error ${e.toString()}');
      return false;
    }
  }

  // Order execution function
  Future<Map<String, String>> placeOrder() async {
    await updateNftDB('processing');
    try {
      oc = await signTx();
      if (oc.error != null) {
        await updateNftDB('hold');
        await _firestore.sendError(
            error: 'placeOrder signTx() oc.error ${oc.error.toString()}',
            order: oc.toString());
        return {
          'error':
              'Wallet Error: Sorry your purchases did not go through please try again. ${oc.error.toString()}'
        };
      }
      hash = oc.tx!.substring(1, oc.tx!.length - 1);
    } catch (e) {
      await _firestore.sendError(
          error: 'placeOrder signTx() Error ${e.toString()}',
          order: oc.toString());
      return {'error': 'Place Order Error $e'};
    }

    try {
      mr = await sendTx(oc);
      if (mr.error != null) {
        await updateNftDB('hold');
        await _firestore.sendError(
            error: 'placeOrder sendTx() mr.error ${mr.error.toString()}',
            order: oc.toString());
        return {
          'error':
              'Minting Error: Sorry your purchases did not go through please try again. ${mr.error.toString()}'
        };
      }
      hash = mr.txhash!.substring(1, mr.txhash!.length - 1);
    } catch (e) {
      await _firestore.sendError(
          error: 'placeOrder sendTx() Error ${e.toString()}',
          order: oc.toString());
      return {'error': 'sendTx Error $e'};
    }

    try {
      await updateNftDB(hash);
      bool orderStoreUpdatedError = await sendOrderToStore(mr);
      if (premium) {
        await _db.incrementSold(1, true);
      } else {
        await _db.incrementSold(1, false);
      }
      if (orderStoreUpdatedError) {
        await _firestore.sendError(
            error: 'placeOrder updateNftDB orderStoreUpdatedError',
            order: oc.toString());
        return {
          'error':
              'Order Update Error: Your purchase was placed but we had problems updating our database with your order. Please contact us ASAP at contact@coffeedao.org with your transaction number: ${mr.txhash}'
        };
      } else {
        return {'hash': hash!, 'nftUrl': 'https://arweave.net/$arweaveId'};
      }
    } catch (e) {
      await _firestore.sendError(
          error: 'placeOrder updateNftDB Error ${e.toString()}',
          order: oc.toString());
      return {'error': 'Update DB Error $e'};
    }
  }
}
