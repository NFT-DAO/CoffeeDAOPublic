import 'dart:math';

import 'package:cdao/widgets/common/web_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/nftDbModel.dart';
import '../providers/firebaseRTDBProvider.dart';
import '../providers/storageProvider.dart';
import '../routes/route_const.dart';
import '../widgets/common/title.dart';

class RegNftsScreen extends StatefulWidget {
  static const routeName = '/nfts';
  const RegNftsScreen({Key? key}) : super(key: key);

  @override
  State<RegNftsScreen> createState() => _RegNftsScreenState();
}

class _RegNftsScreenState extends State<RegNftsScreen> {
  ScrollController scrollController = ScrollController();
  bool loaded = false;
  String? pageToken;
  late StorageService storage;
  Map<String, dynamic>? imgList;
  late DB db;
  List<NftDBModel?> availableNFT = [];
  List<NftDBModel?>? gottenNFTs;
  bool isEmpty = false;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
              scrollController.offset &&
          availableNFT.length % 10 == 0) {
        getMoreNfts();
      }
    });
    getNfts();
  }

  int minNftToShow = 50;
  Future<void> getNfts() async {
    storage = Provider.of<StorageService>(context, listen: false);
    db = Provider.of<DB>(context, listen: false);
    gottenNFTs = await db.getNfts(false);
    if (gottenNFTs == null || gottenNFTs!.isEmpty) {
      isEmpty = true;
    } else {
      availableNFT = gottenNFTs!.sublist(0, minNftToShow);
      gottenNFTs!.removeRange(0, minNftToShow);
    }
    loaded = true;
    setState(() {});
  }

  Future<void> getMoreNfts() async {
    if (gottenNFTs!.length > minNftToShow && gottenNFTs!.isNotEmpty) {
      availableNFT.addAll(gottenNFTs!.sublist(0, minNftToShow));
      gottenNFTs!.removeRange(0, minNftToShow);
    } else if (gottenNFTs!.length < minNftToShow && gottenNFTs!.isNotEmpty) {
      availableNFT.addAll(gottenNFTs!.sublist(0, gottenNFTs!.length - 1));
      gottenNFTs!.removeRange(0, gottenNFTs!.length - 1);
      isEmpty = true;
    }
    setState(() {});
  }

  Future<void> order() async {
    context.goNamed(CDAOConstants.orderRoute, pathParameters: {
      "id": availableNFT.elementAt(Random().nextInt(availableNFT.length))!.id
          as String,
      "premium": 'false',
    });
  }

  @override
  void dispose() {
    availableNFT;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double smallTextSize = width > 650 ? 25 : 15;
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
      body: !loaded
          ? const Center(child: CircularProgressIndicator())
          : availableNFT.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '''We are having issues retrieving the available NFT's please try again in a little bit.''',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: smallTextSize),
                        ),
                      ],
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      '''Half Pound of Product and a Regular NFT ₳120''',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 35),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      '''These are the Regular NFT's with a watermark.
Your NFT's will not have the watermark.''',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: smallTextSize),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          '''Go To
Premium NFT's''',
                          style: TextStyle(fontSize: 25),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      onPressed: () => context.goNamed(
                        CDAOConstants.premiumNftRoute,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Text(
                                '''Sorry, there are no more Regular NFT's left. Please see the Premium NFT's.'''),
                          )
                        : Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: GridView.builder(
                                  controller: scrollController,
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 180,
                                          childAspectRatio: 1,
                                          crossAxisSpacing: 20,
                                          mainAxisSpacing: 20),
                                  itemCount: availableNFT.length,
                                  itemBuilder: (BuildContext ctx, index) {
                                    return InkWell(
                                      onTap: () async {
                                        await showDialog(
                                            context: context,
                                            builder: (_) {
                                              return Dialog(
                                                  backgroundColor: Colors.black,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      children: [
                                                        Image.network(
                                                          availableNFT
                                                              .elementAt(index)!
                                                              .wmImageUrl as String,
                                                        ),
                                                      ],
                                                    ),
                                                  ));
                                            });
                                      },
                                      child: Image.network(
                                        availableNFT
                                            .elementAt(index)!
                                            .wmImageUrl as String,
                                        key: ValueKey(index),
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                  : null,
                                            ),
                                          );
                                        },
                                        errorBuilder: (context, url, error) =>
                                            Text('Error! $error'),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                    const Text('Copyright © DAO 2023')
                  ],
                ),
    );
  }
}
