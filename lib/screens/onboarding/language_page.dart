import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../theme/design_system.dart';
import '../../utils/app_state.dart';
import '../../widgets/vector_icons.dart';

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

  VectorIconType _getFlagType(String code) {
    switch (code) {
      case 'bn':
        return VectorIconType.flagBd;
      case 'en':
        return VectorIconType.flagGb;
      case 'ar':
        return VectorIconType.flagSa;
      default:
        return VectorIconType.globe;
    }
  }

  final List<Map<String, String>> _languages = [
    {
      'code': 'bn',
      'name': 'বাংলা',
      'native': 'Bengali',
    },
    {
      'code': 'en',
      'name': 'English',
      'native': 'ইংরেজি',
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
          LocalizedText(
            'ভাষা বেছে নাও',
            style: TextStyle(
              fontSize: widget.isTablet ? 28 : 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkText,
            ),
          ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1, end: 0),
          const SizedBox(height: 8),
          LocalizedText(
            'অ্যাপের ভাষা নির্বাচন করো। পরে পরিবর্তন করা যাবে।',
            style: TextStyle(
              fontSize: widget.isTablet ? 16 : 14,
              color: AppTheme.darkText.withValues(alpha: 0.65),
            ),
          ),
          SizedBox(height: widget.isTablet ? 40 : 32),
          ..._languages.asMap().entries.map((entry) {
            final index = entry.key;
            final lang = entry.value;
            final isSelected = _selectedLang == lang['code'];

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: GestureDetector(
                onTap: () => _selectLanguage(lang['code']!),
                child: SizedBox(
                  height: widget.isTablet ? 82 : 72,
                  child: Stack(
                    children: [
                      // Bevel
                      Positioned.fill(
                        top: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected ? DS.green600 : const Color(0xFFD1D5DB),
                            borderRadius: BorderRadius.circular(DS.rXl),
                          ),
                        ),
                      ),
                      // Face
                      Positioned(
                        top: 0,
                        bottom: 4,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: widget.isTablet ? 22 : 16,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected ? DS.green100 : Colors.white,
                            borderRadius: BorderRadius.circular(DS.rXl),
                            border: Border.all(
                              color: isSelected ? DS.green500 : const Color(0xFFE5E7EB),
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              VectorIcon(
                                type: _getFlagType(lang['code']!),
                                size: widget.isTablet ? 36 : 30,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LocalizedText(
                                      lang['name']!,
                                      style: TextStyle(
                                        fontSize: widget.isTablet ? 18 : 16,
                                        fontWeight: DS.black,
                                        color: isSelected ? DS.green600 : DS.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    LocalizedText(
                                      lang['native']!,
                                      style: TextStyle(
                                        fontSize: widget.isTablet ? 14 : 13,
                                        fontWeight: DS.bold,
                                        color: isSelected
                                            ? DS.green600.withValues(alpha: 0.8)
                                            : DS.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: DS.green500,
                                  size: 28,
                                )
                              else
                                Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: const Color(0xFFD1D5DB), width: 2),
                                  ),
                                ),
                            ],
                          ),
                        ),
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
                const VectorIcon(
                  type: VectorIconType.globe,
                  size: 22,
                  color: AppTheme.primaryGreen,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: LocalizedText(
                    'কুরআনের আরবি টেক্সট সবসময় আরবিতেই থাকবে। শুধু অ্যাপের বাটন ও নির্দেশনা পরিবর্তন হবে।',
                    style: TextStyle(
                      fontSize: widget.isTablet ? 14 : 12.5,
                      color: AppTheme.darkText.withValues(alpha: 0.85),
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
