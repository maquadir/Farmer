import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class FarmerBaseWidget extends StatefulWidget{
  const FarmerBaseWidget({Key? key}) : super(key: key);

  @override
  FarmerBaseWidgetState createState() => FarmerBaseWidgetState();
}

class FarmerBaseWidgetState<T extends FarmerBaseWidget> extends State<T>{

  User? user;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  FirebaseAppCheck appCheck = FirebaseAppCheck.instance;

  @override
  void initState(){
    super.initState();
    initFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  void initFirebase() {
    FirebaseFirestore.instance.settings =
    const Settings(persistenceEnabled: false);
    FirebaseFirestore.instance.clearPersistence();
    user = FirebaseAuth.instance.currentUser;
  }
}