import 'dart:convert';
import 'package:cdao/models/mintResponseModel.dart';
import 'package:cdao/models/orderConstructorModel.dart';
import 'package:cdao/providers/firebaseRTDBProvider.dart';
import 'package:cdao/providers/firestoreProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:js/js.dart';
import 'dart:js_util';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

@JS()
external purchaseFrontStart(premium, nftId, wallet);

class OrderMaker {
  String premium;
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
  late DB _db;
  late FirestoreService _firestore;
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
  Future<void> updateNftDB(status) async {
    if (premium == 'true') {
      await _db.updateNft(true, nftId, false, status);
    } else {
      await _db.updateNft(false, nftId, false, status);
    }
  }

  Future<void> updateSoldCount(available, status) async {
    if (premium == 'true') {
      await _db.incrementSold(1, true);
    } else {
      await _db.incrementSold(1, false);
    }
  }

  Future<OrderConstructorModel> signTx() async {
    var promise = purchaseFrontStart(premium, arweaveId, wallet.toLowerCase());
    var resp = await promiseToFuture(promise);
    return OrderConstructorModel.fromMap(json.decode(resp));
  }

  Future<MintResponseModel> sendTx(OrderConstructorModel oc) async {
    http.Response resp = await http.post(
        Uri.parse(const String.fromEnvironment('SIGN_MINT_SERVER_URL')),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'witness': oc.witness as String,
          'tx': oc.tx as String
        }));
    return MintResponseModel.fromMap(json.decode(resp.body));
  }

  Future<String> createOrderStore() async {
    try {
      return await _firestore.createOrderForm(
          name: name,
          street1: street1,
          street2: street2,
          city: city,
          state: state,
          zip: zip,
          phone: phone,
          email: email,
          hash: hash ?? 'placed',
          nft: nftId,
          status: 'placed');
    } catch (e) {
      return '-1';
    }
  }

  Future<bool> updateOrderStore(
      String orderIndex, String hash, String status) async {
    try {
      return await _firestore.updateOrderForm(
          id: orderIndex, hash: hash, status: status);
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, String>> placeOrder() async {
    await updateNftDB('processing');
    bool updateError = true;
    String? orderIndex;
    orderIndex = await createOrderStore();
    try {
      oc = await signTx();
      if (oc.error != null) {
        await updateNftDB('hold');
        logger.e(' oc error${oc.error.toString()}');
        await _firestore.sendError(
            error: 'placeOrder 1 ${oc.error.toString()}', order: oc.toString());
        return {
          'error':
              'Wallet Error: Sorry your purchases did not go through please try again. ${oc.error.toString()}'
        };
      }
      hash = oc.tx!.substring(1, oc.tx!.length - 1);
    } catch (e) {
      logger.e(' placeOrder Error $e');
      await _firestore.sendError(
          error: 'placeOrder 2 ${e.toString()}', order: oc.toString());
      return {'error': 'Place Order Error $e'};
    }
    try {
      mr = await sendTx(oc);
      if (mr.error != null) {
        await updateNftDB('hold');
        await _firestore.sendError(
            error: 'placeOrder 3 ${mr.error.toString()}', order: oc.toString());
        return {
          'error':
              'Minting Error: Sorry your purchases did not go through please try again. ${mr.error.toString()}'
        };
      }
      hash = mr.txhash!.substring(1, mr.txhash!.length - 1);
      if (hash != null && orderIndex != '-1') {
        updateError = await updateOrderStore(orderIndex, hash!, 'pending');
      }
    } catch (e) {
      logger.e(' sendTx Error $e');
      await _firestore.sendError(
          error: 'placeOrder 4 ${e.toString()}', order: oc.toString());
      return {'error': 'sendTx Error $e'};
    }

    try {
      await updateNftDB(hash);
      if (premium == 'true') {
        await _db.incrementSold(1, true);
      } else {
        await _db.incrementSold(1, false);
      }

      if (orderIndex == '-1' || updateError) {
        await _firestore.sendError(
            error: 'placeOrder 5 error}', order: oc.toString());
        return {
          'error':
              'Order Update Error: Your purchase was placed but we had problems updating our database with your order. Please contact us ASAP at contact@productdao.org with your transaction number: ${mr.txhash}'
        };
      } else {
        return {'hash': hash!, 'nftUrl': 'https://arweave.net/$arweaveId'};
      }
    } catch (e) {
      await _firestore.sendError(
          error: 'placeOrder 6 ${e.toString()}', order: oc.toString());
      return {'error': 'Update DB Error $e'};
    }
  }
}
