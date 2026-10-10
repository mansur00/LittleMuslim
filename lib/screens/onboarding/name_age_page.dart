import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/app_state.dart';

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
      padding: EdgeInsets.symmetric(horizontal: widget.isTablet ? 64 : 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          Text(
            'তোমার নাম কী?',
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
            'আমরা তোমাকে সঠিকভাবে স্বাগত জানাব',
            style: TextStyle(
              fontSize: widget.isTablet ? 16 : 14,
              color: AppTheme.darkText.withOpacity(0.65),
            ),
          ),

          SizedBox(height: widget.isTablet ? 36 : 28),

          TextField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            style: TextStyle(
              fontSize: widget.isTablet ? 18 : 16,
              fontWeight: FontWeight.w500,
            ),
            onChanged: (value) {
              context.read<AppState>().updateDraftName(value);
            },
            decoration: InputDecoration(
              hintText: 'যেমন: আয়েশা, ইউসুফ, ফাতিমা...',
              hintStyle: TextStyle(
                color: AppTheme.darkText.withOpacity(0.4),
              ),
              filled: true,
              fillColor: AppTheme.white,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: widget.isTablet ? 20 : 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: AppTheme.primaryGreen.withOpacity(0.15),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: AppTheme.primaryGreen,
                  width: 2,
                ),
              ),
              prefixIcon: const Icon(
                Icons.person_outline_rounded,
                color: AppTheme.primaryGreen,
              ),
            ),
          )
              .animate()
              .fadeIn(delay: 150.ms, duration: 400.ms),

          SizedBox(height: widget.isTablet ? 40 : 32),

          Text(
            'তোমার বয়স কত?',
            style: TextStyle(
              fontSize: widget.isTablet ? 22 : 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.darkText,
            ),
          )
              .animate()
              .fadeIn(delay: 250.ms, duration: 400.ms),

          const SizedBox(height: 16),

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
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: widget.isTablet ? 64 : 52,
                  height: widget.isTablet ? 64 : 52,
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primaryGreen : AppTheme.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.primaryGreen
                          : AppTheme.primaryGreen.withOpacity(0.2),
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppTheme.primaryGreen.withOpacity(0.25),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            )
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      '$age',
                      style: TextStyle(
                        fontSize: widget.isTablet ? 20 : 17,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : AppTheme.darkText,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          )
              .animate()
              .fadeIn(delay: 350.ms, duration: 400.ms),

          const Spacer(),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.lightGold.withOpacity(0.5),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Text('💡', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '৬-১৪ বছরের বাচ্চাদের জন্য তৈরি। তোমার বয়স অনুযায়ী কন্টেন্ট দেখানো হবে।',
                    style: TextStyle(
                      fontSize: widget.isTablet ? 14 : 12.5,
                      color: AppTheme.darkText.withOpacity(0.8),
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(delay: 450.ms, duration: 400.ms),

          SizedBox(height: widget.isTablet ? 24 : 16),
        ],
      ),
    );
  }
}
