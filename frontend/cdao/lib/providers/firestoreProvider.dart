import 'dart:async';
import 'package:cdao/models/orderModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

class FirestoreService {
  final FirebaseAuth? _firebaseAuth;
  User? user;
  // var logger = Logger();
  FirestoreService(this._firebaseAuth) {
    if (_firebaseAuth!.currentUser == null) {
      _firebaseAuth!.signInAnonymously().then((value) async {
        user = _firebaseAuth!.currentUser;
      });
    } else {
      user = _firebaseAuth!.currentUser;
    }
  }
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var logger = Logger();
  Future<List<OrderModel>> getOrders() async {
    List<OrderModel> orders = [];
    try {
      var docSnapshot = await firestore.collection('orders').get();
      for (var result in docSnapshot.docs) {
        orders.add(OrderModel.fromMap(result.data()));
      }
      return orders;
    } catch (e) {
      logger.e('8888888888888888888888888 FirestoreService getOrders e $e ');
      return orders;
    }
  }

  Future<List<OrderModel>> getSpecificOrders(
      String field, dynamic value) async {
    List<OrderModel> orders = [];
    try {
      var docSnapshot = await firestore
          .collection('orders')
          .where(field, isEqualTo: value)
          .get();
      for (var result in docSnapshot.docs) {
        logger.e('firestore ${result.data()}');
        orders.add(OrderModel.fromMap(result.data()));
      }
      return orders;
    } catch (e) {
      logger.e('8888888888888888888888888 FirestoreService getOrders e $e ');
      return orders;
    }
  }

  Future<String> updateOrder({required OrderModel order}) async {
    try {
      await firestore
          .collection('orders')
          .doc(order.id)
          .update(order.toMap(order) as Map<Object, dynamic>);
      return 'Updated';
    } catch (e) {
      await sendError(error: 'FirestoreService updateOrder $e ${order.toString()} ');
      logger.e(
          '8888888888888888888888888 FirestoreService updateOrder e $e ');
      return 'Error:$e';
    }
  }

  Future<String> updateFieldInOrder(
      {required String id, required String field, required value}) async {
    try {
      await firestore.collection('orders').doc(id).update({field: value});
      return 'Updated';
    } catch (e) {
      logger.e(
          '8888888888888888888888888 FirestoreService updateFieldInOrder e $e ');
      return 'Error:$e';
    }
  }

  Future<String> sendContactForm(
      {required String userEmail,
      required String subject,
      required String name,
      required String emailBody}) async {
    CollectionReference mail = firestore.collection('contact');
    try {
      await mail.doc(DateTime.now().toUtc().toString()).set(
        {
          'to': userEmail,
          'name': name,
          'message': {'subject': subject, 'text': emailBody},
        },
      );
    } catch (e) {
      await sendError(error: 'FirestoreService sendContactForm $e $userEmail $subject $name $emailBody ');
      return e.toString();
    }
    return 'Contact Sent';
  }

  Future<void> sendError({required String error, String? order}) async {
    CollectionReference errors = firestore.collection('errors');
    try {
      await errors.doc(DateTime.now().toUtc().toString()).set(
        {
          'error': error,
          'order': order ?? 'null'
        },
      );
    } catch (e) {
      return;
    }
    return;
  }

  Future<String> createOrderForm({
    required String name,
    required String email,
    required String street1,
    required String street2,
    required String city,
    required String state,
    required String zip,
    required String phone,
    required String hash,
    required String nft,
    required String status
  }) async {
    CollectionReference ordersReff = firestore.collection('orders');
    bool err = false;
    late AggregateQuerySnapshot query;
    late String count;
    query = await ordersReff.count().get();
    final int iCount = query.count;
    count = (iCount + 1).toString();
    await ordersReff.doc(count.toString()).set({
      'id': count.toString(),
      'name': name,
      'street1': street1,
      'street2': street2,
      'city': city,
      'state': state,
      'zip': zip,
      'phone': phone,
      'email': email,
      'hash': hash,
      'nft': nft,
      'status': status,
      'valid':false,
      'lastUpdate': DateTime.now().toUtc(),
      'shippingEmailSent':false,
      'tracking': '',
      'selected': false
    }).catchError((e) async {
      await sendError(error: 'FirestoreService createOrderForm $e');
      logger.e('FirestoreService createOrderForm Error $e');
      err = true;
    });
    if (err){
      return '-1';
    } else {
      return count.toString();
    }
  }

  Future<bool> updateOrderForm({
    required String id,
    required String hash,
    required String status
  }) async {    
    CollectionReference ordersReff = firestore.collection('orders');
    bool err = false;
    await ordersReff.doc(id).update({
      'hash': hash,
      'status': status
    }).catchError((e) async {
      await sendError(error: 'FirestoreService updateOrderForm $e');
      logger.e('FirestoreService updateOrderForm Error $e');
      err = true;
    });
    return err;
  }
}
