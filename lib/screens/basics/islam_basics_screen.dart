import '../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/app_theme.dart';
import '../../utils/app_state.dart';
import '../../widgets/duolingo_appbar.dart';
import '../../widgets/duolingo_button.dart';
import '../../widgets/vector_icons.dart';

typedef _QuizItem = ({String question, String answer});

class _Chapter {
  const _Chapter(
      {required this.title,
      required this.definition,
      required this.story,
      required this.icon,
      required this.color,
      required this.quiz});
  final String title, definition, story;
  final IconData icon;
  final Color color;
  final List<_QuizItem> quiz;
}

const _chapters = <_Chapter>[
  _Chapter(
      title: 'ঈমান কী?',
      definition:
          'ঈমান হলো আল্লাহ ও তিনি যে সত্যগুলো জানিয়েছেন, সেগুলো অন্তর দিয়ে বিশ্বাস করা।',
      story:
          'ছোট্ট আমিন আকাশের তারা দেখে ভাবল—এত সুন্দর সৃষ্টি কে বানিয়েছেন? মা বললেন, “আল্লাহ সবকিছুর স্রষ্টা। আমরা তাঁকে দেখি না, কিন্তু তাঁর সৃষ্টি দেখি এবং তাঁর ওপর ভরসা করি।” আমিন শিখল, ঈমান শুধু মুখের কথা নয়; বিশ্বাস, ভালো কাজ আর আল্লাহর ওপর ভরসায় তা প্রকাশ পায়।',
      icon: Icons.auto_awesome_rounded,
      color: Color(0xFFDDF4E9),
      quiz: [
        (question: 'ঈমান কোথায় বিশ্বাস হিসেবে থাকে?', answer: 'অন্তরে'),
        (question: 'সবকিছুর স্রষ্টা কে?', answer: 'আল্লাহ'),
        (
          question: 'আল্লাহকে না দেখলেও কীভাবে তাঁর নিদর্শন দেখি?',
          answer: 'সৃষ্টির মধ্যে'
        ),
        (
          question: 'কোন গুণটি মুমিনকে সাহায্য করে?',
          answer: 'আল্লাহর ওপর ভরসা'
        ),
        (
          question: 'ভালো কাজের সঙ্গে ঈমানের সম্পর্ক কী?',
          answer: 'বিশ্বাসকে কাজে প্রকাশ করে'
        ),
        (
          question: 'সত্য কথা বলার চেষ্টা কেন করি?',
          answer: 'আল্লাহ সত্য ভালোবাসেন'
        ),
        (question: 'কঠিন সময়ে কার কাছে সাহায্য চাই?', answer: 'আল্লাহর কাছে'),
        (question: 'নিয়ামত পেলে কী বলি?', answer: 'আলহামদুলিল্লাহ'),
        (
          question: 'ভুল হলে কী করি?',
          answer: 'আল্লাহর কাছে ক্ষমা চাই ও ঠিক করি'
        ),
        (
          question: 'ঈমান কেবল মুখে বললেই পূর্ণ হয়?',
          answer: 'না, বিশ্বাস ও ভালো কাজও জরুরি'
        ),
      ]),
  _Chapter(
      title: 'আকিদা কী?',
      definition:
          'আকিদা হলো ইসলামের বিশ্বাসের ভিত্তি—যে সত্যগুলো একজন মুসলিম মনে-প্রাণে মেনে নেয়।',
      story:
          'স্কুলে শিক্ষক একটি ঘরের ভিত্তির কথা বললেন। ভিত্তি মজবুত হলে ঘর দাঁড়িয়ে থাকে। ইসলামের বিশ্বাসও তেমন—আল্লাহ এক, তিনি আমাদের রব; তাঁর পাঠানো রাসূলগণ মানুষকে সত্য পথ দেখিয়েছেন। সঠিক বিশ্বাস শিখতে আমিন মা-বাবা ও বিশ্বস্ত শিক্ষকের কাছে প্রশ্ন করে।',
      icon: Icons.lightbulb_rounded,
      color: Color(0xFFE8E2FF),
      quiz: [
        (question: 'আকিদা বলতে কী বোঝায়?', answer: 'ইসলামের বিশ্বাসের ভিত্তি'),
        (question: 'আল্লাহ কয়জন?', answer: 'একজন'),
        (question: 'আমাদের স্রষ্টা ও পালনকর্তা কে?', answer: 'আল্লাহ'),
        (question: 'রাসূলগণ কী করেছেন?', answer: 'মানুষকে আল্লাহর পথে ডেকেছেন'),
        (question: 'আল্লাহর ফেরেশতারা কী?', answer: 'আল্লাহর সৃষ্টি'),
        (question: 'আল্লাহর কিতাব কী শেখায়?', answer: 'সত্য ও সঠিক পথ'),
        (
          question: 'শেষ দিনের কথা মনে রাখলে কী করি?',
          answer: 'ভালো কাজের চেষ্টা করি'
        ),
        (
          question: 'বিশ্বাস নিয়ে প্রশ্ন হলে কার কাছে যাব?',
          answer: 'বিশ্বস্ত শিক্ষক বা অভিভাবকের কাছে'
        ),
        (question: 'আল্লাহর মতো আর কেউ স্রষ্টা?', answer: 'না, আল্লাহ এক'),
        (
          question: 'সঠিক আকিদা শেখার ভালো উপায় কী?',
          answer: 'বিশ্বস্ত জ্ঞানীদের কাছ থেকে শেখা'
        ),
      ]),
  _Chapter(
      title: 'ইসলাম কী?',
      definition:
          'ইসলাম হলো এক আল্লাহর ইবাদত করা, তাঁর নির্দেশ মানা এবং মানুষের সঙ্গে ভালো ব্যবহার করা।',
      story:
          'আমিনের বন্ধু জানতে চাইল, “ইসলাম মানে কি শুধু নামাজ?” আমিন বলল, “নামাজ খুব গুরুত্বপূর্ণ; পাশাপাশি সত্য বলা, মা-বাবার সম্মান করা, দয়া করা—এসবও ইসলামের শিক্ষা।” তারা ঠিক করল প্রতিদিন একটি ভালো কাজ করবে এবং পাঁচ ওয়াক্ত নামাজ শিখবে।',
      icon: Icons.mosque_rounded,
      color: Color(0xFFFFF0CE),
      quiz: [
        (question: 'আমরা কার ইবাদত করি?', answer: 'শুধু আল্লাহর'),
        (
          question: 'ইসলামের মূল শিক্ষা কী?',
          answer: 'আল্লাহর আনুগত্য ও ভালো জীবন'
        ),
        (question: 'নামাজ কেমন কাজ?', answer: 'ইসলামের গুরুত্বপূর্ণ ইবাদত'),
        (
          question: 'মা-বাবাকে সম্মান করা কেমন কাজ?',
          answer: 'ইসলামের সুন্দর শিক্ষা'
        ),
        (question: 'সত্য বলা কেমন?', answer: 'ভালো মুসলিমের গুণ'),
        (
          question: 'মানুষকে কষ্ট দেওয়া কি ভালো আচরণ?',
          answer: 'না, দয়া ও সম্মান দেখাই'
        ),
        (question: 'ইবাদত কাকে খুশি করার জন্য?', answer: 'আল্লাহকে'),
        (
          question: 'ইসলাম কি শুধু কিছু আচার?',
          answer: 'না, জীবনযাপনেরও শিক্ষা'
        ),
        (question: 'কারও উপকার করলে কী দেখাই?', answer: 'দয়া ও ভালো চরিত্র'),
        (
          question: 'ইসলাম শিখি কীভাবে?',
          answer: 'কুরআন, সুন্নাহ ও বিশ্বস্ত শিক্ষক থেকে'
        ),
      ]),
  _Chapter(
      title: 'হালাল ও হারাম',
      definition:
          'হালাল মানে ইসলামে অনুমোদিত; হারাম মানে ইসলামে নিষিদ্ধ। সব বিষয়ে নিজে অনুমান না করে বিশ্বস্ত বড়দের জিজ্ঞেস করি।',
      story:
          'দোকানে নতুন খাবারের প্যাকেট দেখে আমিনের মনে প্রশ্ন এল। সে নিজে সিদ্ধান্ত না নিয়ে বাবাকে জিজ্ঞেস করল। বাবা উপাদান ও নির্ভরযোগ্য তথ্য দেখে বুঝিয়ে দিলেন। আমিন শিখল—কোনো কাজ বা খাবারের বিধান নিয়ে সন্দেহ হলে লুকিয়ে নয়, জেনে-বুঝে এবং বিশ্বস্ত আলেম/অভিভাবকের সাহায্যে চলতে হয়।',
      icon: Icons.rule_rounded,
      color: Color(0xFFDDF1FF),
      quiz: [
        (question: 'হালাল মানে কী?', answer: 'ইসলামে অনুমোদিত'),
        (question: 'হারাম মানে কী?', answer: 'ইসলামে নিষিদ্ধ'),
        (
          question: 'সন্দেহ হলে কাকে জিজ্ঞেস করব?',
          answer: 'অভিভাবক বা বিশ্বস্ত আলেম'
        ),
        (
          question: 'নিজে অনুমান করে ফতোয়া দেওয়া ঠিক?',
          answer: 'না, জেনে ও যাচাই করে শিখি'
        ),
        (
          question: 'কোনো ভুল বুঝলে কী করব?',
          answer: 'শান্তভাবে সঠিক তথ্য শিখব'
        ),
        (
          question: 'ইসলামের বিধান কোথা থেকে শিখি?',
          answer: 'কুরআন-সুন্নাহ ও যোগ্য শিক্ষকের কাছ থেকে'
        ),
        (
          question: 'অন্যের মত শুনে যাচাই ছাড়া কী করব?',
          answer: 'বিশ্বস্ত সূত্রে যাচাই করব'
        ),
        (question: 'হালাল-হারাম শেখার সময় কেমন থাকব?', answer: 'সৎ ও সতর্ক'),
        (
          question: 'খাবারের উপাদান বুঝতে না পারলে?',
          answer: 'বড়দের সাহায্যে যাচাই করব'
        ),
        (
          question: 'কাউকে বিধান নিয়ে অপমান করা উচিত?',
          answer: 'না, সম্মান দিয়ে বুঝি ও জিজ্ঞেস করি'
        ),
      ]),
  _Chapter(
      title: 'পোশাক ও শালীনতা',
      definition:
          'পরিষ্কার, আরামদায়ক ও শালীন পোশাক পরি। বয়স অনুযায়ী শালীনতার নিয়ম পরিবার ও শিক্ষকের কাছ থেকে শিখি।',
      story:
          'স্কুলের অনুষ্ঠানে আমিন আর তার বোন পোশাক বেছে নিচ্ছিল। মা বললেন, পরিষ্কার পোশাক পরতে, শরীর ঢেকে রাখতে এবং অন্যের পোশাক নিয়ে হাসাহাসি না করতে। তারা বুঝল—পোশাক পরিচ্ছন্ন ও শালীন হওয়া দরকার, আর সবার প্রতি সম্মানও জরুরি।',
      icon: Icons.checkroom_rounded,
      color: Color(0xFFFFE4E8),
      quiz: [
        (question: 'পোশাক কেমন হওয়া ভালো?', answer: 'পরিষ্কার ও শালীন'),
        (question: 'পোশাক কি আবহাওয়ার উপযোগী হওয়া উচিত?', answer: 'হ্যাঁ'),
        (question: 'অন্যের পোশাক নিয়ে হাসাহাসি করব?', answer: 'না, সম্মান করব'),
        (
          question: 'শালীনতার নিয়ম কার কাছে শিখব?',
          answer: 'অভিভাবক ও বিশ্বস্ত শিক্ষকের কাছে'
        ),
        (question: 'নোংরা পোশাকের বদলে কী বেছে নেব?', answer: 'পরিষ্কার পোশাক'),
        (question: 'পোশাক কি অহংকারের কারণ?', answer: 'না, বিনয়ী থাকি'),
        (
          question: 'পোশাক বাছাইয়ে পরিবারের পরামর্শ কেমন?',
          answer: 'গুরুত্ব দিয়ে শুনি'
        ),
        (question: 'অন্যের ব্যক্তিগত সীমা মানা কী?', answer: 'সম্মানজনক আচরণ'),
        (
          question: 'পোশাকের জন্য কাউকে ছোট করা কেমন?',
          answer: 'অন্যায় ও কষ্টদায়ক'
        ),
        (question: 'শালীনতা কি শুধু পোশাকে?', answer: 'না, কথা ও আচরণেও'),
      ]),
  _Chapter(
      title: 'সুন্দর কথা',
      definition:
          'সত্য, নরম ও সম্মানজনক কথা বলি। গালি, মিথ্যা, অপমান ও গীবত থেকে দূরে থাকি।',
      story:
          'বন্ধু রাফি খেলতে গিয়ে পড়ে গেল। কয়েকজন হাসতে চাইলে আমিন বলল, “চলো, ওকে উঠতে সাহায্য করি।” রাফিকে সান্ত্বনা দিয়ে সে নরম করে কথা বলল। শিক্ষক বললেন, সুন্দর কথা মানুষের মন ভালো করে; তাই সত্য বলি, সালাম দিই, আর কাউকে নিয়ে বিদ্রূপ করি না।',
      icon: Icons.chat_bubble_rounded,
      color: Color(0xFFE3F5DB),
      quiz: [
        (question: 'কেমন কথা বলব?', answer: 'সত্য ও নরম'),
        (
          question: 'ভুল করে ফেললে কী বলব?',
          answer: 'দুঃখিত, ঠিক করার চেষ্টা করব'
        ),
        (question: 'কারও সঙ্গে দেখা হলে কী বলি?', answer: 'সালাম দিই'),
        (question: 'মিথ্যা বলা কেমন?', answer: 'এড়িয়ে চলি'),
        (question: 'কাউকে অপমান করলে তার কেমন লাগে?', answer: 'কষ্ট লাগে'),
        (
          question: 'বন্ধুর গোপন কথা ছড়ানো উচিত?',
          answer: 'না, আমানত রক্ষা করি'
        ),
        (question: 'রাগ হলে কীভাবে কথা বলি?', answer: 'শান্ত হয়ে'),
        (
          question: 'গীবত কী থেকে বাঁচতে শেখায়?',
          answer: 'কারও অনুপস্থিতিতে তার দোষ বলা'
        ),
        (question: 'ভালো কথা শুনলে কী করি?', answer: 'মন দিয়ে শুনি'),
        (question: 'কথা বলার আগে কী ভাবি?', answer: 'এতে কারও কষ্ট হবে কি না'),
      ]),
  _Chapter(
      title: 'ভালো আচরণ',
      definition:
          'সততা, ধৈর্য, পরিচ্ছন্নতা, দয়া ও দায়িত্বশীলতা—এসব সুন্দর আচরণের অংশ।',
      story:
          'আমিন দেখল তার ছোট ভাই খেলনা গুছাতে পারছে না। সে বিরক্ত না হয়ে পাশে বসে সাহায্য করল। নিজের ভুল হলে সে স্বীকার করল, আর ধার করা বই সময়মতো ফিরিয়ে দিল। সে শিখল—ভালো চরিত্র প্রতিদিনের ছোট ছোট কাজে দেখা যায়।',
      icon: Icons.emoji_people_rounded,
      color: Color(0xFFFFEBCF),
      quiz: [
        (
          question: 'ধার করা জিনিসের সঙ্গে কী করি?',
          answer: 'যত্ন নিয়ে ফেরত দিই'
        ),
        (question: 'ভুল করলে কী করি?', answer: 'স্বীকার করে ঠিক করি'),
        (question: 'ছোটদের সঙ্গে কেমন থাকি?', answer: 'দয়ালু'),
        (question: 'পরিচ্ছন্নতা কেমন অভ্যাস?', answer: 'ভালো অভ্যাস'),
        (question: 'কাজের দায়িত্ব কীভাবে পালন করি?', answer: 'সততার সঙ্গে'),
        (question: 'রাগ উঠলে কী করি?', answer: 'ধৈর্য ধরে শান্ত হই'),
        (question: 'অন্যের জিনিস অনুমতি ছাড়া নেওয়া ঠিক?', answer: 'না'),
        (question: 'প্রতিশ্রুতি দিলে কী করি?', answer: 'রাখার চেষ্টা করি'),
        (
          question: 'কেউ সাহায্য চাইলে কী করি?',
          answer: 'সামর্থ্য অনুযায়ী সাহায্য করি'
        ),
        (question: 'ভালো চরিত্র কোথায় দেখা যায়?', answer: 'প্রতিদিনের আচরণে'),
      ]),
  _Chapter(
      title: 'মানুষের সঙ্গে ব্যবহার',
      definition:
          'মা-বাবা, আত্মীয়, শিক্ষক, প্রতিবেশী, বন্ধু—সবার সঙ্গে ন্যায়, দয়া ও সম্মান দিয়ে ব্যবহার করি.',
      story:
          'পড়শি খালা অসুস্থ ছিলেন। আমিনের পরিবার তাঁর খোঁজ নিল। স্কুলে আমিন নতুন বন্ধুকে খেলায় যোগ দিল, আর শিক্ষক কথা বললে মন দিয়ে শুনল। সে বুঝল—মানুষের পরিচয় আলাদা হলেও সবার সঙ্গে ন্যায় ও সম্মান জরুরি।',
      icon: Icons.diversity_3_rounded,
      color: Color(0xFFFFE8D8),
      quiz: [
        (
          question: 'মা-বাবার সঙ্গে কেমন ব্যবহার করি?',
          answer: 'সম্মান ও সদয়ভাবে'
        ),
        (question: 'শিক্ষক কথা বললে কী করি?', answer: 'মন দিয়ে শুনি'),
        (
          question: 'নতুন বন্ধুকে কীভাবে স্বাগত জানাই?',
          answer: 'বন্ধুত্ব ও সম্মান দিয়ে'
        ),
        (question: 'প্রতিবেশীর খোঁজ নেওয়া কেমন কাজ?', answer: 'দয়ার কাজ'),
        (question: 'মত আলাদা হলে কী করি?', answer: 'শান্তভাবে কথা বলি'),
        (question: 'কারও সঙ্গে অন্যায় করা ঠিক?', answer: 'না, ন্যায় করি'),
        (question: 'দুর্বল কাউকে কষ্ট দেওয়া কেমন?', answer: 'ভুল'),
        (question: 'পরিবারে কাজে সাহায্য করা কেমন?', answer: 'ভালো দায়িত্ব'),
        (
          question: 'অন্যের কথা মন দিয়ে শোনা কেন?',
          answer: 'সম্মান দেখানোর জন্য'
        ),
        (question: 'সব মানুষের সঙ্গে কেমন থাকি?', answer: 'ন্যায় ও দয়া দিয়ে'),
      ]),
  _Chapter(
      title: 'হালাল খাবার',
      definition:
          'বৈধ, পরিষ্কার ও নিরাপদ খাবার বেছে নিই। উপাদান বা বিধান বুঝতে না পারলে অভিভাবকের সঙ্গে যাচাই করি।',
      story:
          'স্কুলের টিফিনে আমিন ফল, রুটি আর পানি নিল। খাবারের আগে বিসমিল্লাহ বলল, পরিমিত খেল, বন্ধুর সঙ্গে ভাগ করল এবং খাবার নষ্ট করল না। নতুন কোনো প্যাকেটের উপাদান বুঝতে না পেরে সে বাবাকে দেখাল।',
      icon: Icons.restaurant_rounded,
      color: Color(0xFFE0F1FF),
      quiz: [
        (question: 'খাবার কেমন হওয়া ভালো?', answer: 'বৈধ, পরিষ্কার ও নিরাপদ'),
        (question: 'খাবারের আগে কী বলি?', answer: 'বিসমিল্লাহ'),
        (question: 'খাবার নষ্ট করা কেমন?', answer: 'অপচয়, এড়িয়ে চলি'),
        (
          question: 'নতুন খাবারের উপাদান বুঝতে না পারলে?',
          answer: 'অভিভাবককে দেখাই'
        ),
        (question: 'খাওয়ার সময় কীভাবে থাকি?', answer: 'পরিমিত ও কৃতজ্ঞ'),
        (question: 'খাবার ভাগ করে দেওয়া কেমন?', answer: 'সুন্দর কাজ'),
        (question: 'খাবারের পর কী করি?', answer: 'আল্লাহর শুকরিয়া আদায় করি'),
        (
          question: 'নিরাপদ খাবার বাছাইয়ে কার সাহায্য নিই?',
          answer: 'অভিভাবকের'
        ),
        (
          question: 'পরিষ্কার হাতে খাওয়া কেন ভালো?',
          answer: 'স্বাস্থ্য ও পরিচ্ছন্নতার জন্য'
        ),
        (question: 'খাবার নিয়ে সন্দেহ হলে কী করি?', answer: 'যাচাই করে শিখি'),
      ]),
  _Chapter(
      title: 'হারাম খাবার থেকে বাঁচি',
      definition:
          'ইসলাম কিছু খাবার ও পানীয় নিষিদ্ধ করেছে। উপাদান বা কোনো নির্দিষ্ট খাবার নিয়ে সন্দেহ হলে বিশ্বস্ত বড়দের কাছে যাচাই করি।',
      story:
          'একদিন আমিন শুনল, ইসলামে কিছু খাবার নিষেধ। সে জানতে চাইল কোনগুলো, আর মা কুরআনের শিক্ষা বুঝিয়ে দিলেন—শূকর এবং নেশা সৃষ্টিকারী পানীয় থেকে দূরে থাকতে হয়। প্যাকেটের অচেনা উপাদান দেখলে সে অনুমান না করে বড়দের সঙ্গে যাচাই করে।',
      icon: Icons.no_food_rounded,
      color: Color(0xFFFFE1D5),
      quiz: [
        (question: 'ইসলামে শূকরের মাংসের বিধান কী?', answer: 'নিষিদ্ধ'),
        (question: 'নেশা সৃষ্টিকারী পানীয় থেকে কী করি?', answer: 'দূরে থাকি'),
        (
          question: 'অজানা উপাদান দেখলে কী করি?',
          answer: 'অভিভাবকের সঙ্গে যাচাই'
        ),
        (
          question: 'খাবার নিয়ে অনুমান করে অন্যকে দোষ দিই?',
          answer: 'না, আগে নির্ভরযোগ্যভাবে জানি'
        ),
        (
          question: 'নিষিদ্ধ জিনিস থেকে বাঁচতে কে সাহায্য করেন?',
          answer: 'আল্লাহর নির্দেশ ও অভিভাবকের শিক্ষা'
        ),
        (
          question: 'ভুল করে কিছু খেয়ে ফেললে কী করব?',
          answer: 'বড়দের বলব ও সঠিকটা শিখব'
        ),
        (question: 'বন্ধুকে নিষিদ্ধ কিছু খেতে চাপ দেওয়া ঠিক?', answer: 'না'),
        (
          question: 'খাবারের নিয়ম কার কাছে শিখব?',
          answer: 'বিশ্বস্ত আলেম ও অভিভাবকের কাছে'
        ),
        (question: 'সব অচেনা খাবারকে নিজে হারাম বলব?', answer: 'না, যাচাই করব'),
        (
          question: 'হালাল খাবার বাছাইয়ের উদ্দেশ্য কী?',
          answer: 'আল্লাহর নির্দেশ মেনে চলা'
        ),
      ]),
];

enum _Stage { intro, story, reflect, quiz, result }

class IslamBasicsScreen extends StatefulWidget {
  const IslamBasicsScreen({super.key});
  @override
  State<IslamBasicsScreen> createState() => _IslamBasicsScreenState();
}

class _IslamBasicsScreenState extends State<IslamBasicsScreen> {
  int? _chapterIndex;
  _Stage _stage = _Stage.intro;
  int _itemIndex = 0;
  int? _selected;
  bool _checked = false;

  int _correctAnswers = 0;
  int _unansweredCount = 0;
  final Map<int, bool> _firstAttemptStatus = {};
  bool _lastCompletionEarnedXp = false;

  void _startChapter(int index) {
    final chapterId = 'basics_chapter_$index';
    final saved = context.read<AppState>().basicsProgress(chapterId);
    final stageIndex = saved == 0 ? 0 : ((saved - 1) ~/ 100).clamp(0, 3);
    final itemIndex = saved == 0 ? 0 : ((saved - 1) % 100).clamp(0, 9);
    setState(() {
      _chapterIndex = index;
      _stage = _Stage.values[stageIndex];
      _itemIndex = itemIndex;
      _selected = null;
      _checked = false;
      _correctAnswers = 0;
      _unansweredCount = 0;
      _firstAttemptStatus.clear();
      _lastCompletionEarnedXp = false;
    });
  }

  Future<void> _saveCurrentProgress() async {
    final index = _chapterIndex;
    if (index == null || _stage == _Stage.result) return;
    await context.read<AppState>().saveBasicsProgress(
          'basics_chapter_$index',
          _stage.index * 100 + _itemIndex + 1,
        );
  }

  void _nextStage() {
    setState(() {
      _selected = null;
      _checked = false;
      _itemIndex = 0;
      _stage = switch (_stage) {
        _Stage.intro => _Stage.story,
        _Stage.story => _Stage.reflect,
        _Stage.reflect => _Stage.quiz,
        _Stage.quiz => _Stage.result,
        _Stage.result => _Stage.result,
      };
    });
    _saveCurrentProgress();
  }

  Future<void> _finishChapter() async {
    final index = _chapterIndex!;
    final score = _correctAnswers;
    final appState = context.read<AppState>();
    await appState.recordQuizResult('basics_chapter_$index', score);
    final earned = await appState.completeLesson('basics_chapter_$index', xp: 25);
    await appState.clearBasicsProgress('basics_chapter_$index');
    if (!mounted) return;
    setState(() {
      _lastCompletionEarnedXp = earned;
      _stage = _Stage.result;
    });
  }

  void _retryQuiz() {
    setState(() {
      _stage = _Stage.quiz;
      _itemIndex = 0;
      _selected = null;
      _checked = false;
      _correctAnswers = 0;
      _unansweredCount = 0;
      _firstAttemptStatus.clear();
    });
    _saveCurrentProgress();
  }

  void _restartChapter() {
    setState(() {
      _stage = _Stage.intro;
      _itemIndex = 0;
      _selected = null;
      _checked = false;
      _correctAnswers = 0;
      _unansweredCount = 0;
      _firstAttemptStatus.clear();
    });
    _saveCurrentProgress();
  }

  Future<void> _handleExit() async {
    if (_chapterIndex == null) {
      Navigator.pop(context);
      return;
    }
    if (_stage == _Stage.intro || _stage == _Stage.result) {
      setState(() => _chapterIndex = null);
      return;
    }
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const LocalizedText('পড়া থেকে বিরতি নেবে?'),
        content: const LocalizedText(
            'তোমার শেখার অগ্রগতি সেভ থাকবে। পরে এখান থেকেই শুরু করতে পারবে।'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const LocalizedText('চালিয়ে যাই'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFE05A7A)),
            child: const LocalizedText('বের হই'),
          ),
        ],
      ),
    );
    if (shouldExit == true && mounted) {
      await _saveCurrentProgress();
      setState(() => _chapterIndex = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tablet = MediaQuery.sizeOf(context).shortestSide >= 600;
    if (_chapterIndex == null) return _buildChapterList(tablet);
    final chapter = _chapters[_chapterIndex!];
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _handleExit();
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.cream,
        body: SafeArea(
            child: Center(
                child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Column(children: [
            _topBar(chapter, tablet),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: tablet ? 36 : 20),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: LinearProgressIndicator(
                        value: _progress,
                        minHeight: 10,
                        backgroundColor: Colors.white,
                        color: AppTheme.primaryGreen))),
            Expanded(child: _stageContent(chapter, tablet)),
          ]),
        ))),
      ),
    );
  }

  double get _progress => switch (_stage) {
        _Stage.intro => .08,
        _Stage.story => .18,
        _Stage.reflect => .2 + .3 * (_itemIndex + 1) / 10,
        _Stage.quiz => .5 + .5 * (_itemIndex + (_checked ? 1 : 0)) / 10,
        _Stage.result => 1.0,
      };

  Widget _topBar(_Chapter chapter, bool tablet) => Padding(
        padding: EdgeInsets.fromLTRB(tablet ? 32 : 18, 8, 18, 10),
        child: Row(children: [
          IconButton.filledTonal(
              onPressed: _handleExit,
              icon: const Icon(Icons.arrow_back_rounded),
              style: IconButton.styleFrom(backgroundColor: Colors.white)),
          const SizedBox(width: 8),
          Expanded(
              child: LocalizedText(chapter.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.darkText))),
          LocalizedText(
              switch (_stage) {
                _Stage.intro => 'পাঠ ১',
                _Stage.story => 'গল্প',
                _Stage.reflect => 'ভাবি ${_itemIndex + 1}/১০',
                _Stage.quiz => 'কুইজ ${_itemIndex + 1}/১০',
                _Stage.result => 'ফলাফল',
              },
              style: const TextStyle(
                  fontWeight: FontWeight.w800, color: AppTheme.primaryGreen)),
        ]),
      );

  Widget _buildChapterList(bool tablet) {
    final state = context.watch<AppState>();
    // Lessons unlock in order; completed chapter ids are saved by AppState.
    final firstIncomplete = List.generate(_chapters.length, (i) => i)
        .firstWhere((i) => !state.hasCompletedLesson('basics_chapter_$i'),
            orElse: () => _chapters.length);
    final completedCount = List.generate(_chapters.length, (i) => i)
        .where((i) => state.hasCompletedLesson('basics_chapter_$i'))
        .length;
    return Scaffold(
        backgroundColor: AppTheme.cream,
        body: SafeArea(
            child: Center(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 900),
                    child: ListView(
                        padding: EdgeInsets.all(tablet ? 32 : 18),
                        children: [
                          DuolingoPageHeader(
                            title: 'মৌলিক ইসলাম শিক্ষা',
                            subtitle: 'গল্পে শিখি, কাজে লাগাই',
                            iconType: VectorIconType.book,
                            gradientColors: const [
                              Color(0xFF0D7377),
                              Color(0xFF14919B)
                            ],
                            onBack: () => Navigator.pop(context),
                            trailing: LocalizedText(
                                '$completedCount/${_chapters.length}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900)),
                          ),
                          const SizedBox(height: 20),
                          for (var i = 0; i < _chapters.length; i++) ...[
                            _ChapterCard(
                                chapter: _chapters[i],
                                index: i,
                                completed: state
                                    .hasCompletedLesson('basics_chapter_$i'),
                                quizScore:
                                    state.quizResult('basics_chapter_$i'),
                                inProgress:
                                    state.basicsProgress('basics_chapter_$i') >
                                        0,
                                locked: i > firstIncomplete &&
                                    !state.hasCompletedLesson(
                                        'basics_chapter_$i'),
                                onTap: () => _startChapter(i)),
                            const SizedBox(height: 11),
                          ],
                        ])))));
  }

  Widget _stageContent(_Chapter chapter, bool tablet) {
    final pad = EdgeInsets.all(tablet ? 32 : 20);
    if (_stage == _Stage.intro) {
      return ListView(padding: pad, children: [
        _IllustrationCard(chapter: chapter),
        const SizedBox(height: 18),
        const LocalizedText('সহজ করে জানি',
            style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w900,
                color: AppTheme.darkText)),
        const SizedBox(height: 8),
        Container(
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: LocalizedText(chapter.definition,
                style: const TextStyle(
                    fontSize: 16, height: 1.7, color: AppTheme.darkText))),
        const SizedBox(height: 17),
        _primaryButton(
            'পরের পাঠ: গল্প পড়ি', Icons.auto_stories_rounded, _nextStage),
      ]);
    }
    if (_stage == _Stage.story) {
      return ListView(padding: pad, children: [
        _IllustrationCard(chapter: chapter, compact: true),
        const SizedBox(height: 17),
        Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(22)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const LocalizedText('একটি ছোট্ট গল্প',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.darkText)),
              const SizedBox(height: 12),
              LocalizedText(chapter.story,
                  style: const TextStyle(
                      fontSize: 16, height: 1.85, color: AppTheme.darkText))
            ])),
        const SizedBox(height: 16),
        _primaryButton(
            'গল্প নিয়ে ভাবি', Icons.psychology_alt_rounded, _nextStage),
      ]);
    }
    if (_stage == _Stage.reflect) {
      return ListView(padding: pad, children: [
        _StageLabel(
            color: chapter.color,
            icon: Icons.psychology_alt_rounded,
            title: 'গল্পটি নিয়ে একটু ভাবো',
            subtitle: '১০টি ছোট প্রশ্ন—নিজের মনে উত্তর দাও।'),
        const SizedBox(height: 18),
        Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(22)),
            child: Column(children: [
              LocalizedText('${_itemIndex + 1}',
                  style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.primaryGreen)),
              const SizedBox(height: 8),
              LocalizedText(_reflectionQuestion(chapter, _itemIndex),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 19,
                      height: 1.6,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.darkText)),
              const SizedBox(height: 16),
              LocalizedText(
                  'নিজের ভাষায় উত্তর ভাবো। প্রস্তুত হলে পরের প্রশ্নে যাও।',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppTheme.darkText.withValues(alpha: .65),
                      height: 1.5))
            ])),
        const SizedBox(height: 18),
        _primaryButton(
            _itemIndex == 9 ? 'এবার ১০টি কুইজ দিই' : 'পরের ভাবনার প্রশ্ন',
            _itemIndex == 9 ? Icons.quiz_rounded : Icons.arrow_forward_rounded,
            () {
          if (_itemIndex < 9) {
            setState(() => _itemIndex++);
          } else {
            _nextStage();
          }
          _saveCurrentProgress();
        }),
      ]);
    }
    if (_stage == _Stage.quiz) {
      return _quizContent(chapter, tablet);
    }
    return _resultContent(chapter, tablet);
  }

  Widget _quizContent(_Chapter chapter, bool tablet) {
    final item = chapter.quiz[_itemIndex];
    final options = _optionsFor(chapter, _itemIndex);
    final isCorrect = _selected != null && options[_selected!] == item.answer;

    return ListView(padding: EdgeInsets.all(tablet ? 32 : 20), children: [
      _StageLabel(
          color: chapter.color,
          icon: Icons.quiz_rounded,
          title: 'শেখাটা মনে আছে?',
          subtitle: '১০টি কুইজ—সঠিক উত্তর বেছে নাও।'),
      const SizedBox(height: 18),
      Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(22)),
          child: Column(children: [
            LocalizedText('প্রশ্ন ${_itemIndex + 1} / ১০',
                style: const TextStyle(
                    fontWeight: FontWeight.w800, color: AppTheme.primaryGreen)),
            const SizedBox(height: 10),
            LocalizedText(item.question,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 20,
                    height: 1.5,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.darkText))
          ])),
      const SizedBox(height: 15),
      for (var i = 0; i < options.length; i++)
        Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _QuizOption(
                text: options[i],
                selected: _selected == i,
                correct: _checked && options[i] == item.answer,
                color: chapter.color,
                onTap: _checked ? null : () => setState(() => _selected = i))),
      if (_checked) ...[
        Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: LocalizedText(
                isCorrect
                    ? 'সঠিক উত্তর! মাশাআল্লাহ।'
                    : 'উত্তরটি ভুল হয়েছে। সঠিক উত্তর: ${item.answer}',
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: isCorrect
                        ? AppTheme.primaryGreen
                        : const Color(0xFFD63031)))),
      ],
      _primaryButton(
          !_checked
              ? 'উত্তর মিলিয়ে দেখি'
              : (_itemIndex == 9 ? 'ফলাফল দেখি' : 'পরের প্রশ্ন'),
          !_checked
              ? Icons.check_rounded
              : Icons.arrow_forward_rounded, () {
        if (_selected == null) return;
        if (!_checked) {
          final correct = options[_selected!] == item.answer;
          if (!_firstAttemptStatus.containsKey(_itemIndex)) {
            _firstAttemptStatus[_itemIndex] = correct;
            if (correct) {
              _correctAnswers++;
            }
          }
          setState(() => _checked = true);
          return;
        }
        if (_itemIndex < 9) {
          setState(() {
            _itemIndex++;
            _selected = null;
            _checked = false;
          });
          _saveCurrentProgress();
          return;
        }
        _finishChapter();
      }, enabled: _checked || _selected != null),
      if (!_checked) ...[
        const SizedBox(height: 10),
        Center(
          child: TextButton.icon(
            onPressed: () {
              if (!_firstAttemptStatus.containsKey(_itemIndex)) {
                _firstAttemptStatus[_itemIndex] = false;
                _unansweredCount++;
              }
              if (_itemIndex < 9) {
                setState(() {
                  _itemIndex++;
                  _selected = null;
                  _checked = false;
                });
                _saveCurrentProgress();
              } else {
                _finishChapter();
              }
            },
            icon: const Icon(Icons.skip_next_rounded, size: 18),
            label: const LocalizedText('প্রশ্নটি এড়িয়ে যাই'),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.darkText.withValues(alpha: 0.6),
            ),
          ),
        ),
      ],
    ]);
  }

  Widget _resultContent(_Chapter chapter, bool tablet) {
    final score = _correctAnswers;
    final total = chapter.quiz.length;
    final incorrect = total - score - _unansweredCount;
    final earned = _lastCompletionEarnedXp;

    return ListView(
      padding: EdgeInsets.all(tablet ? 32 : 20),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppTheme.primaryGreen.withValues(alpha: 0.25),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: score >= 7
                      ? const Color(0xFFDDF4E9)
                      : const Color(0xFFFFF4D4),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    score >= 7
                        ? Icons.emoji_events_rounded
                        : Icons.stars_rounded,
                    color: score >= 7
                        ? AppTheme.primaryGreen
                        : const Color(0xFFD4A017),
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const LocalizedText(
                'কুইজের ফলাফল',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.darkText,
                ),
              ),
              const SizedBox(height: 8),
              LocalizedText(
                '$score / $total',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  color: score >= 7
                      ? AppTheme.primaryGreen
                      : const Color(0xFFD4A017),
                ),
              ),
              const SizedBox(height: 8),
              LocalizedText(
                score == 10
                    ? 'মাশাআল্লাহ! তুমি সব প্রশ্নের সঠিক উত্তর দিয়েছো!'
                    : score >= 7
                        ? 'খুব ভালো! তুমি সফলভাবে অধ্যায়টি সম্পন্ন করেছ।'
                        : 'তুমি চেষ্টা করেছো! অধ্যায়টি আবার পড়ে আরও ভালো করতে পারো।',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.darkText.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: earned
                      ? const Color(0xFFE8F8D8)
                      : const Color(0xFFF1EEE7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      earned
                          ? Icons.add_circle_rounded
                          : Icons.check_circle_rounded,
                      size: 18,
                      color: AppTheme.primaryGreen,
                    ),
                    const SizedBox(width: 6),
                    LocalizedText(
                      earned
                          ? '+২৫ XP অর্জিত হয়েছে!'
                          : '+২৫ XP আগেই অর্জিত হয়েছে',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        color: AppTheme.primaryGreen,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ResultStat(
                    label: 'সঠিক',
                    value: '$score',
                    color: const Color(0xFF58A700),
                  ),
                  _ResultStat(
                    label: 'ভুল',
                    value: '$incorrect',
                    color: const Color(0xFFD63031),
                  ),
                  if (_unansweredCount > 0)
                    _ResultStat(
                      label: 'এড়ানো',
                      value: '$_unansweredCount',
                      color: const Color(0xFF888888),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _primaryButton(
          'কুইজ পুনরায় দিন (Retry)',
          Icons.refresh_rounded,
          _retryQuiz,
        ),
        const SizedBox(height: 10),
        Duolingo3DButton(
          text: 'অধ্যায় তালিকায় ফিরুন',
          icon: const Icon(Icons.list_rounded),
          color: const Color(0xFF0D7377),
          onPressed: () => setState(() => _chapterIndex = null),
        ),
        const SizedBox(height: 10),
        Center(
          child: TextButton.icon(
            onPressed: _restartChapter,
            icon: const Icon(Icons.auto_stories_rounded, size: 18),
            label: const LocalizedText('অধ্যায়টি শুরু থেকে আবার পড়ুন'),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.darkText.withValues(alpha: 0.7),
            ),
          ),
        ),
      ],
    );
  }

  List<String> _optionsFor(_Chapter chapter, int index) {
    final correct = chapter.quiz[index].answer;
    final wrong = <String>[];
    for (var offset = 1;
        wrong.length < 2 && offset < chapter.quiz.length;
        offset++) {
      final value = chapter.quiz[(index + offset) % chapter.quiz.length].answer;
      if (value != correct && !wrong.contains(value)) wrong.add(value);
    }
    final list = [correct, ...wrong];
    // Stable per-question shuffle so the answer position isn't always first.
    final shift = index % list.length;
    return [...list.skip(shift), ...list.take(shift)];
  }

  String _reflectionQuestion(_Chapter chapter, int index) {
    const prompts = [
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
    ];
    return '${chapter.quiz[index].question} ${prompts[index]}';
  }

  Widget _primaryButton(String label, IconData icon, VoidCallback onPressed,
          {bool enabled = true}) =>
      Opacity(
        opacity: enabled ? 1 : .45,
        child: Duolingo3DButton(
          text: label,
          icon: Icon(icon),
          color: AppTheme.primaryGreen,
          onPressed: enabled ? onPressed : () {},
        ),
      );
}

class _ChapterCard extends StatelessWidget {
  const _ChapterCard(
      {required this.chapter,
      required this.index,
      required this.completed,
      required this.inProgress,
      required this.quizScore,
      required this.locked,
      required this.onTap});
  final _Chapter chapter;
  final int index;
  final bool completed, inProgress, locked;
  final int? quizScore;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => DuolingoCard(
      onTap: locked ? null : onTap,
      accentColor: completed ? AppTheme.primaryGreen : const Color(0xFF0D7377),
      backgroundColor: locked ? const Color(0xFFF1EEE7) : Colors.white,
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(15),
      child: Row(children: [
        CircleAvatar(
            radius: 25,
            backgroundColor: chapter.color,
            child: Icon(locked ? Icons.lock_rounded : chapter.icon,
                color: AppTheme.primaryGreen)),
        const SizedBox(width: 13),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          LocalizedText('অধ্যায় ${index + 1}',
              style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.primaryGreen)),
          const SizedBox(height: 2),
          LocalizedText(chapter.title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.darkText)),
          const SizedBox(height: 3),
          LocalizedText(
              completed
                  ? 'সম্পন্ন · কুইজ ${quizScore ?? 10}/১০ · চাইলে আবার পড়ো'
                  : locked
                      ? 'আগের অধ্যায় শেষ হলে খুলবে'
                      : inProgress
                          ? 'এখান থেকে আবার শুরু করো'
                          : 'ছবি · গল্প · ১০ ভাবনা · ১০ কুইজ',
              style: const TextStyle(fontSize: 11, color: Colors.black54))
        ])),
        Icon(
            completed
                ? Icons.check_circle_rounded
                : locked
                    ? Icons.lock_rounded
                    : Icons.arrow_forward_ios_rounded,
            color: completed ? AppTheme.primaryGreen : Colors.black38,
            size: 19)
      ]));
}

class _IllustrationCard extends StatelessWidget {
  const _IllustrationCard({required this.chapter, this.compact = false});
  final _Chapter chapter;
  final bool compact;
  @override
  Widget build(BuildContext context) => Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 15 : 22),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [chapter.color, Colors.white]),
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
                color: chapter.color.withValues(alpha: .9),
                blurRadius: 15,
                offset: const Offset(0, 7))
          ]),
      child: Row(children: [
        Container(
            width: compact ? 62 : 84,
            height: compact ? 62 : 84,
            decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .82),
                shape: BoxShape.circle),
            child: Icon(chapter.icon,
                size: compact ? 34 : 48, color: AppTheme.primaryGreen)),
        const SizedBox(width: 16),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          LocalizedText(chapter.title,
              style: TextStyle(
                  fontSize: compact ? 18 : 22,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.darkText)),
          const SizedBox(height: 5),
          LocalizedText(compact ? 'গল্পের কথা মনে রাখি' : 'দেখি · বুঝি · শিখি',
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryGreen))
        ]))
      ]));
}

class _StageLabel extends StatelessWidget {
  const _StageLabel(
      {required this.color,
      required this.icon,
      required this.title,
      required this.subtitle});
  final Color color;
  final IconData icon;
  final String title, subtitle;
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(17),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(21)),
      child: Row(children: [
        CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(icon, color: AppTheme.primaryGreen)),
        const SizedBox(width: 12),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          LocalizedText(title,
              style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.darkText)),
          LocalizedText(subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.black54))
        ]))
      ]));
}

class _QuizOption extends StatelessWidget {
  const _QuizOption(
      {required this.text,
      required this.selected,
      required this.correct,
      required this.color,
      required this.onTap});
  final String text;
  final bool selected, correct;
  final Color color;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Material(
      color: Colors.transparent,
      child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(17),
          child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: correct
                      ? const Color(0xFFDDF4E9)
                      : selected
                          ? color
                          : Colors.white,
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(
                      color: correct || selected
                          ? AppTheme.primaryGreen
                          : Colors.white,
                      width: 2)),
              child: Row(children: [
                Icon(
                    correct
                        ? Icons.check_circle_rounded
                        : selected
                            ? Icons.radio_button_checked_rounded
                            : Icons.circle_outlined,
                    color: AppTheme.primaryGreen),
                const SizedBox(width: 11),
                Expanded(
                    child: LocalizedText(text,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.darkText)))
              ]))));
}

class _ResultStat extends StatelessWidget {
  const _ResultStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LocalizedText(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        LocalizedText(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.darkText.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}

