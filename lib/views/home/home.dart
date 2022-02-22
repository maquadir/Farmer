import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmer/basewidget/farmer_base_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:farmer/scan/scan_page.dart';
import 'package:farmer/record/record_page.dart';
import 'package:farmer/profile/profile_page.dart';

class MyHome extends FarmerBaseWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  MyHomeState createState() => MyHomeState();
}

class MyHomeState extends FarmerBaseWidgetState<MyHome> {

  int _selectedIndex = 0;

  _getScreenFromSelectedItem(int pos) {
    switch (pos) {
      case 0:
        return const ScanPage();
      case 1:
        return const RecordPage();
      case 2:
        return const ProfilePage();
      default:
        return const Text("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Builder(
            builder: (context) =>
                Scaffold(
                  bottomNavigationBar: BottomNavigationBar(
                    selectedItemColor: Theme
                        .of(context)
                        .textSelectionTheme
                        .selectionColor,
                    items: const <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: Icon(Icons.camera),
                        label: 'Scan',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.receipt),
                        label: 'Record',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.account_box),
                        label: 'Profile',
                      ),
                    ],
                    onTap: (value) {
                      setState(() {
                        _selectedIndex = value;
                      });
                    },
                    currentIndex: _selectedIndex,
                  ),
                  body: _getScreenFromSelectedItem(_selectedIndex),
                )));
  }
}
