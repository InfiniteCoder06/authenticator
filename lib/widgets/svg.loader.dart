// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_svg/flutter_svg.dart';

// 🌎 Project imports:
import 'package:authenticator/core/utils/svg.util.dart';

class SvgLoader extends StatelessWidget {
  const SvgLoader({super.key, required this.svgPath});

  final String svgPath;

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).colorScheme.primary;
    return FutureBuilder<String>(
      future: SvgUtils.renderIllustration(context, themeColor, svgPath),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.hasError) {
          return const Center(
              child: CircularProgressIndicator(strokeCap: StrokeCap.round));
        }

        final svgString = snapshot.data!;
        final size = MediaQuery.of(context).size;

        return Center(
          child: SvgPicture.string(
            svgString,
            theme: SvgTheme(currentColor: themeColor),
            width: size.shortestSide / 2,
          ),
        );
      },
    );
  }
}
