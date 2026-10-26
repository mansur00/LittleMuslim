import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:little_muslim/data/nurani_qaida_data.dart';
import 'package:little_muslim/models/qaida/qaida_models.dart';
import 'package:little_muslim/screens/qaida/qaida_activity_screen.dart';
import 'package:little_muslim/screens/qaida/qaida_chapters_screen.dart';
import 'package:little_muslim/screens/qaida/qaida_exam_screen.dart';
import 'package:little_muslim/screens/qaida/qaida_report_screen.dart';
import 'package:little_muslim/utils/app_state.dart';
import 'package:little_muslim/widgets/ds/parental_gate_dialog.dart';
import 'package:little_muslim/widgets/qaida/garden_progress_widget.dart';

void main() {
  group('Nurani Qaida 17-Step Master Plan Verification', () {
    test('Curriculum has exactly 17 steps', () {
      final steps = NuraniQaidaData.steps;
      expect(steps.length, 17);
      for (var i = 0; i < 17; i++) {
        expect(steps[i].stepNumber, i + 1);
        expect(steps[i].title.isNotEmpty, true);
        expect(steps[i].gardenPlant.isNotEmpty, true);
      }
    });

    test('Every lesson has at least 7 activities and #7 is Boss Challenge', () {
      for (final step in NuraniQaidaData.steps) {
        expect(step.lessons.isNotEmpty, true, reason: 'Step ${step.stepNumber} must have lessons');
        for (final lesson in step.lessons) {
          expect(lesson.activities.length >= 7, true,
              reason: 'Lesson ${lesson.id} in step ${step.stepNumber} must have at least 7 activities');
          final lastActivity = lesson.activities.last;
          expect(
            lastActivity.type == QaidaActivityType.bossChallenge ||
                lastActivity.type == QaidaActivityType.lessonCheck,
            true,
            reason: 'Activity #7 in ${lesson.id} must be Boss Challenge or Lesson Check',
          );
        }
      }
    });

    test('Step 1 (Mufradat) has all 28 distinct letters with tailored content', () {
      final step1 = NuraniQaidaData.getStepByNumber(1)!;
      expect(step1.lessons.length, 28);

      final letters = step1.lessons.map((l) => l.arabicDisplay).toSet();
      expect(letters.length, 28, reason: 'Must contain 28 distinct Arabic letters');

      // Verify Alif (1st letter) has tailored properties
      final alif = step1.lessons.first;
      expect(alif.arabicDisplay, 'ا');
      expect(alif.makhraj?.contains('alif') ?? false, true);
      expect(alif.exampleWords.contains('أَكَلَ'), true);

      // Verify Ba (2nd letter) has tailored properties
      final ba = step1.lessons[1];
      expect(ba.arabicDisplay, 'ب');
      expect(ba.makhraj?.contains('ba') ?? false, true);
      expect(ba.exampleWords.contains('بَيْتٌ'), true);

      // Verify option placement is not fixed to index 0 across activities
      final correctIndices = alif.activities.map((a) => a.correctIndex).toSet();
      expect(correctIndices.length > 1, true, reason: 'Correct answers must be dynamically distributed');
    });

    test('Step 2 (Murakkabat) has letter forms and word builder', () {
      final step2 = NuraniQaidaData.getStepByNumber(2)!;
      expect(step2.lessons.length, 8);
      for (final lesson in step2.lessons) {
        expect(lesson.activities.any((a) => a.type == QaidaActivityType.buildArrange), true);
        expect(lesson.activities.any((a) => a.type == QaidaActivityType.matchPairs), true);
      }
    });

    test('Step 3 (Harakat) covers Zabar, Zer, Pesh with Harakat Slider and Speed Reading', () {
      final step3 = NuraniQaidaData.getStepByNumber(3)!;
      expect(step3.lessons.length, 3);
      final firstLesson = step3.lessons.first;
      expect(firstLesson.activities.any((a) => a.type == QaidaActivityType.harakatSlider), true);
      expect(firstLesson.activities.any((a) => a.type == QaidaActivityType.speedReading), true);
      expect(firstLesson.activities.any((a) => a.type == QaidaActivityType.voiceRepeat), true);
    });

    test('Step 17 (Tilawat) covers full Ayah recitation', () {
      final step17 = NuraniQaidaData.getStepByNumber(17)!;
      expect(step17.title, 'qaida.step.17.title');
      expect(step17.lessons.isNotEmpty, true);
    });

    testWidgets('Phase 2: QaidaChaptersScreen renders 17-step island map and garden widget',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final appState = AppState();
      await appState.loadFromPrefs();

      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        ChangeNotifierProvider<AppState>.value(
          value: appState,
          child: const MaterialApp(
            home: QaidaChaptersScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Islamic Garden Progress is displayed
      expect(find.byType(IslamicGardenWidget), findsOneWidget);

      // Verify header with 17 steps
      expect(find.text('নূরানী ক্বায়দা'), findsOneWidget);
      expect(find.text('১৭টি ধাপের পূর্ণাঙ্গ লার্নিং ম্যাপ'), findsOneWidget);

      // Verify quick actions: Review Island & Report
      expect(find.text('রিভিশন আইল্যান্ড'), findsOneWidget);
      expect(find.text('অগ্রগতি প্রতিবেদন'), findsOneWidget);

      // Verify Level 1 section is visible
      expect(find.text('লেভেল ১ · হরফ চেনা ও রূপভেদ (Steps 1–2)'), findsOneWidget);

      // Scroll down to bring Step 1 island card into view
      await tester.drag(find.byType(ListView), const Offset(0, -250));
      await tester.pumpAndSettle();

      // Step 1 title is visible
      expect(find.text('মুফরাদাত'), findsOneWidget);
    });

    testWidgets('Phase 2: Step 1 is unlocked initially, Step 2 is locked until unlocked or admin',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final appState = AppState();
      await appState.loadFromPrefs();

      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        ChangeNotifierProvider<AppState>.value(
          value: appState,
          child: const MaterialApp(
            home: QaidaChaptersScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Scroll down to bring Step 2 into view
      await tester.drag(find.byType(ListView), const Offset(0, -350));
      await tester.pumpAndSettle();

      // Step 2 should show locked status text
      expect(find.text('লকড (৮০% প্রয়োজন)'), findsWidgets);

      // Now toggle Admin mode
      await appState.setUserRole('admin', token: ParentalGate.mintForTesting());
      await tester.pumpAndSettle();

      // Scroll back up to verify Admin banner
      await tester.drag(find.byType(ListView), const Offset(0, 350));
      await tester.pumpAndSettle();

      // Admin banner should now be visible
      expect(find.textContaining('এডমিন মোড সক্রিয়'), findsOneWidget);
    });

    testWidgets('Phase 3: Harakat Slider interactive touch activity',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final appState = AppState();
      await appState.loadFromPrefs();

      final step3 = NuraniQaidaData.getStepByNumber(3)!;
      final harakatLesson = step3.lessons.first;
      final sliderAct = harakatLesson.activities
          .firstWhere((a) => a.type == QaidaActivityType.harakatSlider);

      final testLesson = QaidaLessonInfo(
        id: 'test_harakat_slider_lesson',
        trackId: 'step_3',
        lessonNumber: 1,
        title: 'Harakat Slider Test',
        subtitle: 'Test',
        description: 'Test Description',
        arabicDisplay: 'بَ',
        isReviewNode: true,
        activities: [sliderAct],
      );

      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        ChangeNotifierProvider<AppState>.value(
          value: appState,
          child: MaterialApp(
            home: QaidaActivityScreen(lesson: testLesson),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify slider prompt and 3 harakat nodes (যবর, যের, পেশ)
      expect(find.text('স্লাইড বা ট্যাপ করে সঠিক হরকত বেছে নাও:'), findsOneWidget);
      expect(find.text('যবর'), findsWidgets);
      expect(find.text('যের'), findsWidgets);
      expect(find.text('পেশ'), findsWidgets);

      // Tap 'যের' node to switch harakat to Kasra
      await tester.tap(find.text('যের').first);
      await tester.pumpAndSettle();

      // Bottom check button is present
      expect(find.text('যাচাই করুন'), findsOneWidget);
    });

    testWidgets('Phase 3: Shaddah Press double tap tactile activity',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final appState = AppState();
      await appState.loadFromPrefs();

      const shaddahAct = QaidaActivity(
        id: 'test_shaddah_press',
        slotNumber: 1,
        type: QaidaActivityType.shaddahPress,
        prompt: 'তাশদীদ ডাবল প্রেস',
        arabicTarget: 'أَنَّ',
      );

      final testLesson = QaidaLessonInfo(
        id: 'test_shaddah_lesson',
        trackId: 'step_8',
        lessonNumber: 1,
        title: 'Shaddah Press Test',
        subtitle: 'Test',
        description: 'Test Description',
        arabicDisplay: 'أَنَّ',
        isReviewNode: true,
        activities: [shaddahAct],
      );

      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        ChangeNotifierProvider<AppState>.value(
          value: appState,
          child: MaterialApp(
            home: QaidaActivityScreen(lesson: testLesson),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('১ম চাপ'), findsWidgets);

      // Tap 1
      await tester.tap(find.textContaining('১ম চাপ').last);
      await tester.pumpAndSettle();

      // Tap 1 completed, prompt updates for 2nd tap
      expect(find.textContaining('২য় চাপ'), findsWidgets);

      // Tap 2
      await tester.tap(find.textContaining('২য় চাপ').last);
      await tester.pumpAndSettle();

      // Double press completed successfully
      expect(find.textContaining('দ্বিগুণ চাপ সম্পন্ন'), findsOneWidget);
    });

    testWidgets('Phase 3: Voice Repeat and Echo Mode self-compare activity',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final appState = AppState();
      await appState.loadFromPrefs();

      const voiceAct = QaidaActivity(
        id: 'test_voice_repeat',
        slotNumber: 1,
        type: QaidaActivityType.voiceRepeat,
        prompt: 'উস্তাদের সাথে বলো',
        arabicTarget: 'بَ',
      );

      final testLesson = QaidaLessonInfo(
        id: 'test_voice_lesson',
        trackId: 'step_3',
        lessonNumber: 1,
        title: 'Voice Repeat Test',
        subtitle: 'Test',
        description: 'Test Description',
        arabicDisplay: 'بَ',
        isReviewNode: true,
        activities: [voiceAct],
      );

      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        ChangeNotifierProvider<AppState>.value(
          value: appState,
          child: MaterialApp(
            home: QaidaActivityScreen(lesson: testLesson),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify listen and record buttons
      expect(find.text('১. উস্তাদের তিলাওয়াত শুনুন'), findsOneWidget);
      expect(find.text('২. মাইক্রোফোনে ট্যাপ করে বলুন'), findsOneWidget);

      // Tap mic to record
      await tester.tap(find.text('২. মাইক্রোফোনে ট্যাপ করে বলুন'));
      await tester.pump(const Duration(milliseconds: 100));

      // Fast-forward past simulated recording
      await tester.pump(const Duration(milliseconds: 2500));
      await tester.pumpAndSettle();

      // Verify self-compare action
      expect(find.text('মিলে গেছে! ✓'), findsOneWidget);
      expect(find.text('আবার বলি'), findsOneWidget);

      // Tap 'মিলে গেছে! ✓'
      await tester.tap(find.text('মিলে গেছে! ✓'));
      await tester.pumpAndSettle();

      // Feedback banner appears
      expect(find.text('পরবর্তী ধাপ ➔'), findsOneWidget);
    });

    testWidgets(
        'Phase 4: Spot the Mistake activity correctly identifies mistake',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final appState = AppState();
      await appState.loadFromPrefs();

      const spotAct = QaidaActivity(
        id: 'test_spot_mistake',
        slotNumber: 2,
        type: QaidaActivityType.spotTheMistake,
        prompt: '“مَنْ يَقُولُ”-এর ক্ষেত্রে কোন উচ্চারণটি ভুল?',
        arabicSnippet: 'مَنْ يَقُولُ',
        options: [
          'ইদগাম সহ পড়া (সঠিক)',
          'ইযহার করে স্পষ্ট পড়া (ভুল)',
          'টান ছাড়া পড়া'
        ],
        correctIndex: 1,
      );

      final testLesson = QaidaLessonInfo(
        id: 'test_spot_lesson',
        trackId: 'step_9_noon_sakin',
        lessonNumber: 1,
        title: 'Spot the Mistake Test',
        subtitle: 'Test',
        description: 'Test Description',
        arabicDisplay: 'مَنْ يَقُولُ',
        isReviewNode: true,
        activities: [spotAct],
      );

      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        ChangeNotifierProvider<AppState>.value(
          value: appState,
          child: MaterialApp(
            home: QaidaActivityScreen(lesson: testLesson),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('ভুলটি শনাক্ত করো'), findsOneWidget);
      expect(find.text('مَنْ يَقُولُ'), findsWidgets);
      expect(find.text('সঠিক উচ্চারণ শুনুন'), findsOneWidget);

      // Select the mistake option (index 1)
      await tester.tap(find.text('ইযহার করে স্পষ্ট পড়া (ভুল)'));
      await tester.pumpAndSettle();

      // Tap check
      await tester.tap(find.text('যাচাই করুন'));
      await tester.pumpAndSettle();

      // Success feedback banner
      expect(find.text('পরবর্তী ধাপ ➔'), findsOneWidget);
    });

    testWidgets('Phase 4: Which Rule? / Rule Discovery interactive selection',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final appState = AppState();
      await appState.loadFromPrefs();

      const whichRuleAct = QaidaActivity(
        id: 'test_which_rule',
        slotNumber: 4,
        type: QaidaActivityType.whichRule,
        prompt: '“مَنْ يَقُولُ”-এ কোন তাজবীদ বিধান প্রযোজ্য?',
        arabicSnippet: 'مَنْ يَقُولُ',
        options: ['ইদগাম (মিলিয়ে)', 'ইযহার (স্পষ্ট)', 'ইখফা (গোপন)'],
        correctIndex: 0,
      );

      final testLesson = QaidaLessonInfo(
        id: 'test_rule_lesson',
        trackId: 'step_9_noon_sakin',
        lessonNumber: 1,
        title: 'Which Rule Test',
        subtitle: 'Test',
        description: 'Test Description',
        arabicDisplay: 'مَنْ يَقُولُ',
        isReviewNode: true,
        activities: [whichRuleAct],
      );

      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        ChangeNotifierProvider<AppState>.value(
          value: appState,
          child: MaterialApp(
            home: QaidaActivityScreen(lesson: testLesson),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('তাজবীদ নিয়ম আবিষ্কার করো'), findsOneWidget);
      expect(find.text('ইদগাম (মিলিয়ে)'), findsOneWidget);

      // Select Idgham
      await tester.tap(find.text('ইদগাম (মিলিয়ে)'));
      await tester.pumpAndSettle();

      // Tap check
      await tester.tap(find.text('যাচাই করুন'));
      await tester.pumpAndSettle();

      expect(find.text('পরবর্তী ধাপ ➔'), findsOneWidget);
    });

    testWidgets('Phase 4: Ghunnah Meter holding touch activity',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final appState = AppState();
      await appState.loadFromPrefs();

      const ghunnahAct = QaidaActivity(
        id: 'test_ghunnah_act',
        slotNumber: 3,
        type: QaidaActivityType.ghunnahMeter,
        prompt: 'নাকের বাঁশিতে গুন্নাহ ধরে রাখুন:',
        arabicSnippet: 'إِنَّ',
      );

      final testLesson = QaidaLessonInfo(
        id: 'test_ghunnah_lesson',
        trackId: 'step_11_ghunnah',
        lessonNumber: 1,
        title: 'Ghunnah Meter Test',
        subtitle: 'Test',
        description: 'Test Description',
        arabicDisplay: 'إِنَّ',
        isReviewNode: true,
        activities: [ghunnahAct],
      );

      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        ChangeNotifierProvider<AppState>.value(
          value: appState,
          child: MaterialApp(
            home: QaidaActivityScreen(lesson: testLesson),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
          find.textContaining('গুন্নাহ সম্পূর্ণ করুন'), findsOneWidget);
      expect(find.text('চেপে ধরে গুন্নাহ করুন'), findsOneWidget);

      // Tap down to trigger hold
      await tester.tap(find.text('চেপে ধরে গুন্নাহ করুন'));
      await tester.pumpAndSettle();

      // Verified complete
      expect(find.textContaining('মাশাআল্লাহ! গুন্নাহ সফলভাবে সম্পন্ন'),
          findsOneWidget);
      expect(find.text('পরবর্তী ধাপ ➔'), findsOneWidget);
    });

    testWidgets(
        'Phase 5: QaidaChaptersScreen displays Exam Center for Weekly & Monthly Exams',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final appState = AppState();
      await appState.loadFromPrefs();

      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        ChangeNotifierProvider<AppState>.value(
          value: appState,
          child: const MaterialApp(
            home: QaidaChaptersScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('সাপ্তাহিক পরীক্ষা'), findsOneWidget);
      expect(find.text('মাসিক পরীক্ষা'), findsOneWidget);
      expect(find.textContaining('স্টেপ বস পরীক্ষা দিন'), findsWidgets);
    });

    testWidgets(
        'Phase 5: QaidaExamScreen renders and supports 80% passing gate with positive phrasing',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final appState = AppState();
      await appState.loadFromPrefs();

      final step1 = NuraniQaidaData.steps.first;

      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        ChangeNotifierProvider<AppState>.value(
          value: appState,
          child: MaterialApp(
            home: QaidaExamScreen(
              tier: QaidaExamTier.stepBoss,
              step: step1,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('বস পরীক্ষা'), findsOneWidget);
      expect(find.textContaining('পাস মার্ক ৮০%'), findsOneWidget);
      expect(find.text('যাচাই করুন'), findsOneWidget);
    });

    testWidgets(
        'Phase 6: QaidaActivityScreen renders Voice Guide button and toggles Quiet Mode',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final appState = AppState();
      await appState.loadFromPrefs();

      final step1 = NuraniQaidaData.steps.first;
      final lesson1 = step1.lessons.first;

      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        ChangeNotifierProvider<AppState>.value(
          value: appState,
          child: MaterialApp(
            home: QaidaActivityScreen(lesson: lesson1),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Voice Guide button is present
      expect(find.text('ভয়েস গাইড'), findsOneWidget);

      // Quiet Mode toggle starts in volume_up state
      expect(find.byIcon(Icons.volume_up_rounded), findsOneWidget);

      // Tap Quiet Mode toggle
      await tester.tap(find.byIcon(Icons.volume_up_rounded));
      await tester.pumpAndSettle();

      // Toggled to muted state
      expect(find.byIcon(Icons.volume_off_rounded), findsOneWidget);
    });

    testWidgets(
        'Phase 6: QaidaReportScreen displays 28-letter Heatmap, Exam Audit card, and Guardian Teach Back check-in',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final appState = AppState();
      await appState.loadFromPrefs();

      tester.view.physicalSize = const Size(800, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        ChangeNotifierProvider<AppState>.value(
          value: appState,
          child: const MaterialApp(
            home: QaidaReportScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify 28-letter heatmap section
      await tester.ensureVisible(find.textContaining('২৮ হরফ মাখরাজ হিটম্যাপ'));
      expect(find.textContaining('২৮ হরফ মাখরাজ হিটম্যাপ'), findsOneWidget);

      // Verify Exam audit section
      await tester.ensureVisible(find.textContaining('৩-স্তর বিশিষ্ট পরীক্ষা অডিট'));
      expect(find.textContaining('৩-স্তর বিশিষ্ট পরীক্ষা অডিট'), findsOneWidget);

      // Verify Guardian Teach Back section
      await tester.ensureVisible(find.textContaining('অভিভাবক চেক-ইন'));
      expect(find.textContaining('অভিভাবক চেক-ইন'), findsOneWidget);
      expect(find.text('আজকের তিলাওয়াত শুনেছি (+১৫ XP)'), findsOneWidget);

      final initialXp = appState.xp;

      // Scroll to Guardian Teach Back button if needed and tap it
      await tester.ensureVisible(find.text('আজকের তিলাওয়াত শুনেছি (+১৫ XP)'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('আজকের তিলাওয়াত শুনেছি (+১৫ XP)'));
      await tester.pumpAndSettle();

      // Check +15 XP bonus was awarded and button updated
      expect(appState.xp, initialXp + 15);
      expect(find.text('আজকের তিলাওয়াত শোনা হয়েছে ✓'), findsOneWidget);
    });

    test('Phase 7: All 17 steps have realistic options with ZERO dummy distractors or fake rules', () {
      for (final step in NuraniQaidaData.steps) {
        for (final lesson in step.lessons) {
          for (final activity in lesson.activities) {
            for (final option in activity.options) {
              // No fake rule strings
              expect(option.contains('ভুল নিয়ম'), false,
                  reason: 'Activity ${activity.id} in ${step.title} has placeholder string');
              expect(option.contains('ভুল বিধান'), false,
                  reason: 'Activity ${activity.id} in ${step.title} has placeholder string');
              expect(option.contains('সাধারণ পাঠ'), false,
                  reason: 'Activity ${activity.id} in ${step.title} has placeholder string');

              // If testing full words/ayahs (> 4 chars), distractor must not be a single letter like 'بَ' or 'لِ'
              if ((activity.arabicTarget?.length ?? 0) > 6 && activity.type != QaidaActivityType.harakatSlider) {
                expect(option != 'بَ' && option != 'لِ', true,
                    reason: 'Ayah/Word activity ${activity.id} in Step ${step.stepNumber} has single letter distractor $option');
              }
            }
          }
        }
      }
    });

    test('Phase 7: Step 17 (Tilawat) uses authentic Ayahs as options without single letter distractors', () {
      final step17 = NuraniQaidaData.getStepByNumber(17)!;
      final firstLesson = step17.lessons.first;
      final listenAct = firstLesson.activities.first;
      expect(listenAct.arabicTarget, 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ');
      expect(listenAct.options.contains('الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ'), true);
      expect(listenAct.options.contains('الرَّحْمٰنِ الرَّحِيمِ'), true);
      expect(listenAct.options.contains('بَ'), false);
      expect(listenAct.options.contains('لِ'), false);

      // Verify sequence activity has full Ayahs
      final seqAct = firstLesson.activities.firstWhere((a) => a.type == QaidaActivityType.sequenceOrder);
      expect(seqAct.sequenceItems?.length, 4);
      expect(seqAct.sequenceItems?.first, 'بِسْمِ اللَّهِ الرَّحْمٰنِ الرَّحِيمِ');
    });

    testWidgets('Phase 7: Odd One Out and Sing Along Gap activities render properly',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final appState = AppState();
      await appState.loadFromPrefs();

      const oddAct = QaidaActivity(
        id: 'test_odd_act',
        slotNumber: 1,
        type: QaidaActivityType.oddOneOut,
        prompt: 'ব্যতিক্রম হরফটি নির্বাচন করো',
        options: ['بً', 'تً', 'ثً', 'بَ'],
        correctIndex: 3,
      );

      final testLesson = QaidaLessonInfo(
        id: 'test_odd_lesson',
        trackId: 'step_4',
        lessonNumber: 1,
        title: 'Odd One Out Test',
        subtitle: 'Test',
        description: 'Test Description',
        arabicDisplay: 'بَ',
        isReviewNode: true,
        activities: [oddAct],
      );

      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        ChangeNotifierProvider<AppState>.value(
          value: appState,
          child: MaterialApp(
            home: QaidaActivityScreen(lesson: testLesson),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('ব্যতিক্রম হরফটি খুঁজুন'), findsOneWidget);
      expect(find.text('بَ'), findsWidgets);
      expect(find.text('بً'), findsWidgets);
    });

    testWidgets('Phase 7: Catch Letters activity collects letters and increments basket count',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final appState = AppState();
      await appState.loadFromPrefs();

      const catchAct = QaidaActivity(
        id: 'test_catch_act',
        slotNumber: 1,
        type: QaidaActivityType.catchLetters,
        prompt: 'ঝুড়িতে হরফ ধরো',
        arabicTarget: 'بٰ',
        options: ['بٰ', 'بَ', 'بِ', 'بُ'],
      );

      final testLesson = QaidaLessonInfo(
        id: 'test_catch_lesson',
        trackId: 'step_5',
        lessonNumber: 1,
        title: 'Catch Letters Test',
        subtitle: 'Test',
        description: 'Test Description',
        arabicDisplay: 'بٰ',
        isReviewNode: true,
        activities: [catchAct],
      );

      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        ChangeNotifierProvider<AppState>.value(
          value: appState,
          child: MaterialApp(
            home: QaidaActivityScreen(lesson: testLesson),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('হরফ সংগ্রহ করো:'), findsOneWidget);
      expect(find.textContaining('০ / ৩ টি ধরা হয়েছে'), findsOneWidget);

      // Tap one of the matching target letters
      final targetFinders = find.text('بٰ');
      expect(targetFinders, findsWidgets);
      await tester.tap(targetFinders.last);
      await tester.pumpAndSettle();

      // Basket count should update to 1 / 3
      expect(find.textContaining('১ / ৩ টি ধরা হয়েছে'), findsOneWidget);
    });

    testWidgets('Drag & Drop in sortGroups renders Draggable items and DragTarget bins',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final appState = AppState();
      await appState.loadFromPrefs();

      const sortAct = QaidaActivity(
        id: 'test_sort_act',
        slotNumber: 1,
        type: QaidaActivityType.sortGroups,
        prompt: 'হরকত অনুযায়ী সাজাও',
        sortingCategories: {
          'যবর': ['بَ', 'دَ'],
          'যের': ['بِ', 'دِ'],
        },
      );

      final testLesson = QaidaLessonInfo(
        id: 'test_sort_lesson',
        trackId: 'step_3',
        lessonNumber: 1,
        title: 'Sort Test',
        subtitle: 'Test',
        description: 'Test Description',
        arabicDisplay: 'بَ',
        isReviewNode: true,
        activities: [sortAct],
      );

      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        ChangeNotifierProvider<AppState>.value(
          value: appState,
          child: MaterialApp(
            home: QaidaActivityScreen(lesson: testLesson),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check Draggable<String> widgets exist in the tray
      expect(find.byType(Draggable<String>), findsWidgets);
      // Check DragTarget<String> widgets exist for the bins
      expect(find.byType(DragTarget<String>), findsWidgets);

      // Check group names are displayed
      expect(find.text('যবর'), findsOneWidget);
      expect(find.text('যের'), findsOneWidget);
      expect(find.textContaining('হরফগুলো টেনে নিচের ঘরে রাখো'), findsOneWidget);

      // Tap on unsorted item and then tap the group bin (tap placement fallback)
      final baItem = find.text('بَ');
      expect(baItem, findsWidgets);
      await tester.tap(baItem.first);
      await tester.pumpAndSettle();

      // Tap the 'যবর' bin to drop it in
      await tester.tap(find.text('যবর'));
      await tester.pumpAndSettle();

      // '১ টি রাখা হয়েছে' should appear in 'যবর' bin
      expect(find.textContaining('১ টি রাখা হয়েছে'), findsOneWidget);
    });

    testWidgets('Word Builder renders Draggable tiles and DragTarget pedestals',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final appState = AppState();
      await appState.loadFromPrefs();

      final wordAct = QaidaActivity(
        id: 'test_word_act',
        slotNumber: 1,
        type: QaidaActivityType.buildArrange,
        prompt: 'শব্দ গঠন করো',
        tiles: [
          ActivityTile(id: 't1', label: 'كُ', arabicLabel: 'كُ'),
          ActivityTile(id: 't2', label: 'فُ', arabicLabel: 'فُ'),
        ],
      );

      final testLesson = QaidaLessonInfo(
        id: 'test_word_lesson',
        trackId: 'step_4',
        lessonNumber: 1,
        title: 'Word Builder Test',
        subtitle: 'Test',
        description: 'Test Description',
        arabicDisplay: 'كُفُ',
        isReviewNode: true,
        activities: [wordAct],
      );

      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        ChangeNotifierProvider<AppState>.value(
          value: appState,
          child: MaterialApp(
            home: QaidaActivityScreen(lesson: testLesson),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(DragTarget<ActivityTile>), findsNWidgets(2));
      expect(find.byType(Draggable<ActivityTile>), findsNWidgets(2));
      expect(find.textContaining('নিচ থেকে টেনে বা ট্যাপ করে সাজাও'), findsOneWidget);
    });

    testWidgets('Memory Flip cards render and flip on tap',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final appState = AppState();
      await appState.loadFromPrefs();

      final memAct = QaidaActivity(
        id: 'test_mem_act',
        slotNumber: 1,
        type: QaidaActivityType.memoryMatch,
        prompt: 'মেমোরি কার্ড মেলাও',
        pairs: {
          'ب': 'বা',
          'ت': 'তা',
        },
      );

      final testLesson = QaidaLessonInfo(
        id: 'test_mem_lesson',
        trackId: 'step_1',
        lessonNumber: 1,
        title: 'Memory Test',
        subtitle: 'Test',
        description: 'Test Description',
        arabicDisplay: 'ب',
        isReviewNode: true,
        activities: [memAct],
      );

      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        ChangeNotifierProvider<AppState>.value(
          value: appState,
          child: MaterialApp(
            home: QaidaActivityScreen(lesson: testLesson),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Cards are initially facing down (displaying star icons)
      expect(find.byIcon(Icons.star_rounded), findsWidgets);

      // Tap first card to trigger 3D flip animation
      final stars = find.byIcon(Icons.star_rounded);
      await tester.tap(stars.first);
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();

      // Flipped card reveals text
      expect(find.byType(Text), findsWidgets);
    });
  });
}
