import 'dart:convert';
import 'package:cdao/providers/firebaseRTDBProvider.dart';
import 'package:flutter/material.dart';
import '../models/nftDbModel.dart';

// This class helps reset the NFT RTDB entry when the back button is used when a order is not completed.
class NavObserver extends NavigatorObserver {
  final DB db;
  NavObserver(this.db);
  Future<void> parse(String routeS) async {
    List splitMain = routeS.split(', ');

    String s1 = splitMain.elementAt(2);
    List<String> s1split = s1.split(':');
    String s1a = s1split.elementAt(0).substring(1, s1split.elementAt(0).length);
    String s1b = s1split.elementAt(1).substring(1, s1split.elementAt(1).length);
    String id = '"$s1a": "$s1b"';
    String s2 = splitMain.elementAt(3);
    List<String> s2split = s2.split(':');
    String s2a = s2split.elementAt(0).substring(0, s2split.elementAt(0).length);
    String s2b =
        s2split.elementAt(1).substring(1, s2split.elementAt(1).length - 2);
    String premium = '"$s2a": "$s2b"';
    String sr = '{$id, $premium}';
    var variables = json.decode(sr);
    NftDBModel? nft =
        await db.getOneNft(variables["premium"]!, variables["id"]!);
    String? tId = nft!.transactionId;
    if (tId == null || tId == '' || tId == 'hold') {
      await db.updateNft(variables["premium"]!, nft.id as String, true, '');
    }
    return;
  }

  @override
  Future<void> didPush(
      Route<dynamic> route, Route<dynamic>? previousRoute) async {
    if (route.toString().contains('order') && previousRoute == null) {
      parse(route.toString());
    }
    if (route.toString().contains('live-premium') &&
            previousRoute.toString().contains('order') ||
        route.toString().contains('live-nfts') &&
            previousRoute.toString().contains('order')) {
      parse(previousRoute.toString());
    }
  }
}
