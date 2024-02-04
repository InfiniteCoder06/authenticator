// 🎯 Dart imports:
import 'dart:async';

// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';

// 📦 Package imports:
import 'package:fpdart/fpdart.dart';
import 'package:zxing_lib/common.dart';
import 'package:zxing_lib/multi.dart';
import 'package:zxing_lib/zxing.dart';

class IsoMessage {
  final Uint8List byteData;
  final int width;
  final int height;

  IsoMessage(this.byteData, this.width, this.height);
}

class QrUtils {
  Future<Option<List<Result>>> decodeImageInIsolate(
    Uint8List image,
    int width,
    int height, {
    bool isRgb = true,
  }) async {
    IsoMessage message = IsoMessage(image, width, height);
    if (isRgb) {
      return compute(decodeImage, message);
    } else {
      return compute(decodeCamera, message);
    }
  }

  int getLuminanceSourcePixel(List<int> byte, int index) {
    if (byte.length <= index + 3) {
      return 0xff;
    }
    final red = byte[index] & 0xff;
    final green = (byte[index + 1] << 1) & 0x1fe;
    final blue = byte[index + 2];
    return ((red + green + blue) ~/ 4);
  }

  Option<List<Result>> decodeImage(IsoMessage message) => Option.tryCatch(() {
        final pixels = Uint8List(message.width * message.height);
        for (int i = 0; i < pixels.length; i++) {
          pixels[i] = getLuminanceSourcePixel(message.byteData, i * 4);
        }

        final imageSource =
            RGBLuminanceSource.orig(message.width, message.height, pixels);

        final bitmap = BinaryBitmap(HybridBinarizer(imageSource));
        final reader = GenericMultipleBarcodeReader(MultiFormatReader());

        return reader.decodeMultiple(
          bitmap,
          const DecodeHint(alsoInverted: true, tryHarder: true),
        );
      });

  Option<List<Result>> decodeCamera(IsoMessage message) => Option.tryCatch(() {
        final imageSource = PlanarYUVLuminanceSource(
          message.byteData.buffer.asUint8List(),
          message.width,
          message.height,
        );

        final bitmap = BinaryBitmap(HybridBinarizer(imageSource));
        final reader = GenericMultipleBarcodeReader(MultiFormatReader());

        return reader.decodeMultiple(
          bitmap,
          const DecodeHint(alsoInverted: true, tryHarder: true),
        );
      });
}
