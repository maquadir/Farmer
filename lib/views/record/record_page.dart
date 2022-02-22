import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmer/basewidget/farmer_base_widget.dart';
import 'package:farmer/basewidget/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';

class RecordPage extends FarmerBaseWidget {
  const RecordPage({Key? key}) : super(key: key);

  @override
  RecordPageState createState() => RecordPageState();
}

class RecordPageState extends FarmerBaseWidgetState<RecordPage> {
  var loggedOut = false;
  late Stream<QuerySnapshot> employeeLogin;
  late Stream<QuerySnapshot> employeeCollection;

  @override
  Widget build(BuildContext context) {
    if (user!.uid == "uf6a3TqMAHOjnWWJ2cLcEtyPEth2") {
      employeeLogin =
          FirebaseFirestore.instance.collection('employees').snapshots();
    } else {
      employeeLogin = FirebaseFirestore.instance
          .collection('employees')
          .doc(user?.uid.toString())
          .collection('employee_collection')
          .snapshots();
    }

    final Stream<QuerySnapshot> employerLogin =
        FirebaseFirestore.instance.collection('employer').snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: employeeLogin,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text("Loading"));
        }

        var count = snapshot.data!.docs.length;

        if (user!.uid == "uf6a3TqMAHOjnWWJ2cLcEtyPEth2") {
          return (count > 0
              ? Scaffold(
                  appBar: AppBar(title: Text("Employees")),
                  body: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: count,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      var record = snapshot.data!.docs[index];
                      print(record.get("employee_name"));
                      // employeeCollection = FirebaseFirestore.instance
                      //     .doc(record.id)
                      //     .collection('employee_collection')
                      //     .snapshots();
                      return Column(children: [
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          child: Text("${record.get("employee_name")}",
                          style: const TextStyle(fontSize: 20)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QRScreen(
                                  employeeName: employeeName,
                                ),
                              ),
                            )
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.amber,
                              boxShadow: const [
                                BoxShadow(color: Colors.black, spreadRadius: 1),
                              ],
                            ),
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  // Text(
                                  //     "logged in at - ${record.get("loginTime")} "),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  // Text(!loggedOut
                                  //     ? "Not yet logged out"
                                  //     : "logged out at - ${record.get("logoutTime")} ")
                                ],
                              ),
                            ))
                      ]);
                    },
                  ))
              : const Center(
                  child: Text(
                  "No Records",
                  style: TextStyle(fontSize: 22),
                )));
        } else {
          return (count > 0
              ? ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: count,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    late var record;
                    record = snapshot.data!.docs[index];
                    loggedOut = record.data().toString().contains('logoutTime');
                    return Column(children: [
                      const SizedBox(
                        height: 40,
                      ),
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.amber,
                            boxShadow: const [
                              BoxShadow(color: Colors.black, spreadRadius: 1),
                            ],
                          ),
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Text(
                                  "Date ${record.id}",
                                  style: const TextStyle(fontSize: 20),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                    "logged in at - ${record.get("loginTime")} "),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(!loggedOut
                                    ? "Not yet logged out"
                                    : "logged out at - ${record.get("logoutTime")} ")
                              ],
                            ),
                          ))
                    ]);
                  },
                )
              : const Center(
                  child: Text(
                  "No Records",
                  style: TextStyle(fontSize: 22),
                )));
        }
      },
    );
  }
}
