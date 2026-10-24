const fs = require('fs');
const path = require('path');

const ROOT = path.resolve(__dirname, '..');
const filePath = path.join(ROOT, 'lib', 'l10n', 'app_localizations.dart');
const content = fs.readFileSync(filePath, 'utf8');

const startMarker = '  String? _translateTemplate(String value) {';
const endMarker = '    return null;\n  }\n}';

const startIdx = content.indexOf(startMarker);
const endIdx = content.indexOf(endMarker);

if (startIdx === -1 || endIdx === -1) {
  console.error('Markers not found!');
  process.exit(1);
}

const newMethod = `  String? _translateTemplate(String value) {
    // 1. Step {n} / ধাপ {n} / চরণ {n} / Passo {n}
    final stepMatch = RegExp(
      r'^(?:চলমান:\\s*)?(?:স্টেপ|ধাপ|Step|Passo|चरण)\\s+(\\d+)(?::\\s*(.*))?$',
      caseSensitive: false,
    ).firstMatch(value.trim());

    if (stepMatch != null) {
      final isCurrent = value.trim().startsWith(RegExp(r'^(?:চলমান:|current:)', caseSensitive: false));
      final n = stepMatch.group(1)!;
      final rawTitle = stepMatch.group(2)?.trim();
      final translatedTitle =
          rawTitle != null && rawTitle.isNotEmpty ? translate(rawTitle) : null;

      final prefix = isCurrent ? translate('template.current_prefix') : '';
      final stepWord = translate('template.step_word');

      if (translatedTitle != null) {
        return '\$prefix\$stepWord \$n: \$translatedTitle';
      }
      return '\$prefix\$stepWord \$n';
    }

    // 2. Lesson {n}/{total} / পাঠ {n}/{total} / Lezione {n}/{total}
    final lessonMatch = RegExp(
      r'^(?:পাঠ|Lesson|Lezione|पाठ)\\s+(\\d+)(?:/(\\d+))?$',
      caseSensitive: false,
    ).firstMatch(value.trim());

    if (lessonMatch != null) {
      final n = lessonMatch.group(1)!;
      final total = lessonMatch.group(2);
      final word = translate('template.lesson_word');
      return total != null ? '\$word \$n/\$total' : '\$word \$n';
    }

    // 3. Age {n} / বয়স {n} / उम्र {n} / Età {n}
    final ageMatch = RegExp(
      r'^(?:বয়স|Age|উम्र|Età|उम्र)\\s+(\\d+)(?:\\s*·\\s*(.*))?$',
      caseSensitive: false,
    ).firstMatch(value.trim());

    if (ageMatch != null) {
      final n = ageMatch.group(1)!;
      final rest = ageMatch.group(2)?.trim();
      final word = translate('template.age_word');
      if (rest != null && rest.isNotEmpty) {
        return '\$word \$n · \${translate(rest)}';
      }
      return '\$word \$n';
    }

    // 4. Question {a} / {b}
    final qMatch = RegExp(
      r'^(?:প্রশ্ন|Question|Domanda|प्रश्न)\\s+(\\d+)\\s*/\\s*(\\d+)(.*)$',
      caseSensitive: false,
    ).firstMatch(value.trim());

    if (qMatch != null) {
      final a = qMatch.group(1)!;
      final b = qMatch.group(2)!;
      final rest = qMatch.group(3) ?? '';
      final word = translate('template.question_word');
      final passNote = rest.isNotEmpty ? translate('template.pass_mark_note') : '';
      return '\$word \$a / \$b\$passNote';
    }

    // 5. {n} Lessons / {n}টি পাঠ
    final nLessonsMatch = RegExp(
      r'^(\\d+)(?:টি পাঠ| Lessons| lezioni| पाठ)$',
      caseSensitive: false,
    ).firstMatch(value.trim());

    if (nLessonsMatch != null) {
      final n = nLessonsMatch.group(1)!;
      return translate('template.n_lessons', params: {'n': n});
    }

    // 6. {n} Steps / {n}টি ধাপ
    final nStepsMatch = RegExp(
      r'^(\\d+)(?:টি ধাপ| Steps| passaggi| चरण)$',
      caseSensitive: false,
    ).firstMatch(value.trim());

    if (nStepsMatch != null) {
      final n = nStepsMatch.group(1)!;
      return translate('template.n_steps', params: {'n': n});
    }

    // 7. Track {n} Exam Passed
    final trackExamMatch = RegExp(
      r'^(?:ট্র্যাক|Track)\\s+(\\d+)\\s+(?:সমাপনী উত্তীর্ণ!|Exam Passed!)$',
      caseSensitive: false,
    ).firstMatch(value.trim());

    if (trackExamMatch != null) {
      final n = trackExamMatch.group(1)!;
      return translate('template.track_exam_passed', params: {'n': n});
    }

    // 8. Surah {s} · Ayah {a}
    final surahAyahMatch = RegExp(
      r'^(?:সূরা নম্বর|Surah|सूरा|Sura)\\s+(\\d+)\\s*·\\s*(?:আয়াত|Ayah|आयাত|Versetto)\\s+(\\d+)$',
      caseSensitive: false,
    ).firstMatch(value.trim());

    if (surahAyahMatch != null) {
      final s = surahAyahMatch.group(1)!;
      final a = surahAyahMatch.group(2)!;
      return translate('template.surah_ayah', params: {'s': s, 'a': a});
    }

    // 9. Learn {letter} / {letter} চিনি
    final learnLetterMatch = RegExp(
      r'^(?:Learn\\s+(.+)|(.+?)\\s*চিনি|सीखें\\s+(.+)|Impara\\s+(.+))$',
      caseSensitive: false,
    ).firstMatch(value.trim());

    if (learnLetterMatch != null) {
      final rawLetter = learnLetterMatch.group(1) ??
          learnLetterMatch.group(2) ??
          learnLetterMatch.group(3) ??
          learnLetterMatch.group(4)!;
      final letter = translate(rawLetter.trim());
      return translate('template.learn_letter', params: {'letter': letter});
    }

    // 10. Listen for "{letter}" and choose the letter
    final listenLetterMatch = RegExp(
      r'^(?:Listen for [“"”](.+?)[“"”]|and choose the letter\\.?)',
      caseSensitive: false,
    ).firstMatch(value.trim());

    if (listenLetterMatch != null) {
      final rawLetter =
          listenLetterMatch.group(1) ?? listenLetterMatch.group(2)!;
      final letter = translate(rawLetter.trim());
      return translate('template.listen_choose_letter', params: {'letter': letter});
    }

    // 11. Which letter is "{letter}"?
    final whichLetterMatch = RegExp(
      r'^(?:Which (?:one is the )?letter [“"”](.+?)[“"”]|হরফে বসবে)',
      caseSensitive: false,
    ).firstMatch(value.trim());

    if (whichLetterMatch != null) {
      final rawLetter =
          whichLetterMatch.group(1) ?? whichLetterMatch.group(2)!;
      final letter = translate(rawLetter.trim());
      return translate('template.which_letter', params: {'letter': letter});
    }

    // 12. Which dot piece belongs on the letter "{letter}"?
    final whichDotMatch = RegExp(
      r'^(?:Which dot piece belongs on the letter [“"”](.+?)[“"”]|কোন বিন্দুর টুকরোটি)',
      caseSensitive: false,
    ).firstMatch(value.trim());

    if (whichDotMatch != null) {
      final rawLetter = whichDotMatch.group(1) ?? whichDotMatch.group(2)!;
      final letter = translate(rawLetter.trim());
      return translate('template.which_dot', params: {'letter': letter});
    }

    // 13. Letter {name} / {name} হরফ
    final letterNameMatch = RegExp(
      r'^(?:Letter\\s+(.+)|(.+?)\\s+হরফ|अक्षर\\s+(.+)|Lettera\\s+(.+))$',
      caseSensitive: false,
    ).firstMatch(value.trim());

    if (letterNameMatch != null) {
      final rawName = letterNameMatch.group(1) ??
          letterNameMatch.group(2) ??
          letterNameMatch.group(3) ??
          letterNameMatch.group(4)!;
      final name = translate(rawName.trim());
      return translate('template.letter_name', params: {'name': name});
    }

    // 14. Letter: {x} / হরফ: {x}
    final letterColonMatch = RegExp(
      r'^(?:Letter:\\s*|হরফ:\\s*|अक्षर:\\s*|Lettera:\\s*)(.*)$',
      caseSensitive: false,
    ).firstMatch(value.trim());

    if (letterColonMatch != null) {
      final rest = letterColonMatch.group(1)?.trim() ?? '';
      return translate('template.letter_colon', params: {'rest': rest});
    }

    // 15. Teacher: {name} / শিক্ষক: {name}
    final teacherMatch = RegExp(
      r'^(?:শিক্ষক:\\s*|Teacher:\\s*|शिक्षक:\\s*|Insegnante:\\s*)(.*)$',
      caseSensitive: false,
    ).firstMatch(value.trim());

    if (teacherMatch != null) {
      final teacher = teacherMatch.group(1)?.trim() ?? '';
      return translate('template.teacher', params: {'teacher': teacher});
    }

    return null;
  }`;

const updated = content.substring(0, startIdx) + newMethod + content.substring(endIdx + '    return null;\n  }'.length);
fs.writeFileSync(filePath, updated, 'utf8');
console.log('Successfully patched app_localizations.dart');
