import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/app_state.dart';

class LanguagePage extends StatefulWidget {
  final bool isTablet;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const LanguagePage({
    super.key,
    required this.isTablet,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String _selectedLang = 'bn';
  bool _initialized = false;

  final List<Map<String, String>> _languages = [
    {
      'code': 'bn',
      'name': 'বাংলা',
      'native': 'Bengali',
      'flag': '🇧🇩',
    },
    {
      'code': 'en',
      'name': 'English',
      'native': 'ইংরেজি',
      'flag': '🇬🇧',
    },
    {
      'code': 'ar',
      'name': 'العربية',
      'native': 'Arabic',
      'flag': '🇸🇦',
    },
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final appState = context.read<AppState>();
      _selectedLang = appState.draftLanguage;
      _initialized = true;
    }
  }

  void _selectLanguage(String code) {
    setState(() => _selectedLang = code);
    context.read<AppState>().updateDraftLanguage(code);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.isTablet ? 64 : 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          Text(
            'ভাষা বেছে নাও',
            style: TextStyle(
              fontSize: widget.isTablet ? 28 : 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkText,
            ),
          )
              .animate()
              .fadeIn(duration: 400.ms)
              .slideX(begin: -0.1, end: 0),

          const SizedBox(height: 8),
          Text(
            'অ্যাপের ভাষা নির্বাচন করো। পরে পরিবর্তন করা যাবে।',
            style: TextStyle(
              fontSize: widget.isTablet ? 16 : 14,
              color: AppTheme.darkText.withOpacity(0.65),
            ),
          ),

          SizedBox(height: widget.isTablet ? 40 : 32),

          ..._languages.asMap().entries.map((entry) {
            final index = entry.key;
            final lang = entry.value;
            final isSelected = _selectedLang == lang['code'];

            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: GestureDetector(
                onTap: () => _selectLanguage(lang['code']!),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: EdgeInsets.symmetric(
                    horizontal: widget.isTablet ? 24 : 18,
                    vertical: widget.isTablet ? 20 : 16,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primaryGreen : AppTheme.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.primaryGreen
                          : AppTheme.primaryGreen.withOpacity(0.15),
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppTheme.primaryGreen.withOpacity(0.2),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            )
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            )
                          ],
                  ),
                  child: Row(
                    children: [
                      Text(
                        lang['flag']!,
                        style: TextStyle(fontSize: widget.isTablet ? 32 : 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lang['name']!,
                              style: TextStyle(
                                fontSize: widget.isTablet ? 18 : 16,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Colors.white
                                    : AppTheme.darkText,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              lang['native']!,
                              style: TextStyle(
                                fontSize: widget.isTablet ? 14 : 13,
                                color: isSelected
                                    ? Colors.white.withOpacity(0.85)
                                    : AppTheme.darkText.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        const Icon(
                          Icons.check_circle_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                    ],
                  ),
                ),
              )
                  .animate()
                  .fadeIn(delay: (150 * index).ms, duration: 400.ms)
                  .slideX(begin: 0.1, end: 0),
            );
          }),

          const Spacer(),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.softGreen,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Text('🌍', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'কুরআনের আরবি টেক্সট সবসময় আরবিতেই থাকবে। শুধু অ্যাপের বাটন ও নির্দেশনা পরিবর্তন হবে।',
                    style: TextStyle(
                      fontSize: widget.isTablet ? 14 : 12.5,
                      color: AppTheme.darkText.withOpacity(0.85),
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: widget.isTablet ? 24 : 16),
        ],
      ),
    );
  }
}
