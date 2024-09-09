// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

// 🌎 Project imports:
import 'package:authenticator/core/router/app.router.dart';
import 'package:authenticator/core/utils/dialog.util.dart';
import 'package:authenticator/core/utils/otp.util.dart';
import 'package:authenticator/features/scan/qr_overlay/material_preview.overlay.dart';
import 'package:authenticator/widgets/app_bar_title.dart';
import 'package:authenticator/widgets/app_cross_fade.dart';

class ScanPage extends StatefulHookWidget {
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final torchEnabled = useValueNotifier(controller.torchEnabled);
    final cameraFacingState = useValueNotifier(controller.facing);
    return Scaffold(
      appBar: MorphingAppBar(
        title: const AppBarTitle(fallbackRouter: AppRouter.scan),
        actions: [
          ValueListenableBuilder(
            valueListenable: torchEnabled,
            builder: (context, torch, child) {
              return IconButton(
                icon: AppCrossFade(
                  showFirst: !torch,
                  firstChild: const Icon(Icons.flash_off_rounded),
                  secondChild:
                      const Icon(Icons.flash_on_rounded, color: Colors.yellow),
                ),
                onPressed: () {
                  controller.toggleTorch();
                  torchEnabled.value = !torchEnabled.value;
                },
              );
            },
          ),
          ValueListenableBuilder(
            valueListenable: cameraFacingState,
            builder: (context, cameraFacing, child) {
              return IconButton(
                icon: AppCrossFade(
                  showFirst: cameraFacing == CameraFacing.front,
                  firstChild: const Icon(Icons.camera_front_rounded),
                  secondChild: const Icon(Icons.camera_rear_rounded),
                ),
                onPressed: () {
                  controller.switchCamera();
                  cameraFacingState.value =
                      cameraFacingState.value == CameraFacing.front
                          ? CameraFacing.back
                          : CameraFacing.front;
                },
              );
            },
          ),
        ],
      ),
      body: MobileScanner(
        controller: controller,
        onDetect: (barcode) async =>
            onDetect(context: context, barcodes: barcode.barcodes),
        placeholderBuilder: (_, child) => const Center(
          child: CircularProgressIndicator(),
        ),
        errorBuilder: (context, error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, color: Theme.of(context).colorScheme.error),
              Text(error.errorCode.name),
            ],
          ),
        ),
        overlayBuilder: (context, constraints) =>
            const MaterialPreviewOverlay(),
      ),
    );
  }

  Future<void> onDetect({
    required BuildContext context,
    required List<Barcode> barcodes,
  }) async {
    controller.stop();
    if (barcodes.first.rawValue != null) {
      final result = OtpUtils.parseURI(Uri.parse(barcodes.first.rawValue!));
      result.match(
        (error) async {
          await AppDialogs.showErrorDialog(context, error);
          controller.start();
        },
        (result) async {
          var item = result.$1;
          if (result.$2.length == 2) {
            final selectedIssuer =
                await AppDialogs.showSelectIssuerDialog(context, result.$2);
            item = item.copyWith(issuer: selectedIssuer);
          }
          if (!context.mounted) return;
          await Navigator.of(context).pushReplacementNamed(
            AppRouter.details.path,
            arguments: DetailPageArgs(item: item, isUrl: true),
          );
        },
      );
    } else {
      if (!mounted) return;
      await AppDialogs.showErrorDialog(context, 'Unknown');
      controller.start();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
