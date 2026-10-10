import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/app_theme.dart';
import '../../utils/app_state.dart';
import '../../widgets/vector_icons.dart';
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
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.all(tablet ? 32 : 18),
              children: [
                Row(children: [
                  IconButton.filledTonal(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded),
                    style: IconButton.styleFrom(backgroundColor: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'আজকের মিশন',
                    style: TextStyle(
                      color: AppTheme.darkText,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ]),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF9600), Color(0xFFFF6B00)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF6B00).withValues(alpha: 0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.22),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: VectorIcon(
                            type: VectorIconType.target,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'আজ একটু শিখি',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        done
                            ? 'মাশাআল্লাহ! আজকের শেখার লক্ষ্য পূরণ হয়েছে।'
                            : 'একটি নতুন ক্বায়দা পাঠ শেষ করো। ছোট্ট অগ্রগতিও অনেক মূল্যবান।',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 18),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: LinearProgressIndicator(
                          value: done ? 1 : 0,
                          minHeight: 12,
                          backgroundColor: Colors.white30,
                          color: const Color(0xFFFFD66B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        done ? '১ / ১ পাঠ সম্পন্ন' : '০ / ১ পাঠ সম্পন্ন',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: const Color(0xFFE5E5E5), width: 2),
                  ),
                  child: Row(children: [
                    IconBadge(
                      type: VectorIconType.qaida,
                      bgColor: const Color(0xFFE8F8D8),
                      size: 52,
                      iconColor: const Color(0xFF58A700),
                    ),
                    const SizedBox(width: 13),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'একটি ক্বায়দা পাঠ',
                            style: TextStyle(
                              color: AppTheme.darkText,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'শেষ করলে +১০ XP',
                            style: TextStyle(
                              color: Color(0xFF58A700),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (done)
                      const VectorIcon(
                        type: VectorIconType.check,
                        size: 32,
                        color: Color(0xFF58CC02),
                      )
                    else
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFD0D0D0),
                            width: 3,
                          ),
                        ),
                      ),
                  ]),
                ),
                if (!done) ...[
                  const SizedBox(height: 18),
                  SizedBox(
                    height: 54,
                    child: FilledButton(
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
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF58CC02),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.play_arrow_rounded, size: 26),
                          SizedBox(width: 6),
                          Text(
                            'মিশন শুরু করো',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 18),
                Text(
                  'আজকের মিশন এই ডিভাইসে সংরক্ষিত পাঠের তারিখ থেকে হিসাব করা হয়।',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.darkText.withValues(alpha: 0.45),
                    fontSize: 11,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
