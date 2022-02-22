import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmer/basewidget/farmer_base_widget.dart';
import 'package:farmer/basewidget/utils.dart';
import 'package:farmer/services/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';

import 'package:farmer/login/login_page.dart';

class ProfilePage extends FarmerBaseWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends FarmerBaseWidgetState<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String employeeName = "";
  late CollectionReference employees;
  late CollectionReference employer;

  @override
  void initState() {
    super.initState();
    employees = FirebaseFirestore.instance.collection('employees');
    employer = FirebaseFirestore.instance.collection('employer');
  }

  @override
  Widget build(BuildContext context) {
    Stream<DocumentSnapshot> profileStream = FirebaseFirestore.instance
        .collection('employees')
        .doc(user?.uid.toString())
        .snapshots();

    return StreamBuilder<DocumentSnapshot>(
        stream: profileStream,
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
                child: Text('Something went wrong. Please check back again'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text('Loading...'));
          }

          Map<String, dynamic>? data =
              snapshot.data!.data() as Map<String, dynamic>?;
          return Scaffold(
              appBar: AppBar(title: const Text('Farm')),
              body: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          key: UniqueKey(),
                          decoration: const InputDecoration(
                              icon: Icon(Icons.person),
                              hintText: 'Please enter your name',
                              labelText: "Name"),
                          initialValue:
                              data != null ? data['employee_name'] : "",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            employeeName = value;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if ((data != null &&
                                      data['employee_name'] != employeeName) ||
                                  data == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Saving data')),
                                );
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                saveToFireBase(context);
                              } else if (data != null &&
                                  data['employee_name'] == employeeName) {
                                showToast(
                                    "Please enter a different name to update");
                              }
                            }
                          },
                          child: const Text("Save")),
                      const SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            clearPrefs();
                            FirebaseService()
                                .signOutFromGoogle()
                                .whenComplete(() {
                              Route route = MaterialPageRoute(
                                  builder: (context) => const LoginPage());
                              Navigator.pushReplacement(context, route);
                            });
                          },
                          child: const Text("Sign out"))
                    ],
                  )));
        });
  }

  Future<void> saveToFireBase(BuildContext context) async {
    await employees
        .doc(user!.uid.toString())
        .set({
      "employee_name": employeeName,
    });

    // await employer
    //     .doc("employee_document")
    //     .collection('employee_collection')
    //     .doc(user!.uid.toString())
    //     .set({
    //   "employee_name": employeeName,
    //   "loginDate": "",
    //   "loginTime": "",
    //   "logoutTime": "",
    // });
  }
}
