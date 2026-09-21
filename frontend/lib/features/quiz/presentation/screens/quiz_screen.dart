import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/router/app_routes.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_typography.dart';
import '../../../../shared/layout/breakpoints.dart';
import '../../../../shared/mock/mock_data.dart';
import '../../../../shared/mock/mock_models.dart';
import '../../../../shared/widgets/glass_container.dart';
import '../../../../shared/widgets/pill_button.dart';
import '../../../../shared/widgets/progress_bar.dart';

/// Pantalla de cuestionarios diagnósticos para generar una ruta personalizada.
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentIndex = 0;
  final Map<int, int> _selectedAnswers = <int, int>{};

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final bool isDesktop = screenWidth >= Breakpoints.desktop;
    final double horizontalPadding = isDesktop ? 32.0 : 16.0;

    final List<MockQuizQuestion> questions = MockData.quizQuestions;
    final int totalQuestions = questions.length;
    final int questionNumber = _currentIndex + 1;
    final MockQuizQuestion currentQuestion = questions[_currentIndex];
    final bool hasAnswer = _selectedAnswers.containsKey(_currentIndex);
    final bool isLastQuestion = _currentIndex == totalQuestions - 1;

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
                // Encabezado diagnóstico
                const Text(
                  'EVALUACIÓN DIAGNÓSTICA',
                  style: AppTextStyles.columnHeader,
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Pregunta $questionNumber de $totalQuestions',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 8.0),
                ProgressBar(
                  value: questionNumber / totalQuestions,
                  showLabel: false,
                ),
                const SizedBox(height: 24.0),

                // Pregunta actual
                Text(
                  currentQuestion.prompt,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: AppColors.textMain,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20.0),

                // Opciones de respuesta
                for (
                  int i = 0;
                  i < currentQuestion.options.length;
                  i++
                ) ...<Widget>[
                  if (i > 0) const SizedBox(height: 12.0),
                  _buildOption(
                    theme: theme,
                    optionIndex: i,
                    optionText: currentQuestion.options[i],
                    isSelected: _selectedAnswers[_currentIndex] == i,
                  ),
                ],
                const SizedBox(height: 32.0),

                // Botones al pie: Anterior y Siguiente / Generar mi ruta
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: PillButton(
                          label: 'Anterior',
                          variant: PillButtonVariant.secondary,
                          onPressed: _currentIndex > 0
                              ? () {
                                  setState(() {
                                    _currentIndex--;
                                  });
                                }
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: !isLastQuestion
                            ? PillButton(
                                label: 'Siguiente',
                                variant: PillButtonVariant.primary,
                                onPressed: hasAnswer
                                    ? () {
                                        setState(() {
                                          _currentIndex++;
                                        });
                                      }
                                    : null,
                              )
                            : PillButton(
                                label: 'Generar mi ruta',
                                variant: PillButtonVariant.vivid,
                                onPressed: hasAnswer
                                    ? () {
                                        context.push(
                                          AppRoutes.route(
                                            MockData.generatedRouteId,
                                          ),
                                        );
                                      }
                                    : null,
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOption({
    required ThemeData theme,
    required int optionIndex,
    required String optionText,
    required bool isSelected,
  }) {
    return Semantics(
      selected: isSelected,
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        borderColor: isSelected ? AppColors.accentLavender : null,
        borderWidth: isSelected ? 2.0 : null,
        onTap: () {
          setState(() {
            _selectedAnswers[_currentIndex] = optionIndex;
          });
        },
        child: Row(
          children: <Widget>[
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected
                  ? AppColors.accentLavender
                  : AppColors.textMuted,
              size: 20.0,
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Text(
                optionText,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isSelected ? AppColors.textMain : AppColors.textMuted,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
