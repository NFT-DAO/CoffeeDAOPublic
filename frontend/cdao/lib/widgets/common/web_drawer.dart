import 'package:cdao/routes/route_const.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WebDrawer extends StatelessWidget {
  const WebDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    var logoImage = Image.asset('lib/assets/images/logo.png');
    double fSize = 15;
    double iSize = 25;
    return Drawer(
      child: Material(
        color: Colors.blueGrey,
        child: ListView(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: width / 6, child: logoImage),
            ],
          ),
          ListTile(
              leading: Icon(
                Icons.home,
                color: const Color.fromRGBO(235, 165, 65, 1.0),
                size: iSize,
              ),
              title: Text(
                "  Home",
                style: TextStyle(
                    fontSize: fSize,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromRGBO(235, 165, 65, 1.0)),
              ),
              onTap: () {
                Navigator.of(context).pop();
                context.goNamed(CDAOConstants.homeRoute);
              }),
          ListTile( //TODO
            leading: Icon(
              Icons.circle,
              color: const Color.fromRGBO(235, 165, 65, 1.0),
              size: iSize,
            ),
            title: Text(
              "  Premium NFT's",
              style: TextStyle(
                  fontSize: fSize,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromRGBO(235, 165, 65, 1.0)),
            ),
            onTap: () {
              Navigator.of(context).pop();
              context.goNamed(
                  CDAOConstants.livePremiumNftRoute);
            },
          ),
          ListTile( //TODO
              leading: Icon(
                Icons.square,
                color: const Color.fromRGBO(235, 165, 65, 1.0),
                size: iSize,
              ),
              title: Text(
                "  Regular NFT's",
                style: TextStyle(
                    fontSize: fSize,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromRGBO(235, 165, 65, 1.0)),
              ),
              onTap: () async {
                Navigator.of(context).pop();
                context.goNamed(
                    CDAOConstants.liveRegNftRoute);
              }),
          // ListTile( //TODO
          //   leading: Icon(
          //     Icons.circle,
          //     color: const Color.fromRGBO(235, 165, 65, 1.0),
          //     size: iSize,
          //   ),
          //   title: Text(
          //     "  Premium NFT's",
          //     style: TextStyle(
          //         fontSize: fSize,
          //         fontWeight: FontWeight.bold,
          //         color: const Color.fromRGBO(235, 165, 65, 1.0)),
          //   ),
          //   onTap: () {
          //     Navigator.of(context).pop();
          //     context.goNamed(
          //         CDAOConstants.premiumNftRoute);
          //   },
          // ),
          // ListTile( //TODO
          //     leading: Icon(
          //       Icons.square,
          //       color: const Color.fromRGBO(235, 165, 65, 1.0),
          //       size: iSize,
          //     ),
          //     title: Text(
          //       "  Regular NFT's",
          //       style: TextStyle(
          //           fontSize: fSize,
          //           fontWeight: FontWeight.bold,
          //           color: const Color.fromRGBO(235, 165, 65, 1.0)),
          //     ),
          //     onTap: () async {
          //       Navigator.of(context).pop();
          //       context.goNamed(
          //           CDAOConstants.regNftRoute); 
          //     }),
          ListTile(
              leading: Icon(
                Icons.info,
                color: const Color.fromRGBO(235, 165, 65, 1.0),
                size: iSize,
              ),
              title: Text(
                "  Team",
                style: TextStyle(
                    fontSize: fSize,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromRGBO(235, 165, 65, 1.0)),
              ),
              onTap: () async {
                Navigator.of(context).pop();
                context.goNamed(CDAOConstants.teamRoute);
              }),
          ListTile( 
              leading: Icon(
                Icons.contact_mail,
                color: const Color.fromRGBO(235, 165, 65, 1.0),
                size: iSize,
              ),
              title: Text(
                "  Contact",
                style: TextStyle(
                    fontSize: fSize,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromRGBO(235, 165, 65, 1.0)),
              ),
              onTap: () async {
                Navigator.of(context).pop();
                context.goNamed(CDAOConstants.contactRoute);
              }),
        ]),
      ),
    );
  }
}
