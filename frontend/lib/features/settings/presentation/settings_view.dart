import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_typography.dart';
import '../../../shared/data/mock_data.dart';
import '../../../shared/widgets/app_glass_card.dart';
import '../../../shared/widgets/app_pill_button.dart';

/// Pantalla de Configuración y Perfil del Estudiante.
/// Single Responsibility: Administrar preferencias de estudio, conexión a Discord y créditos.
class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  int _weeklyHours = MockData.demoUser.weeklyHours;

  @override
  Widget build(BuildContext context) {
    const user = MockData.demoUser;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Configuración y Perfil',
                style: AppTypography.h1.copyWith(fontSize: 22.0),
              ),
              const SizedBox(height: 6.0),
              const Text(
                'Ajusta tu dedicación semanal y consulta el estado de tu cuenta.',
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: 24.0),

              // Tarjeta de Perfil
              AppGlassCard(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: <Widget>[
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColors.accentElectric,
                      child: Text(
                        'A',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            user.name,
                            style: AppTypography.h3.copyWith(fontSize: 18.0),
                          ),
                          const SizedBox(height: 4.0),
                          Row(
                            children: <Widget>[
                              const Icon(
                                Icons.discord,
                                size: 16.0,
                                color: AppColors.brandDiscord,
                              ),
                              const SizedBox(width: 6.0),
                              Text(
                                user.discordTag,
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.accentLavender,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6.0),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 2.0,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.catMovilBg,
                              borderRadius: BorderRadius.circular(50.0),
                              border: Border.all(
                                color: AppColors.accentVividLime,
                                width: 0.8,
                              ),
                            ),
                            child: const Text(
                              'Miembro Verificado DevTalles',
                              style: TextStyle(
                                color: AppColors.accentVividLime,
                                fontSize: 10.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24.0),

              // Preferencias de Estudio: Horas Semanales
              const Text('RITMO DE ESTUDIO', style: AppTypography.columnHeader),
              const SizedBox(height: 12.0),
              AppGlassCard(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Expanded(
                          child: Text(
                            'Horas semanales dedicadas',
                            style: AppTypography.h3,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          '$_weeklyHours h/semana',
                          style: AppTypography.numberHighlight.copyWith(
                            color: AppColors.accentVividLime,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    const Text(
                      'Este valor se utiliza para calcular las fechas estimadas de finalización de tus rutas.',
                      style: AppTypography.bodyMedium,
                    ),
                    const SizedBox(height: 16.0),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: AppColors.accentVividLime,
                        inactiveTrackColor: AppColors.bgBox,
                        thumbColor: AppColors.accentVividLime,
                        overlayColor: AppColors.accentVividLime.withAlpha(50),
                      ),
                      child: Slider(
                        value: _weeklyHours.toDouble(),
                        min: 2,
                        max: 40,
                        divisions: 19,
                        label: '$_weeklyHours horas',
                        onChanged: (double val) {
                          setState(() => _weeklyHours = val.round());
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24.0),

              // Estado de Conexión y Modo Mock
              const Text('ESTADO DEL SISTEMA', style: AppTypography.columnHeader),
              const SizedBox(height: 12.0),
              AppGlassCard(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.accentVividLime,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        const Expanded(
                          child: Text(
                            'Modo Offline / Referencias Activo',
                            style: TextStyle(
                              color: AppColors.textMain,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6.0),
                    const Text(
                      'La aplicación está operando con el repositorio de datos local sin depender de un backend remoto para la prueba.',
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24.0),

              // Información del Proyecto y Créditos
              const Text('INFORMACIÓN DEL EVENTO', style: AppTypography.columnHeader),
              const SizedBox(height: 12.0),
              AppGlassCard(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text('TechBrain • Equipo #13', style: AppTypography.h3),
                    const SizedBox(height: 4.0),
                    const Text(
                      'DevTalles CodeQuest 2026 (Misión CQ03-2026)\nLicencia MIT • Desarrollado con Flutter',
                      style: AppTypography.bodyMedium,
                    ),
                    const SizedBox(height: 16.0),
                    AppPillButton(
                      label: 'Vincular Discord',
                      variant: AppPillButtonVariant.discord,
                      icon: const Icon(Icons.discord, size: 18),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Conectado al servidor oficial de DevTalles (1130900724499365958)',
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32.0),
            ],
          ),
        ),
      ),
    );
  }
}
