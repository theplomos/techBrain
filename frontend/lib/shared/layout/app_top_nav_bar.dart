import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_tokens.dart';
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

class _TopNavItem extends StatefulWidget {
  const _TopNavItem({
    required this.tab,
    required this.selected,
    required this.onTap,
  });

  final AppTab tab;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_TopNavItem> createState() => _TopNavItemState();
}

class _TopNavItemState extends State<_TopNavItem> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final AppTab tab = widget.tab;
    final bool selected = widget.selected;
    final VoidCallback onTap = widget.onTap;
    final Color foreground = selected
        ? AppColors.textMain
        : AppColors.textMuted;

    // El ExcludeSemantics evita nodos duplicados del InkWell, pero también
    // borra su acción de activación: el Semantics exterior la repone con
    // onTap para que la pestaña se pueda navegar con un lector (RNF-11).
    return Semantics(
      button: true,
      selected: selected,
      label: tab.label,
      onTap: onTap,
      child: ExcludeSemantics(
        child: InkWell(
          onTap: onTap,
          focusColor: AppColors.cardBorder,
          onFocusChange: (bool value) => setState(() => _focused = value),
          // El Container solo aporta el anillo de foco: sin foco devuelve su
          // hijo intacto, así que no altera el layout de la pestaña.
          child: Container(
            foregroundDecoration: _focused
                ? const BoxDecoration(
                    borderRadius: BorderRadius.zero,
                    border: Border.fromBorderSide(
                      BorderSide(
                        color: AppFocus.ringColor,
                        width: AppFocus.ringWidth,
                      ),
                    ),
                  )
                : null,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: selected
                        ? AppColors.accentVivid
                        : Colors.transparent,
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
      ),
    );
  }
}
