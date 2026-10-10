import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/app_theme.dart';
import '../../utils/app_state.dart';
import '../../widgets/vector_icons.dart';
import '../../widgets/duolingo_appbar.dart';
import '../../widgets/duolingo_button.dart';
import '../qaida/qaida_lesson_screen.dart';
import '../qaida/qaida_letters.dart';

class DailyMissionsScreen extends StatelessWidget {
  const DailyMissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final done = state.todayQaidaLessons > 0;
    final tablet = MediaQuery.sizeOf(context).shortestSide >= 600;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8EE),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.all(tablet ? 32 : 18),
              children: [
                // ── Duolingo Header ──
                DuolingoPageHeader(
                  title: 'আজকের মিশন',
                  subtitle: 'প্রতিদিনের শেখার লক্ষ্য',
                  iconType: VectorIconType.target,
                  gradientColors: const [Color(0xFFFF9600), Color(0xFFFF6B00)],
                  onBack: () => Navigator.pop(context),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      done ? 'সম্পন্ন' : 'চলমান',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12),
                    ),
                  ),
                ),

                // ── Progress card ──
                Container(
                  margin: const EdgeInsets.only(bottom: 18),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFFF9600).withValues(alpha: 0.3), width: 2),
                    boxShadow: [BoxShadow(color: const Color(0xFFFF9600).withValues(alpha: 0.15), blurRadius: 0, offset: const Offset(0, 4))],
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      const Icon(Icons.bolt_rounded, color: Color(0xFFFF9600), size: 22),
                      const SizedBox(width: 6),
                      Text(
                        done ? 'মাশাআল্লাহ! আজকের শেখার লক্ষ্য পূরণ হয়েছে।' : 'একটি নতুন ক্বায়দা পাঠ শেষ করো।',
                        style: TextStyle(color: done ? const Color(0xFF58A700) : AppTheme.darkText, fontSize: 13, fontWeight: FontWeight.w700),
                      ),
                    ]),
                    const SizedBox(height: 14),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: LinearProgressIndicator(
                        value: done ? 1 : 0,
                        minHeight: 14,
                        backgroundColor: const Color(0xFFE5E7EB),
                        color: const Color(0xFF58CC02),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      done ? '১ / ১ পাঠ সম্পন্ন' : '০ / ১ পাঠ সম্পন্ন',
                      style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  ]),
                ),

                DuolingoSectionLabel(label: 'আজকের কাজ', badgeText: done ? 'সম্পন্ন' : 'বাকি আছে', badgeColor: done ? const Color(0xFFE8F8D8) : const Color(0xFFFFF3CD), badgeTextColor: done ? const Color(0xFF58A700) : const Color(0xFFCC8800)),
                const SizedBox(height: 12),

                // ── Mission task card ──
                DuolingoCard(
                  accentColor: const Color(0xFF58CC02),
                  showAccentStripe: true,
                  child: Row(children: [
                    const IconBadge(type: VectorIconType.qaida, bgColor: Color(0xFFE8F8D8), size: 52, iconColor: Color(0xFF58A700)),
                    const SizedBox(width: 13),
                    const Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('একটি ক্বায়দা পাঠ', style: TextStyle(color: AppTheme.darkText, fontSize: 15, fontWeight: FontWeight.w800)),
                        SizedBox(height: 4),
                        Text('শেষ করলে +১০ XP', style: TextStyle(color: Color(0xFF58A700), fontSize: 12, fontWeight: FontWeight.w700)),
                      ]),
                    ),
                    if (done)
                      const VectorIcon(type: VectorIconType.check, size: 32, color: Color(0xFF58CC02))
                    else
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFFD0D0D0), width: 3)),
                      ),
                  ]),
                ),

                if (!done) ...[
                  const SizedBox(height: 20),
                  Duolingo3DButton(
                    text: 'মিশন শুরু করো',
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => QaidaLessonScreen(
                          lessonId: state.todayQaidaMissionLessonId,
                          lessonTitle: 'আজকের আলিফ পাঠ',
                          letter: 'ا',
                          letterName: 'আলিফ',
                          makhrajNote: qaidaLetters.first.makhraj,
                          options: const ['ب', 'ا', 'ت'],
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 24),
                  ),
                ] else ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F8D8),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF58A700).withValues(alpha: 0.3), width: 2),
                    ),
                    child: const Row(children: [
                      VectorIcon(type: VectorIconType.star, size: 28, color: Color(0xFFFFC800)),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'দারুণ! আজকের লক্ষ্য পূরণ হয়েছে। কাল আবার শিখবো!',
                          style: TextStyle(color: Color(0xFF2D7A00), fontSize: 13, fontWeight: FontWeight.w700, height: 1.4),
                        ),
                      ),
                    ]),
                  ),
                ],

                const SizedBox(height: 20),
                Text(
                  'আজকের মিশন এই ডিভাইসে সংরক্ষিত পাঠের তারিখ থেকে হিসাব করা হয়।',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppTheme.darkText.withValues(alpha: 0.45), fontSize: 11, height: 1.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
