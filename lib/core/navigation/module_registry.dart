import 'package:flutter/material.dart';
import '../../theme/design_system.dart';
import '../../screens/qaida/qaida_chapters_screen.dart';
import '../../screens/quran/quran_screen.dart';
import '../../screens/prayer/prayer_screen.dart';
import '../../screens/duas/duas_screen.dart';
import '../../screens/seerah/seerah_screen.dart';
import '../../screens/basics/islam_basics_screen.dart';
import '../../screens/achievements/achievements_screen.dart';
import '../constants/asset_paths.dart';

import '../../l10n/app_localizations.dart';

/// Descriptor for a primary learning module on the Home screen.
class AppModuleItem {
  const AppModuleItem({
    required this.id,
    required this.titleKey,
    required this.subtitleKey,
    required this.colors,
    this.badgeAsset,
    this.customBadge,
    required this.iconPainter,
    required this.routeBuilder,
    this.isEnabled = true,
  });

  final String id;
  final String titleKey;
  final String subtitleKey;
  String get title => titleKey;
  String get subtitle => subtitleKey;
  final ModuleColors colors;
  final String? badgeAsset;
  final Widget? customBadge;
  final CustomPainter iconPainter;
  final WidgetBuilder routeBuilder;
  final bool isEnabled;

  /// Resolves the localized module title via [BuildContext.t]
  String getLocalizedTitle(BuildContext context) => context.t(titleKey);

  /// Resolves the localized module subtitle via [BuildContext.t]
  String getLocalizedSubtitle(BuildContext context) => context.t(subtitleKey);
}

/// Global registry for all interactive learning modules.
///
/// **To add, remove, or reorder modules on the Home Screen, update this registry!**
class AppModuleRegistry {
  AppModuleRegistry._();

  static final List<AppModuleItem> all = [
    AppModuleItem(
      id: 'qaida',
      titleKey: 'nav.qaida',
      subtitleKey: 'nav.qaida_subtitle',
      colors: DS.qaida,
      badgeAsset: AssetPaths.badgeQaida,
      iconPainter: const QaidaIconPainter(),
      routeBuilder: (_) => const QaidaChaptersScreen(),
    ),
    AppModuleItem(
      id: 'quran',
      titleKey: 'nav.quran',
      subtitleKey: 'nav.quran_subtitle',
      colors: DS.quran,
      badgeAsset: AssetPaths.badgeQuran,
      iconPainter: const QuranIconPainter(),
      routeBuilder: (_) => const QuranScreen(),
    ),
    AppModuleItem(
      id: 'prayer',
      titleKey: 'nav.prayer',
      subtitleKey: 'nav.prayer_subtitle',
      colors: DS.prayer,
      badgeAsset: AssetPaths.badgePrayer,
      iconPainter: const PrayerIconPainter(),
      routeBuilder: (_) => const PrayerScreen(),
    ),
    AppModuleItem(
      id: 'dua',
      titleKey: 'nav.dua',
      subtitleKey: 'nav.dua_subtitle',
      colors: DS.dua,
      badgeAsset: AssetPaths.badgeDua,
      iconPainter: const DuaIconPainter(),
      routeBuilder: (_) => const DuasScreen(),
    ),
    AppModuleItem(
      id: 'seerah',
      titleKey: 'nav.seerah',
      subtitleKey: 'nav.seerah_subtitle',
      colors: DS.seerah,
      badgeAsset: AssetPaths.badgeSeerah,
      iconPainter: const SeerahIconPainter(),
      routeBuilder: (_) => const SeerahScreen(),
    ),
    AppModuleItem(
      id: 'basics',
      titleKey: 'nav.basics',
      subtitleKey: 'nav.basics_subtitle',
      colors: DS.basics,
      badgeAsset: AssetPaths.badgeBasics,
      iconPainter: const BasicsIconPainter(),
      routeBuilder: (_) => const IslamBasicsScreen(),
    ),
    AppModuleItem(
      id: 'achievements',
      titleKey: 'nav.achievements',
      subtitleKey: 'nav.achievements_subtitle',
      colors: DS.achievements,
      customBadge: const DSGamifyBadge(
        emblem: BadgeEmblem.trophy,
        primaryColor: Color(0xFFFFC800),
        bevelColor: Color(0xFFE5A100),
        ribbonColor: Color(0xFFFFD700),
        size: 76,
      ),
      iconPainter: const TrophyIconPainter(),
      routeBuilder: (_) => const AchievementsScreen(),
    ),
  ];

  /// List of only currently active/enabled modules
  static List<AppModuleItem> get activeModules =>
      all.where((m) => m.isEnabled).toList();
}
