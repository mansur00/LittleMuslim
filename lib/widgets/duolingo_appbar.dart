import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'vector_icons.dart';

/// Shared Duolingo-style page header used on every inner screen.
/// Standardized with 3D tactile bevel, bubble accents, and responsive layout.
class DuolingoHeader extends StatelessWidget {
  const DuolingoHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.iconType,
    this.iconData,
    this.customIcon,
    this.gradientColors = const [Color(0xFF58CC02), Color(0xFF46A302)],
    this.onBack,
    this.trailing,
    this.margin = const EdgeInsets.only(bottom: 20),
  });

  final String title;
  final String? subtitle;
  final VectorIconType? iconType;
  final IconData? iconData;
  final Widget? customIcon;
  final List<Color> gradientColors;
  final VoidCallback? onBack;
  final Widget? trailing;
  final EdgeInsets margin;

  /// PreferredSizeWidget adapter for screens using Scaffold(appBar: ...)
  static PreferredSizeWidget appBar({
    Key? key,
    required String title,
    String? subtitle,
    VectorIconType? iconType,
    IconData? iconData,
    Widget? customIcon,
    List<Color> gradientColors = const [Color(0xFF58CC02), Color(0xFF46A302)],
    VoidCallback? onBack,
    Widget? trailing,
  }) {
    final hasSubtitle = subtitle != null && subtitle.trim().isNotEmpty;
    final barHeight = hasSubtitle ? 125.0 : 100.0;
    return PreferredSize(
      key: key,
      preferredSize: Size.fromHeight(barHeight),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
          child: DuolingoHeader(
            title: title,
            subtitle: subtitle,
            iconType: iconType,
            iconData: iconData,
            customIcon: customIcon,
            gradientColors: gradientColors,
            onBack: onBack,
            trailing: trailing,
            margin: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lastColor = gradientColors.length > 1 ? gradientColors.last : gradientColors.first;
    final shadowColor = HSLColor.fromColor(lastColor)
        .withLightness(
          (HSLColor.fromColor(lastColor).lightness - .16)
              .clamp(0.0, 1.0),
        )
        .toColor();

    final hasIcon = customIcon != null || iconData != null || iconType != null;

    return Container(
      margin: margin,
      child: Stack(
        children: [
          Positioned.fill(
            top: 7,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: shadowColor,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 7),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withValues(alpha: .24),
                width: 1.5,
              ),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  right: -24,
                  top: -24,
                  child: _HeaderBubble(
                    size: 100,
                    color: Colors.white.withValues(alpha: .10),
                  ),
                ),
                Positioned(
                  right: 48,
                  bottom: -30,
                  child: _HeaderBubble(
                    size: 68,
                    color: Colors.white.withValues(alpha: .08),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (onBack != null)
                          Semantics(
                            button: true,
                            label: context.t('common.go_back'),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: onBack,
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.25),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.35),
                                      width: 1.2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.arrow_back_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          )
                        else
                          const SizedBox.shrink(),
                        if (trailing != null)
                          Flexible(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: trailing!,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        if (hasIcon) ...[
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withValues(alpha: .45),
                                  Colors.white.withValues(alpha: .18),
                                ],
                              ),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: .40),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: shadowColor.withValues(alpha: .30),
                                  blurRadius: 0,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Center(
                              child: customIcon ??
                                  (iconData != null
                                      ? Icon(iconData, size: 26, color: Colors.white)
                                      : VectorIcon(
                                          type: iconType ?? VectorIconType.book,
                                          size: 28,
                                          color: Colors.white,
                                        )),
                            ),
                          ),
                          const SizedBox(width: 14),
                        ],
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              LocalizedText(
                                title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w900,
                                  height: 1.2,
                                ),
                              ),
                              if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
                                const SizedBox(height: 3),
                                LocalizedText(
                                  subtitle!,
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.90),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Unified aliases for DuolingoHeader
typedef DuolingoPageHeader = DuolingoHeader;
typedef AppHeader = DuolingoHeader;

class _HeaderBubble extends StatelessWidget {
  const _HeaderBubble({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
}

/// Duolingo-style section label with optional badge.
class DuolingoSectionLabel extends StatelessWidget {
  const DuolingoSectionLabel(
      {super.key,
      required this.label,
      this.badgeText,
      this.badgeColor,
      this.badgeTextColor});

  final String label;
  final String? badgeText;
  final Color? badgeColor;
  final Color? badgeTextColor;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          child: LocalizedText(label,
              style: const TextStyle(
                  color: Color(0xFF1A3C34),
                  fontSize: 17,
                  fontWeight: FontWeight.w900))),
      if (badgeText != null)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
              color: badgeColor ?? const Color(0xFFE8F8D8),
              borderRadius: BorderRadius.circular(12)),
          child: LocalizedText(badgeText!,
              style: TextStyle(
                  color: badgeTextColor ?? const Color(0xFF58A700),
                  fontSize: 11,
                  fontWeight: FontWeight.w800)),
        ),
    ]);
  }
}

/// Horizontal pill category bar.
class DuolingoCategoryBar extends StatelessWidget {
  const DuolingoCategoryBar(
      {super.key,
      required this.categories,
      required this.selected,
      required this.onSelect,
      this.activeColor = const Color(0xFF58CC02)});

  final List<String> categories;
  final int selected;
  final ValueChanged<int> onSelect;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final isActive = selected == i;
          return _CategoryPill(
            label: categories[i],
            isActive: isActive,
            activeColor: activeColor,
            onTap: () => onSelect(i),
          );
        },
      ),
    );
  }
}

class _CategoryPill extends StatefulWidget {
  const _CategoryPill({
    required this.label,
    required this.isActive,
    required this.activeColor,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final Color activeColor;
  final VoidCallback onTap;

  @override
  State<_CategoryPill> createState() => _CategoryPillState();
}

class _CategoryPillState extends State<_CategoryPill> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final depth = widget.isActive ? 3.0 : 2.0;
    final base = widget.isActive
        ? HSLColor.fromColor(widget.activeColor)
            .withLightness(
              (HSLColor.fromColor(widget.activeColor).lightness - .14)
                  .clamp(0.0, 1.0),
            )
            .toColor()
        : const Color(0xFFD9DEE3);
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        curve: Curves.easeOut,
        height: 40,
        transform: Matrix4.translationValues(0, _pressed ? depth : 0, 0),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: widget.isActive ? widget.activeColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: widget.isActive
                ? Colors.white.withValues(alpha: .22)
                : const Color(0xFFE5E7EB),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: base,
              blurRadius: 0,
              offset: Offset(0, _pressed ? 0 : depth),
            ),
          ],
        ),
        child: LocalizedText(
          widget.label,
          style: TextStyle(
            color: widget.isActive ? Colors.white : const Color(0xFF6B7280),
            fontWeight: FontWeight.w800,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

/// A 3D Duolingo-style pressable card.
class DuolingoCard extends StatefulWidget {
  const DuolingoCard({
    super.key,
    required this.child,
    this.onTap,
    this.accentColor = const Color(0xFF58CC02),
    this.backgroundColor = Colors.white,
    this.margin = const EdgeInsets.only(bottom: 12),
    this.padding = const EdgeInsets.all(16),
    this.showAccentStripe = false,
  });

  final Widget child;
  final VoidCallback? onTap;
  final Color accentColor;
  final Color backgroundColor;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final bool showAccentStripe;

  @override
  State<DuolingoCard> createState() => _DuolingoCardState();
}

class _DuolingoCardState extends State<DuolingoCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown:
          widget.onTap != null ? (_) => setState(() => _pressed = true) : null,
      onTapUp: widget.onTap != null
          ? (_) {
              setState(() => _pressed = false);
              widget.onTap!();
            }
          : null,
      onTapCancel:
          widget.onTap != null ? () => setState(() => _pressed = false) : null,
      child: Container(
        margin: widget.margin,
        child: Stack(
          children: [
            Positioned.fill(
              top: 5,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: HSLColor.fromColor(widget.accentColor)
                      .withLightness(
                        (HSLColor.fromColor(widget.accentColor).lightness - .16)
                            .clamp(0.0, 1.0),
                      )
                      .toColor(),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            AnimatedPadding(
              duration: const Duration(milliseconds: 90),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(
                  top: _pressed ? 5 : 0, bottom: _pressed ? 0 : 5),
              child: Container(
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: widget.accentColor.withValues(alpha: .28),
                    width: 2.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.accentColor.withValues(alpha: .10),
                      blurRadius: 10,
                      offset: Offset(0, _pressed ? 1 : 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Row(children: [
                    if (widget.showAccentStripe)
                      Container(width: 5, color: widget.accentColor),
                    Expanded(
                        child: Padding(
                            padding: widget.padding, child: widget.child)),
                  ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
