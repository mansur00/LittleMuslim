import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/app_state.dart';
import '../../widgets/vector_icons.dart';

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
    final name = appState.draftName.isNotEmpty ? appState.draftName : 'বন্ধু';

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
                  Container(
                    width: isTablet ? 160 : 120,
                    height: isTablet ? 160 : 120,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF58CC02), Color(0xFF58A700)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color:
                              const Color(0xFF58CC02).withValues(alpha: 0.35),
                          blurRadius: 28,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Center(
                      child: VectorIcon(
                        type: VectorIconType.check,
                        size: isTablet ? 72 : 56,
                        color: Colors.white,
                      ),
                    ),
                  )
                      .animate()
                      .scale(duration: 550.ms, curve: Curves.easeOutBack)
                      .then()
                      .shimmer(
                        duration: 1000.ms,
                        color: Colors.white.withValues(alpha: 0.25),
                      ),
                  SizedBox(height: isTablet ? 32 : 24),
                  Text(
                    'তুমি প্রস্তুত, $name!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isTablet ? 28 : 22,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.primaryGreen,
                    ),
                  ).animate().fadeIn(delay: 180.ms, duration: 450.ms),
                  SizedBox(height: isTablet ? 12 : 8),
                  Text(
                    'এখন থেকে প্রতিদিন একটু একটু করে\nকুরআন ও ইসলাম শিখবে মজার সাথে',
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
                          title: 'ক্বায়দা ও বর্ণমালা',
                          subtitle: 'মজার গেমের সাথে শেখা',
                          isTablet: isTablet,
                        ),
                        const SizedBox(height: 12),
                        _LearnItem(
                          type: VectorIconType.book,
                          color: const Color(0xFFE8913A),
                          bg: const Color(0xFFFFF0DB),
                          title: 'কুরআন তিলাওয়াত',
                          subtitle: 'রঙিন পেজ + সঠিক উচ্চারণ',
                          isTablet: isTablet,
                        ),
                        const SizedBox(height: 12),
                        _LearnItem(
                          type: VectorIconType.mosque,
                          color: const Color(0xFF3B82C4),
                          bg: const Color(0xFFDCEBFF),
                          title: 'নামাজ ও দোয়া',
                          subtitle: 'নিয়ম + মাসনুন দোয়া',
                          isTablet: isTablet,
                        ),
                        const SizedBox(height: 12),
                        _LearnItem(
                          type: VectorIconType.scroll,
                          color: const Color(0xFFE05A7A),
                          bg: const Color(0xFFFFE8EE),
                          title: 'রাসূল (সা.)-এর সীরাত',
                          subtitle: 'স্টোরি আকারে',
                          isTablet: isTablet,
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 420.ms, duration: 500.ms)
                      .slideY(begin: 0.12, end: 0),
                  SizedBox(height: isTablet ? 36 : 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _finishOnboarding(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF58CC02),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(
                          vertical: isTablet ? 20 : 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: Text(
                        'যাত্রা শুরু করি',
                        style: TextStyle(
                          fontSize: isTablet ? 18 : 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
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
