import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:liquor_inventory/utils/config/palette.dart';

class ScanItem extends StatefulWidget {
  const ScanItem({Key? key}) : super(key: key);

  @override
  _ScanItemState createState() => _ScanItemState();
}

class _ScanItemState extends State<ScanItem> {
  // if scan result is non-empty, navigate to add item page with string result as argument, see router.dart
  String? scanResult;

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: Palette.accentedRed,
      elevation: 4.0,
      child: IconButton(
        onPressed: scanBarCode,
        icon: const Icon(Icons.qr_code_scanner),
        color: Colors.white,
      ),
    );
  }

  Future scanBarCode() async {
    String scanResult;

    try {
      scanResult = await FlutterBarcodeScanner.scanBarcode(
        "#ff1a00",
        "Cancel Scan",
        true,
        ScanMode.BARCODE,
      );
    } on PlatformException {
      scanResult = "Failed to get platform version";
    }

    if (!mounted) return;

    setState(() {
      this.scanResult = scanResult;
      //TODO: Goto Add Item Form
    });
  }
}
