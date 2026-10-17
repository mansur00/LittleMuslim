import '../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../theme/design_system.dart';
import '../../utils/app_state.dart';
import '../../widgets/vector_icons.dart';

class NameAgePage extends StatefulWidget {
  final bool isTablet;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const NameAgePage({
    super.key,
    required this.isTablet,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<NameAgePage> createState() => _NameAgePageState();
}

class _NameAgePageState extends State<NameAgePage> {
  final TextEditingController _nameController = TextEditingController();
  int _selectedAge = 8;
  final List<int> _ages = List.generate(9, (i) => i + 6); // 6 to 14
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final appState = context.read<AppState>();
      if (appState.draftName.isNotEmpty) {
        _nameController.text = appState.draftName;
      }
      _selectedAge = appState.draftAge;
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.isTablet ? 64 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // Mascot speech row
          Row(
            children: [
              Container(
                width: widget.isTablet ? 68 : 54,
                height: widget.isTablet ? 68 : 54,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: DS.green500, width: 3),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x18000000),
                      offset: Offset(0, 3),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/mascot_reading.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.face_rounded, color: DS.green500),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(DS.rLg),
                    border: Border.all(color: const Color(0xFFE5E7EB), width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0C000000),
                        offset: Offset(0, 3),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: LocalizedText(
                    'তোমার নাম কী, ছোট্ট বন্ধু?',
                    style: TextStyle(
                      fontSize: widget.isTablet ? 18 : 15,
                      fontWeight: DS.black,
                      color: DS.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2, end: 0),

          SizedBox(height: widget.isTablet ? 28 : 20),

          TextField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            style: TextStyle(
              fontSize: widget.isTablet ? 18 : 16,
              fontWeight: DS.bold,
              color: DS.textPrimary,
            ),
            onChanged: (value) {
              context.read<AppState>().updateDraftName(value);
            },
            decoration: InputDecoration(
              hintText: context.uiText('যেমন: আয়েশা, ইউসুফ, ফাতিমা...'),
              hintStyle: const TextStyle(
                color: Color(0xFF9CA3AF),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: widget.isTablet ? 20 : 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(DS.rLg),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(DS.rLg),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(DS.rLg),
                borderSide: const BorderSide(
                  color: DS.green500,
                  width: 2.5,
                ),
              ),
              prefixIcon: const Icon(
                Icons.person_rounded,
                color: DS.green500,
              ),
            ),
          ).animate().fadeIn(delay: 150.ms, duration: 400.ms),

          SizedBox(height: widget.isTablet ? 32 : 24),

          LocalizedText(
            'তোমার বয়স কত?',
            style: TextStyle(
              fontSize: widget.isTablet ? 22 : 18,
              fontWeight: DS.black,
              color: DS.textPrimary,
            ),
          ).animate().fadeIn(delay: 250.ms, duration: 400.ms),

          const SizedBox(height: 14),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _ages.map((age) {
              final isSelected = _selectedAge == age;
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedAge = age);
                  context.read<AppState>().updateDraftAge(age);
                },
                child: SizedBox(
                  width: widget.isTablet ? 64 : 52,
                  height: widget.isTablet ? 64 : 52,
                  child: Stack(
                    children: [
                      // Bevel
                      Positioned.fill(
                        top: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected ? DS.green600 : const Color(0xFFD1D5DB),
                            borderRadius: BorderRadius.circular(DS.rMd),
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
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected ? DS.green500 : Colors.white,
                            borderRadius: BorderRadius.circular(DS.rMd),
                            border: Border.all(
                              color: isSelected ? DS.green600 : const Color(0xFFE5E7EB),
                              width: 1.5,
                            ),
                          ),
                          child: LocalizedText(
                            '$age',
                            style: TextStyle(
                              fontSize: widget.isTablet ? 20 : 17,
                              fontWeight: DS.black,
                              color: isSelected ? Colors.white : DS.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ).animate().fadeIn(delay: 350.ms, duration: 400.ms),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.lightGold.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const VectorIcon(
                  type: VectorIconType.lightbulb,
                  size: 24,
                  color: Color(0xFFD4A017),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: LocalizedText(
                    '৬-১৪ বছরের বাচ্চাদের জন্য তৈরি। তোমার বয়স অনুযায়ী কন্টেন্ট দেখানো হবে।',
                    style: TextStyle(
                      fontSize: widget.isTablet ? 14 : 12.5,
                      color: AppTheme.darkText.withValues(alpha: 0.8),
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 450.ms, duration: 400.ms),
          SizedBox(height: widget.isTablet ? 24 : 16),
        ],
      ),
    );
  }
}
