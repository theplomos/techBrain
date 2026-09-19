import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_tokens.dart';
import '../../config/theme/app_typography.dart';
import '../widgets/glass_container.dart';
import 'app_tabs.dart';

/// Barra de navegación flotante para anchos por debajo de
/// [Breakpoints.desktop].
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  /// Altura de la barra sin contar el área segura ni el margen inferior.
  static const double height = 64.0;

  /// Margen lateral e inferior de la barra flotante.
  static const double margin = 16.0;

  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(margin, 0, margin, margin),
        child: GlassContainer(
          blur: true,
          color: AppColors.navBg,
          padding: const EdgeInsets.all(6.0),
          child: Row(
            children: <Widget>[
              for (final (int index, AppTab tab) in appTabs.indexed)
                Expanded(
                  child: _BottomNavItem(
                    tab: tab,
                    selected: index == currentIndex,
                    onTap: () => onTabSelected(index),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.tab,
    required this.selected,
    required this.onTap,
  });

  final AppTab tab;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color foreground = selected
        ? AppColors.textMain
        : AppColors.textMuted;

    return Semantics(
      button: true,
      selected: selected,
      label: tab.label,
      child: ExcludeSemantics(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadii.inner),
          focusColor: const Color.fromRGBO(192, 185, 252, 0.12),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 52.0, minWidth: 44.0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadii.inner),
                gradient: selected
                    ? const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[
                          AppColors.accentMid,
                          AppColors.accentElectric,
                        ],
                      )
                    : null,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      selected ? tab.selectedIcon : tab.icon,
                      size: 20.0,
                      color: foreground,
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      tab.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.chip.copyWith(
                        color: foreground,
                        letterSpacing: 0.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
