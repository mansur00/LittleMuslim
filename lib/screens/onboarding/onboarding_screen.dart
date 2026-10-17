import '../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../theme/app_theme.dart';
import '../../theme/design_system.dart';
import '../../utils/app_state.dart';
import 'welcome_page.dart';
import 'name_age_page.dart';
import 'language_page.dart';
import 'ready_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Total pages: 0=Welcome, 1=NameAge, 2=Language, 3=Ready
  final int _totalPages = 4;

  void _nextPage() {
    // Validate name on Name & Age page (index 1)
    if (_currentPage == 1) {
      final appState = context.read<AppState>();
      if (appState.draftName.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const LocalizedText('তোমার নাম লিখো প্লিজ'),
            backgroundColor: AppTheme.accentCoral,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        return;
      }
    }

    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.shortestSide >= 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top skip button (except last page)
            if (_currentPage < _totalPages - 1)
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: isTablet ? 16 : 8,
                    right: isTablet ? 24 : 16,
                  ),
                  child: TextButton(
                    onPressed: () {
                      _pageController.animateToPage(
                        _totalPages - 1,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: LocalizedText(
                      'Skip',
                      style: TextStyle(
                        color: AppTheme.primaryGreen.withValues(alpha: 0.7),
                        fontSize: isTablet ? 16 : 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              )
            else
              const SizedBox(height: 48),

            // PageView
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                children: [
                  WelcomePage(
                    isTablet: isTablet,
                    onNext: _nextPage,
                  ),
                  NameAgePage(
                    isTablet: isTablet,
                    onNext: _nextPage,
                    onBack: _previousPage,
                  ),
                  LanguagePage(
                    isTablet: isTablet,
                    onNext: _nextPage,
                    onBack: _previousPage,
                  ),
                  ReadyPage(
                    isTablet: isTablet,
                    onBack: _previousPage,
                  ),
                ],
              ),
            ),

            // Bottom indicator + buttons
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 48 : 24,
                vertical: isTablet ? 32 : 20,
              ),
              child: Column(
                children: [
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _totalPages,
                    effect: const ExpandingDotsEffect(
                      activeDotColor: DS.green500,
                      dotColor: Color(0xFFE5E7EB),
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 3.5,
                      spacing: 6,
                    ),
                  ),
                  const SizedBox(height: 24),

                  if (_currentPage > 0 && _currentPage < _totalPages - 1)
                    Row(
                      children: [
                        Expanded(
                          child: DSButton(
                            label: 'পেছনে',
                            color: Colors.white,
                            shadowColor: const Color(0xFFD1D5DB),
                            textColor: DS.textSecondary,
                            height: isTablet ? DS.btnLg : DS.btnMd,
                            onPressed: _previousPage,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          flex: 2,
                          child: DSButton(
                            label: 'পরবর্তী',
                            color: DS.green500,
                            shadowColor: DS.green600,
                            textColor: Colors.white,
                            height: isTablet ? DS.btnLg : DS.btnMd,
                            onPressed: _nextPage,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
