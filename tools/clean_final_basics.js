const fs = require('fs');
const path = require('path');

const ROOT = path.resolve(__dirname, '..');
const filePath = path.join(ROOT, 'lib', 'screens', 'basics', 'islam_basics_screen.dart');
let content = fs.readFileSync(filePath, 'utf8');

content = content.replace(
  "title: 'মৌলিক ইসলাম শিক্ষা',\n                            subtitle: 'গল্পে শিখি, কাজে লাগাই',",
  "title: context.t('basics.header.title'),\n                            subtitle: context.t('basics.header.subtitle'),"
);

content = content.replace(
  "title: 'গল্পটি নিয়ে একটু ভাবো',\n            subtitle: '১০টি ছোট প্রশ্ন—নিজের মনে উত্তর দাও।'),",
  "title: context.t('basics.reflect.title'),\n            subtitle: context.t('basics.reflect.subtitle')),"
);

content = content.replace(
  "title: 'শেখাটা মনে আছে?',\n          subtitle: '১০টি কুইজ—সঠিক উত্তর বেছে নাও।'),",
  "title: context.t('basics.quiz.title'),\n          subtitle: context.t('basics.quiz.subtitle')),"
);

content = content.replace(
  "correct: _checked && options[i] == item.answer,",
  "correct: _checked && options[i] == context.t(item.answerKey),"
);

content = content.replace(
  `isCorrect
                    ? 'সঠিক উত্তর! মাশাআল্লাহ।'
                    : 'উত্তরটি ভুল হয়েছে। সঠিক উত্তর: \${item.answer}'`,
  `isCorrect
                    ? context.t('basics.quiz.correct_feedback')
                    : context.t('basics.quiz.wrong_feedback', params: {'correct': context.t(item.answerKey)})`
);

content = content.replace(
  `!_checked
              ? 'উত্তর মিলিয়ে দেখি'
              : (_itemIndex == 9 ? 'ফলাফল দেখি' : 'পরের প্রশ্ন')`,
  `!_checked
              ? context.t('basics.quiz.check_answer')
              : (_itemIndex == 9 ? context.t('basics.quiz.see_result') : context.t('basics.quiz.next_question'))`
);

content = content.replace(
  `const LocalizedText(
                'কুইজের ফলাফল',`,
  `Text(
                context.t('basics.result.title'),`
);

content = content.replace(
  `score == 10
                    ? 'মাশাআল্লাহ! তুমি সব প্রশ্নের সঠিক উত্তর দিয়েছো!'
                    : score >= 7
                        ? 'খুব ভালো! তুমি সফলভাবে অধ্যায়টি সম্পন্ন করেছ।'
                        : 'তুমি চেষ্টা করেছো! অধ্যায়টি আবার পড়ে আরও ভালো করতে পারো。'`,
  `score == 10
                    ? context.t('basics.result.perfect')
                    : score >= 7
                        ? context.t('basics.result.good')
                        : context.t('basics.result.retry_advice')`
);

content = content.replace(
  `score == 10
                    ? 'মাশাআল্লাহ! তুমি সব প্রশ্নের সঠিক উত্তর দিয়েছো!'
                    : score >= 7
                        ? 'খুব ভালো! তুমি সফলভাবে অধ্যায়টি সম্পন্ন করেছ।'
                        : 'তুমি চেষ্টা করেছো! অধ্যায়টি আবার পড়ে আরও ভালো করতে পারো।'`,
  `score == 10
                    ? context.t('basics.result.perfect')
                    : score >= 7
                        ? context.t('basics.result.good')
                        : context.t('basics.result.retry_advice')`
);

content = content.replace(
  `earned
                          ? '+২৫ XP অর্জিত হয়েছে!'
                          : '+২৫ XP আগেই অর্জিত হয়েছে'`,
  `earned
                          ? context.t('basics.result.xp_earned')
                          : context.t('basics.result.xp_already')`
);

fs.writeFileSync(filePath, content, 'utf8');
console.log('Final replacement on islam_basics_screen.dart done');
