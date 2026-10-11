import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:little_muslim/screens/home/home_screen.dart';
import 'package:little_muslim/screens/duas/duas_screen.dart';
import 'package:little_muslim/screens/prayer/prayer_screen.dart';
import 'package:little_muslim/screens/qaida/qaida_lesson_screen.dart';
import 'package:little_muslim/screens/qaida/qaida_letters.dart';
import 'package:little_muslim/screens/quran/quran_screen.dart';
import 'package:little_muslim/screens/quran/quran_data.dart';
import 'package:little_muslim/screens/seerah/seerah_screen.dart';
import 'package:little_muslim/screens/achievements/achievements_screen.dart';
import 'package:little_muslim/screens/missions/daily_missions_screen.dart';
import 'package:little_muslim/utils/app_state.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeQuranRepository implements QuranRepository {
  static const surah = QuranSurah(
    number: 1,
    arabicName: 'سُورَةُ الْفَاتِحَة',
    englishName: 'আল-ফাতিহা',
    nameMeaning: 'সূচনা',
    ayahCount: 7,
    revelationType: 'Meccan',
  );

  @override
  Future<List<QuranSurah>> getSurahs() async => const [surah];

  @override
  Future<QuranSurahContent> getSurah(QuranSurah surah) async =>
      QuranSurahContent(
        surah: surah,
        ayahs: [
          for (var number = 1; number <= 7; number++)
            QuranAyah(
              number: number,
              arabic: number == 1
                  ? 'ٱلْحَمْدُ لِلَّهِ رَبِّ ٱلْعَـٰلَمِينَ'
                  : 'آية $number',
              tajweedText: number == 1
                  ? 'ٱلْحَمْدُ لِلَّهِ رَبِّ ٱلْعَـٰلَمِينَ'
                  : 'آية $number',
              translation: number == 1
                  ? 'যাবতীয় প্রশংসা আল্লাহর।'
                  : 'Translation $number',
            ),
        ],
      );
}

class _RetryQuranRepository extends _FakeQuranRepository {
  bool failSurahList = true;
  bool failSurahContent = true;

  @override
  Future<List<QuranSurah>> getSurahs() async {
    if (failSurahList) {
      failSurahList = false;
      throw Exception('offline');
    }
    return super.getSurahs();
  }

  @override
  Future<QuranSurahContent> getSurah(QuranSurah surah) async {
    if (failSurahContent) {
      failSurahContent = false;
      throw Exception('offline');
    }
    return super.getSurah(surah);
  }
}

void main() {
  test('Qaida path includes every letter from Alif through Ya', () {
    expect(qaidaLetters, hasLength(28));
    expect(qaidaLetters.first.letter, 'ا');
    expect(qaidaLetters.last.letter, 'ي');
    expect(qaidaLetters.map((item) => item.id).toSet(), hasLength(28));
    for (var i = 0; i < qaidaLetters.length; i++) {
      expect(qaidaLetters[i].makhraj, isNotEmpty);
      expect(qaidaLetterOptions(i), hasLength(3));
      expect(qaidaLetterOptions(i).toSet(), hasLength(3));
      expect(qaidaLetterOptions(i), contains(qaidaLetters[i].letter));
    }
  });

  Future<void> tapVisible(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pumpAndSettle();
  }

  Future<void> finishAlifLesson(WidgetTester tester) async {
    await tapVisible(tester, find.text('ا').last);
    await tapVisible(tester, find.text('পরের ধাপে যাই'));
    await tapVisible(tester, find.text('ـا'));
    await tapVisible(tester, find.text('পরের ধাপে যাই'));
    await tapVisible(tester, find.text('বিন্দু নেই'));
    await tapVisible(tester, find.text('পরের ধাপে যাই'));
    await tapVisible(tester, find.text('ا').last);
    await tapVisible(tester, find.text('পরের ধাপে যাই'));
    final selfPractice = find.text('আমি উচ্চারণ করে ফেলেছি');
    if (selfPractice.evaluate().isNotEmpty) {
      await tapVisible(tester, selfPractice);
    } else {
      await tapVisible(tester, find.text('অভিভাবক শুনে নিশ্চিত করবেন'));
      await tapVisible(tester, find.text('শুনেছি, ঠিক বলেছে'));
    }
    await tapVisible(tester, find.text('পরের ধাপে যাই'));
  }

  Widget buildHome() {
    SharedPreferences.setMockInitialValues({});
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const MaterialApp(home: HomeScreen()),
    );
  }

  testWidgets('home shows the gamified learning path on a phone',
      (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildHome());
    await tester.pumpAndSettle();

    expect(find.text('তোমার শেখার পথ'), findsOneWidget);
    expect(find.text('0 / 28'), findsOneWidget);
    expect(find.text('ক্বায়দা'), findsOneWidget);
    expect(find.text('কুরআন'), findsOneWidget);

    await tester.tap(find.text('আলিফ').last);
    await tester.pumpAndSettle();
    expect(find.text('“আলিফ” অক্ষরটি শুনে বেছে নাও।'), findsOneWidget);
    await finishAlifLesson(tester);
    expect(find.text('শুরুর মাখরাজ নোট'), findsOneWidget);
    expect(find.text('পরের পাঠ: বা চিনি'), findsOneWidget);
    await tester.ensureVisible(find.text('পরের পাঠ: বা চিনি'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('পরের পাঠ: বা চিনি'));
    await tester.pumpAndSettle();
    expect(find.text('“বা” অক্ষরটি শুনে বেছে নাও।'), findsOneWidget);
    expect(find.text('দুই ঠোঁট মিলিয়ে “বা” বলো; নাক দিয়ে টেনে নয়।'),
        findsOneWidget);
  });

  testWidgets('home lays out on a tablet', (tester) async {
    tester.view.physicalSize = const Size(2048, 1536);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildHome());
    await tester.pumpAndSettle();

    expect(find.text('তোমার শেখার পথ'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Qaida lesson gives XP only after all stages pass',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final appState = AppState();
    await appState.loadFromPrefs();

    await tester.pumpWidget(ChangeNotifierProvider.value(
      value: appState,
      child: const MaterialApp(
        home: QaidaLessonScreen(
          lessonId: 'qaida_alif_test',
          lessonTitle: 'আলিফ চিনি',
          letter: 'ا',
          letterName: 'আলিফ',
          options: ['ب', 'ا', 'ت'],
        ),
      ),
    ));
    await tester.pumpAndSettle();

    expect(appState.xp, 0);
    await finishAlifLesson(tester);
    expect(find.text('সব ধাপ শেষ করেছ, মাশাআল্লাহ!'), findsOneWidget);
    await tester.tap(find.text('পাঠ শেষ করি'));
    await tester.pumpAndSettle();
    expect(appState.xp, 10);
  });

  testWidgets(
      'completed Qaida lessons reopen from the first step without XP duplication',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final appState = AppState();
    await appState.loadFromPrefs();
    await appState.completeLesson('qaida_alif_test');

    await tester.pumpWidget(ChangeNotifierProvider.value(
      value: appState,
      child: const MaterialApp(
        home: QaidaLessonScreen(
          lessonId: 'qaida_alif_test',
          lessonTitle: 'আলিফ চিনি',
          letter: 'ا',
          letterName: 'আলিফ',
          options: ['ب', 'ا', 'ت'],
        ),
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.text('“আলিফ” অক্ষরটি শুনে বেছে নাও।'), findsOneWidget);
    expect(appState.xp, 10);
    await finishAlifLesson(tester);
    expect(find.text('এই পাঠের +১০ XP আগেই পেয়েছ!'), findsOneWidget);
    await tapVisible(tester, find.text('পাঠ শেষ করি'));
    expect(appState.xp, 10);
  });

  testWidgets('Qaida lesson restores its last saved step after restart',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final appState = AppState();
    await appState.loadFromPrefs();
    await tester.pumpWidget(ChangeNotifierProvider.value(
      value: appState,
      child: const MaterialApp(
        home: QaidaLessonScreen(
          lessonId: 'qaida_resume_test',
          lessonTitle: 'আলিফ চিনি',
          letter: 'ا',
          letterName: 'আলিফ',
          options: ['ب', 'ا', 'ت'],
        ),
      ),
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.text('ا').last);
    await tester.pumpAndSettle();
    await tapVisible(tester, find.text('পরের ধাপে যাই'));
    expect(find.text('2 / 6'), findsOneWidget);
    expect(appState.qaidaLessonStep('qaida_resume_test'), 1);
    await tester.pump(const Duration(milliseconds: 20));

    final restoredState = AppState();
    await restoredState.loadFromPrefs();
    await tester.pumpWidget(ChangeNotifierProvider.value(
      value: restoredState,
      child: const MaterialApp(
        home: QaidaLessonScreen(
          lessonId: 'qaida_resume_test',
          lessonTitle: 'আলিফ চিনি',
          letter: 'ا',
          letterName: 'আলিফ',
          options: ['ب', 'ا', 'ت'],
        ),
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.text('হরফের রূপ চিনি'), findsOneWidget);
    expect(find.text('এটি একই হরফের আরেকটি রূপ। মিল আছে এমনটি খুঁজে নাও।'),
        findsOneWidget);
  });

  test('completed lesson cannot award XP again after local restore', () async {
    SharedPreferences.setMockInitialValues({});
    final appState = AppState();
    await appState.loadFromPrefs();
    expect(await appState.completeLesson('qaida_once'), isTrue);

    final restoredState = AppState();
    await restoredState.loadFromPrefs();
    expect(restoredState.xp, 10);
    expect(await restoredState.completeLesson('qaida_once'), isFalse);
    expect(restoredState.xp, 10);
  });

  test('legacy progress preferences migrate without losing Qaida steps',
      () async {
    SharedPreferences.setMockInitialValues({
      'xp': 30,
      'completed_lessons': ['qaida_done'],
      'lesson_activity': ['qaida_done|2026-10-12'],
      'opened_chests': ['first_chest'],
      'qaida_lesson_steps': '{"qaida_pending":3,"qaida_bad":99}',
    });
    final appState = AppState();
    await appState.loadFromPrefs();

    expect(appState.xp, 30);
    expect(appState.hasCompletedLesson('qaida_done'), isTrue);
    expect(appState.qaidaLessonStep('qaida_pending'), 3);
    expect(appState.qaidaLessonStep('qaida_bad'), 0);
    expect(appState.hasOpenedChest('first_chest'), isTrue);
  });

  testWidgets('Quran reading mode opens Al-Fatihah and supports text sizing',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final appState = AppState();
    await appState.loadFromPrefs();
    await tester.pumpWidget(ChangeNotifierProvider.value(
      value: appState,
      child: MaterialApp(
        home: QuranScreen(repository: _FakeQuranRepository()),
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.text('কুরআনের সাথে সময় কাটাই'), findsOneWidget);
    await tapVisible(tester, find.text('আল-ফাতিহা'));

    expect(find.text('সূরা আল-ফাতিহা'), findsOneWidget);
    expect(find.text('ٱلْحَمْدُ لِلَّهِ رَبِّ ٱلْعَـٰلَمِينَ'), findsOneWidget);
    await tester.tap(find.byTooltip('বড় লেখা'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('Continue Reading restores saved ayah and bookmark locally',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final initialState = AppState();
    await initialState.loadFromPrefs();
    await initialState.saveQuranReadingPosition(1, 4);
    await initialState.toggleQuranBookmark(1, 4);

    final restoredState = AppState();
    await restoredState.loadFromPrefs();
    expect(restoredState.quranReadingPosition?.surahNumber, 1);
    expect(restoredState.quranReadingPosition?.ayahNumber, 4);
    expect(restoredState.isQuranAyahBookmarked(1, 4), isTrue);

    await tester.pumpWidget(ChangeNotifierProvider.value(
      value: restoredState,
      child: MaterialApp(home: QuranScreen(repository: _FakeQuranRepository())),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.text('আয়াত 4 থেকে পড়ি'));
    await tester.pumpAndSettle();

    expect(find.text('آية 4'), findsOneWidget);
    expect(find.byTooltip('বুকমার্ক সরাও'), findsOneWidget);

    await tester.drag(
        find.byType(CustomScrollView).last, const Offset(0, -500));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 300));
    expect(restoredState.quranReadingPosition!.ayahNumber, greaterThan(4));
  });

  test('invalid saved Quran progress is clamped or discarded safely', () async {
    SharedPreferences.setMockInitialValues({
      'quran_last_read': '{"surah":1,"ayah":99}',
      'quran_bookmarks': ['1:99', '2:1', 'bad', '1:3'],
    });
    final appState = AppState();
    await appState.loadFromPrefs();
    await appState.validateQuranProgress({1: 7});

    expect(appState.quranReadingPosition?.ayahNumber, 7);
    expect(appState.quranBookmarks, {'1:3'});
    await appState.saveQuranReadingPosition(99, 2);
    await appState.validateQuranProgress({1: 7});
    expect(appState.quranReadingPosition, isNull);
  });

  testWidgets('Quran list and reader recover after a request failure',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final appState = AppState();
    await appState.loadFromPrefs();
    final repository = _RetryQuranRepository();
    await tester.pumpWidget(ChangeNotifierProvider.value(
      value: appState,
      child: MaterialApp(home: QuranScreen(repository: repository)),
    ));
    await tester.pumpAndSettle();
    expect(
        find.text('সূরার তালিকা আনা যায়নি। ইন্টারনেট দেখে আবার চেষ্টা করো।'),
        findsOneWidget);
    await tapVisible(tester, find.text('আবার চেষ্টা করি'));
    expect(find.text('আল-ফাতিহা'), findsOneWidget);

    await tapVisible(tester, find.text('আল-ফাতিহা'));
    expect(find.text('এই সূরার পাঠ আনা যায়নি। ইন্টারনেট দেখে আবার চেষ্টা করো।'),
        findsOneWidget);
    await tapVisible(tester, find.text('আবার চেষ্টা করি'));
    expect(find.text('ٱلْحَمْدُ لِلَّهِ رَبِّ ٱلْعَـٰلَمِينَ'), findsOneWidget);
  });

  testWidgets('prayer screen shows times setup and step-by-step guide',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: PrayerScreen()));
    await tester.pumpAndSettle();

    expect(find.text('নামাজ শিখি'), findsOneWidget);
    expect(find.text('শহর ও গণনা-পদ্ধতি সেটআপ বাকি'), findsOneWidget);
    expect(find.text('--:--'), findsNWidgets(5));

    await tester.tap(find.text('প্রস্তুতি'));
    await tester.pumpAndSettle();
    expect(find.text('ওজু করে প্রস্তুত হও'), findsOneWidget);
    expect(find.text('পরের ধাপ'), findsOneWidget);
  });

  testWidgets('dua screen filters by category and bookmarks a dua',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: DuasScreen()));
    await tester.pumpAndSettle();

    expect(find.text('ঘুম থেকে উঠলে'), findsOneWidget);
    await tester.tap(find.text('দৈনন্দিন'));
    await tester.pumpAndSettle();
    expect(find.text('খাবার শুরু করার আগে'), findsOneWidget);

    await tester.tap(find.text('ঘুম').first);
    await tester.pumpAndSettle();
    expect(find.text('ঘুমাতে যাওয়ার সময়'), findsOneWidget);
    expect(find.text('খাবার শুরু করার আগে'), findsNothing);

    await tester.tap(find.byTooltip('পছন্দে রাখো'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('পছন্দ থেকে সরাও'), findsOneWidget);
  });

  testWidgets('Seerah screen opens a sourced child-friendly story',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SeerahScreen()));
    await tester.pumpAndSettle();

    expect(find.text('নবীজির জীবন থেকে শিখি'), findsOneWidget);
    await tester.tap(find.text('আবু উমাইরের ছোট্ট বন্ধু'));
    await tester.pumpAndSettle();
    expect(find.text('গল্পের শিক্ষা'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('সূত্র: সহিহ বুখারি ৬২০৩'),
      250,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.pumpAndSettle();
    expect(find.text('সূত্র: সহিহ বুখারি ৬২০৩'), findsOneWidget);
  });

  testWidgets('achievement screen reflects earned XP and lessons',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final appState = AppState();
    await appState.loadFromPrefs();
    await appState.completeLesson('qaida_first');

    await tester.pumpWidget(ChangeNotifierProvider.value(
      value: appState,
      child: const MaterialApp(home: AchievementsScreen()),
    ));
    await tester.pumpAndSettle();

    expect(find.text('নতুন শিক্ষার্থী'), findsOneWidget);
    expect(find.text('10 XP'), findsOneWidget);
    expect(find.text('প্রথম পাঠ'), findsOneWidget);
    expect(find.text('1 / 4 পাওয়া'), findsOneWidget);
  });

  testWidgets('daily mission completes only after its Qaida lesson',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final appState = AppState();
    await appState.loadFromPrefs();
    await tester.pumpWidget(ChangeNotifierProvider.value(
      value: appState,
      child: const MaterialApp(home: DailyMissionsScreen()),
    ));
    await tester.pumpAndSettle();

    expect(find.text('০ / ১ পাঠ সম্পন্ন'), findsOneWidget);
    await tester.tap(find.text('মিশন শুরু করো'));
    await tester.pumpAndSettle();
    await finishAlifLesson(tester);
    await tapVisible(tester, find.text('পাঠ শেষ করি'));

    expect(appState.todayQaidaLessons, 1);
    expect(find.text('১ / ১ পাঠ সম্পন্ন'), findsOneWidget);
    expect(find.text('মাশাআল্লাহ! আজকের শেখার লক্ষ্য পূরণ হয়েছে।'),
        findsOneWidget);
  });

  test('onboarding and learning progress persist locally', () async {
    SharedPreferences.setMockInitialValues({});
    final appState = AppState();
    await appState.loadFromPrefs();
    appState.updateDraftName('আয়েশা');
    appState.updateDraftAge(10);
    appState.updateDraftLanguage('en');
    await appState.completeOnboarding();

    expect(appState.hasCompletedOnboarding, isTrue);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('user_name'), 'আয়েশা');
    expect(prefs.getInt('user_age'), 10);
    expect(prefs.getString('language'), 'en');

    await appState.completeLesson('qaida_alif_persistence');
    final restoredState = AppState();
    await restoredState.loadFromPrefs();
    expect(restoredState.hasCompletedOnboarding, isTrue);
    expect(restoredState.userName, 'আয়েশা');
    expect(restoredState.age, 10);
    expect(restoredState.selectedLanguage, 'en');
    expect(restoredState.xp, 10);
    expect(restoredState.hasCompletedLesson('qaida_alif_persistence'), isTrue);
  });
}
