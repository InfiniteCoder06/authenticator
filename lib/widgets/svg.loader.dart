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
    return FutureBuilder(
      future: SvgUtils.renderIllustration(
          Theme.of(context).colorScheme.primary, svgPath),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.hasError) {
          return const Center(child: CircularProgressIndicator());
        }
        final size = MediaQuery.of(context).size;
        return Center(
          child: SvgPicture.string(
            snapshot.data!,
            theme: SvgTheme(
              currentColor: Theme.of(context).colorScheme.primary,
            ),
            width: size.height > size.width ? size.width / 2 : size.height / 2,
          ),
        );
      },
    );
  }
}
