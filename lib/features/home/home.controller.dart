// 🎯 Dart imports:
import 'dart:typed_data';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:buffer_image/buffer_image.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpie/riverpie.dart';
import 'package:zxing_lib/zxing.dart';

// 🌎 Project imports:
import 'package:authenticator/core/database/adapter/base_entry_repository.dart';
import 'package:authenticator/core/models/item.model.dart';
import 'package:authenticator/core/router/app.router.dart';
import 'package:authenticator/core/utils/dialog.util.dart';
import 'package:authenticator/core/utils/mixin/console.mixin.dart';
import 'package:authenticator/core/utils/otp.util.dart';
import 'package:authenticator/core/utils/qr.util.dart';
import 'package:authenticator/modules.dart';
import 'package:authenticator/provider.dart';

part 'home.state.dart';

final homeController = NotifierProvider<HomeController, HomeState>(
  (ref) => HomeController(
    entryRepository: ref.read(hiveEntryRepoProvider),
    imagePicker: ref.read(imagePickerProvider),
  ),
);

class HomeController extends PureNotifier<HomeState> with ConsoleMixin {
  final BaseEntryRepository entryRepository;
  final ImagePicker imagePicker;
  HomeController({required this.entryRepository, required this.imagePicker});

  @override
  HomeState init() => HomeState.initial();

  @override
  void postInit() async {
    console.info("Initialize");
    super.postInit();
  }

  Future<void> get() async {
    final result = await entryRepository.getAll().run();
    result.fold((errorDB) {
      state = state.copyWith(error: errorDB);
    }, (entriesDB) {
      state = state.copyWith(entries: entriesDB, error: '');
    });
  }

  Future<void> pickAndScan(BuildContext context) async {
    final file = await pickFile().run();
    if (file.isNone()) {
      if (context.mounted) {
        AppDialogs.showErrorDialog(context, "User Cancelled Picker");
      }
      return;
    }
    final data = await file.toNullable()!.readAsBytes();
    final result = await getBufferImage(data).flatMap(decodeImage).run();

    if (result.isNone() && context.mounted) {
      AppDialogs.showErrorDialog(context, "QR not Found");
      return;
    }

    final parseResult =
        OtpUtils.parseURI(Uri.parse(result.toNullable()!.first.text));
    parseResult.fold(
        (text) => AppDialogs.showErrorDialog(context, text),
        (item) => Navigator.of(context).pushReplacementNamed(
            AppRouter.details.path,
            arguments: DetailPageArgs(item: item)));
  }

  Future<void> showManualUri(BuildContext context) async {
    final uri = await AppDialogs.showManualURIDialog(context);
    if (uri.isEmpty || uri == 'skip') return;
    final parseResult = OtpUtils.parseURI(Uri.parse(uri));
    parseResult.fold(
        (error) => AppDialogs.showErrorDialog(context, error),
        (item) => Navigator.of(context).pushNamed(AppRouter.details.path,
            arguments: DetailPageArgs(item: item)));
  }

  TaskOption<XFile> pickFile() => TaskOption(() async =>
      optionOf(await imagePicker.pickImage(source: ImageSource.gallery)));

  TaskOption<BufferImage> getBufferImage(Uint8List data) =>
      TaskOption(() async => optionOf(await BufferImage.fromFile(data)));

  TaskOption<List<Result>> decodeImage(BufferImage image) =>
      TaskOption(() async => await QrUtils()
          .decodeImageInIsolate(image.buffer, image.width, image.height));

  void addSelected(Item item) =>
      state = state.copyWith(selected: [...state.selected, item]);

  void removeSelected(Item item) =>
      state = state.copyWith(selected: List.from(state.selected)..remove(item));

  void clearSelected() => state = state.copyWith(selected: List.empty());
}
