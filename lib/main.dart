import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'services/firebase_options.dart';
import 'package:farmer/login/login_page.dart';
import 'package:farmer/home/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).whenComplete(() async => {
        await FirebaseAppCheck.instance.activate(),
        checkUser()
      });
}

Future<void> checkUser() async {
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    runApp(const MyHome());
  } else {
    runApp(const Farmer());
  }
}

class Farmer extends StatelessWidget {
  const Farmer({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Navigation Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const LoginPage());
  }
}
