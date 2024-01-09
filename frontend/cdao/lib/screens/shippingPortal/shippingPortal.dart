import 'package:cdao/models/orderModel.dart';
import 'package:cdao/providers/firestoreProvider.dart';
import 'package:cdao/widgets/shipping/downloadButtons/Processing2CSVButton.dart';
import 'package:cdao/widgets/shipping/downloadButtons/Selected2CSVButton.dart';
import 'package:cdao/widgets/shipping/downloadButtons/All2CSVButton.dart';
import 'package:cdao/widgets/common/scrollableWidget.dart';
import 'package:cdao/widgets/shipping/textDialogWidget.dart';
import 'package:cdao/widgets/common/title.dart';
import 'package:cdao/widgets/common/web_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PortalScreen extends StatefulWidget {
  static const routeName = '/portal';
  final FirebaseAuth firebaseAuth;
  const PortalScreen({required this.firebaseAuth, Key? key}) : super(key: key);

  @override
  State<PortalScreen> createState() => _PortalScreenState();
}

class _PortalScreenState extends State<PortalScreen> {
  bool showLogIn = false;
  late FirestoreService firestore;
  int sortColumnIndex = 0;
  bool isAscending = false;
  List<OrderModel> ord = [];
  @override
  void initState() {
    super.initState();
    firestore = FirestoreService(widget.firebaseAuth);
  }

  void onSort(int columnIndex, bool ascending) {
    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
    if (sortColumnIndex == 0) {
      ord.sort((OrderModel order1, OrderModel order2) => isAscending
          ? order1.selected.toString().compareTo(order2.selected.toString())
          : order2.selected.toString().compareTo(order1.selected.toString()));
    } else if (sortColumnIndex == 1) {
      ord.sort((OrderModel order1, OrderModel order2) => isAscending
          ? order1.status.compareTo(order2.status)
          : order2.status.compareTo(order1.status));
    } else if (sortColumnIndex == 2) {
      ord.sort((OrderModel order1, OrderModel order2) => isAscending
          ? order1.id.compareTo(order2.id)
          : order2.id.compareTo(order1.id));
    } else if (sortColumnIndex == 3) {
      ord.sort((OrderModel order1, OrderModel order2) => isAscending
          ? order1.name.compareTo(order2.name)
          : order2.name.compareTo(order1.name));
    }
  }

  Future firstSort() async {
    ord.sort((OrderModel order1, OrderModel order2) => isAscending
        ? order1.status.compareTo(order2.status)
        : order2.status.compareTo(order1.status));
  }

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          shadowColor: Theme.of(context).scaffoldBackgroundColor,
          toolbarHeight: 100,
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
            child: IconButton(
              onPressed: () {
                scaffoldKey.currentState?.openDrawer();
              },
              icon: const Icon(Icons.menu),
              color: const Color.fromRGBO(235, 165, 65, 1.0),
              iconSize: 30,
            ),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: const Padding(
            padding: EdgeInsets.all(8.0),
            child: TitleWidget(),
          ),
          centerTitle: true,
        ),
        drawer: const WebDrawer(),
        body: StreamBuilder<QuerySnapshot>(
          stream: firestore.firestore.collection('orders').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<OrderModel> ordersData = [];
              for (var result in snapshot.data!.docs) {
                ordersData.add(
                    OrderModel.fromJson(result.data() as Map<String, dynamic>));
              }
              ord = ordersData;
              firstSort();
              // onSort;
              return ScrollableWidget(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 15,
                        ),
                        Selected2CSVButton(firestore: firestore),
                        const SizedBox(
                          width: 15,
                        ),
                        Processing2CSVButton(firestore: firestore),
                        const SizedBox(
                          width: 15,
                        ),
                        All2CSVButton(firestore: firestore),
                        const SizedBox(
                          width: 15,
                        ),
                      ],
                    ),
                  ),
                  buildDataTable(),
                ],
              ));
            } else {
              return const CircularProgressIndicator();
            }
          },
        ));
  }

  Widget buildDataTable() {
    final columns = [
      'Selected',
      'Order Status/Edit',
      'Valid',
      'Id',
      'Name',
      'Street',
      'Street 2',
      'City',
      'State',
      'Zip',
      'Email',
      'Phone',
      'Tracking #'
    ];

    return DataTable(
      sortAscending: isAscending,
      sortColumnIndex: sortColumnIndex,
      dataTextStyle: const TextStyle(color: Colors.black),
      columns: getColumns(columns),
      rows: getRows(),
    );
  }

  List<DataColumn> getColumns(List<String> columns) {
    return columns.map((String column) {
      return DataColumn(
          onSort: onSort,
          label: Text(
            column,
            style: const TextStyle(color: Colors.black),
          ));
    }).toList();
  }

  List<DataRow> getRows() {
    List<DataRow> dr = [];
    for (OrderModel o in ord) {
      dr.add(DataRow(cells: [
        DataCell(
          Switch(
            value: o.selected,
            inactiveThumbColor: Colors.black,
            inactiveTrackColor: Colors.black12,
            activeColor: Colors.orange,
            onChanged: (bool value) {
              firestore.updateFieldInOrder(
                  id: o.id, field: 'selected', value: !o.selected);
            },
          ),
        ),
        DataCell(
            Text(
              o.status,
              style: const TextStyle(color: Colors.black),
            ),
            showEditIcon: o.valid ? true : false, onTap: () {
          editOrder(o);
        }),
        DataCell(Text(
          o.valid.toString(),
          style: const TextStyle(color: Colors.black),
        )),
        DataCell(Text(
          o.id,
          style: const TextStyle(color: Colors.black),
        )),
        DataCell(Text(
          o.name,
          style: const TextStyle(color: Colors.black),
        )),
        DataCell(Text(
          o.street1,
          style: const TextStyle(color: Colors.black),
        )),
        DataCell(Text(
          o.street2 ??= '',
          style: const TextStyle(color: Colors.black),
        )),
        DataCell(Text(
          o.city,
          style: const TextStyle(color: Colors.black),
        )),
        DataCell(Text(
          o.state,
          style: const TextStyle(color: Colors.black),
        )),
        DataCell(Text(
          o.zip,
          style: const TextStyle(color: Colors.black),
        )),
        DataCell(Text(
          o.email,
          style: const TextStyle(color: Colors.black),
        )),
        DataCell(Text(
          o.phone ??= '',
          style: const TextStyle(color: Colors.black),
        )),
        DataCell(Text(
          o.tracking ??= '',
          style: const TextStyle(color: Colors.black),
        )),
      ]));
    }
    return dr;
  }

  Future editOrder(OrderModel editOrder) async {
    OrderModel resp = await showTextDialog(context, order: editOrder);

    await firestore.updateOrder(order: resp);
  }
}
