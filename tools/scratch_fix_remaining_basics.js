const fs = require('fs');
const path = require('path');

const ROOT = path.resolve(__dirname, '..');
const filePath = path.join(ROOT, 'lib', 'screens', 'basics', 'islam_basics_screen.dart');
let content = fs.readFileSync(filePath, 'utf8');

// Fix Header title/subtitle
content = content.replace(
  "title: 'মৌলিক ইসলাম শিক্ষা',\n                    subtitle: 'গল্পে শিখি, কাজে লাগাই',",
  "title: context.t('basics.header.title'),\n                    subtitle: context.t('basics.header.subtitle'),"
);

// Fix reflect title/subtitle
content = content.replace(
  "title: 'গল্পটি নিয়ে একটু ভাবো',\n                subtitle: '১০টি ছোট প্রশ্ন—নিজের মনে উত্তর দাও।'),",
  "title: context.t('basics.reflect.title'),\n                subtitle: context.t('basics.reflect.subtitle')),"
);

// Fix quiz title/subtitle
content = content.replace(
  "title: 'শেখাটা মনে আছে?',\n                subtitle: '১০টি কুইজ—সঠিক উত্তর বেছে নাও।'),",
  "title: context.t('basics.quiz.title'),\n                subtitle: context.t('basics.quiz.subtitle')),"
);

// Fix feedback
content = content.replace(
  "? 'সঠিক উত্তর! মাশাআল্লাহ。'\n                      : 'উত্তরটি ভুল হয়েছে। সঠিক উত্তর: ${item.answer}',",
  "? context.t('basics.quiz.correct_feedback')\n                      : context.t('basics.quiz.wrong_feedback', params: {'correct': context.t(item.answerKey)}),"
);
content = content.replace(
  "? 'সঠিক উত্তর! মাশাআল্লাহ।'\n                      : 'উত্তরটি ভুল হয়েছে। সঠিক উত্তর: ${item.answer}',",
  "? context.t('basics.quiz.correct_feedback')\n                      : context.t('basics.quiz.wrong_feedback', params: {'correct': context.t(item.answerKey)}),"
);

// Fix buttons
content = content.replace(
  "? 'উত্তর মিলিয়ে দেখি'\n                      : (_itemIndex == 9 ? 'ফলাফল দেখি' : 'পরের প্রশ্ন'),",
  "? context.t('basics.quiz.check_answer')\n                      : (_itemIndex == 9 ? context.t('basics.quiz.see_result') : context.t('basics.quiz.next_question')),"
);

// Fix quiz result
content = content.replace(
  "const LocalizedText('কুইজের ফলাফল',",
  "Text(context.t('basics.result.title'),"
);

// Fix result message
content = content.replace(
  "LocalizedText(\n                  perfect\n                      ? 'মাশাআল্লাহ! তুমি সব প্রশ্নের সঠিক উত্তর দিয়েছো!'\n                      : passed\n                          ? 'খুব ভালো! তুমি সফলভাবে অধ্যায়টি সম্পন্ন করেছ।'\n                          : 'তুমি চেষ্টা করেছো! অধ্যায়টি আবার পড়ে আরও ভালো করতে পারো।',",
  "Text(\n                  perfect\n                      ? context.t('basics.result.perfect')\n                      : passed\n                          ? context.t('basics.result.good')\n                          : context.t('basics.result.retry_advice'),"
);

// Fix XP
content = content.replace(
  "? '+২৫ XP অর্জিত হয়েছে!'\n                      : '+২৫ XP আগেই অর্জিত হয়েছে',",
  "? context.t('basics.result.xp_earned')\n                      : context.t('basics.result.xp_already'),"
);

// Fix reflection questions
const oldReflect = `      'এই কথাটি তোমাকে কী ভাবায়?',
      'এটি মনে রাখলে তুমি কী ভালো কাজ করতে পারো?',
      'তোমার জীবনে এর একটি উদাহরণ কী?',
      'এটি কি তোমাকে কারও উপকার করতে শেখায়?',
      'এ বিষয়ে তোমার মনে আর কী প্রশ্ন আসে?',
      'কঠিন হলে কার কাছে সাহায্য চাইবে?',
      'আজ থেকেই কীভাবে এটি কাজে লাগাবে?',
      'তোমার পরিবারের সঙ্গে এ নিয়ে কী কথা বলবে?',
      'এটি ভুলে গেলে কীভাবে মনে করতে পারো?',
      'এই অধ্যায় থেকে সবচেয়ে জরুরি শিক্ষা কোনটি?'`;

const newReflect = `      context.t('basics.reflect.q1'),
      context.t('basics.reflect.q2'),
      context.t('basics.reflect.q3'),
      context.t('basics.reflect.q4'),
      context.t('basics.reflect.q5'),
      context.t('basics.reflect.q6'),
      context.t('basics.reflect.q7'),
      context.t('basics.reflect.q8'),
      context.t('basics.reflect.q9'),
      context.t('basics.reflect.q10'),`;

content = content.replace(oldReflect, newReflect);
content = content.replace('const [', '[');

fs.writeFileSync(filePath, content, 'utf8');
console.log('Finished secondary cleanup of islam_basics_screen.dart');
