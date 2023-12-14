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
    List teamList = [{
        'name': 'Sebastián Pereira',
        'avatarURL': 'https://firebasestorage.googleapis.com/v0/b/coffee-dao-org.appspot.com/o/app%2Fteam%2FSebNFTDAO.png?alt=media&token=0fd2ec95-ff37-4aa8-abdd-9a92cffdf859&_gl=1*3x1kcp*_ga*NjM3MDAxMTM5LjE2OTQ4NjIwNzE.*_ga_CW55HF8NVT*MTY5NTk5NjE0OS42NS4xLjE2OTU5OTcwNTUuMzIuMC4w',
        'title': 'Project Lead',
        'descriptor':'',
        'linkedinLink': 'https://www.linkedin.com/in/sebastianpereira33/'
      },{
        'name': 'Juan Pablo Bulnes',
        'avatarURL': 'https://firebasestorage.googleapis.com/v0/b/coffee-dao-org.appspot.com/o/app%2Fteam%2FFoto_Juan_Pablo_Bulnes.jpg?alt=media&token=95be4140-a222-4340-92ce-9d819dcb8622&_gl=1*14imtz4*_ga*NjM3MDAxMTM5LjE2OTQ4NjIwNzE.*_ga_CW55HF8NVT*MTY5NTk5NjE0OS42NS4xLjE2OTU5OTgzMjkuNjAuMC4w',
        'title': 'Logistics Lead',
        'descriptor':'Doctor and professor at the Central American Technological University (UNITEC)',
      },{
        'name': 'Todd Cleckner',
        'avatarURL':
            'https://firebasestorage.googleapis.com/v0/b/coffee-dao-org.appspot.com/o/app%2Fteam%2FtoddSquar.png?alt=media&token=f5ee5af3-1bcb-4da0-aadc-767367701c2f',
        'title': 'Senior Software Engineer',
        'descriptor':
            'Encourage Eco-Systems, Grow Food, Tell Computers What To Do, Decentralize The Universe, Build Art, Question Everything',
        'linkedinLink': 'https://www.linkedin.com/in/todd-cleckner'
      },{
        'name': 'Ričardas Darkšas',
        'avatarURL':
            'https://firebasestorage.googleapis.com/v0/b/coffee-dao-org.appspot.com/o/app%2Fteam%2FIMG_8015.png?alt=media&token=dd95d81b-dd8f-4c76-a816-9db85cb4f4c8&_gl=1*14bu2dd*_ga*NjM3MDAxMTM5LjE2OTQ4NjIwNzE.*_ga_CW55HF8NVT*MTY5NjAxOTUyNS42OS4xLjE2OTYwMjAyMzAuNTMuMC4w',
        'title': 'Senior Backend Software Engineer',
        'descriptor':
            'Passionate about blockchain and optimization. Dedicated to making life seamlessly efficient. Exploring the intersection of technology and creativity.',
      },{
        'name': 'Rich Kopcho',
        'avatarURL': 'https://firebasestorage.googleapis.com/v0/b/coffee-dao-org.appspot.com/o/app%2Fteam%2Fteam1.png?alt=media&token=c3f94e78-7e75-4314-971a-a2e0c16d4e5e&_gl=1*7l05s*_ga*NjM3MDAxMTM5LjE2OTQ4NjIwNzE.*_ga_CW55HF8NVT*MTY5NTk5NjE0OS42NS4xLjE2OTU5OTc4ODcuNTIuMC4w',
        'title': 'Business Lead',
        'descriptor':'Talks about dao, startups, blockchain, nft uses, and digital transformation.',
        'linkedinLink': 'https://www.linkedin.com/in/kopcho/'
      },{
        'name': 'Andrew Thornhill',
        'avatarURL': 'https://firebasestorage.googleapis.com/v0/b/coffee-dao-org.appspot.com/o/app%2Fteam%2Fteam4.png?alt=media&token=08ae2186-d640-468e-8028-4b2a5d4fb5c6&_gl=1*92d4ru*_ga*NjM3MDAxMTM5LjE2OTQ4NjIwNzE.*_ga_CW55HF8NVT*MTY5NTk5NjE0OS42NS4xLjE2OTU5OTc1MzYuMTEuMC4w',
        'title': 'Marketing Advisor',
        'descriptor':'Founder of Paystars, IT Consult, Solani Creative and more. Fintech entrepreneur, lecturer and visionary.',
        'linkedinLink': 'https://www.linkedin.com/in/andrew-thornhill-194817/'
      },{
        'name': 'Eric den Boer',
        'avatarURL': 'https://firebasestorage.googleapis.com/v0/b/coffee-dao-org.appspot.com/o/app%2Fteam%2FEric.png?alt=media&token=0c335384-9cad-4c7f-96a1-20e4e1630ae9&_gl=1*1chf9ul*_ga*NjM3MDAxMTM5LjE2OTQ4NjIwNzE.*_ga_CW55HF8NVT*MTY5NjAwMDMzOS42Ni4xLjE2OTYwMDA1MDMuNDkuMC4w',
        'title': 'Advisor',
        'descriptor':'AI Entrepreneur/Innovator/Consult',
        'linkedinLink': 'https://www.linkedin.com/in/eric-db/'
      },{
        'name': 'Giezi Ordonez',
        'avatarURL': 'https://firebasestorage.googleapis.com/v0/b/coffee-dao-org.appspot.com/o/app%2Fteam%2Fteam2.png?alt=media&token=f4e15458-7642-4f28-8276-5e58e5a5c603&_gl=1*ony8dw*_ga*NjM3MDAxMTM5LjE2OTQ4NjIwNzE.*_ga_CW55HF8NVT*MTY5NjAwMDMzOS42Ni4xLjE2OTYwMDA3MTcuNDMuMC4w',
        'title': 'Advisor',
        'descriptor':'',
        'linkedinLink': 'https://www.linkedin.com/in/giezi-ordonez/'
      },{
        'name': 'Hung Quy',
        'avatarURL': 'https://firebasestorage.googleapis.com/v0/b/coffee-dao-org.appspot.com/o/app%2Fteam%2Fteam12.png?alt=media&token=1e77e03d-5c2f-48f1-bc9d-f87ab894a183&_gl=1*1k336j8*_ga*NjM3MDAxMTM5LjE2OTQ4NjIwNzE.*_ga_CW55HF8NVT*MTY5NjAwMDMzOS42Ni4xLjE2OTYwMDA3ODAuNTYuMC4w',
        'title': 'Advisor',
        'descriptor':'Social Media Moderator / Computer Engineering Student',
      },
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
            child:  TitleWidget(),
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
          const Text('Copyright © NFTDAO 2023')
        ]));
  }
}