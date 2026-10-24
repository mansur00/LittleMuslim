const fs = require('fs');
const path = require('path');

const ROOT = path.resolve(__dirname, '..');
const filePath = path.join(ROOT, 'lib', 'screens', 'basics', 'islam_basics_screen.dart');
let content = fs.readFileSync(filePath, 'utf8');

// Build the new clean _chapters declaration
const iconsAndColors = [
  { icon: 'Icons.auto_awesome_rounded', color: 'Color(0xFFDDF4E9)' },
  { icon: 'Icons.lightbulb_rounded', color: 'Color(0xFFE8E2FF)' },
  { icon: 'Icons.mosque_rounded', color: 'Color(0xFFFFF0CE)' },
  { icon: 'Icons.rule_rounded', color: 'Color(0xFFDDF1FF)' },
  { icon: 'Icons.checkroom_rounded', color: 'Color(0xFFFFE0EB)' },
  { icon: 'Icons.chat_bubble_rounded', color: 'Color(0xFFE5F9DB)' },
  { icon: 'Icons.favorite_rounded', color: 'Color(0xFFFFECE5)' },
  { icon: 'Icons.people_rounded', color: 'Color(0xFFEAE5FF)' },
  { icon: 'Icons.restaurant_rounded', color: 'Color(0xFFE0F7F4)' },
  { icon: 'Icons.no_food_rounded', color: 'Color(0xFFFFE8E8)' },
];

let newChaptersDart = `typedef _QuizItem = ({String questionKey, String answerKey});

class _Chapter {
  const _Chapter({
    required this.id,
    required this.titleKey,
    required this.definitionKey,
    required this.storyKey,
    required this.icon,
    required this.color,
    required this.quiz,
  });
  final int id;
  final String titleKey, definitionKey, storyKey;
  String get title => titleKey;
  String get definition => definitionKey;
  String get story => storyKey;
  final IconData icon;
  final Color color;
  final List<_QuizItem> quiz;
}

const _chapters = <_Chapter>[\n`;

for (let ch = 1; ch <= 10; ch++) {
  const meta = iconsAndColors[ch - 1];
  newChaptersDart += `  _Chapter(
    id: ${ch},
    titleKey: 'basics.chapter.${ch}.title',
    definitionKey: 'basics.chapter.${ch}.definition',
    storyKey: 'basics.chapter.${ch}.story',
    icon: ${meta.icon},
    color: ${meta.color},
    quiz: [\n`;
  for (let q = 1; q <= 10; q++) {
    newChaptersDart += `      (questionKey: 'basics.chapter.${ch}.quiz.${q}.q', answerKey: 'basics.chapter.${ch}.quiz.${q}.a'),\n`;
  }
  newChaptersDart += `    ],\n  ),\n`;
}
newChaptersDart += `];`;

// Replace from `typedef _QuizItem` to `];\n\nenum _Stage`
const startIdx = content.indexOf('typedef _QuizItem');
const endIdx = content.indexOf('enum _Stage');
content = content.substring(0, startIdx) + newChaptersDart + '\n\n' + content.substring(endIdx);

// Now replace all other UI strings in the remainder of the file
const replacements = [
  {
    target: "title: const LocalizedText('পড়া থেকে বিরতি নেবে?'),",
    replace: "title: Text(context.t('basics.pause.title')),"
  },
  {
    target: "content: const LocalizedText(\n            'তোমার শেখার অগ্রগতি সেভ থাকবে। পরে এখান থেকেই শুরু করতে পারবে।'),",
    replace: "content: Text(context.t('basics.pause.body')),"
  },
  {
    target: "child: const LocalizedText('চালিয়ে যাই'),",
    replace: "child: Text(context.t('basics.pause.continue')),"
  },
  {
    target: "child: const LocalizedText('বের হই'),",
    replace: "child: Text(context.t('basics.pause.exit')),"
  },
  {
    target: "_Stage.intro => 'পাঠ ১',",
    replace: "_Stage.intro => context.t('basics.stage.intro'),"
  },
  {
    target: "_Stage.story => 'গল্প',",
    replace: "_Stage.story => context.t('basics.stage.story'),"
  },
  {
    target: "_Stage.reflect => 'ভাবি ${_itemIndex + 1}/১০',",
    replace: "_Stage.reflect => context.t('basics.stage.reflect', params: {'current': '${_itemIndex + 1}'}),"
  },
  {
    target: "_Stage.quiz => 'কুইজ ${_itemIndex + 1}/১০',",
    replace: "_Stage.quiz => context.t('basics.stage.quiz', params: {'current': '${_itemIndex + 1}'}),"
  },
  {
    target: "_Stage.result => 'ফলাফল',",
    replace: "_Stage.result => context.t('basics.stage.result'),"
  },
  {
    target: "title: 'মৌলিক ইসলাম শিক্ষা',\n                    subtitle: 'গল্পে শিখি, কাজে লাগাই',",
    replace: "title: context.t('basics.header.title'),\n                    subtitle: context.t('basics.header.subtitle'),"
  },
  {
    target: "const LocalizedText('সহজ করে জানি',",
    replace: "Text(context.t('basics.intro.know_easily'),"
  },
  {
    target: "'পরের পাঠ: গল্প পড়ি', Icons.auto_stories_rounded, _nextStage),",
    replace: "context.t('basics.intro.next_story'), Icons.auto_stories_rounded, _nextStage),"
  },
  {
    target: "const LocalizedText('একটি ছোট্ট গল্প',",
    replace: "Text(context.t('basics.story.short_story'),"
  },
  {
    target: "'গল্প নিয়ে ভাবি', Icons.psychology_alt_rounded, _nextStage),",
    replace: "context.t('basics.story.think_story'), Icons.psychology_alt_rounded, _nextStage),"
  },
  {
    target: "title: 'গল্পটি নিয়ে একটু ভাবো',\n                subtitle: '১০টি ছোট প্রশ্ন—নিজের মনে উত্তর দাও।'),",
    replace: "title: context.t('basics.reflect.title'),\n                subtitle: context.t('basics.reflect.subtitle')),"
  },
  {
    target: "'নিজের ভাষায় উত্তর ভাবো। প্রস্তুত হলে পরের প্রশ্নে যাও।',",
    replace: "context.t('basics.reflect.hint'),"
  },
  {
    target: "_itemIndex == 9 ? 'এবার ১০টি কুইজ দিই' : 'পরের ভাবনার প্রশ্ন',",
    replace: "_itemIndex == 9 ? context.t('basics.reflect.take_quiz') : context.t('basics.reflect.next_question'),"
  },
  {
    target: "title: 'শেখাটা মনে আছে?',\n                subtitle: '১০টি কুইজ—সঠিক উত্তর বেছে নাও।'),",
    replace: "title: context.t('basics.quiz.title'),\n                subtitle: context.t('basics.quiz.subtitle')),"
  },
  {
    target: "LocalizedText('প্রশ্ন ${_itemIndex + 1} / ১০',",
    replace: "Text(context.t('basics.quiz.question_counter', params: {'current': '${_itemIndex + 1}', 'total': '10'}),"
  },
  {
    target: "? 'সঠিক উত্তর! মাশাআল্লাহ。'\n                      : 'উত্তরটি ভুল হয়েছে। সঠিক উত্তর: ${item.answer}',",
    replace: "? context.t('basics.quiz.correct_feedback')\n                      : context.t('basics.quiz.wrong_feedback', params: {'correct': context.t(item.answerKey)}),"
  },
  {
    target: "? 'সঠিক উত্তর! মাশাআল্লাহ।'\n                      : 'উত্তরটি ভুল হয়েছে। সঠিক উত্তর: ${item.answer}',",
    replace: "? context.t('basics.quiz.correct_feedback')\n                      : context.t('basics.quiz.wrong_feedback', params: {'correct': context.t(item.answerKey)}),"
  },
  {
    target: "? 'উত্তর মিলিয়ে দেখি'\n                      : (_itemIndex == 9 ? 'ফলাফল দেখি' : 'পরের প্রশ্ন'),",
    replace: "? context.t('basics.quiz.check_answer')\n                      : (_itemIndex == 9 ? context.t('basics.quiz.see_result') : context.t('basics.quiz.next_question')),"
  },
  {
    target: "label: const LocalizedText('প্রশ্নটি এড়িয়ে যাই'),",
    replace: "label: Text(context.t('basics.quiz.skip_question')),"
  },
  {
    target: "const LocalizedText('কুইজের ফলাফল',",
    replace: "Text(context.t('basics.result.title'),"
  },
  {
    target: "LocalizedText(\n                  perfect\n                      ? 'মাশাআল্লাহ! তুমি সব প্রশ্নের সঠিক উত্তর দিয়েছো!'\n                      : passed\n                          ? 'খুব ভালো! তুমি সফলভাবে অধ্যায়টি সম্পন্ন করেছ।'\n                          : 'তুমি চেষ্টা করেছো! অধ্যায়টি আবার পড়ে আরও ভালো করতে পারো।',",
    replace: "Text(\n                  perfect\n                      ? context.t('basics.result.perfect')\n                      : passed\n                          ? context.t('basics.result.good')\n                          : context.t('basics.result.retry_advice'),"
  },
  {
    target: "? '+২৫ XP অর্জিত হয়েছে!'\n                      : '+২৫ XP আগেই অর্জিত হয়েছে',",
    replace: "? context.t('basics.result.xp_earned')\n                      : context.t('basics.result.xp_already'),"
  },
  {
    target: "label: 'সঠিক',",
    replace: "label: context.t('basics.result.correct_label'),"
  },
  {
    target: "label: 'ভুল',",
    replace: "label: context.t('basics.result.wrong_label'),"
  },
  {
    target: "label: 'এড়ানো',",
    replace: "label: context.t('basics.result.skipped_label'),"
  },
  {
    target: "'কুইজ পুনরায় দিন (Retry)',",
    replace: "context.t('basics.result.retry_btn'),"
  },
  {
    target: "text: 'অধ্যায় তালিকায় ফিরুন',",
    replace: "text: context.t('basics.result.back_to_list'),"
  },
  {
    target: "label: const LocalizedText('অধ্যায়টি শুরু থেকে আবার পড়ুন'),",
    replace: "label: Text(context.t('basics.result.read_from_start')),"
  },
  {
    target: "LocalizedText('অধ্যায় ${index + 1}',",
    replace: "Text(context.t('basics.card.chapter_n', params: {'number': '${index + 1}'}),"
  },
  {
    target: "LocalizedText(chapter.title,",
    replace: "Text(context.t(chapter.titleKey),"
  },
  {
    target: "LocalizedText(\n              completed\n                  ? 'সম্পন্ন · কুইজ ${quizScore ?? 10}/১০ · চাইলে আবার পড়ো'\n                  : locked\n                      ? 'আগের অধ্যায় শেষ হলে খুলবে'\n                      : inProgress\n                          ? 'এখান থেকে আবার শুরু করো'\n                          : 'ছবি · গল্প · ১০ ভাবনা · ১০ কুইজ',",
    replace: "Text(\n              completed\n                  ? context.t('basics.card.completed_status', params: {'score': '${quizScore ?? 10}'})\n                  : locked\n                      ? context.t('basics.card.locked_status')\n                      : inProgress\n                          ? context.t('basics.card.resume_status')\n                          : context.t('basics.card.default_status'),"
  },
  {
    target: "LocalizedText(compact ? 'গল্পের কথা মনে রাখি' : 'দেখি · বুঝি · শিখি',",
    replace: "Text(compact ? context.t('basics.card.remember_story') : context.t('basics.card.see_understand_learn'),"
  },
  {
    target: "LocalizedText(chapter.title,\n              style: const TextStyle(\n                  fontSize: 22,",
    replace: "Text(context.t(chapter.titleKey),\n              style: const TextStyle(\n                  fontSize: 22,"
  },
  {
    target: "LocalizedText(chapter.definition,",
    replace: "Text(context.t(chapter.definitionKey),"
  },
  {
    target: "LocalizedText(chapter.story,",
    replace: "Text(context.t(chapter.storyKey),"
  },
  {
    target: "LocalizedText(prompt,",
    replace: "Text(prompt,"
  },
  {
    target: "LocalizedText(item.question,",
    replace: "Text(context.t(item.questionKey),"
  },
  {
    target: "LocalizedText(opt,",
    replace: "Text(opt,"
  }
];

// Replace the 10 reflection prompts list
const oldPromptsBlock = `    return const [
      'এই কথাটি তোমাকে কী ভাবায়?',
      'এটি মনে রাখলে তুমি কী ভালো কাজ করতে পারো?',
      'তোমার জীবনে এর একটি উদাহরণ কী?',
      'এটি কি তোমাকে কারও উপকার করতে শেখায়?',
      'এ বিষয়ে তোমার মনে আর কী প্রশ্ন আসে?',
      'কঠিন হলে কার কাছে সাহায্য চাইবে?',
      'আজ থেকেই কীভাবে এটি কাজে লাগাবে?',
      'তোমার পরিবারের সঙ্গে এ নিয়ে কী কথা বলবে?',
      'এটি ভুলে গেলে কীভাবে মনে করতে পারো?',
      'এই অধ্যায় থেকে সবচেয়ে জরুরি শিক্ষা কোনটি?'
    ];`;

const newPromptsBlock = `    return [
      context.t('basics.reflect.q1'),
      context.t('basics.reflect.q2'),
      context.t('basics.reflect.q3'),
      context.t('basics.reflect.q4'),
      context.t('basics.reflect.q5'),
      context.t('basics.reflect.q6'),
      context.t('basics.reflect.q7'),
      context.t('basics.reflect.q8'),
      context.t('basics.reflect.q9'),
      context.t('basics.reflect.q10'),
    ];`;

content = content.replace(oldPromptsBlock, newPromptsBlock);

for (const rep of replacements) {
  if (content.includes(rep.target)) {
    content = content.replace(rep.target, rep.replace);
  }
}

// In _buildQuizBody:
// final item = chapter.quiz[_itemIndex];
// final options = _buildOptions(chapter, item.answer); -> item.answerKey
content = content.replace(
  'final options = _buildOptions(chapter, item.answer);',
  'final options = _buildOptions(context, chapter, item.answerKey);'
);

// In _buildOptions:
// List<String> _buildOptions(_Chapter chapter, String correct)
content = content.replace(
  'List<String> _buildOptions(_Chapter chapter, String correct) {',
  'List<String> _buildOptions(BuildContext context, _Chapter chapter, String correctKey) {\n    final correct = context.t(correctKey);'
);

content = content.replace(
  'for (final other in chapter.quiz) {\n      if (other.answer != correct && !wrong.contains(other.answer)) {\n        wrong.add(other.answer);',
  'for (final other in chapter.quiz) {\n      final otherAns = context.t(other.answerKey);\n      if (otherAns != correct && !wrong.contains(otherAns)) {\n        wrong.add(otherAns);'
);

fs.writeFileSync(filePath, content, 'utf8');
console.log('Successfully refactored islam_basics_screen.dart');
