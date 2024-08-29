// 🐦 Flutter imports:
import 'package:flutter/services.dart';

class ShareService {
  ShareService() {
    SystemChannels.lifecycle.setMessageHandler((msg) async {
      if (msg?.contains("resumed") ?? false) {
        getSharedData().then((String data) {
          if (data.isEmpty) {
            onDataReceived?.call("");
          }

          onDataReceived?.call(data);
        });
      }
      return;
    });
  }

  void Function(String)? onDataReceived;

  Future<String> getSharedData() async =>
      await const OptionalMethodChannel('com.praveen.authenticator')
          .invokeMethod("getSharedData") ??
      "";
}
