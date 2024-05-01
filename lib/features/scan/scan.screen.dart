// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

// 🌎 Project imports:
import 'package:authenticator/core/router/app.router.dart';
import 'package:authenticator/core/utils/dialog.util.dart';
import 'package:authenticator/core/utils/otp.util.dart';
import 'package:authenticator/features/scan/qr_overlay/material_preview.overlay.dart';
import 'package:authenticator/widgets/app_bar_title.dart';
import 'package:authenticator/widgets/app_cross_fade.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  late MobileScannerController controller;

  @override
  void initState() {
    super.initState();

    controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      formats: [BarcodeFormat.qrCode],
      detectionTimeoutMs: 1000,
    )..start();

    controller.barcodes.listen((barcode) async {
      controller.stop();
      final List<Barcode> barcodes = barcode.barcodes;

      if (barcodes.first.rawValue != null) {
        final result = OtpUtils.parseURI(Uri.parse(barcodes.first.rawValue!));
        result.match((error) async {
          await AppDialogs.showErrorDialog(context, error);
          controller.start();
        },
            (item) => Navigator.of(context).pushReplacementNamed(
                AppRouter.details.path,
                arguments: DetailPageArgs(item: item, isUrl: true)));
      } else {
        await AppDialogs.showErrorDialog(context, 'Unknown');
        controller.start();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        title: const AppBarTitle(fallbackRouter: AppRouter.scan),
        actions: [
          StatefulBuilder(builder: (context, setState) {
            final torch = controller.torchEnabled;
            return IconButton(
              icon: AppCrossFade(
                showFirst: !torch,
                firstChild: const Icon(Icons.flash_off_rounded),
                secondChild:
                    const Icon(Icons.flash_on_rounded, color: Colors.yellow),
              ),
              onPressed: () {
                controller.toggleTorch();
                setState(() {});
              },
            );
          }),
          StatefulBuilder(builder: (context, setState) {
            final facing = controller.facing;
            return IconButton(
              icon: AppCrossFade(
                showFirst: facing == CameraFacing.front,
                firstChild: const Icon(Icons.camera_front_rounded),
                secondChild: const Icon(Icons.camera_rear_rounded),
              ),
              onPressed: () {
                controller.switchCamera();
                setState(() {});
              },
            );
          }),
        ],
      ),
      body: MobileScanner(
        controller: controller,
        placeholderBuilder: (_, child) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        errorBuilder: (context, error, _) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, color: Theme.of(context).colorScheme.error),
                Text(error.errorCode.name),
              ],
            ),
          );
        },
        overlayBuilder: (context, constraints) =>
            const MaterialPreviewOverlay(),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
