part of 'app.router.dart';

class DetailPageArgs {
  const DetailPageArgs({this.key, required this.item, required this.isUrl});

  final Key? key;
  final Item? item;
  final bool isUrl;

  @override
  String toString() {
    return 'DetailPageArgs{key: $key, item: $item, isUrl: $isUrl}';
  }
}

class TransferPageArgs {
  const TransferPageArgs({this.key, required this.items});

  final Key? key;
  final List<Item> items;

  @override
  String toString() {
    return 'TransferPageArgs{key: $key, items: ${items.toString()}}';
  }
}

class SecurityPageArgs {
  const SecurityPageArgs({
    required this.context,
    required this.correctString,
    required this.onUnlocked,
    this.onValidate,
    this.onOpened,
    this.onCancelled,
    this.onError,
    this.onMaxRetries,
    this.customizedButtonTap,
    this.maxRetries = 5,
    this.retryDelay = const Duration(seconds: 30),
    this.title = const Text('Enter PIN'),
    this.config,
    this.secretsConfig = const SecretsConfig(),
    this.keyPadConfig,
    this.delayBuilder,
    this.customizedButtonChild,
    this.footer,
    this.cancelButton,
    this.deleteButton,
    this.inputController,
    this.secretsBuilder,
    this.useBlur = true,
    this.useLandscape = false,
    this.canCancel = false,
  });

  final BuildContext context;
  final String correctString;
  final VoidCallback onUnlocked;
  final ValidationCallback? onValidate;
  final VoidCallback? onOpened;
  final VoidCallback? onCancelled;
  final ValueChanged<int>? onError;
  final ValueChanged<int>? onMaxRetries;
  final int maxRetries;
  final Duration retryDelay;
  final Widget title;
  final ScreenLockConfig? config;
  final SecretsConfig secretsConfig;
  final KeyPadConfig? keyPadConfig;
  final DelayBuilderCallback? delayBuilder;
  final Widget? customizedButtonChild;
  final VoidCallback? customizedButtonTap;
  final Widget? footer;
  final Widget? cancelButton;
  final Widget? deleteButton;
  final InputController? inputController;
  final SecretsBuilderCallback? secretsBuilder;
  final bool useBlur;
  final bool useLandscape;
  final bool canCancel;
}

class SecurityCreatePageArgs {
  const SecurityCreatePageArgs({
    required this.context,
    required this.onConfirmed,
    this.onOpened,
    this.onValidate,
    this.onCancelled,
    this.onError,
    this.onMaxRetries,
    this.maxRetries = 0,
    this.digits = 4,
    this.retryDelay = Duration.zero,
    this.title = const Text('Enter PIN'),
    this.confirmTitle,
    this.config,
    this.secretsConfig = const SecretsConfig(),
    this.keyPadConfig,
    this.delayBuilder,
    this.customizedButtonChild,
    this.customizedButtonTap,
    this.footer,
    this.cancelButton,
    this.deleteButton,
    this.inputController,
    this.secretsBuilder,
    this.useBlur = true,
    this.useLandscape = false,
    this.canCancel = false,
  });

  final BuildContext context;
  final ValueChanged<String> onConfirmed;
  final VoidCallback? onOpened;
  final ValidationCallback? onValidate;
  final VoidCallback? onCancelled;
  final ValueChanged<int>? onError;
  final ValueChanged<int>? onMaxRetries;
  final VoidCallback? customizedButtonTap;
  final int maxRetries;
  final int digits;
  final Duration retryDelay;
  final Widget title;
  final Widget? confirmTitle;
  final ScreenLockConfig? config;
  final SecretsConfig secretsConfig;
  final KeyPadConfig? keyPadConfig;
  final DelayBuilderCallback? delayBuilder;
  final Widget? customizedButtonChild;
  final Widget? footer;
  final Widget? cancelButton;
  final Widget? deleteButton;
  final InputController? inputController;
  final SecretsBuilderCallback? secretsBuilder;
  final bool useBlur;
  final bool useLandscape;
  final bool canCancel;
}
