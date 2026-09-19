import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_typography.dart';
import '../widgets/glass_container.dart';
import '../widgets/tech_brain_logo.dart';
import 'app_tabs.dart';
import 'breakpoints.dart';

/// Barra de navegación superior para anchos a partir de
/// [Breakpoints.desktop].
class AppTopNavBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  static const double height = 72.0;

  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  @override
  Size get preferredSize => const Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double horizontalPadding = screenWidth >= Breakpoints.maxContentWidth
        ? 32.0
        : 16.0;

    return GlassContainer(
      blur: true,
      color: AppColors.navBg,
      borderRadius: 0.0,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: SizedBox(
        height: height,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Center(child: TechBrainLogo()),
            const Spacer(),
            for (final (int index, AppTab tab) in appTabs.indexed)
              _TopNavItem(
                tab: tab,
                selected: index == currentIndex,
                onTap: () => onTabSelected(index),
              ),
          ],
        ),
      ),
    );
  }
}

class _TopNavItem extends StatelessWidget {
  const _TopNavItem({
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
          focusColor: AppColors.cardBorder,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: selected ? AppColors.accentVivid : Colors.transparent,
                  width: 2.0,
                ),
              ),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: 44.0,
                minWidth: 44.0,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      selected ? tab.selectedIcon : tab.icon,
                      size: 18.0,
                      color: foreground,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      tab.label,
                      style: AppTextStyles.chip.copyWith(
                        color: foreground,
                        letterSpacing: 0.0,
                        fontSize: 13.0,
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
