import 'dart:convert';

import 'package:cdao/models/orderModel.dart';
import 'package:cdao/providers/firestoreProvider.dart';
import 'package:cdao/widgets/shipping/pathDialogWidget.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:file_saver/file_saver.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class Processing2CSVButton extends StatefulWidget {
  final FirestoreService firestore;
  const Processing2CSVButton({required this.firestore, super.key});

  @override
  State<Processing2CSVButton> createState() => _Processing2CSVButtonState();
}

class _Processing2CSVButtonState extends State<Processing2CSVButton> {
  @override
  void initState() {
    super.initState();
  }
  var logger = Logger();

  Future setup() async {
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
    List<OrderModel> orders =
        await widget.firestore.getSpecificOrders('status', 'processing');
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
            name: 'cdaoProcessingOrders${DateTime.now().toString()}',
            bytes: const Utf8Encoder().convert(csvData),
            ext: 'csv',
            mimeType: MimeType.csv)
        .then((p) =>
            showPathDialog(context, path: p).onError((error, stackTrace) {
              logger.e('Download All CSV Error: $error');
              return error;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: setup, child: const Text('D2CSV Processing'));
  }
}
