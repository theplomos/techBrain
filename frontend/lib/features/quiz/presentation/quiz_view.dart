import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_typography.dart';
import '../../../shared/data/mock_data.dart';
import '../../../shared/widgets/app_glass_card.dart';
import '../../../shared/widgets/app_pill_button.dart';
import '../../../shared/widgets/progress_bar_widget.dart';

class _QuizQuestion {
  const _QuizQuestion({
    required this.tag,
    required this.title,
    required this.options,
  });

  final String tag;
  final String title;
  final List<String> options;
}

/// Pantalla de Evaluación Diagnóstica de Habilidades e Intereses.
/// Single Responsibility: Guiar al estudiante por el cuestionario y simular la generación de rutas.
class QuizView extends StatefulWidget {
  const QuizView({super.key});

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  int _currentQuestionIndex = 0;
  final Map<int, int> _selectedAnswers = <int, int>{};
  bool _isGeneratingRoadmap = false;

  static const List<_QuizQuestion> _questions = <_QuizQuestion>[
    _QuizQuestion(
      tag: '⚡ ENFOQUE PRINCIPAL',
      title: '¿Cuál es tu área tecnológica de mayor interés actualmente?',
      options: <String>[
        'Desarrollo Frontend Moderno (React, Next.js, Vue)',
        'Desarrollo Backend y Microservicios (NestJS, Go, Docker)',
        'Aplicaciones Móviles Multiplataforma (Flutter & Dart)',
        'Inteligencia Artificial y Agentes Autónomos (MCP, LLMs)',
      ],
    ),
    _QuizQuestion(
      tag: '📊 NIVEL DE EXPERIENCIA',
      title: '¿Cómo evalúas tu dominio en programación y algoritmos?',
      options: <String>[
        'Principiante: Iniciando en fundamentos y sintaxis',
        'Intermedio: He construido proyectos pero busco arquitectura sólida',
        'Avanzado: Busco optimización, sistemas distribuidos o especialización',
      ],
    ),
    _QuizQuestion(
      tag: '⏰ DISPONIBILIDAD SEMANAL',
      title: '¿Cuántas horas a la semana puedes dedicar a tus estudios?',
      options: <String>[
        '5 horas semanales (Ritmo flexible)',
        '10 horas semanales (Ritmo recomendado)',
        '20 o más horas semanales (Intensivo)',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final progress = (_currentQuestionIndex + 1) / _questions.length;
    final currentQ = _questions[_currentQuestionIndex];
    final selectedOption = _selectedAnswers[_currentQuestionIndex];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Título y Progreso
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Evaluación Diagnóstica',
                      style: AppTypography.h2.copyWith(fontSize: 20.0),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    'Pregunta ${_currentQuestionIndex + 1} de ${_questions.length}',
                    style: AppTypography.columnHeader.copyWith(
                      color: AppColors.accentVividLime,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              ProgressBarWidget(progress: progress, showLabel: false),
              const SizedBox(height: 28.0),

              // Ficha de la Pregunta
              AppGlassCard(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accentElectric.withAlpha(40),
                        borderRadius: BorderRadius.circular(50.0),
                        border: Border.all(
                          color: AppColors.accentLavender.withAlpha(50),
                        ),
                      ),
                      child: Text(
                        currentQ.tag,
                        style: AppTypography.columnHeader.copyWith(
                          fontSize: 10.0,
                          color: AppColors.accentLavender,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      currentQ.title,
                      style: AppTypography.h2.copyWith(fontSize: 18.0),
                    ),
                    const SizedBox(height: 24.0),

                    // Opciones interactivas
                    for (int i = 0; i < currentQ.options.length; i++) ...<Widget>[
                      _buildOptionCard(i, currentQ.options[i], selectedOption == i),
                      const SizedBox(height: 12.0),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24.0),

              // Botones de navegación
              Row(
                children: <Widget>[
                  if (_currentQuestionIndex > 0)
                    Expanded(
                      child: AppPillButton(
                        label: 'Anterior',
                        variant: AppPillButtonVariant.secondary,
                        onPressed: () {
                          setState(() => _currentQuestionIndex--);
                        },
                      ),
                    ),
                  if (_currentQuestionIndex > 0) const SizedBox(width: 16.0),
                  Expanded(
                    child: AppPillButton(
                      label: _currentQuestionIndex == _questions.length - 1
                          ? 'Generar Mi Ruta ⚡'
                          : 'Siguiente →',
                      variant: _currentQuestionIndex == _questions.length - 1
                          ? AppPillButtonVariant.vivid
                          : AppPillButtonVariant.primary,
                      isLoading: _isGeneratingRoadmap,
                      onPressed: selectedOption == null
                          ? null
                          : () => _handleNextQuestion(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(int index, String text, bool isSelected) {
    return AppGlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      backgroundColor: isSelected ? AppColors.accentMid.withAlpha(40) : null,
      borderColor: isSelected
          ? AppColors.accentVividLime
          : AppColors.cardBorderHover,
      onTap: () {
        setState(() {
          _selectedAnswers[_currentQuestionIndex] = index;
        });
      },
      child: Row(
        children: <Widget>[
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? AppColors.accentVividLime
                    : AppColors.textMuted,
                width: 2.0,
              ),
              color: isSelected ? AppColors.accentVividLime : Colors.transparent,
            ),
            child: isSelected
                ? const Icon(Icons.check, size: 14, color: Color(0xFF0F172A))
                : null,
          ),
          const SizedBox(width: 14.0),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodyMedium.copyWith(
                color: isSelected ? Colors.white : AppColors.textMain,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleNextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() => _currentQuestionIndex++);
    } else {
      _simulateGeneration();
    }
  }

  void _simulateGeneration() {
    setState(() => _isGeneratingRoadmap = true);
    Future<void>.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() => _isGeneratingRoadmap = false);
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.bgBox,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: const BorderSide(color: AppColors.accentLavender),
          ),
          title: const Text('¡Ruta Generada con Éxito! 🚀'),
          content: const Text(
            'Hemos sintetizado tu ruta recomendada: "Frontend React Moderno + Agentes IA". Tus respuestas han quedado guardadas en el perfil.',
            style: AppTypography.bodyMedium,
          ),
          actions: <Widget>[
            AppPillButton(
              label: 'Ver Mi Ruta ⚡',
              variant: AppPillButtonVariant.vivid,
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _currentQuestionIndex = 0;
                  _selectedAnswers.clear();
                });
                context.push(
                  '/roadmap-detail',
                  extra: MockData.generatedDemoRoadmap,
                );
              },
            ),
          ],
        ),
      );
    });
  }
}
