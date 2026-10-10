import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/app_theme.dart';
import '../../utils/app_state.dart';
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
      backgroundColor: AppTheme.cream,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child:
                ListView(padding: EdgeInsets.all(tablet ? 32 : 20), children: [
              Row(children: [
                IconButton.filledTonal(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_rounded),
                  style: IconButton.styleFrom(backgroundColor: Colors.white),
                ),
                const SizedBox(width: 8),
                const Text('আজকের মিশন',
                    style: TextStyle(
                        color: AppTheme.darkText,
                        fontSize: 18,
                        fontWeight: FontWeight.w800)),
              ]),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  gradient: const LinearGradient(colors: [
                    Color(0xFF2E8B57),
                    Color(0xFF147D78),
                  ]),
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('🌤️', style: TextStyle(fontSize: 38)),
                      const SizedBox(height: 10),
                      const Text('আজ একটু শিখি',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.w900)),
                      const SizedBox(height: 6),
                      Text(
                          done
                              ? 'মাশাআল্লাহ! আজকের শেখার লক্ষ্য পূরণ হয়েছে।'
                              : 'একটি নতুন ক্বায়দা পাঠ শেষ করো। ছোট্ট অগ্রগতিও অনেক মূল্যবান।',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 13, height: 1.5)),
                      const SizedBox(height: 18),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: LinearProgressIndicator(
                          value: done ? 1 : 0,
                          minHeight: 10,
                          backgroundColor: Colors.white30,
                          color: const Color(0xFFFFD66B),
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(done ? '১ / ১ পাঠ সম্পন্ন' : '০ / ১ পাঠ সম্পন্ন',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 11)),
                    ]),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22)),
                child: Row(children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                        color: const Color(0xFFE4F2E7),
                        borderRadius: BorderRadius.circular(17)),
                    alignment: Alignment.center,
                    child: const Text('🔤', style: TextStyle(fontSize: 27)),
                  ),
                  const SizedBox(width: 13),
                  const Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text('একটি ক্বায়দা পাঠ',
                            style: TextStyle(
                                color: AppTheme.darkText,
                                fontSize: 15,
                                fontWeight: FontWeight.w800)),
                        SizedBox(height: 4),
                        Text('শেষ করলে ১০ XP পাবে',
                            style:
                                TextStyle(color: Colors.black54, fontSize: 12)),
                      ])),
                  Icon(
                    done ? Icons.check_circle_rounded : Icons.circle_outlined,
                    color: done ? AppTheme.primaryGreen : Colors.black26,
                    size: 26,
                  ),
                ]),
              ),
              if (!done) ...[
                const SizedBox(height: 16),
                SizedBox(
                  height: 52,
                  child: FilledButton.icon(
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
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text('মিশন শুরু করো'),
                    style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.primaryGreen,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17))),
                  ),
                ),
              ],
              const SizedBox(height: 18),
              const Text(
                  'আজকের মিশন এই ডিভাইসে সংরক্ষিত পাঠের তারিখ থেকে হিসাব করা হয়।',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black45, fontSize: 11, height: 1.5)),
            ]),
          ),
        ),
      ),
    );
  }
}
