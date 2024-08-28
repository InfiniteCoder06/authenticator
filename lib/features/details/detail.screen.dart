// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

// 🌎 Project imports:
import 'package:authenticator/core/fields/textfield.field.dart';
import 'package:authenticator/core/fields/totp.field.dart';
import 'package:authenticator/core/models/item.model.dart';
import 'package:authenticator/core/router/app.router.dart';
import 'package:authenticator/core/utils/constants/config.constant.dart';
import 'package:authenticator/core/utils/dialog.util.dart';
import 'package:authenticator/features/details/detail.controller.dart';
import 'package:authenticator/features/details/widgets/add.widget.dart';
import 'package:authenticator/features/details/widgets/icon.widget.dart';
import 'package:authenticator/widgets/app_bar_title.dart';
import 'package:authenticator/widgets/app_pop_button.dart';

class DetailPage extends HookConsumerWidget {
  const DetailPage({super.key, required this.item, required this.isUrl});

  final Option<Item> item;
  final bool isUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      ref.read(detailController.notifier).initialize(item, isUrl);
      return null;
    }, [item]);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        if (didPop) return;
        final bool shouldPop =
            await ref.read(detailController.notifier).popRequest(context);
        if (context.mounted && shouldPop) {
          Navigator.pop(context, result);
        }
      },
      child: Scaffold(
        appBar: MorphingAppBar(
          leading: AppPopButton.wrapper(context),
          title: AppBarTitle(
            fallbackRouter: AppRouter.details,
            overridedTitle: item.isSome() ? 'Edit' : 'Create',
          ),
          actions: [
            IconButton(
              tooltip: "Save",
              icon: const Icon(Icons.save_rounded),
              onPressed: () async {
                if (ref.read(detailController.notifier).isNotDirty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("No changes detected")),
                  );
                  return;
                }
                await ref.read(detailController.notifier).save(context);
              },
            ),
            if (item.isSome())
              PopupMenuButton<int>(
                tooltip: "More",
                icon: const Icon(Icons.more_vert_rounded),
                routeSettings: const RouteSettings(name: "DetailAppBarMore"),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 0,
                    child: Text("Delete"),
                  )
                ],
                onSelected: (value) async {
                  if (value == 0) {
                    await AppDialogs.showDeletionDialog(
                        context, [item.toNullable()!], ref);
                    Future<void>.delayed(Durations.medium2, () {
                      if (!context.mounted) return;
                      Navigator.of(context).pop();
                    });
                  }
                },
              ),
          ],
        ),
        body: Builder(builder: (context) {
          final controller = ref.watch(detailController);
          return controller.isLoading
              ? const Center(
                  child: CircularProgressIndicator(strokeCap: StrokeCap.round))
              : ReactiveFormConfig(
                  validationMessages: {
                    ValidationMessage.required: (_) => 'Required',
                    ValidationMessage.pattern: (_) => 'Enter a valid Secret'
                  },
                  child: ReactiveForm(
                    formGroup: controller.form,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          const ItemIcon(),
                          ConfigConstant.sizedBoxH2,
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: ReactiveTextField<String>(
                              formControlName: 'name',
                              textCapitalization: TextCapitalization.words,
                              decoration: const InputDecoration(
                                labelText: 'Name',
                                hintText: 'John.doe@email.com',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: AppTotpField(
                              formName: 'secret',
                              label: 'Secret',
                              hint: 'JBSWY3DPEHPK3PXP',
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: AppTextField(
                              formName: 'issuer',
                              label: 'Issuer',
                              hint: 'Acme Co',
                            ),
                          ),
                          ConfigConstant.sizedBoxH1,
                          const AddField(),
                        ],
                      ),
                    ),
                  ),
                );
        }),
      ),
    );
  }
}
