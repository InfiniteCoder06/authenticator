// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// 🌎 Project imports:
import 'package:authenticator/core/router/app.router.dart';
import 'package:authenticator/core/utils/mixin/console.mixin.dart';
import 'package:authenticator/core/utils/otp.util.dart';

part 'scan.controller.g.dart';

@riverpod
class ScanController extends _$ScanController with ConsoleMixin {
  @override
  MobileScannerController build() {
    postInit();
    return MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      formats: [BarcodeFormat.qrCode],
      detectionTimeoutMs: 1000,
    );
  }

  void postInit() async {
    console.info("⚙️ Initialize");
  }

  Future<void> onDetect(BuildContext context, BarcodeCapture capture) async {
    state.stop();
    final List<Barcode> barcodes = capture.barcodes;

    if (barcodes.first.rawValue != null) {
      final result = OtpUtils.parseURI(Uri.parse(barcodes.first.rawValue!));
      result.match(
          (error) => showErrorDialog(context, error),
          (item) => Navigator.of(context).pushNamed(AppRouter.details.path,
              arguments: DetailPageArgs(item: item)));
    } else {
      await showErrorDialog(context, 'Unknown');
    }
  }

  Future<void> showErrorDialog(BuildContext context, String error) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            icon: const Icon(Icons.info_rounded),
            title: const Text("Error"),
            content: Text(error),
            actions: [
              TextButton(
                onPressed: Navigator.of(context).pop,
                child: const Text("Ok"),
              )
            ],
          );
        });
    state.start();
  }
}
