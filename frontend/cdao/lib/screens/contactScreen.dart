import 'package:cdao/widgets/common/contact/contactDialogForm.dart';
import 'package:cdao/widgets/common/web_drawer.dart';
import 'package:flutter/material.dart';
import '../widgets/common/title.dart';

class ContactScreen extends StatelessWidget {
  static const routeName = '/contact';
  const ContactScreen({super.key});

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
        body: const Center(
            child: SingleChildScrollView(
          child: Column(children: [
            SizedBox(
              height: 12,
            ),
            Text(
              '''Questions & Comments''',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
              ),
            ),
            ContactForm(),
            Text('Copyright © DAO 2023')
          ]),
        )));
  }
}
