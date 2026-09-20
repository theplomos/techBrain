import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_tokens.dart';
import '../../config/theme/app_typography.dart';

/// Variantes de [PillButton].
///
/// Según el §4.2 del sistema de diseño, cada pantalla usa como máximo un
/// botón [vivid].
enum PillButtonVariant { primary, secondary, vivid }

/// Botón en forma de píldora de TechBrain.
class PillButton extends StatefulWidget {
  const PillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = PillButtonVariant.primary,
    this.icon,
  });

  /// Se muestra siempre en mayúsculas.
  final String label;

  /// Con null el botón queda deshabilitado.
  final VoidCallback? onPressed;

  final PillButtonVariant variant;
  final IconData? icon;

  @override
  State<PillButton> createState() => _PillButtonState();
}

class _PillButtonState extends State<PillButton> {
  bool _hovered = false;
  bool _focused = false;

  bool get _enabled => widget.onPressed != null;
  bool get _highlighted => _enabled && (_hovered || _focused);

  BoxDecoration get _decoration {
    final BorderRadius radius = BorderRadius.circular(AppRadii.pill);

    return switch (widget.variant) {
      PillButtonVariant.primary => BoxDecoration(
        borderRadius: radius,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[AppColors.accentMid, AppColors.accentElectric],
        ),
        boxShadow: _highlighted
            ? AppShadows.buttonPrimaryHover
            : AppShadows.buttonPrimary,
      ),
      PillButtonVariant.secondary => BoxDecoration(
        borderRadius: radius,
        color: _highlighted
            ? const Color.fromRGBO(192, 185, 252, 0.12)
            : Colors.transparent,
        border: Border.all(
          color: _highlighted ? Colors.white : AppColors.accentLavender,
          width: 2.0,
        ),
      ),
      PillButtonVariant.vivid => BoxDecoration(
        borderRadius: radius,
        color: AppColors.accentVivid,
        boxShadow: _highlighted
            ? AppShadows.buttonVividHover
            : AppShadows.buttonVivid,
      ),
    };
  }

  TextStyle get _textStyle => switch (widget.variant) {
    PillButtonVariant.primary => AppTextStyles.button.copyWith(
      color: Colors.white,
    ),
    PillButtonVariant.secondary => AppTextStyles.button.copyWith(
      color: AppColors.textMain,
    ),
    PillButtonVariant.vivid => AppTextStyles.buttonVivid.copyWith(
      color: AppColors.textOnVivid,
    ),
  };

  @override
  Widget build(BuildContext context) {
    final bool reduceMotion = MediaQuery.disableAnimationsOf(context);
    final TextStyle style = _textStyle;
    final String label = widget.label.toUpperCase();

    final Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (widget.icon != null) ...<Widget>[
          Icon(widget.icon, size: 16.0, color: style.color),
          const SizedBox(width: 8.0),
        ],
        Text(label, style: style),
      ],
    );

    final Widget button = AnimatedContainer(
      duration: AppMotion.hover,
      curve: AppMotion.hoverCurve,
      transform: Matrix4.translationValues(
        0,
        _highlighted && !reduceMotion ? -2.0 : 0.0,
        0,
      ),
      constraints: const BoxConstraints(minHeight: 44.0, minWidth: 44.0),
      padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 13.0),
      decoration: _decoration,
      foregroundDecoration: _enabled && _focused
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadii.pill),
              border: Border.all(
                color: AppFocus.ringColor,
                width: AppFocus.ringWidth,
              ),
            )
          : null,
      child: content,
    );

    if (!_enabled) {
      return Semantics(
        label: label,
        button: true,
        enabled: false,
        child: ExcludeSemantics(child: Opacity(opacity: 0.5, child: button)),
      );
    }

    final VoidCallback onPressed = widget.onPressed!;

    // El ExcludeSemantics evita que el InkWell y el GestureDetector dupliquen
    // nodos, pero también borra su acción de activación: el Semantics exterior
    // la repone con onTap (RNF-11).
    return Semantics(
      label: label,
      button: true,
      onTap: onPressed,
      child: ExcludeSemantics(
        child: FocusableActionDetector(
          mouseCursor: SystemMouseCursors.click,
          onShowHoverHighlight: (bool value) =>
              setState(() => _hovered = value),
          onShowFocusHighlight: (bool value) =>
              setState(() => _focused = value),
          actions: <Type, Action<Intent>>{
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (_) {
                onPressed();
                return null;
              },
            ),
            ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
              onInvoke: (_) {
                onPressed();
                return null;
              },
            ),
          },
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onPressed,
            child: button,
          ),
        ),
      ),
    );
  }
}
