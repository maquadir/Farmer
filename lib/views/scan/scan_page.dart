import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmer/basewidget/farmer_base_widget.dart';
import 'package:farmer/basewidget/utils.dart';
import 'package:farmer/scan/qr_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScanPage extends FarmerBaseWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  ScanPageState createState() => ScanPageState();
}

class ScanPageState extends FarmerBaseWidgetState<ScanPage> {
  bool loggedInToday = false;

  @override
  Widget build(BuildContext context) {
    Stream<DocumentSnapshot> employeeProfile = FirebaseFirestore.instance
        .collection('employees')
        .doc(user?.uid.toString())
        .snapshots();

    Stream<DocumentSnapshot> employeeLogin = FirebaseFirestore.instance
        .collection('employees')
        .doc(user?.uid.toString())
        .collection('employee_collection')
        .doc(getTodaysDate())
        .snapshots();

    return StreamBuilder<DocumentSnapshot>(
        stream: employeeProfile,
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
                child: Text('Something went wrong. Please check back again'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text('Loading...'));
          }

          Map<String, dynamic>? profileData =
              snapshot.data!.data() as Map<String, dynamic>?;
          return Scaffold(
              appBar: AppBar(title: const Text('Farm')),
              body: Center(
                child: StreamBuilder<DocumentSnapshot>(
                    stream: employeeLogin,
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text("Loading");
                      }

                      Map<String, dynamic>? data =
                          snapshot.data!.data() as Map<String, dynamic>?;

                      var loggedIn = data != null
                          ? data['loginTime']?.toString().isNotEmpty
                          : false;
                      var loggedOut = data != null
                          ? data['logoutTime']?.toString().isNotEmpty
                          : false;

                      if (loggedOut == true) {
                        return const Text(
                          "Good work today.\n Let's do the same tomorrow",
                          style: TextStyle(fontSize: 20),
                        );
                      }

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          (loggedIn == true)
                              ? const Text(
                                  "Welcome to the farm. you are Logged in",
                                  style: TextStyle(fontSize: 20),
                                )
                              : const Text(
                                  "Please sign in to the farm",
                                  style: TextStyle(fontSize: 20),
                                ),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (loggedIn == true) {
                                if (profileData != null &&
                                    profileData['employee_name'].isNotEmpty) {
                                  var employeeName =
                                      profileData['employee_name'];
                                  saveToFireBase(context, employeeName);
                                }
                              } else {
                                if (profileData != null &&
                                    profileData['employee_name'].isNotEmpty) {
                                  var employeeName =
                                      profileData['employee_name'];
                                  _navigateAndDisplayScanResult(
                                      context, employeeName);
                                } else {
                                  showAlertDialog(
                                      "Error",
                                      "Please complete your profile to proceed",
                                      context);
                                }
                              }
                            },
                            child: (loggedIn == true)
                                ? const Text('Sign out')
                                : const Text('Open Camera to Scan'),
                          )
                        ],
                      );
                    }),
              ));
        });
  }

  Future<void> saveToFireBase(BuildContext context, String employeeName) async {
    CollectionReference employees =
        FirebaseFirestore.instance.collection('employees');
    CollectionReference employer =
        FirebaseFirestore.instance.collection('employer');

    await employees
        .doc(user!.uid.toString())
        .collection('employee_collection')
        .doc(getTodaysDate())
        .update({"logoutTime": getTodaysTime()});

    await employer
        .doc(getTodaysDate())
        .collection('employee_collection')
        .doc(user!.uid.toString())
        .update({
      "logoutTime": getTodaysTime(),
    });
  }

  // A method that launches the SelectionScreen and awaits the result from
  // Navigator.pop.
  void _navigateAndDisplayScanResult(
      BuildContext context, String employeeName) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRScreen(
          employeeName: employeeName,
        ),
      ),
    ).then((result) => showToast(result));
  }
}
