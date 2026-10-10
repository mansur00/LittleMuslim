import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/app_state.dart';

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

    // Persist onboarding data. Root _AppEntryPoint watches hasCompletedOnboarding
    // and will automatically show HomeScreen — no Navigator push needed.
    await appState.completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final name = appState.draftName.isNotEmpty ? appState.draftName : 'বন্ধু';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 64 : 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Celebration illustration
          Container(
            width: isTablet ? 200 : 150,
            height: isTablet ? 200 : 150,
            decoration: BoxDecoration(
              color: AppTheme.softGreen,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryGreen.withOpacity(0.2),
                  blurRadius: 40,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Center(
              child: Text(
                '🎉',
                style: TextStyle(fontSize: isTablet ? 80 : 64),
              ),
            ),
          )
              .animate()
              .scale(duration: 600.ms, curve: Curves.easeOutBack)
              .then()
              .shimmer(duration: 1200.ms, color: AppTheme.secondaryGold.withOpacity(0.3)),

          SizedBox(height: isTablet ? 40 : 32),

          Text(
            'তুমি প্রস্তুত, $name!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isTablet ? 30 : 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryGreen,
            ),
          )
              .animate()
              .fadeIn(delay: 200.ms, duration: 500.ms),

          SizedBox(height: isTablet ? 16 : 12),

          Text(
            'এখন থেকে প্রতিদিন একটু একটু করে\nকুরআন ও ইসলাম শিখবে মজার সাথে',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isTablet ? 17 : 15,
              color: AppTheme.darkText.withOpacity(0.75),
              height: 1.5,
            ),
          )
              .animate()
              .fadeIn(delay: 350.ms, duration: 500.ms),

          SizedBox(height: isTablet ? 48 : 36),

          // What you will learn
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(isTablet ? 24 : 18),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                _LearnItem(
                  emoji: '🔤',
                  title: 'ক্বায়দা ও বর্ণমালা',
                  subtitle: 'মজার গেমের সাথে শেখা',
                  isTablet: isTablet,
                ),
                const Divider(height: 24),
                _LearnItem(
                  emoji: '📖',
                  title: 'কুরআন তিলাওয়াত',
                  subtitle: 'রঙিন পেজ + সঠিক উচ্চারণ',
                  isTablet: isTablet,
                ),
                const Divider(height: 24),
                _LearnItem(
                  emoji: '🕌',
                  title: 'নামাজ ও দোয়া',
                  subtitle: 'নিয়ম + মাসনুন দোয়া',
                  isTablet: isTablet,
                ),
                const Divider(height: 24),
                _LearnItem(
                  emoji: '🌟',
                  title: 'রাসূল (সা.)-এর সীরাত',
                  subtitle: 'স্টোরি আকারে',
                  isTablet: isTablet,
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(delay: 500.ms, duration: 600.ms)
              .slideY(begin: 0.15, end: 0),

          SizedBox(height: isTablet ? 48 : 36),

          // Start Journey Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _finishOnboarding(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                padding: EdgeInsets.symmetric(
                  vertical: isTablet ? 20 : 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 0,
              ),
              child: Text(
                'যাত্রা শুরু করি 🚀',
                style: TextStyle(
                  fontSize: isTablet ? 18 : 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
              .animate()
              .fadeIn(delay: 700.ms, duration: 500.ms)
              .slideY(begin: 0.2, end: 0),
        ],
      ),
    );
  }
}

class _LearnItem extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final bool isTablet;

  const _LearnItem({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(emoji, style: TextStyle(fontSize: isTablet ? 28 : 24)),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14.5,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.darkText,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: isTablet ? 13 : 12,
                  color: AppTheme.darkText.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
