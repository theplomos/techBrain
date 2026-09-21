import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_tokens.dart';
import '../../../../config/theme/app_typography.dart';
import '../../../../shared/layout/breakpoints.dart';
import '../../../../shared/mock/mock_data.dart';
import '../../../../shared/mock/mock_models.dart';
import '../../../../shared/utils/initials.dart';
import '../../../../shared/widgets/glass_container.dart';
import '../../../../shared/widgets/pill_button.dart';
import '../../../../shared/widgets/section_header.dart';

/// Pantalla de configuración y perfil del usuario.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late int _weeklyHours;

  @override
  void initState() {
    super.initState();
    _weeklyHours = MockData.user.weeklyHours;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final bool isDesktop = screenWidth >= Breakpoints.desktop;
    final double horizontalPadding = isDesktop ? 32.0 : 16.0;

    final MockUser user = MockData.user;

    return ListView(
      padding:
          MediaQuery.paddingOf(context) +
          EdgeInsets.symmetric(vertical: 24.0, horizontal: horizontalPadding),
      children: <Widget>[
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: Breakpoints.maxContentWidth,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Título principal
                Text(
                  'Configuración y perfil',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: AppColors.textMain,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 24.0),

                // Tarjeta de perfil
                GlassContainer(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: <Widget>[
                      // Círculo de 56 px con iniciales sobre degradado
                      Container(
                        width: 56.0,
                        height: 56.0,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: <Color>[
                              AppColors.accentMid,
                              AppColors.accentElectric,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          initialsOf(user.name),
                          style: const TextStyle(
                            fontFamily: AppFonts.heading,
                            fontWeight: FontWeight.w700,
                            fontSize: 20.0,
                            color: AppColors.textMain,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16.0),

                      // Nombre, tag y chip
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 8.0,
                              runSpacing: 4.0,
                              children: <Widget>[
                                Text(
                                  user.name,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: AppColors.textMain,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 4.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.catFrontendBg,
                                    borderRadius: BorderRadius.circular(
                                      AppRadii.pill,
                                    ),
                                    border: Border.all(
                                      color: AppColors.catFrontendBorder,
                                    ),
                                  ),
                                  child: Text(
                                    'Miembro de DevTalles',
                                    style: AppTextStyles.chip.copyWith(
                                      color: AppColors.textMain,
                                      fontSize: 10.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              '@${user.discordTag}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32.0),

                // Sección: Ritmo de estudio
                const SectionHeader('Ritmo de estudio'),
                GlassContainer(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              'Horas semanales',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.textMain,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            '$_weeklyHours h/semana',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.accentLavender,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: AppColors.accentLavender,
                          inactiveTrackColor: AppColors.cardBorder,
                          thumbColor: AppColors.accentLavender,
                          overlayColor: AppColors.accentLavender.withValues(
                            alpha: 0.2,
                          ),
                        ),
                        child: Slider(
                          value: _weeklyHours.toDouble(),
                          min: 1.0,
                          max: 40.0,
                          divisions: 39,
                          label: '$_weeklyHours',
                          onChanged: (double value) {
                            setState(() {
                              _weeklyHours = value.round();
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Se usará para estimar la fecha de fin de tus rutas.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32.0),

                // Sección: Cuenta
                const SectionHeader('Cuenta'),
                GlassContainer(
                  padding: const EdgeInsets.all(20.0),
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                          final bool isNarrow = constraints.maxWidth < 450.0;
                          final Widget discordInfo = Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const Icon(
                                Icons.discord,
                                color: AppColors.brandDiscord,
                                size: 24.0,
                              ),
                              const SizedBox(width: 12.0),
                              Flexible(
                                child: Text(
                                  'Conectado con Discord',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textMain,
                                  ),
                                ),
                              ),
                            ],
                          );
                          const Widget logoutButton = PillButton(
                            label: 'Cerrar sesión',
                            variant: PillButtonVariant.secondary,
                            onPressed: null,
                          );

                          if (isNarrow) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                discordInfo,
                                const SizedBox(height: 16.0),
                                logoutButton,
                              ],
                            );
                          }
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Flexible(child: discordInfo),
                              const SizedBox(width: 16.0),
                              logoutButton,
                            ],
                          );
                        },
                  ),
                ),
                const SizedBox(height: 32.0),

                // Sección: Acerca de
                const SectionHeader('Acerca de'),
                GlassContainer(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'TechBrain · Equipo #13',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textMain,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'DevTalles CodeQuest 2026 · Misión CQ03-2026',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Licencia MIT',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
