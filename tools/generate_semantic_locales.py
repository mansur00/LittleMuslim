import json
import os

semantic_en = {
    # App
    "app.name": "Little Muslim",
    "app.tagline": "Fun & Interactive Islamic Learning for Children",
    "app.version": "Version {{version}}",
    "app.copyright": "© 2026 Little Muslim. All rights reserved.",

    # Navigation
    "nav.home": "Learn",
    "nav.qaida": "Qaida",
    "nav.quran": "Quran",
    "nav.prayer": "Prayer",
    "nav.profile": "Profile",
    "nav.back": "Back",
    "nav.next": "Next",
    "nav.close": "Close",
    "nav.skip": "Skip",

    # Authentication & Profile
    "auth.login": "Login",
    "auth.logout": "Log Out",
    "auth.email": "Email",
    "auth.password": "Password",
    "auth.guest": "Continue as Guest",
    "auth.parent_portal": "Parent Portal",
    "auth.pin": "PIN Code",
    "auth.login_success": "Login successful! Welcome.",
    "auth.login_error": "Invalid email or password.",
    "auth.profile_updated": "Profile successfully updated!",

    # Validation
    "validation.required": "This field is required",
    "validation.email_invalid": "Please enter a valid email address",
    "validation.password_min": "Password must be at least 6 characters",
    "validation.name_required": "Please enter your name",

    # Onboarding
    "onboarding.welcome_title": "Welcome to Little Muslim",
    "onboarding.welcome_subtitle": "Learn Arabic letters, daily prayers, and Quran with fun games",
    "onboarding.choose_language": "Choose a language",
    "onboarding.language_hint": "Choose the app language. You can change it later.",
    "onboarding.enter_name": "What is your name?",
    "onboarding.name_placeholder": "Enter your name",
    "onboarding.select_age": "How old are you?",
    "onboarding.ready_title": "You are ready!",
    "onboarding.ready_subtitle": "Let's begin your wonderful Islamic learning journey",
    "onboarding.start_journey": "Start Learning",

    # Qaida Track
    "qaida.title": "Nurani Qaida",
    "qaida.subtitle": "Master Arabic alphabet & correct Makhraj",
    "qaida.step": "Step {{stepNumber}}",
    "qaida.step_with_title": "Step {{stepNumber}}: {{title}}",
    "qaida.lesson": "Lesson {{lessonNumber}}",
    "qaida.locked": "Locked",
    "qaida.completed": "Completed",
    "qaida.in_progress": "In Progress",
    "qaida.continue_lesson": "Continue Lesson",
    "qaida.check_answer": "Check Answer",
    "qaida.correct": "MashaAllah! Correct!",
    "qaida.incorrect": "Try again — you can do it!",
    "qaida.parent_help": "Ask a grown-up for help",
    "qaida.parent_verify_prompt": "Did the child pronounce \"{{letter}}\" correctly?",
    "qaida.parent_confirm": "Yes, Correct",
    "qaida.parent_retry": "Retry",
    "qaida.audio_unavailable": "Sound is unavailable on this device.",
    "qaida.admin_unlock": "Admin Unlock",
    "qaida.quit_dialog_title": "Exit lesson?",
    "qaida.quit_dialog_body": "Your progress (Step {{stepNumber}}) will be saved. You can resume anytime.",
    "qaida.quit_dialog_stay": "Keep Reading",
    "qaida.quit_dialog_exit": "Exit",

    # Quran
    "quran.title": "Holy Quran",
    "quran.surah": "Surah",
    "quran.ayah": "Ayah",
    "quran.juz": "Juz",
    "quran.bookmarks": "Bookmarks",
    "quran.no_bookmarks": "No saved ayahs yet",
    "quran.reciter": "Reciter",
    "quran.play": "Play",
    "quran.pause": "Pause",
    "quran.continue_reading": "Continue Reading",
    "quran.surah_ayah_info": "Surah {{surah}} · Ayah {{ayah}}",

    # Prayer Times & Guide
    "prayer.title": "Prayer Times",
    "prayer.fajr": "Fajr",
    "prayer.dhuhr": "Dhuhr",
    "prayer.asr": "Asr",
    "prayer.maghrib": "Maghrib",
    "prayer.isha": "Isha",
    "prayer.next_prayer": "Next Prayer: {{prayer}} in {{time}}",
    "prayer.wudu": "Wudu Guide",
    "prayer.rakat": "Rakat Guide",
    "prayer.qibla": "Qibla Compass",
    "prayer.alerts_enabled": "Play Adhan at prayer times",
    "prayer.countdown": "Next Prayer: {{prayer}} ({{time}} remaining)",

    # Duas & Supplications
    "duas.title": "Duas & Adhkar",
    "duas.daily": "Daily",
    "duas.prayer_duas": "Prayer",
    "duas.morning_evening": "Morning & Evening",
    "duas.favorites": "Favorites",
    "duas.no_favorites": "No favorite duas added yet",
    "duas.copied": "Dua copied to clipboard",
    "duas.favorite_added": "Added to favorites",
    "duas.favorite_removed": "Removed from favorites",
    "duas.counter": "Count: {{count}}",

    # Islamic Basics
    "basics.title": "Islamic Basics",
    "basics.pillars": "5 Pillars of Islam",
    "basics.faith": "6 Articles of Faith",
    "basics.kalimas": "Kalimas",
    "basics.ethics": "Manners & Character",
    "basics.quiz": "Quiz",
    "basics.quiz_restart": "Restart Quiz",

    # Seerah Stories
    "seerah.title": "Prophet Stories",
    "seerah.timeline": "Timeline",
    "seerah.read_story": "Read Story",
    "seerah.moral": "Moral Lesson",
    "seerah.completed": "Story Completed",

    # Live Learning
    "live.title": "Live Class",
    "live.teacher": "Teacher: {{name}}",
    "live.schedule": "Class Schedule",
    "live.join": "Join Class",
    "live.upcoming": "Upcoming",
    "live.completed": "Completed",
    "live.booking_success": "Class booked successfully! Notification will be sent.",

    # Missions & Streaks
    "missions.title": "Daily Missions",
    "missions.streak": "{{count}} Day Streak",
    "missions.streak_days.zero": "0 Days",
    "missions.streak_days.one": "1 Day",
    "missions.streak_days.other": "{{count}} Days",
    "missions.xp_reward": "+{{amount}} XP",
    "missions.completed_all": "All daily missions completed today! MashaAllah!",

    # Achievements
    "achievements.title": "Achievements & Badges",
    "achievements.level": "Level {{level}}: {{name}}",
    "achievements.next_level": "Next level in {{amount}} XP",
    "achievements.badges": "Badges Earned",

    # Settings
    "settings.title": "Settings",
    "settings.subtitle": "Make your learning experience your own",
    "settings.language": "App language",
    "settings.alarm": "Daily Study Alarm",
    "settings.alarm_time": "Alarm Time: {{time}}",
    "settings.sound_effects": "Sound Effects",
    "settings.notifications": "Notification",
    "settings.privacy": "Child Privacy Policy",
    "settings.privacy_body": "Little Muslim protects children's privacy. All progress is stored locally on this device.",
    "settings.reset_data": "Reset All Progress",
    "settings.reset_warning": "Are you sure? This will delete all XP, streaks, and progress.",
    "settings.reset_success": "All data deleted successfully.",
    "settings.payment_placeholder": "Subscription & payments coming soon.",

    # Common
    "common.save": "Save",
    "common.cancel": "Cancel",
    "common.confirm": "Confirm",
    "common.retry": "Retry",
    "common.continue_btn": "Continue",
    "common.done": "Completed",
    "common.skip": "Skip",
    "common.loading": "Loading...",
    "common.error": "An error occurred",
    "common.success": "Success",
    "common.age_years": "{{age}} years",
}

semantic_bn = {
    # App
    "app.name": "লিটল মুসলিম",
    "app.tagline": "শিশুদের জন্য আনন্দময় ইসলামিক শিক্ষা",
    "app.version": "ভার্সন {{version}}",
    "app.copyright": "© ২০২৬ লিটল মুসলিম। সর্বস্বত্ব সংরক্ষিত।",

    # Navigation
    "nav.home": "শেখা",
    "nav.qaida": "কায়দা",
    "nav.quran": "কুরআন",
    "nav.prayer": "নামাজ",
    "nav.profile": "প্রোফাইল",
    "nav.back": "পেছনে",
    "nav.next": "পরবর্তী",
    "nav.close": "বন্ধ করুন",
    "nav.skip": "স্কিপ",

    # Authentication & Profile
    "auth.login": "লগইন",
    "auth.logout": "লগআউট",
    "auth.email": "ইমেইল",
    "auth.password": "পাসওয়ার্ড",
    "auth.guest": "লগইন ছাড়াই চালিয়ে যাই",
    "auth.parent_portal": "অভিভাবক পোর্টাল",
    "auth.pin": "পিন কোড",
    "auth.login_success": "লগইন সফল হয়েছে! স্বাগতম।",
    "auth.login_error": "ইমেইল বা পাসওয়ার্ড সঠিক নয়।",
    "auth.profile_updated": "প্রোফাইল সফলভাবে আপডেট হয়েছে!",

    # Validation
    "validation.required": "এই তথ্যটি দেওয়া আবশ্যক",
    "validation.email_invalid": "অনুগ্রহ করে একটি সঠিক ইমেইল ঠিকানা দিন",
    "validation.password_min": "পাসওয়ার্ড কমপক্ষে ৬ অক্ষরের হতে হবে",
    "validation.name_required": "অনুগ্রহ করে তোমার নাম লেখো",

    # Onboarding
    "onboarding.welcome_title": "লিটল মুসলিমে স্বাগতম",
    "onboarding.welcome_subtitle": "খেলার ছলে আরবি হরফ, নামাজ ও কুরআন শেখার সহজ অ্যাপ",
    "onboarding.choose_language": "ভাষা বেছে নাও",
    "onboarding.language_hint": "অ্যাপের ভাষা নির্বাচন করো। পরে পরিবর্তন করা যাবে।",
    "onboarding.enter_name": "তোমার নাম কী?",
    "onboarding.name_placeholder": "তোমার নাম লেখো",
    "onboarding.select_age": "তোমার বয়স কত?",
    "onboarding.ready_title": "তুমি প্রস্তুত!",
    "onboarding.ready_subtitle": "এসো শুরু করি আনন্দময় ইসলামিক শেখার যাত্রা",
    "onboarding.start_journey": "শেখা শুরু করি",

    # Qaida Track
    "qaida.title": "নূরানী কায়দা",
    "qaida.subtitle": "সহীহ মাখরাজে আরবি হরফ চেনা ও পড়া",
    "qaida.step": "ধাপ {{stepNumber}}",
    "qaida.step_with_title": "ধাপ {{stepNumber}}: {{title}}",
    "qaida.lesson": "পাঠ {{lessonNumber}}",
    "qaida.locked": "লক",
    "qaida.completed": "সম্পন্ন",
    "qaida.in_progress": "চলমান",
    "qaida.continue_lesson": "পাঠ চালিয়ে যাও",
    "qaida.check_answer": "যাচাই করো",
    "qaida.correct": "মাশাআল্লাহ! সঠিক হয়েছে!",
    "qaida.incorrect": "আবার চেষ্টা করো — তুমি পারবে!",
    "qaida.parent_help": "অভিভাবকের সাহায্য",
    "qaida.parent_verify_prompt": "শিশুটি কি “{{letter}}” হরফটি সঠিক বলেছে?",
    "qaida.parent_confirm": "হ্যাঁ, সঠিক হয়েছে",
    "qaida.parent_retry": "আবার চেষ্টা",
    "qaida.audio_unavailable": "এই ডিভাইসে শব্দ শোনানো যাচ্ছে না।",
    "qaida.admin_unlock": "অ্যাডমিন আনলক",
    "qaida.quit_dialog_title": "পাঠ থেকে বের হবে?",
    "qaida.quit_dialog_body": "তোমার অগ্রগতি (ধাপ {{stepNumber}}) সংরক্ষিত থাকবে। পরে যেকোনো সময় এখান থেকে শুরু করতে পারবে।",
    "qaida.quit_dialog_stay": "পড়তে থাকি",
    "qaida.quit_dialog_exit": "বের হই",

    # Quran
    "quran.title": "আল-কুরআন",
    "quran.surah": "সূরা",
    "quran.ayah": "আয়াত",
    "quran.juz": "পারা",
    "quran.bookmarks": "সংরক্ষিত",
    "quran.no_bookmarks": "কোনো সংরক্ষিত আয়াত নেই",
    "quran.reciter": "ক্বারী",
    "quran.play": "চালু করুন",
    "quran.pause": "থামান",
    "quran.continue_reading": "পড়া চালিয়ে যাই",
    "quran.surah_ayah_info": "সূরা {{surah}} · আয়াত {{ayah}}",

    # Prayer Times & Guide
    "prayer.title": "নামাজের সময়সূচি",
    "prayer.fajr": "ফজর",
    "prayer.dhuhr": "যোহর",
    "prayer.asr": "আসর",
    "prayer.maghrib": "মাগরিব",
    "prayer.isha": "ইশা",
    "prayer.next_prayer": "পরবর্তী নামাজ: {{prayer}} আর {{time}} পর",
    "prayer.wudu": "অজু শিক্ষা",
    "prayer.rakat": "নামাজের রাকাত",
    "prayer.qibla": "কিবলা কম্পাস",
    "prayer.alerts_enabled": "নামাজের সময় আযান বাজবে",
    "prayer.countdown": "পরবর্তী নামাজ: {{prayer}} (আর {{time}} বাকি)",

    # Duas & Supplications
    "duas.title": "দুআ ও যিকির",
    "duas.daily": "দৈনন্দিন",
    "duas.prayer_duas": "নামাজ",
    "duas.morning_evening": "সকাল-সন্ধ্যা",
    "duas.favorites": "পছন্দের",
    "duas.no_favorites": "পছন্দের কোনো দুআ যুক্ত করা হয়নি",
    "duas.copied": "দুআ কপি করা হয়েছে!",
    "duas.favorite_added": "পছন্দের তালিকায় যুক্ত হয়েছে।",
    "duas.favorite_removed": "পছন্দের তালিকা থেকে সরানো হয়েছে।",
    "duas.counter": "গণনা: {{count}}",

    # Islamic Basics
    "basics.title": "ইসলামের বুনিয়াদ",
    "basics.pillars": "ইসলামের ৫টি স্তম্ভ",
    "basics.faith": "ঈমানের ৬টি রুকন",
    "basics.kalimas": "কালেমা",
    "basics.ethics": "নৈতিকতা ও শিষ্টাচার",
    "basics.quiz": "কুইজ",
    "basics.quiz_restart": "কুইজ পুনরায় শুরু করুন",

    # Seerah Stories
    "seerah.title": "নবীদের জীবনকাহিনি",
    "seerah.timeline": "টাইমলাইন",
    "seerah.read_story": "গল্প পড়ি",
    "seerah.moral": "নৈতিক শিক্ষা",
    "seerah.completed": "গল্প সম্পন্ন হয়েছে",

    # Live Learning
    "live.title": "লাইভ ক্লাস",
    "live.teacher": "শিক্ষক: {{name}}",
    "live.schedule": "ক্লাস শিডিউল",
    "live.join": "ক্লাসে যুক্ত হোন",
    "live.upcoming": "আসন্ন",
    "live.completed": "সম্পন্ন",
    "live.booking_success": "ক্লাস বুকিং সফল হয়েছে! ক্লাসের সময় নোটিফিকেশন পাঠানো হবে।",

    # Missions & Streaks
    "missions.title": "দৈনিক মিশন",
    "missions.streak": "{{count}} দিনের স্ট্রিক",
    "missions.streak_days.zero": "০ দিন",
    "missions.streak_days.one": "১ দিন",
    "missions.streak_days.other": "{{count}} দিন",
    "missions.xp_reward": "+{{amount}} XP",
    "missions.completed_all": "আজকের সব মিশন সম্পন্ন হয়েছে! মাশাআল্লাহ!",

    # Achievements
    "achievements.title": "অর্জন ও ব্যাজ",
    "achievements.level": "লেভেল {{level}}: {{name}}",
    "achievements.next_level": "পরের লেভেল আর {{amount}} XP পর",
    "achievements.badges": "অর্জিত ব্যাজ",

    # Settings
    "settings.title": "সেটিংস",
    "settings.subtitle": "শেখার অভিজ্ঞতা নিজের মতো সাজাও",
    "settings.language": "অ্যাপের ভাষা",
    "settings.alarm": "দৈনিক পড়ার অ্যালার্ম",
    "settings.alarm_time": "পড়ার অ্যালার্মের সময়: {{time}}",
    "settings.sound_effects": "শব্দ ইফেক্ট",
    "settings.notifications": "নোটিফিকেশন",
    "settings.privacy": "শিশু প্রাইভেসি নীতি",
    "settings.privacy_body": "LittleMuslim শিশুদের গোপনীয়তা রক্ষা করে। যাবতীয় অগ্রগতি স্থানীয়ভাবে ডিভাইসে সংরক্ষিত থাকে।",
    "settings.reset_data": "সব ডেটা মুছে ফেলুন",
    "settings.reset_warning": "সব ডেটা মুছে ফেলবেন? আপনার অর্জিত XP, স্ট্রিক ও অগ্রগতি সব মুছে যাবে।",
    "settings.reset_success": "সব ডেটা সফলভাবে মুছে ফেলা হয়েছে।",
    "settings.payment_placeholder": "পেমেন্ট এখনো যুক্ত হয়নি।",

    # Common
    "common.save": "সংরক্ষণ",
    "common.cancel": "বাতিল",
    "common.confirm": "নিশ্চিত",
    "common.retry": "পুনরায় চেষ্টা",
    "common.continue_btn": "চালিয়ে যাই",
    "common.done": "সম্পন্ন",
    "common.skip": "স্কিপ",
    "common.loading": "লোড হচ্ছে...",
    "common.error": "একটি সমস্যা হয়েছে",
    "common.success": "সফল",
    "common.age_years": "বয়স {{age}} বছর",
}

semantic_hi = {
    # App
    "app.name": "लिटिल मुस्लिम",
    "app.tagline": "बच्चों के लिए मजेदार इस्लामी शिक्षा",
    "app.version": "संस्करण {{version}}",
    "app.copyright": "© 2026 लिटिल मुस्लिम। सर्वाधिकार सुरक्षित।",

    # Navigation
    "nav.home": "सीखें",
    "nav.qaida": "कायदा",
    "nav.quran": "कुरआन",
    "nav.prayer": "नमाज़",
    "nav.profile": "प्रोफाइल",
    "nav.back": "पीछे",
    "nav.next": "आगे",
    "nav.close": "बंद करें",
    "nav.skip": "छोड़ें",

    # Authentication & Profile
    "auth.login": "लॉग इन",
    "auth.logout": "लॉग आउट",
    "auth.email": "ईमेल",
    "auth.password": "पासवर्ड",
    "auth.guest": "अतिथि के रूप में जारी रखें",
    "auth.parent_portal": "अभिभावक पोर्टल",
    "auth.pin": "पिन कोड",
    "auth.login_success": "लॉगिन सफल! स्वागत है।",
    "auth.login_error": "अमान्य ईमेल या पासवर्ड।",
    "auth.profile_updated": "प्रोफाइल सफलतापूर्वक अपडेट हो गई!",

    # Validation
    "validation.required": "यह जानकारी आवश्यक है",
    "validation.email_invalid": "कृपया एक वैध ईमेल पता दर्ज करें",
    "validation.password_min": "पासवर्ड कम से कम 6 अक्षरों का होना चाहिए",
    "validation.name_required": "कृपया अपना नाम लिखें",

    # Onboarding
    "onboarding.welcome_title": "लिटिल मुस्लिम में आपका स्वागत है",
    "onboarding.welcome_subtitle": "खेल-खेल में अरबी अक्षर, नमाज़ और कुरआन सीखें",
    "onboarding.choose_language": "अपनी भाषा चुनें",
    "onboarding.language_hint": "ऐप की भाषा चुनें। इसे बाद में बदला जा सकता है।",
    "onboarding.enter_name": "आपका नाम क्या है?",
    "onboarding.name_placeholder": "अपना नाम दर्ज करें",
    "onboarding.select_age": "आपकी आयु कितनी है?",
    "onboarding.ready_title": "आप तैयार हैं!",
    "onboarding.ready_subtitle": "आइए इस्लामिक शिक्षा का सुंदर सफर शुरू करें",
    "onboarding.start_journey": "सीखना शुरू करें",

    # Qaida Track
    "qaida.title": "नूरानी कायदा",
    "qaida.subtitle": "सही मखरज के साथ अरबी अक्षर पहचानें और पढ़ें",
    "qaida.step": "चरण {{stepNumber}}",
    "qaida.step_with_title": "चरण {{stepNumber}}: {{title}}",
    "qaida.lesson": "पाठ {{lessonNumber}}",
    "qaida.locked": "बंद",
    "qaida.completed": "पूरा हुआ",
    "qaida.in_progress": "जारी है",
    "qaida.continue_lesson": "पाठ जारी रखें",
    "qaida.check_answer": "जांचें",
    "qaida.correct": "माशाअल्लाह! सही जवाब!",
    "qaida.incorrect": "फिर से प्रयास करें — आप कर सकते हैं!",
    "qaida.parent_help": "अभिभावक की सहायता",
    "qaida.parent_verify_prompt": "क्या बच्चे ने \"{{letter}}\" सही उच्चारण किया?",
    "qaida.parent_confirm": "हाँ, सही है",
    "qaida.parent_retry": "फिर कोशिश करें",
    "qaida.audio_unavailable": "इस डिवाइस पर ऑडियो उपलब्ध नहीं है",
    "qaida.admin_unlock": "एडमिन अनलॉक",
    "qaida.quit_dialog_title": "क्या पाठ से बाहर जाना चाहते हैं?",
    "qaida.quit_dialog_body": "आपकी प्रगति (चरण {{stepNumber}}) सुरक्षित रहेगी। आप कभी भी फिर शुरू कर सकते हैं।",
    "qaida.quit_dialog_stay": "सीखते रहें",
    "qaida.quit_dialog_exit": "बाहर जाएं",

    # Quran
    "quran.title": "पवित्र कुरआन",
    "quran.surah": "सूरह",
    "quran.ayah": "आयत",
    "quran.juz": "पारा",
    "quran.bookmarks": "बुकमार्क",
    "quran.no_bookmarks": "कोई सहेजी गई आयत नहीं है",
    "quran.reciter": "कारी",
    "quran.play": "चलाएं",
    "quran.pause": "रोकें",
    "quran.continue_reading": "पढ़ना जारी रखें",
    "quran.surah_ayah_info": "सूरह {{surah}} · आयत {{ayah}}",

    # Prayer Times & Guide
    "prayer.title": "नमाज़ का समय",
    "prayer.fajr": "फज्र",
    "prayer.dhuhr": "जुहर",
    "prayer.asr": "अस्र",
    "prayer.maghrib": "मग़रिब",
    "prayer.isha": "इशा",
    "prayer.next_prayer": "अगली नमाज़: {{prayer}} {{time}} में",
    "prayer.wudu": "वुज़ू गाइड",
    "prayer.rakat": "रकात गाइड",
    "prayer.qibla": "क़िबला कंपास",
    "prayer.alerts_enabled": "नमाज़ अज़ान अलर्ट",
    "prayer.countdown": "अगली नमाज़: {{prayer}} ({{time}} शेष)",

    # Duas & Supplications
    "duas.title": "दुआएं और अज़कार",
    "duas.daily": "दैनिक",
    "duas.prayer_duas": "नमाज़",
    "duas.morning_evening": "सुबह-शाम",
    "duas.favorites": "पसंदीदा",
    "duas.no_favorites": "कोई पसंदीदा दुआ नहीं जोड़ी गई",
    "duas.copied": "दुआ कॉपी हो गई!",
    "duas.favorite_added": "पसंदीदा में जोड़ा गया।",
    "duas.favorite_removed": "पसंदीदा से हटाया गया।",
    "duas.counter": "गिनती: {{count}}",

    # Islamic Basics
    "basics.title": "इस्लाम के बुनियादी उसूल",
    "basics.pillars": "इस्लाम के 5 स्तंभ",
    "basics.faith": "ईमान के 6 अरकान",
    "basics.kalimas": "कलिमा",
    "basics.ethics": "अखलाक व आदाब",
    "basics.quiz": "प्रश्नोत्तरी",
    "basics.quiz_restart": "क्विज दोबारा शुरू करें",

    # Seerah Stories
    "seerah.title": "नबियों की कहानियां",
    "seerah.timeline": "समयरेखा",
    "seerah.read_story": "कहानी पढ़ें",
    "seerah.moral": "नैतिक शिक्षा",
    "seerah.completed": "कहानी पूरी हुई",

    # Live Learning
    "live.title": "लाइव कक्षाएं",
    "live.teacher": "शिक्षक: {{name}}",
    "live.schedule": "कक्षा अनुसूची",
    "live.join": "कक्षा में शामिल हों",
    "live.upcoming": "आगामी",
    "live.completed": "पूर्ण",
    "live.booking_success": "कक्षा बुकिंग सफल! कक्षा समय पर सूचना भेजी जाएगी।",

    # Missions & Streaks
    "missions.title": "दैनिक मिशन",
    "missions.streak": "{{count}} दिन की स्ट्रीक",
    "missions.streak_days.zero": "0 दिन",
    "missions.streak_days.one": "1 दिन",
    "missions.streak_days.other": "{{count}} दिन",
    "missions.xp_reward": "+{{amount}} XP",
    "missions.completed_all": "आज के सभी मिशन पूरे हो गए! माशाअल्लाह!",

    # Achievements
    "achievements.title": "उपलब्धियां और बैज",
    "achievements.level": "स्तर {{level}}: {{name}}",
    "achievements.next_level": "अगले स्तर के लिए {{amount}} XP शेष",
    "achievements.badges": "अर्जित बैज",

    # Settings
    "settings.title": "सेटिंग्स",
    "settings.subtitle": "सीखने के अनुभव को अपने अनुसार बनाएं",
    "settings.language": "ऐप की भाषा",
    "settings.alarm": "दैनिक अध्ययन अलार्म",
    "settings.alarm_time": "अलार्म समय: {{time}}",
    "settings.sound_effects": "ध्वनि प्रभाव",
    "settings.notifications": "सूचनाएं",
    "settings.privacy": "बाल गोपनीयता नीति",
    "settings.privacy_body": "लिटिल मुस्लिम बच्चों की गोपनीयता की रक्षा करता है। समस्त प्रगति इसी डिवाइस में सुरक्षित है।",
    "settings.reset_data": "सभी डेटा रीसेट करें",
    "settings.reset_warning": "क्या आप निश्चित हैं? यह आपके सभी XP, स्ट्रीक और प्रगति को मिटा देगा।",
    "settings.reset_success": "सभी डेटा सफलतापूर्वक रीसेट कर दिया गया है।",
    "settings.payment_placeholder": "सदस्यता और भुगतान जल्द आ रहे हैं।",

    # Common
    "common.save": "सहेजें",
    "common.cancel": "रद्द करें",
    "common.confirm": "पुष्टि करें",
    "common.retry": "पुनः प्रयास करें",
    "common.continue_btn": "जारी रखें",
    "common.done": "पूर्ण",
    "common.skip": "छोड़ें",
    "common.loading": "लोड हो रहा है...",
    "common.error": "एक त्रुटि हुई",
    "common.success": "सफल",
    "common.age_years": "आयु {{age}} वर्ष",
}

semantic_it = {
    # App
    "app.name": "Piccolo Musulmano",
    "app.tagline": "Apprendimento Islamico Divertente per Bambini",
    "app.version": "Versione {{version}}",
    "app.copyright": "© 2026 Piccolo Musulmano. Tutti i diritti riservati.",

    # Navigation
    "nav.home": "Impara",
    "nav.qaida": "Qaida",
    "nav.quran": "Corano",
    "nav.prayer": "Preghiera",
    "nav.profile": "Profilo",
    "nav.back": "Indietro",
    "nav.next": "Avanti",
    "nav.close": "Chiudi",
    "nav.skip": "Salta",

    # Authentication & Profile
    "auth.login": "Accedi",
    "auth.logout": "Esci",
    "auth.email": "Email",
    "auth.password": "Password",
    "auth.guest": "Continua come ospite",
    "auth.parent_portal": "Portale Genitori",
    "auth.pin": "Codice PIN",
    "auth.login_success": "Accesso riuscito! Benvenuto.",
    "auth.login_error": "Email o password non valida.",
    "auth.profile_updated": "Profilo aggiornato con successo!",

    # Validation
    "validation.required": "Questo campo è obbligatorio",
    "validation.email_invalid": "Inserisci un indirizzo email valido",
    "validation.password_min": "La password deve contenere almeno 6 caratteri",
    "validation.name_required": "Inserisci il tuo nome",

    # Onboarding
    "onboarding.welcome_title": "Benvenuto in Piccolo Musulmano",
    "onboarding.welcome_subtitle": "Impara le lettere arabe, le preghiere e il Corano divertendoti",
    "onboarding.choose_language": "Scegli la tua lingua",
    "onboarding.language_hint": "Seleziona la lingua dell'app. Puoi cambiarla più tardi.",
    "onboarding.enter_name": "Come ti chiami?",
    "onboarding.name_placeholder": "Inserisci il tuo nome",
    "onboarding.select_age": "Quanti anni hai?",
    "onboarding.ready_title": "Sei pronto!",
    "onboarding.ready_subtitle": "Iniziamo il tuo meraviglioso viaggio di apprendimento islamico",
    "onboarding.start_journey": "Inizia a Imparare",

    # Qaida Track
    "qaida.title": "Nurani Qaida",
    "qaida.subtitle": "Impara l'alfabeto arabo e la pronuncia corretta (Makhraj)",
    "qaida.step": "Passo {{stepNumber}}",
    "qaida.step_with_title": "Passo {{stepNumber}}: {{title}}",
    "qaida.lesson": "Lezione {{lessonNumber}}",
    "qaida.locked": "Bloccato",
    "qaida.completed": "Completato",
    "qaida.in_progress": "In corso",
    "qaida.continue_lesson": "Continua la lezione",
    "qaida.check_answer": "Verifica",
    "qaida.correct": "MashaAllah! Risposta esatta!",
    "qaida.incorrect": "Riprova — ce la puoi fare!",
    "qaida.parent_help": "Aiuto del genitore",
    "qaida.parent_verify_prompt": "Il bambino ha pronunciato correttamente la lettera \"{{letter}}\"?",
    "qaida.parent_confirm": "Sì, corretto",
    "qaida.parent_retry": "Riprova",
    "qaida.audio_unavailable": "Audio non disponibile su questo dispositivo",
    "qaida.admin_unlock": "Sblocco Amministratore",
    "qaida.quit_dialog_title": "Vuoi uscire dalla lezione?",
    "qaida.quit_dialog_body": "I tuoi progressi (Passo {{stepNumber}}) saranno salvati. Puoi riprendere quando vuoi.",
    "qaida.quit_dialog_stay": "Continua a imparare",
    "qaida.quit_dialog_exit": "Esci",

    # Quran
    "quran.title": "Sacro Corano",
    "quran.surah": "Sura",
    "quran.ayah": "Ayah",
    "quran.juz": "Juz",
    "quran.bookmarks": "Segnalibri",
    "quran.no_bookmarks": "Nessuna ayah salvata",
    "quran.reciter": "Recitatore",
    "quran.play": "Riproduci",
    "quran.pause": "Pausa",
    "quran.continue_reading": "Continua la lettura",
    "quran.surah_ayah_info": "Sura {{surah}} · Ayah {{ayah}}",

    # Prayer Times & Guide
    "prayer.title": "Orari delle Preghiere",
    "prayer.fajr": "Fajr",
    "prayer.dhuhr": "Dhuhr",
    "prayer.asr": "Asr",
    "prayer.maghrib": "Maghrib",
    "prayer.isha": "Isha",
    "prayer.next_prayer": "Prossima preghiera: {{prayer}} tra {{time}}",
    "prayer.wudu": "Guida al Wudu",
    "prayer.rakat": "Guida ai Rakat",
    "prayer.qibla": "Bussola Qibla",
    "prayer.alerts_enabled": "Avvisi Adhan di preghiera",
    "prayer.countdown": "Prossima preghiera: {{prayer}} ({{time}} rimanenti)",

    # Duas & Supplications
    "duas.title": "Dua e Adhkar",
    "duas.daily": "Quotidiane",
    "duas.prayer_duas": "Preghiera",
    "duas.morning_evening": "Mattina e Sera",
    "duas.favorites": "Preferiti",
    "duas.no_favorites": "Nessuna dua preferita aggiunta",
    "duas.copied": "Dua copiata negli appunti",
    "duas.favorite_added": "Aggiunta ai preferiti",
    "duas.favorite_removed": "Rimossa dai preferiti",
    "duas.counter": "Conteggio: {{count}}",

    # Islamic Basics
    "basics.title": "Basi dell'Islam",
    "basics.pillars": "5 Pilastri dell'Islam",
    "basics.faith": "6 Articoli di Fede",
    "basics.kalimas": "Kalima",
    "basics.ethics": "Buone maniere e carattere",
    "basics.quiz": "Quiz",
    "basics.quiz_restart": "Ricomincia il Quiz",

    # Seerah Stories
    "seerah.title": "Storie dei Profeti",
    "seerah.timeline": "Cronologia",
    "seerah.read_story": "Leggi la storia",
    "seerah.moral": "Insegnamento morale",
    "seerah.completed": "Storia completata",

    # Live Learning
    "live.title": "Lezioni dal Vivo",
    "live.teacher": "Insegnante: {{name}}",
    "live.schedule": "Orario delle lezioni",
    "live.join": "Partecipa alla lezione",
    "live.upcoming": "In arrivo",
    "live.completed": "Completata",
    "live.booking_success": "Prenotazione riuscita! Riceverai una notifica.",

    # Missions & Streaks
    "missions.title": "Missioni Quotidiane",
    "missions.streak": "Serie di {{count}} giorni",
    "missions.streak_days.zero": "0 giorni",
    "missions.streak_days.one": "1 giorno",
    "missions.streak_days.other": "{{count}} giorni",
    "missions.xp_reward": "+{{amount}} XP",
    "missions.completed_all": "Tutte le missioni di oggi completate! MashaAllah!",

    # Achievements
    "achievements.title": "Obiettivi e Medaglie",
    "achievements.level": "Livello {{level}}: {{name}}",
    "achievements.next_level": "Prossimo livello tra {{amount}} XP",
    "achievements.badges": "Medaglie ottenute",

    # Settings
    "settings.title": "Impostazioni",
    "settings.subtitle": "Personalizza la tua esperienza di apprendimento",
    "settings.language": "Lingua dell'applicazione",
    "settings.alarm": "Sveglia studio giornaliera",
    "settings.alarm_time": "Ora della sveglia: {{time}}",
    "settings.sound_effects": "Effetti sonori",
    "settings.notifications": "Notifiche",
    "settings.privacy": "Informativa sulla privacy dei minori",
    "settings.privacy_body": "Piccolo Musulmano tutela la privacy dei minori. Tutti i progressi sono memorizzati localmente su questo dispositivo.",
    "settings.reset_data": "Reimposta tutti i progressi",
    "settings.reset_warning": "Sei sicuro? Questo cancellerà tutti gli XP, le serie e i progressi.",
    "settings.reset_success": "Tutti i dati sono stati reimpostati con successo.",
    "settings.payment_placeholder": "Abbonamenti e pagamenti in arrivo.",

    # Common
    "common.save": "Salva",
    "common.cancel": "Annulla",
    "common.confirm": "Conferma",
    "common.retry": "Riprova",
    "common.continue_btn": "Continua",
    "common.done": "Fatto",
    "common.skip": "Salta",
    "common.loading": "Caricamento...",
    "common.error": "Si è verificato un errore",
    "common.success": "Successo",
    "common.age_years": "{{age}} anni",
}

# Verify key parity
assert set(semantic_en.keys()) == set(semantic_bn.keys()) == set(semantic_hi.keys()) == set(semantic_it.keys()), "Semantic key mismatch!"

# Now write JSON files to /locales and /assets/locales
for lang, data in [("en", semantic_en), ("bn", semantic_bn), ("hi", semantic_hi), ("it", semantic_it)]:
    for folder in ["locales", "assets/locales"]:
        os.makedirs(folder, exist_ok=True)
        path = os.path.join(folder, f"{lang}.json")
        with open(path, "w", encoding="utf-8") as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        print(f"Saved {path} with {len(data)} semantic keys.")

    # Also update ARB files with metadata
    arb_path = f"assets/l10n/app_{lang}.arb"
    if os.path.exists(arb_path):
        with open(arb_path, "r", encoding="utf-8") as f:
            arb_data = json.load(f)
        for k, v in data.items():
            arb_data[k] = v
            # Ensure metadata exists for every key
            arb_data[f"@{k}"] = {"description": f"{k} semantic key"}
        with open(arb_path, "w", encoding="utf-8") as f:
            json.dump(arb_data, f, ensure_ascii=False, indent=2)
        print(f"Updated {arb_path} (total keys: {len([k for k in arb_data if not k.startswith('@')])}).")
