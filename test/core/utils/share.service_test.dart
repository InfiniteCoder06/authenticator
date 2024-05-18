// 🐦 Flutter imports:
import 'package:flutter/services.dart';

// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';

// 🌎 Project imports:
import 'package:authenticator/core/utils/share.service.dart';

void main() {
  late ShareService shareService;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    shareService = ShareService();
  });

  void setupMockMethodChannel(String? mockReturnValue) {
    TestWidgetsFlutterBinding.instance.defaultBinaryMessenger
      ..setMockMethodCallHandler(
        const OptionalMethodChannel('com.praveen.authenticator'),
        (methodCall) async {
          switch (methodCall.method) {
            case 'getSharedData':
              return mockReturnValue;
          }
          return null;
        },
      )
      ..handlePlatformMessage(
          'flutter/lifecycle',
          const StringCodec().encodeMessage('AppLifecycleState.resumed'),
          (_) {});
  }

  test('GetSharedData returns empty string when method channel returns null',
      () async {
    setupMockMethodChannel(null);
    final result = await shareService.getSharedData();
    expect(result, '');
  });

  test('GetSharedData returns shared data from method channel', () async {
    const sharedData = 'Hello, World!';
    setupMockMethodChannel(sharedData);

    final result = await shareService.getSharedData();
    expect(result, sharedData);
  });

  test('OnDataReceived is called with empty string when no data is shared',
      () async {
    String? receivedData;
    shareService.onDataReceived = (data) {
      receivedData = data;
    };

    setupMockMethodChannel('');

    await shareService.getSharedData();
    expect(receivedData, '');
  });

  test('OnDataReceived is called with shared data', () async {
    String? receivedData;
    shareService.onDataReceived = (data) {
      receivedData = data;
    };

    const sharedData = 'Hello, World!';
    setupMockMethodChannel(sharedData);

    await shareService.getSharedData();
    expect(receivedData, sharedData);
  });
}
