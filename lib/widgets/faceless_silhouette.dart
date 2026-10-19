import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_state.dart';
import '../theme/design_system.dart';

/// Available avatar silhouette types
enum SilhouetteType {
  topi,
  hijab;

  static SilhouetteType fromString(String val) {
    if (val.toLowerCase() == 'hijab') return SilhouetteType.hijab;
    return SilhouetteType.topi;
  }
}

/// Available silhouette poses
enum SilhouettePose {
  portrait,
  reading,
  celebrating,
}

/// Curated child-friendly Islamic color palette for faceless silhouettes
const List<Color> kAvatarColors = [
  Color(0xFF10B981), // Emerald Green
  Color(0xFF0284C7), // Sky Blue
  Color(0xFF8B5CF6), // Royal Purple
  Color(0xFFF59E0B), // Golden Amber
  Color(0xFFF43F5E), // Rose Pink
  Color(0xFF0D9488), // Deep Teal
  Color(0xFF6366F1), // Indigo
  Color(0xFFF97316), // Sunset Orange
];

/// A Shari'ah-compliant, faceless Islamic silhouette widget.
/// Strictly no eyes, nose, mouth or living facial features.
/// Supports both Topi (boys) and Hijab (girls), with customizable tint color.
class FacelessSilhouette extends StatelessWidget {
  final SilhouetteType? type;
  final SilhouettePose pose;
  final Color? color;
  final double size;
  final bool circleBackground;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final bool tintMode;
  final VoidCallback? onTap;

  const FacelessSilhouette({
    super.key,
    this.type,
    this.pose = SilhouettePose.portrait,
    this.color,
    this.size = 80,
    this.circleBackground = false,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 2.0,
    this.tintMode = false,
    this.onTap,
  });

  String _getAssetPath(SilhouetteType t, SilhouettePose p) {
    switch (p) {
      case SilhouettePose.reading:
        return t == SilhouetteType.hijab
            ? 'assets/images/silhouette_reading_hijab.png'
            : 'assets/images/silhouette_reading_topi.png';
      case SilhouettePose.celebrating:
        return t == SilhouetteType.hijab
            ? 'assets/images/silhouette_celebrate_hijab.png'
            : 'assets/images/silhouette_celebrate_topi.png';
      case SilhouettePose.portrait:
      default:
        return t == SilhouetteType.hijab
            ? 'assets/images/silhouette_hijab.png'
            : 'assets/images/silhouette_topi.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Resolve type and color from AppState if not provided explicitly
    final appState = context.watch<AppState?>();
    final resolvedType = type ??
        (appState != null
            ? SilhouetteType.fromString(appState.avatarType)
            : SilhouetteType.topi);
    final resolvedColor = color ??
        (appState != null ? Color(appState.avatarColor) : const Color(0xFF10B981));

    final assetPath = _getAssetPath(resolvedType, pose);

    Widget imageWidget = Image.asset(
      assetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      color: tintMode ? resolvedColor : null,
      colorBlendMode: tintMode ? BlendMode.srcIn : null,
      errorBuilder: (_, __, ___) => Icon(
        resolvedType == SilhouetteType.hijab
            ? Icons.face_3_outlined
            : Icons.account_circle_outlined,
        size: size * 0.8,
        color: resolvedColor,
      ),
    );

    if (circleBackground) {
      final bg = backgroundColor ?? resolvedColor.withValues(alpha: 0.12);
      final border = borderColor ?? resolvedColor.withValues(alpha: 0.35);

      imageWidget = Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: bg,
          border: Border.all(color: border, width: borderWidth),
          boxShadow: [
            BoxShadow(
              color: resolvedColor.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: EdgeInsets.all(size * 0.08),
        child: ClipOval(child: imageWidget),
      );
    }

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}

/// Interactive Bottom Sheet to customize Avatar (Topi/Hijab) and Color
Future<void> showAvatarCustomizerModal(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => const _AvatarCustomizerContent(),
  );
}

class _AvatarCustomizerContent extends StatefulWidget {
  const _AvatarCustomizerContent();

  @override
  State<_AvatarCustomizerContent> createState() =>
      _AvatarCustomizerContentState();
}

class _AvatarCustomizerContentState extends State<_AvatarCustomizerContent> {
  late String _selectedType;
  late int _selectedColor;

  @override
  void initState() {
    super.initState();
    final appState = context.read<AppState>();
    _selectedType = appState.avatarType;
    _selectedColor = appState.avatarColor;
  }

  @override
  Widget build(BuildContext context) {
    final currentColor = Color(_selectedColor);
    final isBangla =
        context.watch<AppState>().selectedLanguage == 'bn';

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              isBangla ? 'অবতার ও রঙ নির্বাচন' : 'Choose Avatar & Color',
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isBangla
                  ? 'তোমার পছন্দের টুপি বা হিজাব ও প্রিয় রঙ বেছে নাও'
                  : 'Pick Topi or Hijab and your favorite color',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 18),

            // Live Preview Card
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentColor.withValues(alpha: 0.12),
                border: Border.all(color: currentColor, width: 3.5),
                boxShadow: [
                  BoxShadow(
                    color: currentColor.withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Image.asset(
                  _selectedType == 'hijab'
                      ? 'assets/images/silhouette_hijab.png'
                      : 'assets/images/silhouette_topi.png',
                  width: 90,
                  height: 90,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Topi / Hijab Selector
            Row(
              children: [
                Expanded(
                  child: _AvatarTypeButton(
                    title: isBangla ? 'টুপি (Topi)' : 'Topi (Boy)',
                    icon: Icons.person_rounded,
                    isSelected: _selectedType == 'topi',
                    color: currentColor,
                    onTap: () => setState(() => _selectedType = 'topi'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _AvatarTypeButton(
                    title: isBangla ? 'হিজাব (Hijab)' : 'Hijab (Girl)',
                    icon: Icons.face_3_rounded,
                    isSelected: _selectedType == 'hijab',
                    color: currentColor,
                    onTap: () => setState(() => _selectedType = 'hijab'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Color Selector Label
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                isBangla ? 'প্রিয় রঙ বাছুন:' : 'Select Color:',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF334155),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Color Palette Circles
            Wrap(
              spacing: 12,
              runSpacing: 10,
              children: kAvatarColors.map((col) {
                final isSelected = col.value == _selectedColor;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = col.value),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: col,
                      border: Border.all(
                        color: isSelected ? Colors.white : Colors.transparent,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: col.withValues(alpha: isSelected ? 0.5 : 0.2),
                          blurRadius: isSelected ? 8 : 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 20)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Save Button
            DSButton(
              label: isBangla ? 'সংরক্ষণ করুন' : 'Save Avatar',
              color: currentColor,
              fullWidth: true,
              onPressed: () {
                context.read<AppState>().updateAvatar(
                      type: _selectedType,
                      color: _selectedColor,
                    );
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AvatarTypeButton extends StatelessWidget {
  const _AvatarTypeButton({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.12) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? color : const Color(0xFFE2E8F0),
            width: isSelected ? 2.5 : 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? color : Colors.grey.shade600,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? color : const Color(0xFF475569),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
