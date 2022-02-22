import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class Success extends StatelessWidget {
  final Barcode? result;

  const Success({Key? key, required this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text(
          'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}'),
    );
  }
}
