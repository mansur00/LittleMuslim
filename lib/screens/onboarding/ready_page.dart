import '../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../theme/design_system.dart';
import '../../utils/app_state.dart';
import '../../widgets/vector_icons.dart';
import '../../widgets/faceless_silhouette.dart';

class ReadyPage extends StatelessWidget {
  final bool isTablet;
  final VoidCallback onBack;

  const ReadyPage({
    super.key,
    required this.isTablet,
    required this.onBack,
  });

  Future<void> _finishOnboarding(BuildContext context) async {
    final appState = context.read<AppState>();
    await appState.completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final name = appState.draftName.isNotEmpty
        ? appState.draftName
        : context.t('common.friend');

    return LayoutBuilder(
      builder: (context, constraints) => ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isTablet ? 64 : 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 3D Celebrate Mascot
                  Container(
                    width: isTablet ? 150 : 120,
                    height: isTablet ? 150 : 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: DS.gold500, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: DS.gold500.withValues(alpha: 0.35),
                          blurRadius: 28,
                          offset: const Offset(0, 10),
                        ),
                        const BoxShadow(
                          color: Color(0xFFE5A100),
                          offset: Offset(0, 4),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Center(
                        child: FacelessSilhouette(
                          size: isTablet ? 140 : 115,
                          pose: SilhouettePose.celebrating,
                        ),
                      ),
                    ),
                  )
                      .animate()
                      .scale(duration: 550.ms, curve: Curves.easeOutBack),
                  SizedBox(height: isTablet ? 32 : 24),
                  Text(
                    context.t('onboarding.ready_name', params: {'name': name}),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isTablet ? 28 : 22,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.primaryGreen,
                    ),
                  ).animate().fadeIn(delay: 180.ms, duration: 450.ms),
                  if (appState.draftRole == 'admin') ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFF59E0B)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.admin_panel_settings_rounded,
                              color: Color(0xFFD97706), size: 16),
                          const SizedBox(width: 6),
                          Text(
                            context.t('onboarding.admin_badge_desc'),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF92400E),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 240.ms, duration: 400.ms),
                  ],
                  SizedBox(height: isTablet ? 12 : 8),
                  Text(
                    context.t('onboarding.ready_learn_fun'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isTablet ? 15 : 14,
                      color: AppTheme.darkText.withValues(alpha: 0.65),
                      height: 1.45,
                      fontWeight: FontWeight.w500,
                    ),
                  ).animate().fadeIn(delay: 300.ms, duration: 450.ms),
                  SizedBox(height: isTablet ? 36 : 28),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(isTablet ? 20 : 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      border:
                          Border.all(color: const Color(0xFFE5E5E5), width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _LearnItem(
                          type: VectorIconType.qaida,
                          color: const Color(0xFF58A700),
                          bg: const Color(0xFFE8F8D8),
                          title: context.t('onboarding.curriculum_qaida_title'),
                          subtitle: context.t('onboarding.curriculum_qaida_sub'),
                          isTablet: isTablet,
                        ),
                        const SizedBox(height: 12),
                        _LearnItem(
                          type: VectorIconType.book,
                          color: const Color(0xFFE8913A),
                          bg: const Color(0xFFFFF0DB),
                          title: context.t('onboarding.curriculum_quran_title'),
                          subtitle: context.t('onboarding.curriculum_quran_sub'),
                          isTablet: isTablet,
                        ),
                        const SizedBox(height: 12),
                        _LearnItem(
                          type: VectorIconType.mosque,
                          color: const Color(0xFF3B82C4),
                          bg: const Color(0xFFDCEBFF),
                          title: context.t('onboarding.curriculum_prayer_title'),
                          subtitle: context.t('onboarding.curriculum_prayer_sub'),
                          isTablet: isTablet,
                        ),
                        const SizedBox(height: 12),
                        _LearnItem(
                          type: VectorIconType.scroll,
                          color: const Color(0xFFE05A7A),
                          bg: const Color(0xFFFFE8EE),
                          title: context.t('onboarding.curriculum_seerah_title'),
                          subtitle: context.t('onboarding.curriculum_seerah_sub'),
                          isTablet: isTablet,
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 420.ms, duration: 500.ms)
                      .slideY(begin: 0.12, end: 0),
                  SizedBox(height: isTablet ? 36 : 28),
                  DSButton(
                    label: context.t('onboarding.start_journey_btn'),
                    width: double.infinity,
                    height: isTablet ? DS.btnLg : DS.btnMd,
                    color: DS.green500,
                    shadowColor: DS.green600,
                    onPressed: () => _finishOnboarding(context),
                  )
                      .animate()
                      .fadeIn(delay: 580.ms, duration: 450.ms)
                      .slideY(begin: 0.2, end: 0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LearnItem extends StatelessWidget {
  final VectorIconType type;
  final Color color;
  final Color bg;
  final String title;
  final String subtitle;
  final bool isTablet;

  const _LearnItem({
    required this.type,
    required this.color,
    required this.bg,
    required this.title,
    required this.subtitle,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconBadge(
          type: type,
          bgColor: bg,
          size: isTablet ? 46 : 40,
          iconColor: color,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: isTablet ? 15 : 13.5,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.darkText,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: isTablet ? 12 : 11,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.darkText.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
