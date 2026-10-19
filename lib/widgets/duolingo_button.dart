import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

/// Tactile 3D Duolingo-style pushable button.
/// Depresses downward with a 3D bevel when pressed for an ultra-satisfying tactile feel.
class Duolingo3DButton extends StatefulWidget {
  const Duolingo3DButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = const Color(0xFF58CC02),
    this.shadowColor = const Color(0xFF46A302),
    this.textColor = Colors.white,
    this.height = 54,
    this.width,
    this.fontSize = 16,
    this.borderRadius = 16, // DS.rLg
    this.depth = 4, // DS.bevelSm
    this.icon,
    this.trailingIcon,
    this.isLoading = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final Color color;
  final Color shadowColor;
  final Color textColor;
  final double height;
  final double? width;
  final double fontSize;
  final double borderRadius;
  final double depth;
  final Widget? icon;
  final Widget? trailingIcon;
  final bool isLoading;

  /// Secondary white style button with gray bottom shadow
  factory Duolingo3DButton.secondary({
    Key? key,
    required String text,
    required VoidCallback? onPressed,
    double height = 54,
    double? width,
    Widget? icon,
    Widget? trailingIcon,
  }) {
    return Duolingo3DButton(
      key: key,
      text: text,
      onPressed: onPressed,
      color: Colors.white,
      shadowColor: const Color(0xFFE5E7EB),
      textColor: const Color(0xFF374151),
      height: height,
      width: width,
      icon: icon,
      trailingIcon: trailingIcon,
    );
  }

  /// Gold/XP style button
  factory Duolingo3DButton.gold({
    Key? key,
    required String text,
    required VoidCallback? onPressed,
    double height = 54,
    double? width,
    Widget? icon,
    Widget? trailingIcon,
  }) {
    return Duolingo3DButton(
      key: key,
      text: text,
      onPressed: onPressed,
      color: const Color(0xFFFFC800),
      shadowColor: const Color(0xFFE5A100),
      textColor: Colors.white,
      height: height,
      width: width,
      icon: icon,
      trailingIcon: trailingIcon,
    );
  }

  /// Little Muslim brand green theme button
  factory Duolingo3DButton.brandGreen({
    Key? key,
    required String text,
    required VoidCallback? onPressed,
    double height = 54,
    double? width,
    Widget? icon,
    Widget? trailingIcon,
  }) {
    return Duolingo3DButton(
      key: key,
      text: text,
      onPressed: onPressed,
      color: const Color(0xFF58CC02),
      shadowColor: const Color(0xFF46A302),
      textColor: Colors.white,
      height: height,
      width: width,
      icon: icon,
      trailingIcon: trailingIcon,
    );
  }

  /// Backwards compatible teal alias now routed to brand green
  factory Duolingo3DButton.teal({
    Key? key,
    required String text,
    required VoidCallback? onPressed,
    double height = 54,
    double? width,
    Widget? icon,
    Widget? trailingIcon,
  }) => Duolingo3DButton.brandGreen(
    key: key,
    text: text,
    onPressed: onPressed,
    height: height,
    width: width,
    icon: icon,
    trailingIcon: trailingIcon,
  );

  @override
  State<Duolingo3DButton> createState() => _Duolingo3DButtonState();
}

class _Duolingo3DButtonState extends State<Duolingo3DButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null || widget.isLoading;
    final depth = widget.depth;
    final totalHeight = widget.height + depth;

    final effectiveColor = isDisabled ? const Color(0xFFE5E7EB) : widget.color;
    final effectiveShadowColor =
        isDisabled ? const Color(0xFFD1D5DB) : widget.shadowColor;
    final effectiveTextColor =
        isDisabled ? const Color(0xFF9CA3AF) : widget.textColor;

    return GestureDetector(
      onTapDown: isDisabled ? null : (_) => setState(() => _isPressed = true),
      onTapUp: isDisabled
          ? null
          : (_) {
              setState(() => _isPressed = false);
              widget.onPressed?.call();
            },
      onTapCancel: isDisabled ? null : () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 60),
        curve: Curves.easeOutQuad,
        width: widget.width,
        height: widget.height,
        margin: EdgeInsets.only(
          top: _isPressed ? depth : 0,
          bottom: _isPressed ? 0 : depth,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: effectiveColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.22),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: effectiveShadowColor,
              offset: Offset(0, _isPressed ? 0 : depth),
              blurRadius: 0,
            ),
          ],
        ),
        child: Center(
          child: widget.isLoading
              ? SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(effectiveTextColor),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.icon != null) ...[
                      widget.icon!,
                      const SizedBox(width: 6),
                    ],
                    Flexible(
                      child: LocalizedText(
                        widget.text,
                        style: TextStyle(
                          color: effectiveTextColor,
                          fontSize: widget.fontSize,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (widget.trailingIcon != null) ...[
                      const SizedBox(width: 6),
                      widget.trailingIcon!,
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
