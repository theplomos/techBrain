import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';
import '../errors/failure.dart';
import 'glass_container.dart';
import 'pill_button.dart';

/// Vista de error reutilizable.
///
/// Recibe un [Object] porque `AsyncValue.error` no garantiza que el error sea
/// una [Failure]: si no lo es, se muestra el mensaje de [UnexpectedFailure]
/// para no enseñar al usuario un texto técnico.
class ErrorView extends StatelessWidget {
  const ErrorView({
    super.key,
    required this.error,
    this.onRetry,
    this.retryLabel = 'Reintentar',
  });

  final Object error;
  final VoidCallback? onRetry;
  final String retryLabel;

  String get _message => switch (error) {
    final Failure failure => failure.message,
    _ => const UnexpectedFailure().message,
  };

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420.0),
        child: GlassContainer(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(
                Icons.error_outline,
                size: 40.0,
                color: AppColors.accentLavender,
              ),
              const SizedBox(height: 16.0),
              Text(
                _message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              if (onRetry != null) ...<Widget>[
                const SizedBox(height: 24.0),
                PillButton(
                  label: retryLabel,
                  variant: PillButtonVariant.secondary,
                  onPressed: onRetry,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
