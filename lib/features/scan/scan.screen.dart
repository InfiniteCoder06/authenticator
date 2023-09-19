// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

// 🌎 Project imports:
import 'package:authenticator/core/router/app.router.dart';
import 'package:authenticator/features/scan/qr_overlay/material_preview.overlay.dart';
import 'package:authenticator/features/scan/scan.controller.dart';
import 'package:authenticator/widgets/app_bar_title.dart';

class ScanPage extends HookConsumerWidget {
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(scanControllerProvider);
    return Scaffold(
      appBar: MorphingAppBar(
        title: const AppBarTitle(fallbackRouter: AppRouter.scan),
        actions: [
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: controller.torchState,
              builder: (context, state, _) {
                switch (state) {
                  case TorchState.off:
                    return const Icon(
                      Icons.flash_off_rounded,
                    );
                  case TorchState.on:
                    return const Icon(
                      Icons.flash_on_rounded,
                      color: Colors.yellow,
                    );
                }
              },
            ),
            onPressed: () => controller.toggleTorch(),
          ),
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: controller.cameraFacingState,
              builder: (context, state, _) {
                switch (state) {
                  case CameraFacing.front:
                    return const Icon(Icons.camera_front_rounded);
                  case CameraFacing.back:
                    return const Icon(Icons.camera_rear_rounded);
                }
              },
            ),
            onPressed: () => controller.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (data) => ref
                .read(scanControllerProvider.notifier)
                .onDetect(context, data),
          ),
          const Padding(
            padding: EdgeInsets.zero,
            child: MaterialPreviewOverlay(),
          ),
        ],
      ),
    );
  }
}
