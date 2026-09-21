import 'package:flutter/material.dart';

import '../../config/theme/app_typography.dart';

/// Encabezado de sección con título en mayúsculas y trailing opcional.
class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Semantics(
        header: true,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(title.toUpperCase(), style: AppTextStyles.columnHeader),
            ?trailing,
          ],
        ),
      ),
    );
  }
}
