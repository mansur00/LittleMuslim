import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  const AppLocalizations(this.locale, this.translations);

  final Locale locale;
  final Map<String, String> translations;

  static AppLocalizations? of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations);

  String translate(String source) {
    if (source.isEmpty) return source;

    // 1. Direct match
    var result = translations[source] ??
        translations[source.trim()] ??
        _translateTemplate(source);

    // 2. If no direct match, check if entire string is just digits
    result ??= source;

    // 3. Digits localization according to target locale
    const banglaDigits = '০১২৩৪৫৬৭৮৯';
    const englishDigits = '0123456789';
    if (locale.languageCode == 'en') {
      for (var i = 0; i < banglaDigits.length; i++) {
        result = result!.replaceAll(banglaDigits[i], englishDigits[i]);
      }
    } else {
      for (var i = 0; i < englishDigits.length; i++) {
        result = result!.replaceAll(englishDigits[i], banglaDigits[i]);
      }
    }

    return result!;
  }

  String? _translateTemplate(String value) {
    final isEn = locale.languageCode == 'en';

    // Built-in high-priority parametric templates
    final commonTemplates = [
      (
        RegExp(r'^(?:চলমান:\s*)?(?:স্টেপ|ধাপ|Step)\s+(\d+)(?::\s*(.*))?$', caseSensitive: false),
        (Match m) {
          final isCurrent = m.group(0)!.trim().startsWith('চলমান:') || m.group(0)!.trim().startsWith('Current:');
          final n = m.group(1)!;
          final title = m.group(2);
          final translatedTitle = title != null ? translate(title) : null;
          final prefix = isCurrent ? (isEn ? 'Current: ' : 'চলমান: ') : '';
          if (isEn) {
            return '$prefix${translatedTitle != null ? 'Step $n: $translatedTitle' : 'Step $n'}';
          } else {
            return '$prefix${translatedTitle != null ? 'ধাপ $n: $translatedTitle' : 'ধাপ $n'}';
          }
        }
      ),
      (
        RegExp(r'^(?:পাঠ|Lesson)\s+(\d+)(?:/(\d+))?$', caseSensitive: false),
        (Match m) {
          final n = m.group(1)!;
          final total = m.group(2);
          if (isEn) {
            return total != null ? 'Lesson $n/$total' : 'Lesson $n';
          } else {
            return total != null ? 'পাঠ $n/$total' : 'পাঠ $n';
          }
        }
      ),
      (
        RegExp(r'^(?:বয়স|Age)\s+(\d+)(?:\s*·\s*(.*))?$', caseSensitive: false),
        (Match m) {
          final n = m.group(1)!;
          final rest = m.group(2)?.trim();
          if (rest == null || rest.isEmpty) {
            return isEn ? 'Age $n' : 'বয়স $n';
          }
          final translatedRest = translate(rest);
          return isEn ? 'Age $n · $translatedRest' : 'বয়স $n · $translatedRest';
        }
      ),
      (
        RegExp(r'^(?:প্রশ্ন|Question)\s+(\d+)\s*/\s*(\d+)(.*)$', caseSensitive: false),
        (Match m) {
          final a = m.group(1)!;
          final b = m.group(2)!;
          final rest = m.group(3) ?? '';
          if (isEn) {
            return 'Question $a / $b${rest.isNotEmpty ? " (Pass mark 80%)" : ""}';
          } else {
            return 'প্রশ্ন $a / $b${rest.isNotEmpty ? " (পাস মার্ক ৮০%)" : ""}';
          }
        }
      ),
      (
        RegExp(r'^(\d+)(?:টি পাঠ| Lessons)$', caseSensitive: false),
        (Match m) {
          final n = m.group(1)!;
          return isEn ? '$n Lessons' : '$nটি পাঠ';
        }
      ),
      (
        RegExp(r'^(\d+)(?:টি ধাপ| Steps)$', caseSensitive: false),
        (Match m) {
          final n = m.group(1)!;
          return isEn ? '$n Steps' : '$nটি ধাপ';
        }
      ),
      (
        RegExp(r'^(\d+)টি হরফ রিভিশন প্রয়োজন$', caseSensitive: false),
        (Match m) {
          final n = m.group(1)!;
          return isEn ? '$n letters need review' : '$nটি হরফ রিভিশন প্রয়োজন';
        }
      ),
      (
        RegExp(r'^(?:ট্র্যাক|Track)\s+(\d+)\s+(?:সমাপনী উত্তীর্ণ!|Exam Passed!)$', caseSensitive: false),
        (Match m) {
          final n = m.group(1)!;
          return isEn ? 'Track $n Exam Passed!' : 'ট্র্যাক $n সমাপনী উত্তীর্ণ!';
        }
      ),
      (
        RegExp(r'^(?:সূরা নম্বর|Surah)\s+(\d+)\s*·\s*(?:আয়াত|Ayah)\s+(\d+)$', caseSensitive: false),
        (Match m) {
          final s = m.group(1)!;
          final a = m.group(2)!;
          return isEn ? 'Surah $s · Ayah $a' : 'সূরা নম্বর $s · আয়াত $a';
        }
      ),
      (
        RegExp(r'^(?:সূরা|Surah)\s+(.+)$', caseSensitive: false),
        (Match m) {
          final name = m.group(1)!;
          return isEn ? 'Surah $name' : 'সূরা $name';
        }
      ),
      (
        RegExp(r'^(?:আয়াত|Ayah)\s+(\d+)(.*)$', caseSensitive: false),
        (Match m) {
          final a = m.group(1)!;
          final rest = m.group(2) ?? '';
          if (isEn) {
            return 'Ayah $a$rest';
          } else {
            return 'আয়াত $a$rest';
          }
        }
      ),
      (
        RegExp(r'^\+(\d+)\s*XP$', caseSensitive: false),
        (Match m) {
          final n = m.group(1)!;
          return '+$n XP';
        }
      ),
      (
        RegExp(r'^(\d+)%\s*(?:প্রয়োজন|Required)$', caseSensitive: false),
        (Match m) {
          final n = m.group(1)!;
          return isEn ? '$n% Required' : '$n% প্রয়োজন';
        }
      ),
      (
        RegExp(r'^(?:স্টেপ|Step)\s+(\d+)\s+(?:বস পরীক্ষা|Boss Exam)$', caseSensitive: false),
        (Match m) {
          final n = m.group(1)!;
          return isEn ? 'Step $n Boss Exam' : 'স্টেপ $n বস পরীক্ষা';
        }
      ),
      (
        RegExp(r'^(?:সাপ্তাহিক মূল্যায়ন|Weekly Assessment)\s+(\d+)$', caseSensitive: false),
        (Match m) {
          final n = m.group(1)!;
          return isEn ? 'Weekly Assessment $n' : 'সাপ্তাহিক মূল্যায়ন $n';
        }
      ),
      (
        RegExp(r'^(?:মাসিক মেগা পরীক্ষা|Monthly Mega Exam)\s+(\d+)$', caseSensitive: false),
        (Match m) {
          final n = m.group(1)!;
          return isEn ? 'Monthly Mega Exam $n' : 'মাসিক মেগা পরীক্ষা $n';
        }
      ),
      (
        RegExp(r'^(?:বাগান পুরস্কার:\s*|Garden Reward:\s*)(.*)$', caseSensitive: false),
        (Match m) {
          final plant = m.group(1) ?? '';
          final translatedPlant = plant.isNotEmpty ? translate(plant.trim()) : '';
          return isEn ? 'Garden Reward: $translatedPlant' : 'বাগান পুরস্কার: $translatedPlant';
        }
      ),
      (
        RegExp(r'^(?:পড়ার অ্যালার্ম:\s*|Study Alarm:\s*)(.*)$', caseSensitive: false),
        (Match m) {
          final time = m.group(1) ?? '';
          return isEn ? 'Study Alarm: $time' : 'পড়ার অ্যালার্ম: $time';
        }
      ),
      (
        RegExp(r'^(\d+)/(\d+)\s*(?:ধাপ|Steps)$', caseSensitive: false),
        (Match m) {
          final a = m.group(1)!;
          final b = m.group(2)!;
          return isEn ? '$a/$b Steps' : '$a/$b ধাপ';
        }
      ),
      (
        RegExp(r'^(\d+)/(\d+)\s*(?:পাঠ|Lessons)$', caseSensitive: false),
        (Match m) {
          final a = m.group(1)!;
          final b = m.group(2)!;
          return isEn ? '$a/$b Lessons' : '$a/$b পাঠ';
        }
      ),
      (
        RegExp(r'^(\d+)/(\d+)\s*(?:পাঠ সম্পন্ন|Lessons Completed)$', caseSensitive: false),
        (Match m) {
          final a = m.group(1)!;
          final b = m.group(2)!;
          return isEn ? '$a/$b Lessons Completed' : '$a/$b পাঠ সম্পন্ন';
        }
      ),
      (
        RegExp(r'^(?:ধাপ|Step)\s+(\d+)\s*\((.*?)\)(?:\s*(?:লক করা রয়েছে।|is locked\.))?$', caseSensitive: false),
        (Match m) {
          final n = m.group(1)!;
          final inner = m.group(2) ?? '';
          final translatedInner = inner.isNotEmpty ? translate(inner.trim()) : '';
          final isLockedSuffix = m.group(0)!.contains('লক করা রয়েছে') || m.group(0)!.contains('is locked');
          if (isLockedSuffix) {
            return isEn ? 'Step $n ($translatedInner) is locked.' : 'ধাপ $n ($translatedInner) লক করা রয়েছে।';
          }
          return isEn ? 'Step $n ($translatedInner)' : 'ধাপ $n ($translatedInner)';
        }
      ),
      (
        RegExp(r'^(?:লকড|লক করা)\s*\((?:৮০% প্রয়োজন|৮০% প্রয়োজন|80% Required)\)$', caseSensitive: false),
        (Match m) {
          return isEn ? 'Locked (80% Required)' : 'লক করা (৮০% প্রয়োজন)';
        }
      ),
      (
        RegExp(r'^(?:স্টেপ বস পাস|Step Boss Passed)\s*\((?:৮০%\+|80%\+)\)(?:\s*✓)?$', caseSensitive: false),
        (Match m) {
          return isEn ? 'Step Boss Passed (80%+) ✓' : 'স্টেপ বস পাস (৮০%+) ✓';
        }
      ),
      (
        RegExp(r'^(?:স্টেপ বস পরীক্ষা দিন|Take Step Boss Exam)\s*\((?:৮০%\+|80%\+)\)$', caseSensitive: false),
        (Match m) {
          return isEn ? 'Take Step Boss Exam (80%+)' : 'স্টেপ বস পরীক্ষা দিন (৮০%+)';
        }
      ),
      (
        RegExp(r'^(?:মাস্টার্ড|Mastered)\s*\((?:সম্পন্ন|Completed)\)$', caseSensitive: false),
        (Match m) {
          return isEn ? 'Mastered (Completed)' : 'মাস্টার্ড (সম্পন্ন)';
        }
      ),
      (
        RegExp(r'^(\d+)\s*XP\s*(?:অর্জিত|Earned)$', caseSensitive: false),
        (Match m) {
          final n = m.group(1)!;
          return isEn ? '$n XP Earned' : '$n XP অর্জিত';
        }
      ),
      (
        RegExp(r'^(?:দক্ষতা ও নির্ভুলতা হার:\s*|Accuracy Rate:\s*)(.*)$', caseSensitive: false),
        (Match m) {
          final val = m.group(1) ?? '';
          return isEn ? 'Accuracy Rate: $val' : 'দক্ষতা ও নির্ভুলতা হার: $val';
        }
      ),
      (
        RegExp(r'^(?:শেখার স্ট্রিক\s*|Streak:\s*)(\d+)\s*(?:দিন|days)(.*)$', caseSensitive: false),
        (Match m) {
          final d = m.group(1)!;
          final rest = m.group(2) ?? '';
          return isEn ? 'Streak: $d days$rest' : 'শেখার স্ট্রিক $d দিন$rest';
        }
      ),
      (
        RegExp(r'^তুমি সফলভাবে পরীক্ষায় উত্তীর্ণ হয়েছ!\s*\(\+(\d+)\s*XP\)$', caseSensitive: false),
        (Match m) {
          final xp = m.group(1)!;
          return isEn ? 'You passed the exam successfully! (+$xp XP)' : 'তুমি সফলভাবে পরীক্ষায় উত্তীর্ণ হয়েছ! (+$xp XP)';
        }
      ),
      (
        RegExp(r'^(?:সংশোধন প্রয়োজন এমন পাঠ|Lessons needing correction)\s*\((.*?)\)$', caseSensitive: false),
        (Match m) {
          final count = m.group(1)!;
          return isEn ? 'Lessons needing correction ($count)' : 'সংশোধন প্রয়োজন এমন পাঠ ($count)';
        }
      ),
      (
        RegExp(r'^(?:তোমার সম্পন্ন করা পাঠসমূহ|Completed Lessons)\s*\((.*?)\)$', caseSensitive: false),
        (Match m) {
          final count = m.group(1)!;
          return isEn ? 'Completed Lessons ($count)' : 'তোমার সম্পন্ন করা পাঠসমূহ ($count)';
        }
      ),
      (
        RegExp(r'^(?:ভূমিকা:\s*অ্যাডমিন পর্যবেক্ষক|Role:\s*Admin Observer)$', caseSensitive: false),
        (Match m) => isEn ? 'Role: Admin Observer' : 'ভূমিকা: অ্যাডমিন পর্যবেক্ষক'
      ),
      (
        RegExp(r'^(?:বয়স:\s*)?(\d+)\s*(?:বছর\s*·\s*নূরানী ক্বায়দা শিক্ষার্থী|years\s*·\s*Nurani Qaida Student)$', caseSensitive: false),
        (Match m) {
          final age = m.group(1)!;
          return isEn ? 'Age: $age years · Nurani Qaida Student' : 'বয়স: $age বছর · নূরানী ক্বায়দা শিক্ষার্থী';
        }
      ),
      (
        RegExp(r'^(\d+)\s*/\s*(\d+)\s*(?:পাঠ|Lessons)\s*\((.*?)\)$', caseSensitive: false),
        (Match m) {
          final a = m.group(1)!;
          final b = m.group(2)!;
          final p = m.group(3)!;
          return isEn ? '$a / $b Lessons ($p)' : '$a / $b পাঠ ($p)';
        }
      ),
      (
        RegExp(r'^(\d+)টি দক্ষতার রিভিশন অপেক্ষমাণ$', caseSensitive: false),
        (Match m) {
          final n = m.group(1)!;
          return isEn ? '$n skills pending revision' : '$nটি দক্ষতার রিভিশন অপেক্ষমাণ';
        }
      ),
      (
        RegExp(r'^(?:নির্ভুলতা:\s*|Accuracy:\s*)(.*)$', caseSensitive: false),
        (Match m) {
          final val = m.group(1) ?? '';
          return isEn ? 'Accuracy: $val' : 'নির্ভুলতা: $val';
        }
      ),
      (
        RegExp(r'^(?:Letter\s+(.+)|(.+)\s+(?:হরফ|Letter))$', caseSensitive: false),
        (Match m) {
          final raw = m.group(1) ?? m.group(2)!;
          final name = translate(raw.trim());
          return isEn ? 'Letter $name' : '$name হরফ';
        }
      ),
      (
        RegExp(r'^(?:হরফ:\s*|Letter:\s*)(.*)$', caseSensitive: false),
        (Match m) {
          final rest = m.group(1)?.trim() ?? '';
          return isEn ? 'Letter: $rest' : 'হরফ: $rest';
        }
      ),
      (
        RegExp(r'^(?:ধাপ|Step)\s+(\d+)[/／](\d+)\s*·\s*(.*)$', caseSensitive: false),
        (Match m) {
          final a = m.group(1)!;
          final b = m.group(2)!;
          final title = m.group(3)?.trim() ?? '';
          final translatedTitle = title.isNotEmpty ? translate(title) : '';
          return isEn ? 'Step $a/$b · $translatedTitle' : 'ধাপ $a/$b · $translatedTitle';
        }
      ),
      (
        RegExp(r'^(?:শিক্ষক:\s*|Teacher:\s*)(.*)$', caseSensitive: false),
        (Match m) {
          final teacher = m.group(1)?.trim() ?? '';
          return isEn ? 'Teacher: $teacher' : 'শিক্ষক: $teacher';
        }
      ),
      (
        RegExp(r'^[“"”](.+?)[“"”]\s*অক্ষরটি শুনে বেছে নাও।?$', caseSensitive: false),
        (Match m) {
          final letter = translate(m.group(1)!);
          return isEn
              ? 'Listen for “$letter” and choose the letter.'
              : '“$letter” অক্ষরটি শুনে বেছে নাও।';
        }
      ),
      (
        RegExp(r'^Listen for [“"”](.+?)[“"”]\s+and choose the letter\.?$', caseSensitive: false),
        (Match m) {
          final letter = translate(m.group(1)!);
          return isEn
              ? 'Listen for “$letter” and choose the letter.'
              : '“$letter” অক্ষরটি শুনে বেছে নাও।';
        }
      ),
      (
        RegExp(r'^কোন বিন্দুর টুকরোটি [“"”](.+?)[“"”]\s*হরফে বসবে\??$', caseSensitive: false),
        (Match m) {
          final letter = translate(m.group(1)!);
          return isEn
              ? 'Which dot piece belongs on the letter “$letter”?'
              : 'কোন বিন্দুর টুকরোটি “$letter” হরফে বসবে?';
        }
      ),
      (
        RegExp(r'^Which dot piece belongs on the letter [“"”](.+?)[“"”]\??$', caseSensitive: false),
        (Match m) {
          final letter = translate(m.group(1)!);
          return isEn
              ? 'Which dot piece belongs on the letter “$letter”?'
              : 'কোন বিন্দুর টুকরোটি “$letter” হরফে বসবে?';
        }
      ),
      (
        RegExp(r'^[“"”](.+?)[“"”]\s*অক্ষরটি কোনটি\??$', caseSensitive: false),
        (Match m) {
          final letter = translate(m.group(1)!);
          return isEn
              ? 'Which letter is “$letter”?'
              : '“$letter” অক্ষরটি কোনটি?';
        }
      ),
      (
        RegExp(r'^Which letter is [“"”](.+?)[“"”]\??$', caseSensitive: false),
        (Match m) {
          final letter = translate(m.group(1)!);
          return isEn
              ? 'Which letter is “$letter”?'
              : '“$letter” অক্ষরটি কোনটি?';
        }
      ),
      (
        RegExp(r'^(?:মাইক্রোফোনে আরবি নামটি বলো:\s*|Say the Arabic name into the microphone:\s*)(.*)$', caseSensitive: false),
        (Match m) {
          final name = m.group(1)?.trim() ?? '';
          return isEn ? 'Say the Arabic name into the microphone: $name' : 'মাইক্রোফোনে আরবি নামটি বলো: $name';
        }
      ),
    ];

    for (final (regex, handler) in commonTemplates) {
      final match = regex.firstMatch(value.trim());
      if (match != null) {
        return handler(match);
      }
    }

    // Dynamic ARB template matcher {placeholder}
    return null;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode == 'bn' || locale.languageCode == 'en';

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final isEn = locale.languageCode == 'en';

    // Load both ARB files concurrently to build a 100% bidirectional dictionary
    final rawFiles = await Future.wait([
      rootBundle.loadString('assets/l10n/app_bn.arb'),
      rootBundle.loadString('assets/l10n/app_en.arb'),
    ]);

    final decodedBn = jsonDecode(rawFiles[0]) as Map<String, dynamic>;
    final decodedEn = jsonDecode(rawFiles[1]) as Map<String, dynamic>;

    final translations = <String, String>{};

    void addMapping(String? source, String target) {
      if (source == null) return;
      final trimmedSource = source.trim();
      if (trimmedSource.isEmpty) return;
      translations[source] = target;
      if (trimmedSource != source) {
        translations[trimmedSource] = target;
      }
    }

    // 1. Process all ARB keys and values bidirectionally
    final allKeys = <String>{
      ...decodedBn.keys.where((k) => !k.startsWith('@')),
      ...decodedEn.keys.where((k) => !k.startsWith('@')),
    };

    for (final k in allKeys) {
      final valBn = decodedBn[k] as String?;
      final valEn = decodedEn[k] as String?;

      final metaBn = decodedBn['@$k'];
      final metaEn = decodedEn['@$k'];

      final descBn = (metaBn is Map) ? metaBn['description'] as String? : null;
      final descEn = (metaEn is Map) ? metaEn['description'] as String? : null;

      final target = isEn
          ? (valEn ?? descEn ?? valBn ?? k)
          : (valBn ?? descBn ?? valEn ?? k);

      addMapping(k, target);
      addMapping(valBn, target);
      addMapping(valEn, target);
      addMapping(descBn, target);
      addMapping(descEn, target);
    }

    // 2. Inject comprehensive built-in bilingual dictionary for complete UI coverage
    for (final entry in _coreBilingualPairs.entries) {
      final bnText = entry.key;
      final enText = entry.value;
      final target = isEn ? enText : bnText;

      addMapping(bnText, target);
      addMapping(enText, target);
    }

    return AppLocalizations(Locale(isEn ? 'en' : 'bn'), translations);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => true;

  static const Map<String, String> _coreBilingualPairs = {
    // Modules & Card Titles
    'ক্বায়দা': 'Qaida',
    'বর্ণমালা': 'Alphabet',
    'কুরআন': 'Quran',
    'তিলাওয়াত': 'Recitation',
    'নামাজ': 'Prayer',
    'সময় + নিয়ম': 'Times & Guide',
    'দোয়া': 'Dua',
    'মাসনুন': 'Masnoon',
    'সীরাত': 'Seerah',
    'নবীর গল্প': "Prophet's Stories",
    'মৌলিক ইসলাম': 'Basic Islam',
    'গল্পে গল্পে শিখি': 'Learn with Stories',
    'অর্জন': 'Achievements',
    'ব্যাজ · লেভেল': 'Badges & Levels',

    // Bottom Navigation
    'শেখার পথ': 'Learning Path',
    'আমার পড়া': 'My Learning',
    'মিশন': 'Missions',

    // Dashboard & Home Screen
    'আমার পড়ার ড্যাশবোর্ড': 'My Learning Dashboard',
    'আজকের পাঠ ও অগ্রগতি': "Today's Lessons & Progress",
    'চালিয়ে যাও': 'Continue',
    'রোডম্যাপ': 'Roadmap',
    'রিভিশন': 'Revision',
    'পড়ি ›': 'Read ›',
    'পড়া শুরু করি': 'Start Reading',
    'বুকমার্ক সরাও': 'Remove Bookmark',
    'মুছে ফেলো': 'Delete',
    'সূরা খুঁজে দেখো': 'Search Surah',
    'সূরা আল-ফাতিহা (১ম আয়াত)': 'Surah Al-Fatihah (1st Ayah)',
    'উচ্চারণ ও অর্থসহ সুন্দর তিলাওয়াত': 'Beautiful recitation with pronunciation & meaning',
    'আযান শুনুন': 'Play Adhan',
    'আযান থামান': 'Stop Adhan',
    'পড়ার অ্যালার্ম শুনুন': 'Play Study Alarm',
    'অ্যালার্ম থামান': 'Stop Alarm',
    'ভুল সংশোধন': 'Mistake Review',
    'পুনরায় অনুশীলন': 'Practice Again',
    'ভুল সংশোধন করি': 'Fix Mistakes',
    'পুনরায় অনুশীলন করি': 'Practice Again',
    'কিছু দক্ষতায় আরো মনোযোগ দরকার। ভুল সংশোধন করে এগিয়ে যাও!': 'Some skills need more focus. Fix mistakes to advance!',
    'কিছু পুরনো পাঠ পুনরায় অনুশীলন করার সময় হয়েছে।': "It's time to review some previous lessons.",
    'লাইভ ক্লাসের সময়সূচি': 'Live Class Schedule',
    'টিচারের সাথে পড়ুন': 'Learn with a Teacher',
    'অভিজ্ঞ শিক্ষকের সাথে সরাসরি তাজবিদ ও সহীহ তিলাওয়াত শিখুন': 'Learn Tajweed and authentic recitation directly with qualified teachers',
    'কুরআন বলছে': 'The Quran Says',

    // Admin & Learning Modes
    'অ্যাডমিন মোড: সব লেভেল ও ধাপ আনলক': 'Admin Mode: All levels & steps unlocked',
    'অ্যাডমিন মোড (সব আনলক দিয়ে শুরু)': 'Admin Mode (Start with all unlocked)',
    'শিক্ষার্থী মোডে ফিরুন': 'Return to Student Mode',
    'অ্যাডমিন মোড (সব আনলক)': 'Admin Mode (All Unlocked)',
    'মূল শিক্ষার্থী মোড': 'Main Student Mode',
    'সব লেসন, ক্বায়দা, কুইজ ও ধাপ ১০০% আনলক আছে': 'All lessons, Qaida, quizzes & steps are 100% unlocked',
    'স্বাভাবিক নিয়মে ক্রমান্বয়ে লেসন আনলক হবে': 'Lessons will unlock progressively through regular practice',
    'মূল শিক্ষার্থী মোডে যান': 'Switch to Student Mode',
    'অ্যাডমিন মোডে যান (সব আনলক)': 'Switch to Admin Mode (Unlock All)',
    'অ্যাডমিন মোড চালু: সব ধাপ আনলক!': 'Admin mode enabled: All steps unlocked!',
    'শিক্ষার্থী মোড চালু: স্বাভাবিক লক নিয়ম সক্রিয়!': 'Student mode enabled: Normal lock rules active!',
    'এডমিন মোড সক্রিয়': 'Admin Mode Active',
    'শিক্ষার্থী মোড (ধাপে ধাপে আনলক)': 'Student Mode (Step-by-step unlock)',
    '১৭টি স্টেপ ও সকল পাঠ উন্মুক্ত রয়েছে': 'All 17 steps and lessons are unlocked',
    'পরীক্ষা করতে অ্যাডমিন মোড চালু করুন': 'Enable admin mode for testing',

    // Revision, Exams & Boss Challenges
    'রিভিশন আইল্যান্ড': 'Revision Island',
    'দুর্বল হরফ অনুশীলন': 'Practice Weak Letters',
    'অগ্রগতি প্রতিবেদন': 'Progress Report',
    'মাস্টারি ও পারফরম্যান্স': 'Mastery & Performance',
    'সাপ্তাহিক পরীক্ষা': 'Weekly Exam',
    '৮০% পাসে +২৫ XP': 'Pass 80% for +25 XP',
    'মাসিক পরীক্ষা': 'Monthly Exam',
    'মেগা রিভিউ +৪০ XP': 'Mega Review +40 XP',
    'মেগা রিভিউ': 'Mega Review',
    'বস চ্যালেঞ্জ (ধাপের চূড়ান্ত পরীক্ষা)': 'Boss Challenge (Step Final Exam)',
    'বস চ্যালেঞ্জ': 'Boss Challenge',
    'চূড়ান্ত পরীক্ষা': 'Final Exam',
    '“আবার চেষ্টা ব্যাজ” অর্জিত হয়েছে!': '“Try Again Badge” earned!',
    'মাশাআল্লাহ! সব জোড়া মিলে গেছে!': 'MashaAllah! All pairs matched!',
    '৮০% মার্কস পেলে পরবর্তী ধাপ উন্মুক্ত হবে • নেগেটিভ মার্কিং নেই': 'Score 80% to unlock next step • No negative marking',
    '৮০% প্রয়োজন': '80% Required',
    'উত্তীর্ণ ✓': 'Passed ✓',
    'অভিনন্দন! তুমি উত্তীর্ণ হয়েছ!': 'Congratulations! You passed!',
    'আবার চেষ্টা করার সুযোগ আছে': 'Opportunity to try again',
    'তুমি সফলভাবে পরীক্ষায় উত্তীর্ণ হয়েছ!': 'You have successfully passed the exam!',
    'মন খারাপের কিছু নেই! চলো ভুলগুলো রিভিশন দ্বীপে আবার শিখি।': "Don't worry! Let's practice mistakes in Revision Island.",
    'পরবর্তী ধাপের জন্য প্রস্তুতি': 'Prepare for Next Step',
    'পরবর্তী পাঠ': 'Next Lesson',
    'আবার চেষ্টা করো': 'Try Again',
    'ঠিক আছে': 'OK',
    'বুঝেছি': 'Got it',
    'সীরাতের গল্পে যাই': 'Go to Seerah Stories',

    // Onboarding
    'আসসালামু আলাইকুম! চলো শুরু করি': 'Assalamu Alaikum! Let’s get started',
    'এখন থেকে প্রতিদিন একটু একটু করে\nকুরআন ও ইসলাম শিখবে মজার সাথে': 'Learn Quran and Islam step by step every day with fun',
    'তোমার নাম কী?': 'What is your name?',
    'তোমার বয়স কত?': 'How old are you?',
    'বছর': 'years',
    'শুরু করি': 'Get Started',
    'পরবর্তী': 'Next',
    'ফিরে যাই': 'Go Back',
    'কে ব্যবহার করবে? প্রোফাইল বেছে নাও': 'Who is learning? Choose profile',
    'অবতার ও প্রিয় রঙ বেছে নাও': 'Choose avatar & favorite color',
    'যেমন: আয়েশা, ইউসুফ, ফাতিমা...': 'e.g. Ayesha, Yusuf, Fatima...',
    'তোমার নাম লিখো প্লিজ': 'Please enter your name',

    // Settings Screen
    'সেটিংস': 'Settings',
    'শেখার অভিজ্ঞতা নিজের মতো সাজাও': 'Make your learning experience your own',
    'প্রোফাইল ও অ্যাকাউন্ট': 'Profile & Account',
    'শিক্ষার্থীর প্রোফাইল': 'Student Profile',
    'অবতার ও রঙ নির্বাচন': 'Avatar & Color Selection',
    'হিজাব অবতার · রঙ পরিবর্তন করুন': 'Hijab Avatar · Change Color',
    'পড়ার অ্যালার্ম ও স্ট্রিক রিমাইন্ডার': 'Study Alarm & Streak Reminder',
    'দৈনিক পড়ার অ্যালার্ম (আউযুবিল্লাহ ও বিসমিল্লাহ)': 'Daily Study Alarm (A\'udhu & Bismillah)',
    'নির্ধারিত সময়ে আউযুবিল্লাহ ও বিসমিল্লাহ পড়ে পড়ার জন্য ডাকবে': 'Plays audio at scheduled time to remind you to study',
    'পড়ার অ্যালার্মের সময়': 'Study Alarm Time',
    'দৈনিক স্ট্রিক রিমাইন্ডার': 'Daily Streak Reminder',
    'স্ট্রিক ধরে রাখতে মনে করিয়ে দেবে': 'Reminds you to keep your study streak',
    'শিক্ষকের ক্লাসের আপডেট': 'Teacher Class Updates',
    'ক্লাস schedule ও reminder': 'Class schedule & reminder',
    'স্ট্রিক রিমাইন্ডারের সময়': 'Streak Reminder Time',
    'নির্ধারিত সময়ে আপনার ডিভাইসে দৈনিক পড়ার রিমাইন্ডার পৌঁছে যাবে।': 'Daily reminder will arrive on your device at set time.',
    'ইমেইল/ফোন login ও cloud sync এখনো backend-এ যুক্ত হয়নি।': 'Email/phone login and cloud sync are not connected to backend yet.',
    'যেখান থেকে শেষ করেছিলে, সেখান থেকেই পড়া চালিয়ে যাও!': 'Continue reading right from where you left off!',
    'চলমান কায়দা পাঠ': 'Current Qaida Lesson',
    'স্মার্ট রিভিশন': 'Smart Revision',
    'কিছু হরফে ভুল হয়েছিল, পুনরায় ঝালিয়ে নাও': 'Review the letters you made mistakes on',
    'পরবর্তী পড়ার আগে রিভিশন করে নাও': 'Review before the next lesson',
    'কিছু দক্ষতায় আরো মনোযোগ দরকার! ভুল সংশোধন করে এগিয়ে যাও!': 'Needs more practice on some skills! Fix mistakes and move ahead!',
    'কিছু দক্ষতায় আরো মনোযোগ দরকার। ভুল সংশোধন করে এগিয়ে যাও!': 'Needs more practice on some skills! Fix mistakes and move ahead!',
    'কিছু পুরনো পাঠ পুনরায় অনুশীলন করার সময় হয়েছে।': 'Time to practice some previous lessons.',
    'পুনরায় অনুশীলন': 'Practice Review',
    'পুনরায় অনুশীলন করি': 'Practice Again',
    'পবিত্র কুরআন তিলাওয়াত': 'Holy Quran Recitation',
    'সূরা আল-ফাতিহা থেকে শুরু করো': 'Start from Surah Al-Fatihah',
    'আযান ও পড়ার অ্যালার্ম': 'Adhan & Study Alarm',
    'সুমধুর আযান ও আউযুবিল্লাহ-বিসমিল্লাহ শুনুন': 'Listen to sweet Adhan & A\'udhu-Bismillah',
    'সব মডিউল': 'All Modules',
    'কুরআন, নামাজ, দোয়া ও ইসলামিক গল্প শিখি': 'Learn Quran, Prayer, Dua & Islamic Stories',
    'অবতার ও রঙ পরিবর্তন করুন': 'Change Avatar & Color',
    'আসসালামু আলাইকুম': 'Assalamu alaikum',
    'নিয়ম': 'Rules',
    'ভয়েস গাইড': 'Voice Guide',
    'নিয়ম জেনে অনুশীলন শুরু করি': 'Learn the rule and start practicing',
    'আরবি হরফমালার প্রথম হরফ। কোনো নুকতা নেই, সোজা লাঠির মতো।': 'The first letter of the Arabic alphabet. Has no dots, looks straight like a stick.',
    'বুঝেছি, অনুশীলন শুরু করি ➔': 'Got it, start practice ➔',
    'বুঝেছি, অনুশীলন করি ➔': 'Got it, start practice ➔',
    'এই নিয়মের হরফসমূহ': 'Letters for this rule',
    'জোড়া মিলাই': 'Match Pairs',
    'হরফ ও তার নামের জোড়া মিলাও:': 'Match the letter with its name:',
    'হরফ ও তার নামের জোড়া মেলাও:': 'Match the letter with its name:',
    'একই হরফের ভিন্ন রূপের জোড়া মিলাও:': 'Match different forms of the same letter:',
    'হরফের টুকরোগুলো জোড়া লাগিয়ে শব্দ তৈরি করো:': 'Connect letter pieces to form the word:',
    'হরকত ও তার শব্দের জোড়া মিলাও:': 'Match Harakat with its word:',
    'তানভীন ও তার সঠিক উচ্চারণের জোড়া মিলাও:': 'Match Tanween with its correct sound:',
    'খাড়া হরকত ও তার নামের জোড়া মেলাও:': 'Match Standing Harakat with its name:',
    'টুকরো জোড়া লাগিয়ে লীন শব্দ “بَيْتُ” তৈরি করো:': 'Connect pieces to form Leen word “بَيْتُ”:',
    'নূন সাকিনের উদাহরণ ও নিয়মের জোড়া মেলাও:': 'Match Nun Sakin rule with its example:',
    'টুকরো জোড়া লাগিয়ে ইখফার শব্দ “مِنْ قَبْلِ” তৈরি করো:': 'Connect pieces to form Ikhfa word “مِنْ قَبْلِ”:',
    'মীম সাকিনের বিধান ও উদাহরণের জোড়া মেলাও:': 'Match Meem Sakin rule with its example:',
    'শব্দ ও তার মাদ্দের পরিমাণের জোড়া মেলাও:': 'Match word with its Madd duration:',
    'শব্দ ও তার লামের নিয়মের জোড়া মেলাও:': 'Match word with its Lam rule:',
    'শব্দ ও তার মোটা/পাতলা নিয়মের জোড়া মেলাও:': 'Match word with its Heavy/Light rule:',
    'মুক্বাত্তায়াত ও ক্বলক্বলাহর হরফ ও শব্দের জোড়া মেলাও:': 'Match Muqatta\'at & Qalqalah letters:',
    'বাক্যের টুকরোগুলো জোড়া লাগিয়ে আয়াতটি সম্পূর্ণ করো:': 'Connect sentence pieces to complete the Ayah:',
    'যাচাই করুন': 'Verify',
    'মাশাআল্লাহ! সব জোড়া মিলে গেছে!': 'MashaAllah! All pairs matched!',
    'নিচ থেকে টেনে বা ট্যাপ করে বসাও:': 'Drag or tap from below to place:',
    'হরফগুলো টেনে নিচের ঘরে রাখো (অথবা ট্যাপ করো):': 'Drag letters into boxes below (or tap):',
    'এখানে ড্র্যাগ করো অথবা ট্যাপ করো': 'Drag here or tap',
    'মিলছে না, আবার ভাবো!': 'Not matching, think again!',
    'নীরব মোড সক্রিয়': 'Silent mode active',
    'নীরব মোড বন্ধ': 'Silent mode off',
    'আদর্শ উদাহরণ শব্দসমূহ:': 'Standard Example Words:',
    'মূল নিয়ম ও কানুন:': 'Core Rules:',
    'মাদ্দ স্ট্রেচ কন্ট্রোলার: টেনে আওয়াজ লম্বা করো': 'Madd Stretch Controller: Drag to elongate sound',
    'স্লাইড বা ট্যাপ করে সঠিক হরকত বেছে নাও:': 'Slide or tap to choose the correct Harakat:',
    'আলিফ': 'Alif',
    'বা': 'Ba',
    'তা': 'Ta',
    'ছা': 'Tha',
    'জীম': 'Jeem',
    'হা': 'Haa',
    'খা': 'Khaa',
    'দাল': 'Dal',
    'যাল': 'Dhal',
    'রা': 'Raa',
    'যা': 'Zay',
    'সীন': 'Seen',
    'শীন': 'Sheen',
    'সোয়াদ': 'Saad',
    'দোয়াদ': 'Daad',
    'তোয়া': 'Taa',
    'যোয়া': 'Dhaa',
    'আইন': 'Ayn',
    'গাইন': 'Ghayn',
    'ফা': 'Faa',
    'ক্বাফ': 'Qaaf',
    'কাফ': 'Kaaf',
    'লাম': 'Laam',
    'মীম': 'Meem',
    'নূন': 'Noon',
    'ওয়াও': 'Waw',
    'হা-গোল': 'Haa',
    'হামযাহ': 'Hamzah',
    'ইয়া': 'Yaa',
    'টুপি অবতার · রঙ পরিবর্তন করুন': 'Topi Avatar · Change Color',
    'অ্যাপের ভাষা': 'App language',
    'এই ডিভাইসে সংরক্ষিত': 'saved on this device',
    'শিক্ষক': 'Teacher',
    'শিক্ষক:': 'Teacher:',
    'বাংলা': 'Bangla',
    'English': 'English',
    'নামাজের আযান অ্যালার্ট': 'Prayer Adhan Alerts',
    'নামাজের সময় আযান বাজবে': 'Play Adhan at prayer times',
    'ওয়াক্ত হলে সুমধুর আযানের অ্যালার্ট ও নোটিফিকেশন আসবে': 'Receive sweet Adhan alerts and notifications at prayer times',
    'ওয়াক্ত অনুযায়ী আযান নির্বাচন:': 'Select Adhan by prayer:',
    'দৈনিক পড়ার রিমাইন্ডার': 'Daily Study Reminder',
    'প্রতিদিন নির্দিষ্ট সময়ে পড়ার নোটিফিকেশন': 'Receive daily notification to study at set time',
    'শব্দ ও অডিও ইফেক্ট': 'Sound & Audio Effects',
    'সাউন্ড ইফেক্ট চালু রাখুন': 'Keep sound effects enabled',
    'সঠিক/ভুল উত্তরের মিষ্টি সাউন্ড': 'Pleasant sound on correct/wrong answers',
    'পড়ার গতি ও ফন্ট': 'Reading Speed & Font',
    'অডিওর সাথে পড়ার গতি': 'Audio playback speed',
    'ধীরগতিতে স্পষ্ট উচ্চারণ (ছোটদের জন্য উপযুক্ত)': 'Slow & clear pronunciation (ideal for children)',
    'কুরআন পড়ার ফন্ট সাইজ': 'Quran reading font size',
    'অভিভাবকীয় নিয়ন্ত্রণ ও রিসেট': 'Parental Controls & Reset',
    'সব শেখার অগ্রগতি রিসেট করুন': 'Reset All Learning Progress',
    'সব পাঠ, পয়েন্ট ও ব্যাজ মুছে নতুন করে শুরু হবে': 'Erase all lessons, points & badges to restart',
    'সাপোর্ট ও যোগাযোগ': 'Support & Contact',
    'মতামত বা পরামর্শ পাঠান': 'Send feedback or suggestions',
    'অ্যাপ সংস্করণ': 'App Version',
    'পেমেন্ট পদ্ধতি': 'Payment Methods',
    'মোবাইল ওয়ালেট': 'Mobile Wallet',
    'বিকাশ / নগদ সংযোগ বাকি': 'bKash / Nagad setup pending',
    'কার্ড বা অনলাইন পেমেন্ট': 'Card or Online Payment',
    'Payment gateway সংযোগ বাকি': 'Payment gateway setup pending',
    'পেমেন্ট সেটআপের অবস্থা': 'Payment Setup Status',
    'প্রাইভেসি ও ডেটা নিয়ন্ত্রণ': 'Privacy & Data Control',
    'শিশু প্রাইভেসি নীতি': 'Children Privacy Policy',
    'LittleMuslim কোনো ব্যক্তিগত তথ্য সংগ্রহ বা ট্র্যাক করে না': 'LittleMuslim does not collect or track any personal data',
    'ডিভাইসে সংরক্ষিত সব শিক্ষা ও স্কোর মুছে ফেলা হবে': 'All learning and score data saved on device will be erased',
    'আপনার অর্জিত XP, স্ট্রিক, পড়া পাঠের অগ্রগতি এবং সংরক্ষণ করা বুকমার্ক সব মুছে যাবে।': 'Your earned XP, streak, lesson progress, and saved bookmarks will be deleted.',
    'অনবোর্ডিং আবার দেখুন / রিসেট করুন': 'Review Onboarding / Reset',
    'শিক্ষার্থীর তথ্য': 'Student Information',
    'নাম': 'Name',
    'বয়স': 'Age',
    'প্রোফাইল সংরক্ষণ করুন': 'Save Profile',

    // Quran Screen
    'আল-কুরআনুল কারীম': 'The Holy Quran',
    'কুরআনের সাথে সময় কাটাই': 'Spend Time with the Quran',
    'শান্ত মনে পড়ো, ভাবো, আর সুন্দর গল্প শোনো।': 'Read with peace, reflect, and listen to beautiful stories.',
    'পড়া চালিয়ে যাও': 'Continue Reading',
    'শুরু থেকে পড়ি': 'Read from the Beginning',
    'ইন্টারনেট সংযোগ দেখে আবার চেষ্টা করো': 'Check internet connection and try again',
    'সূরার তালিকা লোড হলে পড়া শুরু হবে।': 'Reading will begin once surah list loads.',
    'এখন কোনো সূরা পাওয়া যায়নি।': 'No surahs found.',
    'এখনো কোনো বুকমার্ক নেই': 'No bookmarks saved yet',
    'কুরআন পড়ার সময় যেকোনো আয়াতের পাশে বুকমার্ক আইকনে চাপ দিলে এখানে সহজে খুঁজে পাবে।': 'Tap bookmark icon beside any ayah to find it here easily.',
    'পাঠ মোড': 'Reading Mode',
    'ছোট লেখা': 'Smaller text',
    'বড় লেখা': 'Larger text',
    'তিলাওয়াত চলছে...': 'Playing recitation...',
    'আয়াতের অডিও চালু হয়নি। ইন্টারনেট সংযোগ দেখে আবার চেষ্টা করো।': 'Ayah audio failed to play. Check connection and retry.',

    // Duas Screen
    'দৈনন্দিন দোয়া ও মোনাজাত': 'Daily Duas & Supplications',
    'মাসনুন দোয়া': 'Masnoon Duas',
    'ছোট ছোট দোয়া, প্রতিদিন': 'Short daily duas for everyday life',
    'আজকের ছোট্ট অভ্যাস': "Today's Little Habit",
    'দোয়া মুখস্থ করি': 'Memorize Dua',
    'অর্থ:': 'Meaning:',
    'উচ্চারণ:': 'Pronunciation:',
    'কাউন্টার রিসেট করি': 'Reset Counter',
    'দোয়াটি অনুশীলন করি': 'Practice Dua',
    'কপি করো': 'Copy',
    'দোয়াটি কপি হয়েছে।': 'Dua copied to clipboard.',
    'এই ডিভাইসে আরবি অডিও পাওয়া যায়নি।': 'Arabic audio not available on this device.',

    // Prayer Screen
    'নামাজ শিখি': 'Learn Prayer',
    'সময় জেনে নাও, ধাপে ধাপে শিখে নাও।': 'Check prayer times and learn step by step.',
    'নামাজের সময়': 'Prayer Times',
    'একটি জায়গা বেছে নাও': 'Choose a Location',
    'ডিভাইসের লোকেশন ব্যবহার করো': 'Use Device Location',
    'শহরের নাম লেখো': 'Enter City Name',
    'নামাজের ধাপ': 'Steps of Prayer',
    'ওজু থেকে সালাম পর্যন্ত শিখি': 'Learn from Wudu to Salam',
    'শিক্ষামূলক অনুশীলন · নামাজের অঙ্গভঙ্গি শেখা': 'Educational Practice · Learning Prayer Postures',
    'ওয়াক্ত হলে ডিভাইসে আযানের অ্যালার্ট বাজবে। ঘণ্টা আইকন ট্যাপ করে ওয়াক্তের অ্যালার্ট অন/অফ করো।': 'Adhan alerts will play at prayer times. Tap bell icon to toggle alerts.',
    'আজকের ওয়াক্ত অনুযায়ী সঠিক সময়ে নামাজ আদায়ের জন্য মূল স্ক্রিনের সময়সূচি দেখো।': 'Check main screen schedule for today’s exact prayer times.',
    'আবার রিভিশন দিই': 'Review Again',
    'ফজর': 'Fajr',
    'যোহর': 'Dhuhr',
    'আসর': 'Asr',
    'মাগরিব': 'Maghrib',
    'ইশা': 'Isha',

    // Seerah Screen
    'প্রিয় নবীর জীবনী': 'Seerah of the Prophet',
    'নবীজির জীবন থেকে শিখি': "Learn from the Prophet's Life",
    'ছোট গল্প, বড় শিক্ষা': 'Short stories, great lessons',
    'গল্পের শিক্ষা পড়ি →': 'Read Lesson of Story →',
    'গল্পের শিক্ষা': 'Lesson of the Story',
    'গল্পটি পড়া শেষ হয়েছে! মাশাআল্লাহ।': 'Story completed! MashaAllah.',
    'এখানেই থাকি': 'Stay Here',
    'পরের গল্প পড়ুন': 'Read Next Story',
    'তালিকায় ফেরো': 'Return to List',
    'পড়া থেকে বিরতি নেবে?': 'Take a break from reading?',
    'চালিয়ে যাই': 'Continue Reading',
    'বিরতি নিই': 'Take a Break',
    'মাশাআল্লাহ!': 'MashaAllah!',

    // Islam Basics Screen
    'মৌলিক ইসলাম শিক্ষা': 'Basic Islamic Teachings',
    'গল্পে শিখি, কাজে লাগাই': 'Learn through stories, apply in life',
    'ঈমান ও বিশ্বাস': 'Iman & Faith',
    'সুন্দর চরিত্র': 'Good Character',
    'অধ্যায়টি শুরু থেকে আবার পড়ুন': 'Read chapter again from beginning',
    'কুইজের ফলাফল': 'Quiz Results',

    // Achievements & Missions
    'আমার অর্জন': 'My Achievements',
    'XP ও ব্যাজ সংগ্রহ দেখো': 'View XP and earned badges',
    'তোমার বর্তমান লেভেল': 'Your Current Level',
    'আজকের মিশন': 'Daily Missions',
    'প্রতিদিনের শেখার লক্ষ্য': 'Daily learning goals',
    'সম্পন্ন': 'Completed',
    'চলমান': 'In Progress',
    'একটি ক্বায়দা পাঠ': 'One Qaida Lesson',
    'শেষ করলে +১০ XP': 'Complete for +10 XP',

    // 17 Nurani Steps
    'মুফরাদাত': 'Mufradat',
    'মুরাক্কাবাত': 'Murakkabat',
    'হরকত': 'Harakat',
    'তানভীন': 'Tanween',
    'খাড়া হরকত': 'Khari Harakat',
    'হরফে লীন': 'Layyin',
    'জযম / সাকিন': 'Sukoon',
    'তাশদীদ': 'Shaddah',
    'নূন সাকিন ও তানভীন': 'Noon Sakin',
    'মীম সাকিন': 'Meem Sakin',
    'ওয়াজিব গুন্নাহ': 'Ghunnah',
    'মাদ্দের নিয়ম': 'Madd',
    'লামের নিয়ম': 'Lam Rules',
    'র ও লামের পুর-বারিক': 'Ra and Lam',
    'মুক্বাত্তায়াত ও কলক্বলাহ': 'Muqattaat & Qalqalah',
    'ওয়াক্বফ (থামার নিয়ম)': 'Waqf',
    'পূর্ণাঙ্গ তিলাওয়াত': 'Tilawat',

    // Garden Plants
    'Date Palm (খেজুর গাছ)': 'Date Palm Tree',
    'Olive Tree (যাইতুন গাছ)': 'Olive Tree',
    'Jasmine Flower (জুঁই ফুল)': 'Jasmine Flower',
    'Rose (গোলাপ ফুল)': 'Rose Flower',
    'Tulip Flower (টিউলিপ ফুল)': 'Tulip Flower',
    'Pomegranate (ডালিম গাছ)': 'Pomegranate Tree',
    'Fig Tree (ডুমুর গাছ)': 'Fig Tree',
    'Citrus Tree (লেবু গাছ)': 'Citrus Tree',
    'Golden Lantern (সোনালী লণ্ঠন)': 'Golden Lantern',
    'Silver Lantern (রুপালী লণ্ঠন)': 'Silver Lantern',
    'Emerald Fountain (মরকত ফোয়ারা)': 'Emerald Fountain',
    'Crystal Pavillion (স্ফটিক চত্বর)': 'Crystal Pavilion',
    'Sun & Moon Arch (সূর্য-চন্দ্র তোরণ)': 'Sun & Moon Arch',
    'Cedar Tree (সুরভিত বৃক্ষ)': 'Cedar Tree',
    'Echoing Spring (প্রতিধ্বনিময় ঝর্ণা)': 'Echoing Spring',
    'Resting Bower (বিশ্রাম কুটির)': 'Resting Bower',
    'Eternal Paradise Garden (জান্নাতের বাগান)': 'Eternal Paradise Garden',

    // Home, Qaida & Actions
    'কায়দা পড়া চালিয়ে যাই': 'Continue Qaida Study',
    'পড়া চালিয়ে যাই': 'Continue Studying',
    '১৭টি ধাপের মানচিত্র': '17 Steps Roadmap',
    '১৭টি স্টেপ': '17 Steps',
    'পড়ার রিপোর্ট (হিটম্যাপ)': 'Study Report (Heatmap)',
    'নামাজের সময়সূচি ›': 'Prayer Times ›',
    'শিক্ষক সহায়তা': 'Teacher Support',
    'লক মোড': 'Lock Mode',
    'সব আনলক': 'Unlock All',
    'নূরানী ক্বায়দা · ১৭টি ধাপের পাঠ্যক্রম': 'Nurani Qaida · 17-Step Curriculum',
    'হরফ চেনা → সংযোগ → হারাকাত/তানবীন → সুকুন/শাদ্দাহ → তাজবীদ → ওয়াকফ ও তিলাওয়াত': 'Letters → Joining → Harakat/Tanween → Sukoon/Shaddah → Tajweed → Waqf & Recitation',
    'পরীক্ষা থেকে বের হবেন?': 'Exit Exam?',
    'এখন বের হলে এই পরীক্ষার অগ্রগতি সংরক্ষিত হবে না।': 'If you exit now, progress in this exam will not be saved.',
    'একটু আরও অনুশীলন করি!': 'Let’s practice a bit more!',
    'শিক্ষকের সাথে কুরআন ও ইসলাম শিখি': 'Learn Quran & Islam with a Teacher',
    'মাসিক পরিকল্পনায় সরাসরি live class': 'Live classes with monthly plans',
    'ক্লাস ও পরিকল্পনা দেখো  ›': 'View Classes & Plans  ›',
    'স্মার্ট রিভিশন ও সংশোধন': 'Smart Revision & Correction',
    'স্মরণ করি ও ভুল শোধরাই': 'Remember & Correct Mistakes',
    'ভুলগুলো বারবার চর্চা করলে তিলাওয়াত খাঁটি হয়': 'Repeated practice makes recitation pure',
    'সংশোধন প্রয়োজন এমন পাঠ': 'Lessons needing correction',
    'তোমার সম্পন্ন করা পাঠসমূহ': 'Your completed lessons',
    'দক্ষতা ও নির্ভুলতা হার:': 'Skill & Accuracy Rate:',
    'তোমার শেখার অগ্রগতি সেভ থাকবে। পরে এখান থেকেই শুরু করতে পারবে।': 'Your learning progress is saved. You can resume anytime.',
    'বের হই': 'Exit',
    'সহজ করে জানি': 'Learn Easily',
    'একটি দোয়া শেখো ও জীবনে প্রয়োগ করো': 'Learn a dua and apply in life',
    'এখনো কোনো পছন্দের দোয়া নেই।': 'No favorite duas yet.',
    'নামাজ শেখা থেকে বের হবে?': 'Exit prayer practice?',
    'পড়তে থাকি': 'Keep Reading',
    'গল্পগুলো সংক্ষেপে লেখা। সূত্রের বিস্তারিত জানতে বড়দের সাহায্য নাও': 'Stories are summarized. Ask elders for source details.',
    'গল্পটি পড়া শেষ হয়েছে!': 'Story completed!',
    'পরের গল্প': 'Next Story',
    'আয়াতের অডিও চালু হয়নি। ইন্টারনেট সংযোগ পরীক্ষা করো।': 'Ayah audio not available. Check internet connection.',
    'রঙিন তাজবিদ: Quran.com · বাংলা অর্থ: মুজিবুর রহমান': 'Tajweed: Quran.com · Bengali: Mujibur Rahman',
    'এই সূরায় এখন কোনো আয়াত পাওয়া যায়নি।': 'No verses found in this Surah.',
    'কুরআনিক শিক্ষণীয় ঘটনাভিত্তিক বিশেষ শিশুতোষ উপস্থাপনা': 'Special child-friendly presentation of Quranic educational stories',
    'শিক্ষকের দেওয়া ক্লাসের তথ্য এখানে দেখবে। কোনো ক্লাস অ্যাসাইন না থাকলে অ্যাডমিন বা শিক্ষকের সাথে যোগাযোগ করো।': 'You will see teacher class info here. If none assigned, contact admin or teacher.',
    'আবার চেষ্টা': 'Try Again',
    'ক্লাসের সময়সূচি ও লিংক শিক্ষক/প্রতিষ্ঠান দ্বারা নির্ধারিত': 'Class schedule & link set by teacher/institution',
    'মিটিং লিংক খুলতে পারিনি। অভিভাবকের সাহায্য নিন অথবা লিংক কপি করুন।': 'Could not open meeting link. Ask parents or copy link.',
    'লিংক কপি': 'Copy Link',
    'নতুন account তৈরি করো': 'Create New Account',
    'অভিভাবকের email দিয়ে শিক্ষার্থীর profile নিরাপদে রাখুন': "Secure student profile with parent's email",
    'অভিভাবকের email': "Parent's Email",
    'ভাষা বেছে নাও': 'Choose Language',
    'অ্যাপের ভাষা নির্বাচন করো। পরে পরিবর্তন করা যাবে।': 'Select app language. Can be changed later.',
    'কুরআনের আরবি টেক্সট সবসময় আরবিতেই থাকবে': 'Quranic Arabic text will always remain in Arabic',
    'তুমি প্রস্তুত': 'You are Ready',
    'অ্যাডমিন মোড: সব ধাপ ও লেভেল আনলক থাকবে': 'Admin Mode: All steps and levels will be unlocked',
    'এখন থেকে প্রতিদিন একটু একটু করে\nকুরআন ও ইসলাম শিখবো মজার সাথে': 'From now on, learn Quran and Islam step by step every day with fun',
    'ব্যবহারকারীর ধরন': 'User Role',
    'বয়স নির্বাচন করো': 'Select Age',
    'পরবর্তী ধাপ ➔': 'Next Step ➔',
    'রিভিশন দ্বীপে অনুশীলন ➔': 'Practice in Revision Island ➔',
    'আবার পরীক্ষা দিন': 'Retake Exam',
    'চালিয়ে যান': 'Continue',
    'বের হন': 'Exit',
    'অ্যাডমিন আনলক': 'Admin Unlock',
    'স্মার্ট রিভিশন কিউ (এখন চর্চা আবশ্যক)': 'Smart Revision Queue (Practice Required Now)',
    'ভুল শোধরাই (Mistakes to Fix)': 'Fix Mistakes (Mistakes to Fix)',
    'প্রস্তাবিত রিভিশন পাঠ': 'Recommended Revision Lessons',
    'মাশাআল্লাহ! কোনো ভুল জমা নেই!': 'MashaAllah! No mistakes recorded!',
    'তুমি খুব সুন্দর ও মনোযোগ দিয়ে শিখছ। যখনই কোনো ভুল হবে, তা স্বয়ংক্রিয়ভাবে এখানে অনুশীলনের জন্য জমা হবে।': 'You are learning attentively. Whenever a mistake occurs, it will automatically appear here for practice.',
    'এখনো কোনো পাঠ সম্পন্ন হয়নি': 'No lessons completed yet',
    'ক্বায়দা রোডম্যাপ থেকে নতুন পাঠ সম্পন্ন করলেই তা এখানে রিভিশন করার সুবিধা পাবে।': 'Complete lessons from the roadmap to review them here.',
    'চর্চা': 'Practice',
    'পুনরাবৃত্তি': 'Review',
    'রিভিশন বাকি': 'Revision Due',
    'ভুল হয়েছে': 'Needs Correction',
    'আযান টেস্ট করুন / শুনুন': 'Test / Listen to Adhan',
    'পড়ার অ্যালার্ম থামান': 'Stop Study Alarm',
    'পড়ার অ্যালার্ম টেস্ট করুন (আউযুবিল্লাহ ও বিসমিল্লাহ)': 'Test Study Alarm (A’udhu & Bismillah)',
    'শিশু শিক্ষার্থী': 'Young Learner',
    'সব পাঠ তাজা রয়েছে': 'All lessons are fresh',
    'অনুশীলন': 'Practice',
    'ট্র্যাকভিত্তিক দক্ষতা বিবরণ': 'Track-based Skill Details',
    'অভিভাবকদের জন্য নির্দেশনা': 'Guidance for Parents',
    'অ্যাপের ফলাফল শিক্ষার্থীর পরিচিতি ও নিয়মিত অনুশীলনের অগ্রগতি নির্দেশ করে। বিশুদ্ধ মাখরাজ ও পরিপূর্ণ তাজবীদের জন্য অভিজ্ঞ শিক্ষকের সরাসরি তিলাওয়াত শ্রবণ ও যাচাই প্রশংসনীয়।': 'App results reflect regular learning progress. Live recitation listening by a qualified teacher is recommended for authentic Makhraj & Tajweed.',
    '২৮ হরফ মাখরাজ হিটম্যাপ (Weak Letter List)': '28 Letters Makhraj Heatmap (Weak Letter List)',
    'সবুজ = নিখুঁত • কমলা = অনুশীলন দরকার • লাল = দুর্বল হরফ': 'Green = Mastered • Orange = Needs Practice • Red = Weak Letter',
    'মাখরাজ (উচ্চারণস্থল)': 'Makhraj (Articulation Point)',
    'এখনো অনুশীলন শুরু হয়নি': 'Practice not started yet',
    '৩-স্তর বিশিষ্ট পরীক্ষা অডিট (৮০% পাস গেট)': '3-Tier Examination Audit (80% Pass Gate)',
    'স্টেপ বস পরীক্ষা': 'Step Boss Exam',
    'অভিভাবক চেক-ইন (Teach Back & Family Practice)': 'Parent Check-in (Teach Back & Family Practice)',
    'সন্তানের তিলাওয়াত সরাসরি শুনুন ও উৎসাহ দিন (+১৫ XP)': 'Listen to your child’s recitation directly & encourage (+15 XP)',
    'আজকের পাঠ বা দুর্বল হরফগুলো সন্তানকে আপনার সামনে জোরে উচ্চারণ করতে বলুন। এতে আত্মবিশ্বাস বাড়ে ও ভুল দ্রুত সংশোধন হয়।': 'Ask child to recite today’s lesson or weak letters aloud in front of you. This builds confidence and fixes errors.',
    'মাশাআল্লাহ! বাচ্চার সাথে অভিভাবকের তিলাওয়াত অনুশীলনের জন্য +১৫ XP যোগ হয়েছে!': 'MashaAllah! +15 XP added for practicing recitation with your child!',
    'আজকের তিলাওয়াত শোনা হয়েছে ✓': 'Today’s recitation verified ✓',
    'আজকের তিলাওয়াত শুনেছি (+১৫ XP)': 'Verified today’s recitation (+15 XP)',
    'স্টেপ বস পরীক্ষা, সাপ্তাহিক ও মাসিক মূল্যায়ন রেকর্ড': 'Step Boss exam, weekly & monthly assessment records',
    'মাখরাজ (উচ্চারণস্থল):': 'Makhraj (Articulation Point):',
    'অনুশীলন করুন': 'Practice Now',
  };
}

extension LocalizedBuildContext on BuildContext {
  String uiText(String source) =>
      AppLocalizations.of(this)?.translate(source) ?? source;
}

/// A drop-in Text widget that resolves its source text from the active locale.
class LocalizedText extends StatelessWidget {
  const LocalizedText(
    this.data, {
    super.key,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
  });

  final String data;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final TextScaler? textScaler;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;

  @override
  Widget build(BuildContext context) => Text(
        AppLocalizations.of(context)?.translate(data) ?? data,
        style: style,
        strutStyle: strutStyle,
        textAlign: textAlign,
        textDirection: textDirection,
        locale: locale,
        softWrap: softWrap,
        overflow: overflow,
        textScaler: textScaler,
        maxLines: maxLines,
        semanticsLabel: semanticsLabel,
        textWidthBasis: textWidthBasis,
        textHeightBehavior: textHeightBehavior,
        selectionColor: selectionColor,
      );
}
