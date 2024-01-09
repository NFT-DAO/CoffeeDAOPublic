import 'package:cdao/widgets/about/teamMember.dart';
import 'package:cdao/widgets/common/web_drawer.dart';
import 'package:flutter/material.dart';

import '../widgets/common/title.dart';

class TeamScreen extends StatefulWidget {
  static const routeName = '/team';
  const TeamScreen({Key? key}) : super(key: key);

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    List teamList = [
      {
        'name': '',
        'avatarURL': '',
        'title': '',
        'descriptor': '',
        'linkedinLink': ''
      }
    ];
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
        body: Column(children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 550,
                      childAspectRatio: 1,
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 1),
                  itemCount: teamList.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return TeamMemberWidget(data: teamList[index]);
                  }),
            ),
          ),
          const Text('Copyright © DAO 2023')
        ]));
  }
}
