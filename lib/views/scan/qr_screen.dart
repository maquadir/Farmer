import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmer/basewidget/farmer_base_widget.dart';
import 'package:farmer/basewidget/utils.dart';
import 'package:farmer/scan/success.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScreen extends FarmerBaseWidget {
  final String employeeName;

  const QRScreen({Key? key, required this.employeeName}) : super(key: key);

  @override
  _QRScreenState createState() => _QRScreenState();
}

class _QRScreenState extends FarmerBaseWidgetState<QRScreen> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool scannedOnce = false;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void initState() {
    super.initState();
    scannedOnce = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildQrView(context));
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    controller.scannedDataStream.listen((scanData) async {
      if (!scannedOnce) {
        scannedOnce = true;

        String time = getTodaysTime();
        String date = getTodaysDate();

        saveToFireBase(context, time, date).whenComplete(() =>
            Navigator.pop(context, "You have signed in. Welcome to the farm"));
      }
    });
  }

  Future<void> saveToFireBase(
      BuildContext context, String time, String date) async {
    CollectionReference employees =
        FirebaseFirestore.instance.collection('employees');
    CollectionReference employer =
        FirebaseFirestore.instance.collection('employer');

    await employees
        .doc(user!.uid.toString())
        .collection('employee_collection')
        .doc(date.toString())
        .set({"loginTime": time, "logoutTime": ""});

    await employer
        .doc(date.toString())
        .collection("employee_collection")
        .doc(user!.uid.toString())
        .set({
      "employee_name": widget.employeeName,
      "loginDate": date,
      "loginTime": time,
      "logoutTime": ""
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
