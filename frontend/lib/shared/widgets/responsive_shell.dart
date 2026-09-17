import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_typography.dart';
import 'cosmic_background.dart';
import 'devtalles_logo.dart';

/// Contenedor responsivo que adapta la barra de navegación para Web, iOS y Android.
/// Single Responsibility: Coordinar la navegación y la disposición de pantalla.
class ResponsiveShell extends StatelessWidget {
  const ResponsiveShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= 1024;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: CosmicBackground(
        child: isDesktop
            ? Column(
                children: <Widget>[
                  _buildDesktopNavBar(context),
                  Expanded(child: navigationShell),
                ],
              )
            : navigationShell,
      ),
      bottomNavigationBar: isDesktop ? null : _buildMobileBottomBar(context),
    );
  }

  Widget _buildDesktopNavBar(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      decoration: const BoxDecoration(
        color: AppColors.navBg,
        border: Border(
          bottom: BorderSide(color: AppColors.cardBorder, width: 1.0),
        ),
      ),
      child: Row(
        children: <Widget>[
          const DevTallesLogo(fontSize: 22.0),
          const SizedBox(width: 48.0),
          _buildDesktopNavItem(0, 'Home', Icons.home_rounded),
          _buildDesktopNavItem(1, 'Explorar', Icons.explore_rounded),
          _buildDesktopNavItem(2, 'Cuestionarios', Icons.quiz_rounded),
          _buildDesktopNavItem(3, 'Configuración', Icons.settings_rounded),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14.0,
              vertical: 6.0,
            ),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(50.0),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: const Row(
              children: <Widget>[
                Text(
                  '🔥 5 Días',
                  style: TextStyle(
                    color: AppColors.accentVividLime,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 12.0),
                CircleAvatar(
                  radius: 14,
                  backgroundColor: AppColors.accentElectric,
                  child: Text(
                    'A',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopNavItem(int index, String label, IconData icon) {
    final isSelected = navigationShell.currentIndex == index;

    return Padding(
      padding: const EdgeInsets.only(right: 24.0),
      child: TextButton.icon(
        onPressed: () => navigationShell.goBranch(index),
        icon: Icon(
          icon,
          size: 18.0,
          color: isSelected ? AppColors.accentVividLime : AppColors.textMuted,
        ),
        label: Text(
          label,
          style: TextStyle(
            fontFamily: AppTypography.bodyFamily,
            fontFamilyFallback: AppTypography.fontFallbacks,
            fontSize: 14.0,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textMuted,
          ),
        ),
      ),
    );
  }

  Widget _buildMobileBottomBar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.navBg,
        border: Border(
          top: BorderSide(color: AppColors.cardBorder, width: 1.0),
        ),
      ),
      child: NavigationBar(
        height: 65,
        backgroundColor: Colors.transparent,
        indicatorColor: AppColors.accentMid,
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (int index) => navigationShell.goBranch(index),
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: AppColors.textMuted),
            selectedIcon: Icon(Icons.home_rounded, color: Colors.white),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined, color: AppColors.textMuted),
            selectedIcon: Icon(Icons.explore_rounded, color: Colors.white),
            label: 'Explorar',
          ),
          NavigationDestination(
            icon: Icon(Icons.quiz_outlined, color: AppColors.textMuted),
            selectedIcon: Icon(Icons.quiz_rounded, color: Colors.white),
            label: 'Cuestionarios',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined, color: AppColors.textMuted),
            selectedIcon: Icon(Icons.settings_rounded, color: Colors.white),
            label: 'Ajustes',
          ),
        ],
      ),
    );
  }
}
