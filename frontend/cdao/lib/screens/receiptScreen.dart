import 'dart:convert';

import 'package:cdao/widgets/common/contact/contactDialog.dart';
import 'package:cdao/widgets/common/web_drawer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/common/title.dart';
import '../routes/route_const.dart';

class ReceiptScreen extends StatefulWidget {
  String data;
  ReceiptScreen({required this.data, Key? key}) : super(key: key);

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  late Map param;
  bool loading = true;
  late String url;

  Future<void> inni() async {
    param = await json.decode(widget.data);
    url = 'https://cardanoscan.io/transaction/${param['hash']}'; //TODO
    loading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    inni();
  }

  Future<void> launchInBrowser() async {
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
        body: Center(
            child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: loading
                ? const CircularProgressIndicator()
                : Column(
                    children: [
                      const Text(
                        'Thank You For Your Purchase!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 60,
                            color: Color.fromRGBO(235, 165, 65, 1.0)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Image.network(param['nftUrl']),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Your Purchases Confirmation Hash:',
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(color: Color.fromRGBO(235, 165, 65, 1.0)),
                      ),
                      Text(
                        param['hash'],
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'You can view your purchase on the Cardano blockchain explorer CardanoScan.io:',
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(color: Color.fromRGBO(235, 165, 65, 1.0)),
                      ),
                      TextButton(
                          onPressed: () => setState(() {
                                launchInBrowser();
                              }),
                          child: Text(
                            url,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.blue,
                            ),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'SHIPPING',
                        style:
                            TextStyle(color: Color.fromRGBO(235, 165, 65, 1.0)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        '''Your product will be shipped by with in a week from ordering. Be on the look out for update emails about your order from contact@productdao.org. Feel free to reach out to us at the same email if you have any questions concerning your order.''',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            context.goNamed(CDAOConstants.livePremiumNftRoute);
                          },
                          child: const Text(
                            '''More Product & NFT's?''',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const Text(
                        '''Having Troubles or Questions
Contact Us at contact@productdao.me or via the contact form.''',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      IconButton(
                        alignment: Alignment.bottomCenter,
                        color: const Color.fromRGBO(156, 112, 53, 1.0),
                        icon: const Icon(Icons.contact_mail_rounded),
                        onPressed: () {
                          showDialog(
                              barrierColor: Colors.blueGrey,
                              builder: (BuildContext context) {
                                return const ContactDialog();
                              },
                              context: context);
                        },
                      ),
                      const Text('Copyright © DAO 2023')
                    ],
                  ),
          ),
        )));
  }
}
