import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:little_muslim/screens/home/home_screen.dart';
import 'package:little_muslim/screens/duas/duas_screen.dart';
import 'package:little_muslim/screens/prayer/prayer_screen.dart';
import 'package:little_muslim/screens/qaida/qaida_lesson_screen.dart';
import 'package:little_muslim/screens/qaida/qaida_letters.dart';
import 'package:little_muslim/screens/quran/quran_screen.dart';
import 'package:little_muslim/screens/quran/quran_data.dart';
import 'package:little_muslim/screens/seerah/seerah_screen.dart';
import 'package:little_muslim/screens/live_learning/class_schedule.dart';
import 'package:little_muslim/screens/live_learning/live_learning_screen.dart';
import 'package:little_muslim/screens/achievements/achievements_screen.dart';
import 'package:little_muslim/screens/missions/daily_missions_screen.dart';
import 'package:little_muslim/utils/app_state.dart';
import 'package:little_muslim/l10n/app_localizations.dart';
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

class _FakeClassScheduleRepository implements ClassScheduleRepository {
  _FakeClassScheduleRepository(this.classes);
  final List<LiveClass> classes;

  @override
  Future<List<LiveClass>> loadClasses() async => classes;
}

class _RetryClassScheduleRepository implements ClassScheduleRepository {
  bool fail = true;

  @override
  Future<List<LiveClass>> loadClasses() async {
    if (fail) {
      fail = false;
      throw Exception('schedule unavailable');
    }
    return [
      LiveClass(
        id: 'retry-class',
        title: 'আবার চেষ্টা করা ক্লাস',
        startAt: DateTime(2026, 3, 8, 9),
        endAt: DateTime(2026, 3, 8, 10),
      ),
    ];
  }
}

class _FakeMeetingLauncher implements MeetingLinkLauncher {
  Uri? openedUri;
  bool result = true;

  @override
  Future<bool> open(Uri uri) async {
    openedUri = uri;
    return result;
  }
}

class _LocalizedTestApp extends StatelessWidget {
  const _LocalizedTestApp({required this.state, required this.home});
  final AppState state;
  final Widget home;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider.value(
        value: state,
        child: Consumer<AppState>(
          builder: (context, appState, _) => MaterialApp(
            locale: Locale(appState.selectedLanguage),
            supportedLocales: const [Locale('bn'), Locale('en')],
            localizationsDelegates: const [
              AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: home,
          ),
        ),
      );
}

class _LanguageSwitcher extends StatelessWidget {
  const _LanguageSwitcher({required this.state});
  final AppState state;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: [
            const LocalizedText('সেটিংস'),
            DropdownButton<String>(
              value: state.selectedLanguage,
              items: const [
                DropdownMenuItem(value: 'bn', child: Text('বাংলা')),
                DropdownMenuItem(value: 'en', child: Text('English')),
              ],
              onChanged: (value) {
                if (value != null) state.updateLanguage(value);
              },
            ),
          ],
        ),
      );
}

void main() {
  testWidgets('language switch updates screens and persists after restart',
      (tester) async {
    SharedPreferences.setMockInitialValues({'language': 'bn'});
    final state = AppState();
    await state.loadFromPrefs();
    await tester.pumpWidget(
        _LocalizedTestApp(state: state, home: _LanguageSwitcher(state: state)));
    await tester.pumpAndSettle();
    expect(find.text('সেটিংস'), findsOneWidget);

    await state.updateLanguage('en');
    final restoredState = AppState();
    await restoredState.loadFromPrefs();
    expect(restoredState.selectedLanguage, 'en');
    expect(
      AppLocalizations(const Locale('en'), const {'তোমার শেখার পথ': 'Your learning path'})
          .translate('তোমার শেখার পথ'),
      'Your learning path',
    );
  });

  test('class schedule derives states and accepts only safe HTTPS links', () {
    final start = DateTime(2026, 3, 8, 10);
    final live = LiveClass(
      id: 'live',
      title: 'Live class',
      startAt: start,
      endAt: start.add(const Duration(hours: 1)),
      meetingUrl: 'https://meet.google.com/example',
    );
    expect(live.statusAt(start.subtract(const Duration(minutes: 1))),
        LiveClassStatus.upcoming);
    expect(live.statusAt(start), LiveClassStatus.live);
    expect(live.statusAt(start.add(const Duration(hours: 1))),
        LiveClassStatus.completed);
    expect(live.safeMeetingUri?.scheme, 'https');
    expect(
        const LiveClass(
          id: 'http',
          title: 'HTTP',
          meetingUrl: 'http://meet.google.com/example',
        ).safeMeetingUri,
        isNull);
    expect(
        const LiveClass(
          id: 'credentials',
          title: 'Credentials',
          meetingUrl: 'https://user:pass@meet.google.com/example',
        ).safeMeetingUri,
        isNull);
    expect(
        const LiveClass(
          id: 'javascript',
          title: 'Unsafe',
          meetingUrl: 'javascript:alert(1)',
        ).safeMeetingUri,
        isNull);
    expect(
      LiveClass(
        id: 'cancelled',
        title: 'Cancelled',
        startAt: start,
        endAt: start.add(const Duration(hours: 1)),
        recordState: ClassRecordState.cancelled,
      ).statusAt(start),
      LiveClassStatus.cancelled,
    );
    expect(
      const LiveClass(id: 'missing', title: 'Missing').statusAt(start),
      LiveClassStatus.unavailable,
    );
  });

  testWidgets('live class schedule shows an honest empty state',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LiveLearningScreen()));
    await tester.pumpAndSettle();
    expect(find.text('এখনো কোনো ক্লাসের সময়সূচি নেই।'), findsOneWidget);
    expect(find.text('শিক্ষক বা প্রতিষ্ঠান সময়সূচি দিলে এখানে দেখাবে।'),
        findsOneWidget);
  });

  testWidgets(
      'class list labels upcoming, completed, cancelled and unavailable',
      (tester) async {
    final now = DateTime(2026, 3, 8, 10);
    await tester.pumpWidget(MaterialApp(
      home: LiveLearningScreen(
        repository: _FakeClassScheduleRepository([
          LiveClass(
            id: 'upcoming',
            title: 'আসন্ন ক্লাস',
            startAt: now.add(const Duration(hours: 1)),
            endAt: now.add(const Duration(hours: 2)),
          ),
          LiveClass(
            id: 'completed',
            title: 'শেষ ক্লাস',
            startAt: now.subtract(const Duration(hours: 2)),
            endAt: now.subtract(const Duration(hours: 1)),
          ),
          const LiveClass(
            id: 'cancelled',
            title: 'বাতিল ক্লাস',
            recordState: ClassRecordState.cancelled,
          ),
          const LiveClass(id: 'unavailable', title: 'তথ্যহীন ক্লাস'),
        ]),
        now: () => now,
      ),
    ));
    await tester.pumpAndSettle();
    expect(find.text('আসছে'), findsOneWidget);
    expect(find.text('শেষ'), findsOneWidget);
    expect(find.text('বাতিল'), findsOneWidget);
    expect(find.text('তথ্য নেই'), findsOneWidget);
  });

  testWidgets('live class schedule error can be retried', (tester) async {
    final repository = _RetryClassScheduleRepository();
    await tester.pumpWidget(MaterialApp(
      home: LiveLearningScreen(
        repository: repository,
        now: () => DateTime(2026, 3, 8),
      ),
    ));
    await tester.pumpAndSettle();
    expect(find.text('ক্লাসের তথ্য আনা যায়নি।'), findsOneWidget);
    await tester.tap(find.text('আবার চেষ্টা'));
    await tester.pumpAndSettle();
    expect(find.text('আবার চেষ্টা করা ক্লাস'), findsOneWidget);
  });

  testWidgets('live class detail opens valid meeting URL externally',
      (tester) async {
    final launcher = _FakeMeetingLauncher();
    final start = DateTime(2026, 3, 8, 10);
    final liveClass = LiveClass(
      id: 'qaida-live',
      title: 'কুরআন পড়ার ক্লাস',
      teacher: 'শিক্ষক',
      startAt: start,
      endAt: start.add(const Duration(hours: 1)),
      description: 'আজ আমরা পড়া অনুশীলন করব।',
      meetingUrl: 'https://meet.google.com/abc-defg-hij',
    );
    await tester.pumpWidget(MaterialApp(
      home: LiveLearningScreen(
        repository: _FakeClassScheduleRepository([liveClass]),
        launcher: launcher,
        now: () => start.add(const Duration(minutes: 5)),
      ),
    ));
    await tester.pumpAndSettle();
    expect(find.text('এখন চলছে'), findsOneWidget);
    await tester.tap(find.text('কুরআন পড়ার ক্লাস'));
    await tester.pumpAndSettle();
    expect(find.text('শিক্ষক: '), findsOneWidget);
    expect(find.text('শিক্ষক'), findsOneWidget);
    expect(find.text('আজ আমরা পড়া অনুশীলন করব।'), findsOneWidget);
    await tester.tap(find.text('ক্লাসে যোগ দাও'));
    await tester.pumpAndSettle();
    expect(launcher.openedUri.toString(), liveClass.meetingUrl);
  });

  testWidgets(
      'missing or unsafe links cannot be joined; launcher failure is clear',
      (tester) async {
    final now = DateTime(2026, 3, 8, 10, 5);
    final badClass = LiveClass(
      id: 'unsafe',
      title: 'লিংক নেই',
      startAt: DateTime(2026, 3, 8, 10),
      endAt: DateTime(2026, 3, 8, 11),
      meetingUrl: 'http://example.com/room',
    );
    await tester.pumpWidget(MaterialApp(
      home: LiveClassDetailScreen(
        liveClass: badClass,
        launcher: _FakeMeetingLauncher(),
        now: () => now,
      ),
    ));
    await tester.pumpAndSettle();
    expect(
        tester
            .widget<FilledButton>(find.widgetWithText(
              FilledButton,
              'ক্লাসে যোগ দাও',
            ))
            .onPressed,
        isNull);
    expect(find.text('নিরাপদ HTTPS মিটিং লিংক না থাকায় যোগ দেওয়া যাবে না।'),
        findsOneWidget);

    await tester.pumpWidget(MaterialApp(
      home: LiveClassDetailScreen(
        liveClass: LiveClass(
          id: 'missing',
          title: 'লিংক আসেনি',
          startAt: DateTime(2026, 3, 8, 10),
          endAt: DateTime(2026, 3, 8, 11),
        ),
        launcher: _FakeMeetingLauncher(),
        now: () => now,
      ),
    ));
    await tester.pumpAndSettle();
    expect(
        tester
            .widget<FilledButton>(find.widgetWithText(
              FilledButton,
              'ক্লাসে যোগ দাও',
            ))
            .onPressed,
        isNull);
    expect(find.text('শিক্ষক এখনো মিটিং লিংক দেননি।'), findsOneWidget);

    final launcher = _FakeMeetingLauncher()..result = false;
    await tester.pumpWidget(MaterialApp(
      home: LiveClassDetailScreen(
        liveClass: LiveClass(
          id: 'available',
          title: 'আজকের ক্লাস',
          startAt: DateTime(2026, 3, 8, 10),
          endAt: DateTime(2026, 3, 8, 11),
          meetingUrl: 'https://meet.google.com/abc',
        ),
        launcher: launcher,
        now: () => now,
      ),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.text('ক্লাসে যোগ দাও'));
    await tester.pumpAndSettle();
    expect(find.text('মিটিং লিংক খুলতে পারিনি। অভিভাবকের সাহায্য নাও।'),
        findsOneWidget);
    expect(find.text('লিংক কপি'), findsOneWidget);
  });

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
    expect(appState.xp, 10);
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
    SharedPreferences.setMockInitialValues({});
    final appState = AppState();
    await appState.loadFromPrefs();
    await tester.pumpWidget(ChangeNotifierProvider.value(
      value: appState,
      child: const MaterialApp(home: DuasScreen()),
    ));
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
    expect(appState.isDuaFavorite('sleep'), isTrue);
    expect(find.text('পছন্দে রাখা হয়েছে।'), findsOneWidget);
    await tester.tap(find.text('পছন্দের'));
    await tester.pumpAndSettle();
    expect(find.text('ঘুমাতে যাওয়ার সময়'), findsOneWidget);
    expect(find.text('খাবার শুরু করার আগে'), findsNothing);
  });

  testWidgets('Seerah screen opens a sourced child-friendly story',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final appState = AppState();
    await appState.loadFromPrefs();
    await tester.pumpWidget(ChangeNotifierProvider.value(
      value: appState,
      child: const MaterialApp(home: SeerahScreen()),
    ));
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
    await tester.scrollUntilVisible(
      find.text('গল্প শেষ করেছি · +১০ XP'),
      250,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text('গল্প শেষ করেছি · +১০ XP'));
    await tester.pumpAndSettle();
    expect(appState.hasCompletedLesson('seerah_abu_umair'), isTrue);
    expect(appState.xp, 10);
    await tester.pumpWidget(const SizedBox());
    await appState.completeLesson('seerah_abu_umair', xp: 10);
    expect(appState.xp, 10);
  });

  test('Dua favorites, chapter progress, quiz results and completion restore',
      () async {
    SharedPreferences.setMockInitialValues({});
    final appState = AppState();
    await appState.loadFromPrefs();
    await appState.toggleDuaFavorite('wake');
    await appState.saveBasicsProgress('basics_chapter_1', 205);
    await appState.recordQuizResult('basics_chapter_0', 10);
    expect(await appState.completeLesson('basics_chapter_0', xp: 25), isTrue);
    expect(await appState.completeLesson('basics_chapter_0', xp: 25), isFalse);
    expect(await appState.completeLesson('seerah_abu_umair', xp: 10), isTrue);

    final restored = AppState();
    await restored.loadFromPrefs();
    expect(restored.isDuaFavorite('wake'), isTrue);
    expect(restored.basicsProgress('basics_chapter_1'), 205);
    expect(restored.quizResult('basics_chapter_0'), 10);
    expect(restored.hasCompletedLesson('basics_chapter_0'), isTrue);
    expect(restored.hasCompletedLesson('seerah_abu_umair'), isTrue);
    expect(restored.xp, 35);
    expect(await restored.completeLesson('basics_chapter_0', xp: 25), isFalse);
    expect(await restored.completeLesson('seerah_abu_umair', xp: 10), isFalse);
    expect(restored.xp, 35);
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
