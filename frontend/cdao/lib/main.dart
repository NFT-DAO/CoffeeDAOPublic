@JS()
library callable_function;

import 'firebase_options.dart';
import 'package:js/js.dart';
import 'package:cdao/providers/firebaseRTDBProvider.dart';
import 'package:cdao/providers/firestoreProvider.dart';
import 'package:cdao/providers/storageProvider.dart';
import 'package:cdao/routes/route_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

@JS('getKey')
external set _getKey(void Function() f);

String _gk() {
  return const String.fromEnvironment('MAESTRO_KEY');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  // Dev
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  _getKey = allowInterop(_gk);
  runApp(CDAO());
}

class CDAO extends StatefulWidget {
  CDAO({super.key});
  @override
  State<CDAO> createState() => _CDAOState();
}

class _CDAOState extends State<CDAO> {
  late FirebaseAuth _firebaseAuth;
  @override
  void initState() {
    super.initState();
    _firebaseAuth = FirebaseAuth.instance;
    if(_firebaseAuth.currentUser == null){
      _firebaseAuth.signInAnonymously();
    }
  }

  @override
  Widget build(BuildContext context) {
    var themeData = ThemeData(
      scaffoldBackgroundColor: const Color.fromRGBO(36, 32, 32, 1.0),
      colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color.fromRGBO(235, 165, 65, 1.0), // EBA541
          secondary: const Color.fromRGBO(156, 112, 53, 1.0),
          background: const Color.fromRGBO(36, 32, 32, 1.0)),
      textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(color: Colors.white),
          backgroundColor: const Color.fromRGBO(156, 112, 53, 1.0),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(color: Colors.white),
        ),
      ),
    );
    return MultiProvider(
        providers: [
          Provider<FirestoreService>(
            create: (context) => FirestoreService(_firebaseAuth),
          ),
          Provider<StorageService>(
            create: (context) => StorageService(_firebaseAuth),
          ),
          Provider<DB>(
            create: (context) => DB(_firebaseAuth),
          ),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: CDAORouter(_firebaseAuth).returnRouter(),
          title: 'Coffee DAO',
          theme: themeData,
        ));
  }
}
