// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'package:url_launcher/url_launcher.dart';

// 🌎 Project imports:
import 'package:authenticator/core/models/item.model.dart';
import 'package:authenticator/core/router/app.router.dart';
import 'package:authenticator/core/utils/constants/shape.constant.dart';
import 'package:authenticator/core/utils/extension/item_x.extension.dart';
import 'package:authenticator/core/utils/utils.dart';
import 'package:authenticator/widgets/app_bar_title.dart';
import 'package:authenticator/widgets/app_cross_fade.dart';
import 'package:authenticator/widgets/app_pop_button.dart';

class TransferPage extends HookWidget {
  const TransferPage({super.key, required this.items});

  final List<Item> items;

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController();
    final page = useValueNotifier(0);
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
      child: Scaffold(
        appBar: MorphingAppBar(
          leading: AppPopButton.wrapper(context),
          title: const AppBarTitle(fallbackRouter: AppRouter.transfer),
          actions: <Widget>[
            IconButton(
              onPressed: () async {
                await AppUtils.copyToClipboard(
                    items.elementAt(pageController.page?.toInt() ?? 0).name);
                if (context.mounted) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(const SnackBar(
                        content: Text("OTP url copied to clipboard")));
                }
              },
              tooltip: 'Copy URL',
              icon: const Icon(Icons.copy_rounded),
            ),
            IconButton(
              onPressed: () async {
                final url =
                    items.elementAt(pageController.page?.toInt() ?? 0).uri;
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(const SnackBar(
                          content: Text("Cannot share to other app")));
                  }
                }
              },
              tooltip: 'Share URL',
              icon: const Icon(Icons.share_rounded),
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Scan this QR code with the authenticator app you would like to transfer this entry to",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Expanded(
              child: PageView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: pageController,
                itemCount: items.length,
                onPageChanged: (currentPage) => page.value = currentPage,
                itemBuilder: (context, index) {
                  final size = MediaQuery.of(context).size.shortestSide;
                  final Item item = items.elementAt(index);
                  return Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: ShapeConstant.large,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: QrImageView(
                              data: item.uri.toString(),
                              size: size * 0.5,
                              backgroundColor: Colors.white,
                              dataModuleStyle: const QrDataModuleStyle(
                                dataModuleShape: QrDataModuleShape.circle,
                                color: Colors.black,
                              ),
                              eyeStyle: const QrEyeStyle(
                                eyeShape: QrEyeShape.circle,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(item.name)
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            ValueListenableBuilder(
              valueListenable: page,
              builder: (context, page, child) {
                return Column(
                  children: [
                    Center(
                      child: Text(
                        "Showing ${page + 1} / ${items.length} Items",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OverflowBar(
                        alignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          AppCrossFade(
                            duration: Durations.short4,
                            showFirst: page == 0,
                            firstChild: const SizedBox.shrink(),
                            secondChild: TextButton(
                              onPressed: () {
                                pageController.previousPage(
                                  duration: Durations.medium2,
                                  curve: Curves.ease,
                                );
                              },
                              child: const Text("Back"),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              if (page == items.length - 1) {
                                Navigator.of(context).pop();
                              } else {
                                pageController.nextPage(
                                  duration: Durations.medium2,
                                  curve: Curves.ease,
                                );
                              }
                            },
                            child: Text(
                                page == items.length - 1 ? 'Done' : 'Next'),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
