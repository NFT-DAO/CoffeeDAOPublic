import 'package:cdao/providers/firebaseRTDBProvider.dart';
import 'package:cdao/routes/route_const.dart';
import 'package:cdao/screens/shippingPortal/signin.dart';
import 'package:cdao/screens/shippingPortal/shippingPortal.dart';
import 'package:cdao/screens/teamScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/breakpoint.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';

import '../screens/contactScreen.dart';
import '../screens/homeScreen.dart';
import '../screens/livePremiumNftsScreen.dart';
import '../screens/liveRegNftsScreen.dart';
import '../screens/orderFormScreen.dart';
import '../screens/premiumNftsScreen.dart';
import '../screens/receiptScreen.dart';
import '../screens/regNftsScreen.dart';
import 'navigatorObserver.dart';

class CDAORouter {
  final FirebaseAuth _firebaseAuth;
  final DB db;
  User? user;
  CDAORouter(this.db, this._firebaseAuth);
  GoRouter returnRouter() {
    GoRouter router = GoRouter(
      observers: [
        NavObserver(db),
      ],
      routes: <RouteBase>[
        GoRoute(
          name: CDAOConstants.homeRoute,
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return const ResponsiveBreakpoints(
              breakpoints: [
                Breakpoint(start: 0, end: 450, name: MOBILE),
                Breakpoint(start: 451, end: 800, name: TABLET),
                Breakpoint(start: 801, end: 1920, name: DESKTOP),
                Breakpoint(start: 1921, end: double.infinity, name: '4K'),
              ], child: HomeScreen());
          },
        ),
        GoRoute(
          name: CDAOConstants.regNftRoute,
          path: '/nfts',
          builder: (BuildContext context, GoRouterState state) {
            return const ResponsiveBreakpoints(
              breakpoints: [
                Breakpoint(start: 0, end: 450, name: MOBILE),
                Breakpoint(start: 451, end: 800, name: TABLET),
                Breakpoint(start: 801, end: 1920, name: DESKTOP),
                Breakpoint(start: 1921, end: double.infinity, name: '4K'),
              ], child: RegNftsScreen());
          },
        ),
        GoRoute(
          name: CDAOConstants.premiumNftRoute,
          path: '/premium',
          builder: (BuildContext context, GoRouterState state) {
            return const PremiumNftsScreen();
          },
        ),
        GoRoute(
          name: CDAOConstants.signin,
          path: '/signin',
          builder: (BuildContext context, GoRouterState state) {
            return SignInScreen(firebaseAuth: _firebaseAuth);
          },
        ),
        GoRoute(
          name: CDAOConstants.portal,
          path: '/portal',
          builder: (BuildContext context, GoRouterState state) {
            return PortalScreen(firebaseAuth: _firebaseAuth);
          },
        ),
        GoRoute(
          name: CDAOConstants.liveRegNftRoute,
          path: '/live-nfts',
          builder: (BuildContext context, GoRouterState state) {
            return const LiveRegNftsScreen();
          },
        ),
        GoRoute(
          name: CDAOConstants.livePremiumNftRoute,
          path: '/live-premium',
          builder: (BuildContext context, GoRouterState state) {
            return const ResponsiveBreakpoints(
              breakpoints: [
                Breakpoint(start: 0, end: 450, name: MOBILE),
                Breakpoint(start: 451, end: 800, name: TABLET),
                Breakpoint(start: 801, end: 1920, name: DESKTOP),
                Breakpoint(start: 1921, end: double.infinity, name: '4K'),
              ], child: LivePremiumNftsScreen(),
            );
          },
        ),
        GoRoute(
          name: CDAOConstants.teamRoute,
          path: '/team',
          builder: (BuildContext context, GoRouterState state) {
            return const TeamScreen();
          },
        ),
        GoRoute(
          name: CDAOConstants.contactRoute,
          path: '/contact',
          builder: (BuildContext context, GoRouterState state) {
            return const ContactScreen();
          },
        ),
        GoRoute(
            name: CDAOConstants.orderRoute,
            path: '/order/:id/:premium',
            builder: (BuildContext context, GoRouterState state) =>
                OrderFormScreen(
                  id: state.pathParameters["id"] as String,
                  prem: state.pathParameters["prem"] as String,
                )),
        GoRoute(
          name: CDAOConstants.receiptRoute,
          path: '/receipt/:data',
          builder: (BuildContext context, GoRouterState state) =>
              ReceiptScreen(data: state.pathParameters["data"] as String),
        ),
      ],
    );
    return router;
  }
}
