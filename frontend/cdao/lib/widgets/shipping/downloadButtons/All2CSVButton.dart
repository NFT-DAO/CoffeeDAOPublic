import 'dart:convert';

import 'package:cdao/models/orderModel.dart';
import 'package:cdao/providers/firestoreProvider.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:file_saver/file_saver.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class All2CSVButton extends StatefulWidget {
  final FirestoreService firestore;
  const All2CSVButton({required this.firestore, super.key});

  @override
  State<All2CSVButton> createState() => _All2CSVButtonState();
}

class _All2CSVButtonState extends State<All2CSVButton> {
  var logger = Logger();
  Future getOrd() async {
    List<List<String>> orderList = [
      [
        'Order ID (required)',
        'Order Date',
        'Order Value',
        'Requested Service',
        'Ship To - Name',
        'Ship To - Company',
        'Ship To - Address 1',
        'Ship To - Address 2',
        'Ship To - Address 3',
        'Ship To - State/Province',
        'Ship To - City',
        'Ship To - Postal Code',
        'Ship To - Country',
        'Ship To - Phone',
        'Ship To - Email',
        'Total Weight in Oz',
        'Dimensions - Length',
        'Dimensions - Width',
        'Dimensions - Height',
        'Notes - From Customer',
        'Notes - Internal',
        'Gift Wrap?',
        'Gift Message'
      ]
    ];
    List<OrderModel> orders = await widget.firestore.getOrders();
    for (OrderModel order in orders) {
      orderList.add([
        order.id,
        DateFormat('MM-dd-yyyy').format(DateTime.fromMicrosecondsSinceEpoch(
            int.parse(order.lastUpdate) * 1000)),
        '20.00',
        'Standard Shipping',
        order.name,
        '',
        order.street1,
        order.street2 ??= '',
        '',
        order.state,
        order.city,
        order.zip,
        'US',
        order.phone ??= '',
        order.email,
        '9',
        '9',
        '6',
        '3',
        '',
        '',
        '',
        ''
      ]);
    }
    String csvData = const ListToCsvConverter().convert(orderList);
    await FileSaver.instance
        .saveFile(
            name: 'cdaoAllOrders${DateTime.now().toString()}',
            bytes: const Utf8Encoder().convert(csvData),
            ext: 'csv',
            mimeType: MimeType.csv)
        .catchError((error, stackTrace) {
      logger.e('Download All CSV Error: $error');
      return error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: getOrd, child: const Text('D2CSV All'));
  }
}
