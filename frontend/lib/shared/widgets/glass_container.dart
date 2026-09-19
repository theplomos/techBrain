import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_tokens.dart';

/// Superficie de vidrio de TechBrain.
///
/// Es la única tarjeta glass de la app: tarjetas de contenido, barras de
/// navegación y vistas de error se construyen sobre ella.
///
/// El desenfoque está apagado por defecto porque `BackdropFilter` es caro en
/// web; solo las dos barras de navegación lo encienden.
class GlassContainer extends StatefulWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.blur = false,
    this.color = AppColors.cardBg,
    this.borderRadius = AppRadii.card,
    this.padding,
    this.onTap,
    this.semanticLabel,
  });

  final Widget child;

  /// Aplica un BackdropFilter con [AppBlur.bar]. Solo para las barras.
  final bool blur;

  final Color color;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  /// Si no es null, la tarjeta reacciona al cursor, al foco, al toque,
  /// a Enter y a Espacio.
  final VoidCallback? onTap;

  final String? semanticLabel;

  @override
  State<GlassContainer> createState() => _GlassContainerState();
}

class _GlassContainerState extends State<GlassContainer> {
  bool _hovered = false;
  bool _focused = false;

  bool get _interactive => widget.onTap != null;
  bool get _highlighted => _interactive && (_hovered || _focused);

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(widget.borderRadius);
    final bool reduceMotion = MediaQuery.disableAnimationsOf(context);

    Widget surface = AnimatedContainer(
      duration: AppMotion.hover,
      curve: AppMotion.hoverCurve,
      transform: Matrix4.translationValues(
        0,
        _highlighted && !reduceMotion ? -4.0 : 0.0,
        0,
      ),
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: radius,
        border: Border.all(
          color: _highlighted
              ? AppColors.cardBorderHover
              : AppColors.cardBorder,
        ),
        boxShadow: _highlighted ? AppShadows.glowLg : AppShadows.glowSm,
      ),
      child: widget.child,
    );

    if (widget.blur) {
      surface = ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: AppBlur.bar, sigmaY: AppBlur.bar),
          child: surface,
        ),
      );
    }

    if (!_interactive) {
      if (widget.semanticLabel == null) return surface;
      return Semantics(
        label: widget.semanticLabel,
        container: true,
        child: surface,
      );
    }

    final VoidCallback onTap = widget.onTap!;

    return Semantics(
      label: widget.semanticLabel,
      button: true,
      container: true,
      child: FocusableActionDetector(
        mouseCursor: SystemMouseCursors.click,
        onShowHoverHighlight: (bool value) => setState(() => _hovered = value),
        onShowFocusHighlight: (bool value) => setState(() => _focused = value),
        actions: <Type, Action<Intent>>{
          // Enter mapea a ButtonActivateIntent en escritorio y web,
          // y Espacio a ActivateIntent. Se registran los dos.
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              onTap();
              return null;
            },
          ),
          ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
            onInvoke: (_) {
              onTap();
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: surface,
        ),
      ),
    );
  }
}
