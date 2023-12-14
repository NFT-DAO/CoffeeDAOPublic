import 'dart:async';
import 'dart:math';
import 'package:cdao/providers/firestoreProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';
import '../models/nftDbModel.dart';

class DB {
  List<NftDBModel>? _nftlist;
  List<NftDBModel>? get nftlist => _nftlist;
  late final FirebaseAuth? _firebaseAuth;
  late FirestoreService _firestore;
  User? user;
  final _db = FirebaseDatabase.instance.ref();

  DB(this._firebaseAuth) {
    if (_firebaseAuth!.currentUser == null) {
      _firebaseAuth!.signInAnonymously().then((value) async {
        user = _firebaseAuth!.currentUser;
      });
    } else {
      user = _firebaseAuth!.currentUser;
    }
    _firestore = FirestoreService(_firebaseAuth);
  }
  var logger = Logger();

  Future<List<NftDBModel?>> getNfts(bool premium) async {
    String child = '';
    List<NftDBModel> nlist = [];
    if (premium) {
      child = 'nfts';
    } else {
      child = 'regularNfts';
    }
    await _db
        .child(child)
        .orderByChild("available")
        .equalTo(true)
        .get()
        .then((value) {
      if (premium) {
        try {
          Map<dynamic, dynamic> values = value.value as Map<dynamic, dynamic>;
          values.forEach((key, data) {
            if (key != null && data != null) {
              nlist.add(NftDBModel.fromRTDB(data));
            }
          });
        } catch (e) {
          _firestore.sendError(error: 'GetNfts error $e');
        }
      } else {
        try {
          for (var x in value.value as List<dynamic>) {
            try {
              Map<String, dynamic> z = x as Map<String, dynamic>;
              nlist.add(NftDBModel.fromRTDB(z));
            } catch (e) {
              _firestore.sendError(error: 'GetNfts error $e');
            }
          }
        } catch (e) {
          _firestore.sendError(error: 'GetNfts error $e');
        }
      }
    });
    return nlist;
  }

  Future<bool?> getNftAvailability(bool premium, String id) async {
    bool ava = false;
    String child = '';
    if (premium) {
      child = 'nfts/$id';
    } else {
      child = 'regularNfts/$id';
    }
    await _db.child(child).once().then((value) {
      try {
        Map<dynamic, dynamic> values =
            value.snapshot.value as Map<dynamic, dynamic>;
        ava = values['available'];
        return ava;
      } catch (e) {
        _firestore.sendError(error: 'GetNftAvailability() try catch error $e');
      }
    });
    return ava;
  }

  Future<NftDBModel?> getOneNft(bool premium, String id) async {
    NftDBModel? nftm;
    String child = '';
    if (premium) {
      child = 'nfts/$id';
    } else {
      child = 'regularNfts/$id';
    }
    await _db.child(child).once().then((value) {
      try {
        Map<dynamic, dynamic> values =
            value.snapshot.value as Map<dynamic, dynamic>;
        nftm = NftDBModel.fromRTDB(values);
        return nftm;
      } catch (e) {
        _firestore.sendError(error: 'GetOneNft() try catch error $e');
      }
    }).onError((error, stackTrace) {
      _firestore.sendError(error: 'GetOneNft error $error ');
      throw 'getNft error $error';
    });
    return nftm;
  }

  Future<void> incrementSold(int amount, bool premium) async {
    await _db.update({
      'totalSold': ServerValue.increment(amount),
    }).onError((error, stackTrace) => _firestore.sendError(
        error: 'UpdateNft update({totalMinted error $error '));
    if (!premium) {
      await _db.update({
        'totalRegularMinted': ServerValue.increment(amount),
      }).onError((error, stackTrace) => _firestore.sendError(
          error: 'UpdateNft update({totalMinted error $error '));
    } else {
      await _db.update({
        'totalPremiumMinted': ServerValue.increment(amount),
      }).onError((error, stackTrace) => _firestore.sendError(
          error: 'UpdateNft update({totalMinted error $error '));
    }
    return;
  }

  Future<void> updateNft(
      bool premium, String nftId, bool b, String transId) async {
    String child = '';
    if (premium) {
      child = 'nfts/$nftId';
    } else {
      child = 'regularNfts/$nftId';
    }
    await _db.child(child).update({
      'available': b,
      'transactionId': transId,
      'lastUpdate': DateTime.now().toUtc().millisecondsSinceEpoch
    }).onError((error, stackTrace) => _firestore.sendError(
        error: 'UpdateNft update({available) error $error '));
    return;
  }

  Future<void> notifyEntry(String email) async {
    var intValue = Random().nextInt(500000);
    await _db.child('notifyMe').update({intValue.toString(): email}).onError(
        (error, stackTrace) =>
            _firestore.sendError(error: 'Notify Entry error $error '));
    return;
  }
}
