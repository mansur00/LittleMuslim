import json
import os

keys_data = {
    # Layout & Navigation
    "nav.dua": {
        "en": "Dua",
        "bn": "দোয়া",
        "hi": "दुआ",
        "it": "Dua"
    },
    "nav.seerah": {
        "en": "Seerah",
        "bn": "সীরাত",
        "hi": "सीरत",
        "it": "Seerah"
    },
    "nav.basics": {
        "en": "Basic Islam",
        "bn": "মৌলিক ইসলাম",
        "hi": "बुनियादी इस्लाम",
        "it": "Islam di base"
    },
    "nav.achievements": {
        "en": "Achievements",
        "bn": "অর্জন",
        "hi": "उपलब्धियाँ",
        "it": "Obiettivi"
    },
    "nav.learn_path": {
        "en": "Learn Path",
        "bn": "শেখার পথ",
        "hi": "सीखने का मार्ग",
        "it": "Percorso"
    },
    "nav.my_learning": {
        "en": "My Learning",
        "bn": "আমার পড়া",
        "hi": "मेरी पढ़ाई",
        "it": "I miei studi"
    },
    "nav.missions": {
        "en": "Missions",
        "bn": "মিশন",
        "hi": "मिशन",
        "it": "Missioni"
    },
    "nav.qaida": {
        "en": "Qaida",
        "bn": "ক্বায়দা",
        "hi": "कायदा",
        "it": "Qaida"
    },
    "nav.qaida_subtitle": {
        "en": "Alphabet",
        "bn": "বর্ণমালা",
        "hi": "वर्णमाला",
        "it": "Alfabeto"
    },
    "nav.quran_subtitle": {
        "en": "Recitation",
        "bn": "তিলাওয়াত",
        "hi": "तिलावत",
        "it": "Recitazione"
    },
    "nav.prayer_subtitle": {
        "en": "Times & Rules",
        "bn": "সময় + নিয়ম",
        "hi": "समय और नियम",
        "it": "Orari e Regole"
    },
    "nav.dua_subtitle": {
        "en": "Masnun",
        "bn": "মাসনুন",
        "hi": "मसनून",
        "it": "Masnun"
    },
    "nav.seerah_subtitle": {
        "en": "Prophet Stories",
        "bn": "নবীর গল্প",
        "hi": "नबी की कहानियाँ",
        "it": "Storie dei Profeti"
    },
    "nav.basics_subtitle": {
        "en": "Learn Through Stories",
        "bn": "গল্পে গল্পে শিখি",
        "hi": "कहानियों से सीखें",
        "it": "Impara con le Storie"
    },
    "nav.achievements_subtitle": {
        "en": "Badges & Levels",
        "bn": "ব্যাজ · লেভেল",
        "hi": "बैज और स्तर",
        "it": "Distintivi e Livelli"
    },

    # Dashboard & Home
    "home.greeting": {
        "en": "Assalamu Alaikum",
        "bn": "আসসালামু আলাইকুম",
        "hi": "अस्सलामू अलैकुम",
        "it": "Assalamu Alaikum"
    },
    "common.friend": {
        "en": "Friend",
        "bn": "বন্ধু",
        "hi": "मित्र",
        "it": "Amico"
    },
    "avatar.customize_tooltip": {
        "en": "Change avatar & color",
        "bn": "অবতার ও রঙ পরিবর্তন করুন",
        "hi": "अवतार और रंग बदलें",
        "it": "Cambia avatar e colore"
    },
    "home.admin_mode_notice": {
        "en": "Admin Mode: All levels & steps unlocked",
        "bn": "অ্যাডমিন মোড: সব লেভেল ও ধাপ আনলক",
        "hi": "एडमिन मोड: सभी स्तर और चरण अनलॉक",
        "it": "Modalità amministratore: tutti i livelli sbloccati"
    },
    "home.student_mode": {
        "en": "Student Mode",
        "bn": "শিক্ষার্থী মোড",
        "hi": "छात्र मोड",
        "it": "Modalità studente"
    },
    "home.mission_done_encouragement": {
        "en": "MashaAllah! Today's mission is completed.",
        "bn": "মাশাআল্লাহ! আজকের মিশন সম্পূর্ণ করেছ।",
        "hi": "माशाअल्लाह! आज का मिशन पूरा हुआ।",
        "it": "MashaAllah! La missione di oggi è completata."
    },
    "home.start_new_lesson_encouragement": {
        "en": "Assalamu Alaikum! Let's learn a new lesson today!",
        "bn": "আসসালামু আলাইকুম! চলো আজ নতুন পাঠ শিখি!",
        "hi": "अस्सलामू अलैकुम! चलो आज नया सबक सीखें!",
        "it": "Assalamu Alaikum! Impariamo una nuova lezione oggi!"
    },
    "home.quran_says": {
        "en": "Quran Says",
        "bn": "কুরআন বলছে",
        "hi": "क़ुरआन कहता है",
        "it": "Il Corano dice"
    },
    "home.review_mistakes_desc": {
        "en": "Some letters need attention. Fix mistakes and keep advancing!",
        "bn": "কিছু দক্ষতায় আরো মনোযোগ দরকার। ভুল সংশোধন করে এগিয়ে যাও!",
        "hi": "कुछ अक्षरों पर अधिक ध्यान देने की आवश्यकता है। सुधार कर आगे बढ़ें!",
        "it": "Alcune lettere necessitano di attenzione. Correggi e vai avanti!"
    },
    "home.review_spaced_desc": {
        "en": "Time to practice previous lessons again.",
        "bn": "কিছু পুরনো পাঠ পুনরায় অনুশীলন করার সময় হয়েছে।",
        "hi": "पिछले पाठों को दोहराने का समय आ गया है।",
        "it": "È tempo di ripassare le lezioni precedenti."
    },
    "home.fix_mistakes": {
        "en": "Fix Mistakes",
        "bn": "ভুল সংশোধন করি",
        "hi": "गलतियाँ सुधारें",
        "it": "Correggi errori"
    },
    "home.practice_again": {
        "en": "Practice Again",
        "bn": "পুনরায় অনুশীলন করি",
        "hi": "पुनः अभ्यास करें",
        "it": "Esercitati di nuovo"
    },
    "home.all_modules": {
        "en": "Modules",
        "bn": "মডিউল",
        "hi": "मॉड्यूल",
        "it": "Moduli"
    },
    "home.modules_subtitle": {
        "en": "Learn Quran, Prayer, Dua & Islamic Stories",
        "bn": "কুরআন, নামাজ, দোয়া ও ইসলামিক গল্প শিখি",
        "hi": "क़ुरआन, नमाज़, दुआ और इस्लामी कहानियाँ सीखें",
        "it": "Impara Corano, Preghiera, Du'a e Storie Islamiche"
    },
    "dashboard.my_learning_title": {
        "en": "My Learning Dashboard",
        "bn": "আমার পড়ার ড্যাশবোর্ড",
        "hi": "मेरी पढ़ाई का डैशबोर्ड",
        "it": "La mia dashboard di studio"
    },
    "dashboard.resume_subtitle": {
        "en": "Continue reading right from where you left off!",
        "bn": "যেখান থেকে শেষ করেছিলে, সেখান থেকেই পড়া চালিয়ে যাও!",
        "hi": "जहाँ छोड़ा था, वहीं से सीखना जारी रखें!",
        "it": "Riprendi lo studio da dove avevi interrotto!"
    },
    "dashboard.current_qaida_title": {
        "en": "Current Qaida Lesson",
        "bn": "চলমান কায়দা পাঠ",
        "hi": "वर्तमान कायदा पाठ",
        "it": "Lezione di Qaida in corso"
    },
    "dashboard.seventeen_steps_map": {
        "en": "17-Step Roadmap",
        "bn": "১৭টি ধাপের মানচিত্র",
        "hi": "१७ चरणों का रोडमैप",
        "it": "Mappa a 17 fasi"
    },
    "dashboard.progress_report_heatmap": {
        "en": "Progress Report (Heatmap)",
        "bn": "পড়ার রিপোর্ট (হিটম্যাপ)",
        "hi": "प्रगति रिपोर्ट (हीटमैप)",
        "it": "Report sui progressi (Mappa termica)"
    },
    "dashboard.smart_revision": {
        "en": "Smart Review",
        "bn": "স্মার্ট রিভিশন",
        "hi": "स्मार्ट पुनरीक्षण",
        "it": "Ripasso intelligente"
    },
    "dashboard.revision_mistakes_hint": {
        "en": "Some letters had mistakes. Polish them now!",
        "bn": "কিছু হরফে ভুল হয়েছিল, পুনরায় ঝালিয়ে নাও",
        "hi": "कुछ अक्षरों में गलतियाँ थीं। उन्हें अभी सुधारें!",
        "it": "Alcune lettere contenevano errori. Ripassale ora!"
    },
    "dashboard.revision_routine_hint": {
        "en": "Review before starting the next lesson",
        "bn": "পরবর্তী পড়ার আগে রিভিশন করে নাও",
        "hi": "अगला पाठ शुरू करने से पहले दोहराएं",
        "it": "Ripassa prima di iniziare la prossima lezione"
    },
    "dashboard.adhan_alarm_title": {
        "en": "Adhan & Study Alarm",
        "bn": "আযান ও পড়ার অ্যালার্ম",
        "hi": "अज़ान और अध्ययन अलार्म",
        "it": "Adhan e allarme studio"
    },
    "dashboard.adhan_alarm_subtitle": {
        "en": "Listen to beautiful Adhan and prayers",
        "bn": "সুমধুর আযান ও আউযুবিল্লাহ-বিসমিল্লাহ শুনুন",
        "hi": "सुमधुर अज़ान और प्रार्थनाएँ सुनें",
        "it": "Ascolta il dolce Adhan e le preghiere"
    },
    "prayer.stop_adhan": {
        "en": "Stop Adhan",
        "bn": "আযান থামান",
        "hi": "अज़ान रोकें",
        "it": "Ferma Adhan"
    },
    "prayer.play_adhan": {
        "en": "Listen to Adhan",
        "bn": "আযান শুনুন",
        "hi": "अज़ान सुनें",
        "it": "Ascolta Adhan"
    },
    "prayer.view_schedule": {
        "en": "Prayer Schedule ›",
        "bn": "নামাজের সময়সূচি ›",
        "hi": "नमाज़ का समय ›",
        "it": "Orari della preghiera ›"
    },
    "settings.stop_alarm": {
        "en": "Stop Alarm",
        "bn": "অ্যালার্ম থামান",
        "hi": "अलार्म रोकें",
        "it": "Ferma allarme"
    },
    "settings.test_alarm": {
        "en": "Test Study Alarm",
        "bn": "পড়ার অ্যালার্ম শুনুন",
        "hi": "अध्ययन अलार्म सुनें",
        "it": "Ascolta allarme studio"
    },
    "quran.title": {
        "en": "Holy Quran Recitation",
        "bn": "পবিত্র কুরআন তিলাওয়াত",
        "hi": "पवित्र क़ुरआन तिलावत",
        "it": "Recitazione del Sacro Corano"
    },
    "holyQuranRecitation": {
        "en": "Holy Quran Recitation",
        "bn": "পবিত্র কুরআন তিলাওয়াত",
        "hi": "पवित्र क़ुरआन तिलावत",
        "it": "Recitazione del Sacro Corano"
    },
    "quran.start_from_fatihah": {
        "en": "Start from Surah Al-Fatihah",
        "bn": "সূরা আল-ফাতিহা থেকে শুরু করো",
        "hi": "सूरह अल-फ़ातिहा से शुरू करें",
        "it": "Inizia dalla Sura Al-Fatiha"
    },
    "quran.fatihah_first_ayah": {
        "en": "Surah Al-Fatihah (Ayah 1)",
        "bn": "সূরা আল-ফাতিহা (১ম আয়াত)",
        "hi": "सूरह अल-फ़ातिहा (आयत १)",
        "it": "Sura Al-Fatiha (Versetto 1)"
    },
    "quran.recitation_meaning_subtitle": {
        "en": "Beautiful recitation with pronunciation & meaning",
        "bn": "উচ্চারণ ও অর্থসহ সুন্দর তিলাওয়াত",
        "hi": "उच्चारण और अर्थ के साथ सुंदर तिलावत",
        "it": "Bella recitazione con pronuncia e significato"
    },
    "qaida.continue_lesson": {
        "en": "Continue Lesson",
        "bn": "কায়দা পড়া চালিয়ে যাই",
        "hi": "कायदा पाठ जारी रखें",
        "it": "Continua lezione di Qaida"
    },
    "common.read": {
        "en": "Read ›",
        "bn": "পড়ি ›",
        "hi": "पढ़ें ›",
        "it": "Leggi ›"
    },
    "qaida.seventeen_steps": {
        "en": "17 Steps",
        "bn": "১৭টি স্টেপ",
        "hi": "१७ चरण",
        "it": "17 Fasi"
    },
    "live.teacher_help": {
        "en": "Teacher Help",
        "bn": "শিক্ষক সহায়তা",
        "hi": "शिक्षक सहायता",
        "it": "Supporto insegnante"
    },
    "live.banner_title": {
        "en": "Learn Quran & Islam with a Teacher",
        "bn": "শিক্ষকের সাথে কুরআন ও ইসলাম শিখি",
        "hi": "शिक्षक के साथ क़ुरआन और इस्लाम सीखें",
        "it": "Impara Corano e Islam con un Insegnante"
    },
    "live.banner_subtitle": {
        "en": "Live interactive classes with monthly plans",
        "bn": "মাসিক পরিকল্পনায় সরাসরি live class",
        "hi": "मासिक योजना में लाइव कक्षाएं",
        "it": "Lezioni dal vivo con piani mensili"
    },
    "live.view_schedule_btn": {
        "en": "View Classes & Plans ›",
        "bn": "ক্লাস ও পরিকল্পনা দেখো  ›",
        "hi": "कक्षाएं और योजनाएं देखें ›",
        "it": "Vedi lezioni e piani ›"
    },
    "qaida.lesson_progress": {
        "en": "Lesson {{current}}/{{total}}",
        "bn": "পাঠ {{current}}/{{total}}",
        "hi": "पाठ {{current}}/{{total}}",
        "it": "Lezione {{current}}/{{total}}"
    },
    "common.in_progress": {
        "en": "In Progress",
        "bn": "চলমান",
        "hi": "प्रगति में",
        "it": "In corso"
    },
    "quran.header_title": {
        "en": "Spend Time with the Quran",
        "bn": "কুরআনের সাথে সময় কাটাই",
        "hi": "क़ुरआन के साथ समय बिताएं",
        "it": "Trascorri del tempo con il Corano"
    },
    "quran.header_subtitle": {
        "en": "Read peacefully, reflect, and listen to beautiful stories.",
        "bn": "শান্ত মনে পড়ো, ভাবো, আর সুন্দর গল্প শোনো।",
        "hi": "शांति से पढ़ें, विचार करें और सुंदर कहानियाँ सुनें।",
        "it": "Leggi in pace, rifletti e ascolta belle storie."
    },
    "quran.load_error": {
        "en": "Could not load surahs. Please check your internet and try again.",
        "bn": "সূরার তালিকা আনা যায়নি। ইন্টারনেট দেখে আবার চেষ্টা করো।",
        "hi": "सूरहों की सूची लोड नहीं हो सकी। कृपया इंटरनेट की जाँच करें।",
        "it": "Impossibile caricare l'elenco delle sure. Controlla la connessione e riprova."
    },
    "quran.wait_load_surah": {
        "en": "Reading will begin once the Surah list loads.",
        "bn": "সূরার তালিকা লোড হলে পড়া শুরু হবে।",
        "hi": "सूरह सूची लोड होते ही पढ़ाई शुरू होगी।",
        "it": "La lettura inizierà al caricamento delle sure."
    },
    "quran.wait_load_retry": {
        "en": "Please try again once surahs are loaded",
        "bn": "সূরা লোড হলে আবার চেষ্টা করো",
        "hi": "सूरह लोड होने के बाद पुनः प्रयास करें",
        "it": "Riprova dopo aver caricato le sure"
    },
    "quran.surah_prefix": {
        "en": "Surah {{name}}",
        "bn": "সূরা {{name}}",
        "hi": "सूरह {{name}}",
        "it": "Sura {{name}}"
    },
    "quran.all_114_surahs": {
        "en": "All 114 Surahs",
        "bn": "সব ১১৪টি সূরা",
        "hi": "सभी ११४ सूरह",
        "it": "Tutte le 114 sure"
    },
    "quran.search_hint": {
        "en": "Search Surah",
        "bn": "সূরা খুঁজে দেখো",
        "hi": "सूरह खोजें",
        "it": "Cerca sura"
    },
    "quran.surah_meta": {
        "en": "{{ayahs}} Verses · {{revelation}} · {{meaning}}",
        "bn": "{{ayahs}} আয়াত · {{revelation}} · {{meaning}}",
        "hi": "{{ayahs}} आयतें · {{revelation}} · {{meaning}}",
        "it": "{{ayahs}} Versetti · {{revelation}} · {{meaning}}"
    },
    "quran.meccan": {
        "en": "Meccan",
        "bn": "মক্কী",
        "hi": "मक्की",
        "it": "Meccana"
    },
    "quran.medinan": {
        "en": "Medinan",
        "bn": "মাদানী",
        "hi": "मदनी",
        "it": "Medinese"
    },
    "quran.thirty_juz": {
        "en": "30 Juz / Paras",
        "bn": "৩০টি পারা / জুয",
        "hi": "३० पारे / जुज़",
        "it": "30 Juz / Parti"
    },
    "quran.juz_count_badge": {
        "en": "{{count}} Juz",
        "bn": "{{count}} পারা",
        "hi": "{{count}} पारे",
        "it": "{{count}} Juz"
    },
    "quran.saved_ayahs": {
        "en": "Bookmarked Verses",
        "bn": "সংরক্ষিত আয়াত",
        "hi": "सहेजी गई आयतें",
        "it": "Versetti salvati"
    },
    "quran.surahs_count_badge": {
        "en": "{{count}} Surahs",
        "bn": "{{count}}টি সূরা",
        "hi": "{{count}} सूरह",
        "it": "{{count}} Sure"
    },
    "quran.bookmarks_count_badge": {
        "en": "{{count}} Saved",
        "bn": "{{count}}টি সংরক্ষিত",
        "hi": "{{count}} सहेजे गए",
        "it": "{{count}} Salvati"
    },
    "quran.tab_surah": {
        "en": "Surah",
        "bn": "সূরা",
        "hi": "सूरह",
        "it": "Sura"
    },
    "quran.tab_juz": {
        "en": "Juz",
        "bn": "পারা",
        "hi": "पारा",
        "it": "Juz"
    },
    "quran.tab_bookmarks": {
        "en": "Bookmarks",
        "bn": "বুকমার্ক",
        "hi": "बुकमार्क",
        "it": "Segnalibri"
    },
    "quran.tab_stories": {
        "en": "Stories",
        "bn": "গল্প",
        "hi": "कहानियाँ",
        "it": "Storie"
    },
    "quran.islamic_stories_section": {
        "en": "Little Islamic Stories",
        "bn": "ছোট্ট ইসলামিক গল্প",
        "hi": "छोटी इस्लामी कहानियाँ",
        "it": "Piccole storie islamiche"
    },
    "quran.story_kindness_title": {
        "en": "Beautiful Story of Kindness",
        "bn": "দয়ার সুন্দর গল্প",
        "hi": "दया की सुंदर कहानी",
        "it": "Bella storia di gentilezza"
    },
    "quran.story_kindness_desc": {
        "en": "Good manners and compassion",
        "bn": "ভালো আচরণ আর মমতা",
        "hi": "अच्छा आचरण और दया",
        "it": "Buone maniere e compassione"
    },
    "quran.story_courage_title": {
        "en": "Story of Courage & Patience",
        "bn": "সাহস ও ধৈর্যের গল্প",
        "hi": "साहस और धैर्य की कहानी",
        "it": "Storia di coraggio e pazienza"
    },
    "quran.story_courage_desc": {
        "en": "A little lesson for kids",
        "bn": "ছোটদের জন্য ছোট্ট শিক্ষা",
        "hi": "बच्चों के लिए एक छोटी सीख",
        "it": "Una piccola lezione per bambini"
    },
    "quran.story_truth_title": {
        "en": "Story of Truthfulness",
        "bn": "সত্য বলার গল্প",
        "hi": "सच्चाई की कहानी",
        "it": "Storia di sincerità"
    },
    "quran.story_truth_desc": {
        "en": "Practicing noble character",
        "bn": "সুন্দর চরিত্রের অনুশীলন",
        "hi": "सुंदर चरित्र का अभ्यास",
        "it": "Praticare un nobile carattere"
    },
    "quran.credits_footer": {
        "en": "Color Tajweed text: Quran.com · Translation: Al Quran Cloud",
        "bn": "রঙিন তাজবিদ পাঠ: Quran.com · বাংলা অনুবাদ: মুহিউদ্দীন খান, Al Quran Cloud",
        "hi": "रंगीन तजवीद पाठ: Quran.com · अनुवाद: Al Quran Cloud",
        "it": "Testo Tajweed a colori: Quran.com · Traduzione: Al Quran Cloud"
    },
    "quran.stories_modal_body": {
        "en": "This special module of Quranic stories for children is being compiled using reliable Tafsir sources.\n\nCurrently, you can read authentic historical stories of the Prophet ﷺ in the ‘Seerah’ module.",
        "bn": "কুরআনিক শিক্ষণীয় ঘটনাভিত্তিক বিশেষ শিশুতোষ মডিউলটি নির্ভরযোগ্য তাফসির সূত্রের আলোকে সংকলন করা হচ্ছে।\n\nবর্তমানে তুমি ‘সীরাত’ মডিউল থেকে রাসুলুল্লাহ ﷺ-এর জীবনের নির্ভরযোগ্য ঐতিহাসিক গল্পগুলো পড়তে পারো।",
        "hi": "बच्चों के लिए क़ुरआनी कहानियों का यह विशेष मॉड्यूल तैयार किया जा रहा है।\n\nवर्तमान में आप 'सीरत' मॉड्यूल से पैगंबर ﷺ के जीवन की कहानियाँ पढ़ सकते हैं।",
        "it": "Questo modulo speciale per bambini di storie coraniche è in fase di compilazione utilizzando fonti affidabili.\n\nAttualmente, puoi leggere storie autentiche del Profeta ﷺ nel modulo 'Seerah'."
    },
    "common.got_it": {
        "en": "Got it",
        "bn": "বুঝেছি",
        "hi": "समझ गया",
        "it": "Ho capito"
    },
    "quran.go_to_seerah": {
        "en": "Go to Seerah Stories",
        "bn": "সীরাতের গল্পে যাই",
        "hi": "सीरत की कहानियों पर जाएँ",
        "it": "Vai alle storie di Seerah"
    },
    "common.delete": {
        "en": "Delete",
        "bn": "মুছে ফেলো",
        "hi": "हटाएं",
        "it": "Elimina"
    },
    "common.retry": {
        "en": "Try Again",
        "bn": "আবার চেষ্টা করি",
        "hi": "पुनः प्रयास करें",
        "it": "Riprova"
    },
    "quran.no_surahs_found": {
        "en": "No surahs found right now.",
        "bn": "এখন কোনো সূরা পাওয়া যায়নি।",
        "hi": "अभी कोई सूरह नहीं मिली।",
        "it": "Nessuna sura trovata al momento."
    },
    "quran.continue_reading": {
        "en": "Continue Reading",
        "bn": "পড়া চালিয়ে যাও",
        "hi": "पढ़ना जारी रखें",
        "it": "Continua a leggere"
    },
    "quran.check_internet_retry": {
        "en": "Check your internet connection and try again",
        "bn": "ইন্টারনেট সংযোগ দেখে আবার চেষ্টা করো",
        "hi": "इंटरनेट कनेक्शन की जाँच करें और पुनः प्रयास करें",
        "it": "Controlla la connessione internet e riprova"
    },
    "quran.read_from_beginning": {
        "en": "Read from the beginning",
        "bn": "শুরু থেকে পড়ি",
        "hi": "शुरू से पढ़ें",
        "it": "Leggi dall'inizio"
    },
    "quran.read_from_ayah": {
        "en": "Read from Ayah {{ayah}}",
        "bn": "আয়াত {{ayah}} থেকে পড়ি",
        "hi": "आयत {{ayah}} से पढ़ें",
        "it": "Leggi dal versetto {{ayah}}"
    },
    "quran.search_no_results": {
        "en": "No surahs found matching “{{query}}”.",
        "bn": "“{{query}}” দিয়ে কোনো সূরা পাওয়া যায়নি।",
        "hi": "“{{query}}” के लिए कोई सूरह नहीं मिली।",
        "it": "Nessuna sura trovata per “{{query}}”."
    },
    "common.clear_search": {
        "en": "Clear Search",
        "bn": "অনুসন্ধান মুছুন",
        "hi": "खोज साफ़ करें",
        "it": "Cancella ricerca"
    },
    "quran.no_bookmarks_title": {
        "en": "No bookmarks yet",
        "bn": "এখনো কোনো বুকমার্ক নেই",
        "hi": "अभी तक कोई बुकमार्क नहीं है",
        "it": "Ancora nessun segnalibro"
    },
    "quran.no_bookmarks_subtitle": {
        "en": "Tap the bookmark icon next to any verse while reading to easily find it here.",
        "bn": "কুরআন পড়ার সময় যেকোনো আয়াতের পাশে বুকমার্ক আইকনে চাপ দিলে এখানে সহজে খুঁজে পাবে।",
        "hi": "पढ़ते समय किसी भी आयत के पास बुकमार्क आइकन पर टैप करें।",
        "it": "Tocca l'icona del segnalibro accanto a qualsiasi versetto durante la lettura."
    },
    "quran.juz_title": {
        "en": "Juz {{number}}",
        "bn": "পারা {{number}}",
        "hi": "पारा {{number}}",
        "it": "Juz {{number}}"
    },
    "quran.juz_start_info": {
        "en": "Starts: Surah {{surah}} · Ayah {{ayah}}",
        "bn": "শুরু: সূরা {{surah}} · আয়াত {{ayah}}",
        "hi": "प्रारंभ: सूरह {{surah}} · आयत {{ayah}}",
        "it": "Inizio: Sura {{surah}} · Versetto {{ayah}}"
    },
    "quran.bookmark_item_title": {
        "en": "Surah {{surah}} · Ayah {{ayah}}",
        "bn": "সূরা {{surah}} · আয়াত {{ayah}}",
        "hi": "सूरह {{surah}} · आयत {{ayah}}",
        "it": "Sura {{surah}} · Versetto {{ayah}}"
    },
    "quran.start_reading": {
        "en": "Start Reading",
        "bn": "পড়া শুরু করি",
        "hi": "पढ़ना शुरू करें",
        "it": "Inizia a leggere"
    },
    "quran.remove_bookmark": {
        "en": "Remove Bookmark",
        "bn": "বুকমার্ক সরাও",
        "hi": "बुकमार्क हटाएं",
        "it": "Rimuovi segnalibro"
    },
    "quran.surah_load_error": {
        "en": "Could not load this Surah. Check your internet connection and try again.",
        "bn": "এই সূরার পাঠ আনা যায়নি। ইন্টারনেট দেখে আবার চেষ্টা করো।",
        "hi": "इस सूरह का पाठ लोड नहीं हो सका। कृपया इंटरनेट जाँचें।",
        "it": "Impossibile caricare questa Sura. Controlla la connessione e riprova."
    },
    "quran.audio_error": {
        "en": "Could not play ayah audio. Check internet connection and try again.",
        "bn": "আয়াতের অডিও চালু হয়নি। ইন্টারনেট সংযোগ দেখে আবার চেষ্টা করো।",
        "hi": "आयत का ऑडियो नहीं चल सका। इंटरनेट जाँचें।",
        "it": "Impossibile riprodurre l'audio del versetto. Controlla la connessione."
    },
    "quran.no_ayahs_in_surah": {
        "en": "No verses found in this Surah.",
        "bn": "এই সূরায় এখন কোনো আয়াত পাওয়া যায়নি।",
        "hi": "इस सूरह में कोई आयत नहीं मिली।",
        "it": "Nessun versetto trovato in questa Sura."
    },
    "quran.reading_mode": {
        "en": "Reading Mode",
        "bn": "পাঠ মোড",
        "hi": "पठन मोड",
        "it": "Modalità lettura"
    },
    "quran.text_smaller": {
        "en": "Smaller text",
        "bn": "ছোট লেখা",
        "hi": "छोटा टेक्स्ट",
        "it": "Testo più piccolo"
    },
    "quran.text_larger": {
        "en": "Larger text",
        "bn": "বড় লেখা",
        "hi": "बड़ा टेक्स्ट",
        "it": "Testo più grande"
    },
    "quran.bookmark": {
        "en": "Bookmark",
        "bn": "বুকমার্ক",
        "hi": "बुकमार्क",
        "it": "Segnalibro"
    },
    "quran.stop_recitation": {
        "en": "Stop Recitation",
        "bn": "তিলাওয়াত থামাই",
        "hi": "तिलावत रोकें",
        "it": "Ferma recitazione"
    },
    "quran.play_full_surah": {
        "en": "Listen to Full Surah",
        "bn": "পুরো সূরা তিলাওয়াত শুনি",
        "hi": "पूरी सूरह सुनें",
        "it": "Ascolta l'intera Sura"
    },
    "quran.reciting_now": {
        "en": "Reciting now...",
        "bn": "তিলাওয়াত চলছে...",
        "hi": "तिलावत जारी है...",
        "it": "Recitazione in corso..."
    },
    "quran.stop_ayah": {
        "en": "Stop Ayah",
        "bn": "আয়াত থামাই",
        "hi": "आयत रोकें",
        "it": "Ferma versetto"
    },
    "quran.play_ayah": {
        "en": "Listen to Ayah",
        "bn": "আয়াত শুনি",
        "hi": "आयत सुनें",
        "it": "Ascolta versetto"
    },
    "quran.surahs_loading_wait": {
        "en": "Reading will start once surahs list loads.",
        "bn": "সূরার তালিকা লোড হলে পড়া শুরু হবে।",
        "hi": "सूरह सूची लोड होने पर पठन शुरू होगा।",
        "it": "La lettura inizierà dopo il caricamento delle sure."
    },
    "quran.broken_bookmark_ref": {
        "en": "Deleted or invalid reference ({{key}})",
        "bn": "মুছে যাওয়া বা অপ্রাসঙ্গিক রেফারেন্স ({{key}})",
        "hi": "हटाया गया या अमान्य संदर्भ ({{key}})",
        "it": "Riferimento eliminato o non valido ({{key}})"
    },
    "quran.surah_title_with_name": {
        "en": "Surah {{name}}",
        "bn": "সূরা {{name}}",
        "hi": "सूरह {{name}}",
        "it": "Sura {{name}}"
    },
    "quran.surah_heading_info": {
        "en": "{{revelation}}  ·  {{ayahCount}} Ayahs  ·  {{meaning}}",
        "bn": "{{revelation}}  ·  {{ayahCount}} আয়াত  ·  {{meaning}}",
        "hi": "{{revelation}}  ·  {{ayahCount}} आयतें  ·  {{meaning}}",
        "it": "{{revelation}}  ·  {{ayahCount}} versetti  ·  {{meaning}}"
    },
    "quran.reader_credits": {
        "en": "Color Tajweed: Quran.com · Translation: Al Quran Cloud",
        "bn": "রঙিন তাজবিদ: Quran.com · বাংলা অর্থ: মুহিউদ্দীন খান, Al Quran Cloud",
        "hi": "रंगीन तजवीद: Quran.com · अनुवाद: Al Quran Cloud",
        "it": "Testo Tajweed a colori: Quran.com · Traduzione: Al Quran Cloud"
    },
    "qaida.title": {
        "en": "Noorani Qaida",
        "bn": "নূরানী ক্বায়দা",
        "hi": "नूरानी कायदा",
        "it": "Noorani Qaida"
    },
    "qaida.full_map_subtitle": {
        "en": "Full 17-Step Learning Map",
        "bn": "১৭টি ধাপের পূর্ণাঙ্গ লার্নিং ম্যাপ",
        "hi": "17 चरणों का पूर्ण सीखने का नक्शा",
        "it": "Mappa di apprendimento completa in 17 passaggi"
    },
    "qaida.steps_progress_badge": {
        "en": "{{completed}}/{{total}} Steps",
        "bn": "{{completed}}/{{total}} ধাপ",
        "hi": "{{completed}}/{{total}} चरण",
        "it": "{{completed}}/{{total}} Passaggi"
    },
    "qaida.phase_1_title": {
        "en": "Level 1 · Letter Recognition & Forms (Steps 1–2)",
        "bn": "লেভেল ১ · হরফ চেনা ও রূপভেদ (Steps 1–2)",
        "hi": "लेवल 1 · अक्षर पहचान और रूप (Steps 1–2)",
        "it": "Livello 1 · Riconoscimento lettere e forme (Steps 1–2)"
    },
    "qaida.phase_2_title": {
        "en": "Level 2 · Harakat & Tanween (Steps 3–5)",
        "bn": "লেভেল ২ · হারাকাত ও তানবীন (Steps 3–5)",
        "hi": "लेवल 2 · हरकात और तनवीन (Steps 3–5)",
        "it": "Livello 2 · Harakat e Tanween (Steps 3–5)"
    },
    "qaida.phase_3_title": {
        "en": "Level 3 · Sukun, Shaddah & Leen (Steps 6–8)",
        "bn": "লেভেল ৩ · সুকুন, শাদ্দাহ ও লাইয়্যিন (Steps 6–8)",
        "hi": "लेवल 3 · सुकून, शद् Fortাহ ও লীন (Steps 6–8)",
        "it": "Livello 3 · Sukun, Shaddah e Leen (Steps 6–8)"
    },
    "qaida.phase_4_title": {
        "en": "Level 4 · Core Tajweed Rules (Steps 9–12)",
        "bn": "লেভেল ৪ · তাজবীদের মূল নিয়মাবলি (Steps 9–12)",
        "hi": "लेवल 4 · तजवीद के मुख्य नियम (Steps 9–12)",
        "it": "Livello 4 · Regole fondamentali del Tajweed (Steps 9–12)"
    },
    "qaida.phase_5_title": {
        "en": "Level 5 · Advanced Rules (Steps 13–15)",
        "bn": "লেভেল ৫ · অগ্রসর নিয়মাবলি (Steps 13–15)",
        "hi": "লেভেল ৫ · উন্নত নিয়ম (Steps 13–15)",
        "it": "Livello 5 · Regole avanzate (Steps 13–15)"
    },
    "qaida.phase_6_title": {
        "en": "Level 6 · Waqf & Full Recitation (Steps 16–17)",
        "bn": "লেভেল ৬ · ওয়াকফ ও পূর্ণাঙ্গ তিলাওয়াত (Steps 16–17)",
        "hi": "लेवल 6 · वक़्फ़ और पूर्ण तिलावत (Steps 16–17)",
        "it": "Livello 6 · Waqf e recitazione completa (Steps 16–17)"
    },
    "qaida.phase_1_subtitle": {
        "en": "Isolated letters, initial, medial, and final forms",
        "bn": "আলাদা আলাদা হরফ চেনা এবং হরফের শুরু, মাঝে ও শেষের রূপভেদ",
        "hi": "अलग-अलग अक्षरों की पहचान और शुरुआत, बीच व अंत के रूप",
        "it": "Riconoscimento di lettere isolate e forme iniziali, mediane e finali"
    },
    "qaida.phase_2_subtitle": {
        "en": "Accurate pronunciation of Fatha, Kasra, Damma, Tanween & Standing Harakat",
        "bn": "যবর, যের, পেশ, তানবীন এবং খাড়া হারাকাতের শুদ্ধ উচ্চারণ",
        "hi": "ज़बर, ज़ेर, पेश, तनवीन और खड़े हरकात का शुद्ध उच्चारण",
        "it": "Pronuncia corretta di Fatha, Kasra, Damma, Tanween e Harakat in piedi"
    },
    "qaida.phase_3_subtitle": {
        "en": "Letters of Leen, Sukun practice & Tashdeed double-press exercises",
        "bn": "হরফে লাইয়্যিন, সাকিন হরফ ও তাশদীদ ডাবল-প্রেস অনুশীলন",
        "hi": "हुहूफ़े लीन, साकिन अक्षर और तशदीद अभ्यास",
        "it": "Lettere di Leen, lettere con Sukun ed esercizi di Tashdeed"
    },
    "qaida.phase_4_subtitle": {
        "en": "Noon Sakin, Meem Sakin, Wajib Ghunnah & Madd varieties",
        "bn": "নূন সাকিন, মীম সাকিন, ওয়াজিব গুন্নাহ ও মাদ্দের প্রকারভেদ",
        "hi": "नून साकिन, मीम साकिन, वाजिब ग़ुन्ना और मद के प्रकार",
        "it": "Noon Sakin, Meem Sakin, Wajib Ghunnah e tipi di Madd"
    },
    "qaida.phase_5_subtitle": {
        "en": "Shamsi & Qamari Lam, nuances of Ra and Lam, and Qalqalah",
        "bn": "শামসী ও ক্বামারিয়্যাহ লাম, র ও লামের গভীর চর্চা এবং ক্বলক্বলাহ",
        "hi": "शम्सी व क़मरी लाम, रा और लाम का गहरा अभ्यास और क़लक़ला",
        "it": "Lam Shamsi e Qamari, regole di Ra e Lam e Qalqalah"
    },
    "qaida.phase_6_subtitle": {
        "en": "Signs and rules of Waqf and full Quran recitation preparation",
        "bn": "ওয়াকফের চিহ্ন ও নিয়মাবলি এবং পূর্ণাঙ্গ কুরআন তিলাওয়াত প্রস্তুতি",
        "hi": "वक़्फ़ के संकेत व नियम और संपूर्ण क़ुरआन तिलावत की तैयारी",
        "it": "Segni e regole del Waqf e preparazione alla recitazione completa del Corano"
    },
    "qaida.revision_island": {
        "en": "Revision Island",
        "bn": "রিভিশন আইল্যান্ড",
        "hi": "रिवीजन द्वीप",
        "it": "Isola di Ripasso"
    },
    "qaida.letters_due_for_review": {
        "en": "{{count}} letters need review",
        "bn": "{{count}}টি হরফ রিভিশন প্রয়োজন",
        "hi": "{{count}} अक्षरों का दोहराव आवश्यक",
        "it": "{{count}} lettere da ripassare"
    },
    "qaida.weak_letters_practice": {
        "en": "Practice Weak Letters",
        "bn": "দুর্বল হরফ অনুশীলন",
        "hi": "कमज़ोर अक्षरों का अभ्यास",
        "it": "Esercitati sulle lettere deboli"
    },
    "qaida.progress_report": {
        "en": "Progress Report",
        "bn": "অগ্রগতি প্রতিবেদন",
        "hi": "प्रगति रिपोर्ट",
        "it": "Rapporto sui progressi"
    },
    "qaida.mastery_and_performance": {
        "en": "Mastery & Performance",
        "bn": "মাস্টারি ও পারফরম্যান্স",
        "hi": "दक्षता और प्रदर्शन",
        "it": "Padronanza e prestazioni"
    },
    "qaida.weekly_exam": {
        "en": "Weekly Exam",
        "bn": "সাপ্তাহিক পরীক্ষা",
        "hi": "साप्ताहिक परीक्षा",
        "it": "Esame settimanale"
    },
    "qaida.weekly_exam_reward": {
        "en": "80% Pass +25 XP",
        "bn": "৮০% পাসে +২৫ XP",
        "hi": "80% पास पर +25 XP",
        "it": "Promosso all'80% +25 XP"
    },
    "qaida.monthly_exam": {
        "en": "Monthly Exam",
        "bn": "মাসিক পরীক্ষা",
        "hi": "मासिक परीक्षा",
        "it": "Esame mensile"
    },
    "qaida.monthly_exam_reward": {
        "en": "Mega Review +40 XP",
        "bn": "মেগা রিভিউ +৪০ XP",
        "hi": "मेगा समीक्षा +40 XP",
        "it": "Mega revisione +40 XP"
    },
    "qaida.admin_mode_active": {
        "en": "Admin Mode Active",
        "bn": "এডমিন মোড সক্রিয়",
        "hi": "एडमिन मोड सक्रिय",
        "it": "Modalità amministratore attiva"
    },
    "qaida.student_mode_active": {
        "en": "Student Mode (Step-by-step unlock)",
        "bn": "শিক্ষার্থী মোড (ধাপে ধাপে আনলক)",
        "hi": "छात्र मोड (चरणबद्ध अनलॉक)",
        "it": "Modalità studente (Sblocco graduale)"
    },
    "qaida.admin_all_unlocked_desc": {
        "en": "All 17 steps and lessons are unlocked",
        "bn": "১৭টি স্টেপ ও সকল পাঠ উন্মুক্ত রয়েছে",
        "hi": "सभी 17 चरण और पाठ अनलॉक हैं",
        "it": "Tutti i 17 passaggi e le lezioni sono sbloccati"
    },
    "qaida.admin_enable_desc": {
        "en": "Enable Admin Mode to test all steps",
        "bn": "পরীক্ষা করতে অ্যাডমিন মোড চালু করুন",
        "hi": "परीक्षण के लिए एडमिन मोड चालू करें",
        "it": "Attiva la modalità amministratore per testare i passaggi"
    },
    "qaida.lock_mode_button": {
        "en": "Lock Mode",
        "bn": "লক মোড",
        "hi": "लॉक मोड",
        "it": "Blocca"
    },
    "qaida.unlock_all_button": {
        "en": "Unlock All",
        "bn": "সব আনলক",
        "hi": "सभी अनलॉक",
        "it": "Sblocca tutto"
    },
    "qaida.step_locked_snack": {
        "en": "Step {{step}} ({{title}}) is locked.",
        "bn": "ধাপ {{step}} ({{title}}) লক করা রয়েছে।",
        "hi": "चरण {{step}} ({{title}}) लॉक है।",
        "it": "Il passaggio {{step}} ({{title}}) è bloccato."
    },
    "qaida.admin_unlock_action": {
        "en": "Admin Unlock",
        "bn": "অ্যাডমিন আনলক",
        "hi": "एडमिन अनलॉक",
        "it": "Sblocco admin"
    },
    "qaida.step_badge": {
        "en": "Step {{number}}",
        "bn": "ধাপ {{number}}",
        "hi": "चरण {{number}}",
        "it": "Passo {{number}}"
    },
    "qaida.garden_reward": {
        "en": "Garden Reward: {{plant}}",
        "bn": "বাগান পুরস্কার: {{plant}}",
        "hi": "बगीचा पुरस्कार: {{plant}}",
        "it": "Premio giardino: {{plant}}"
    },
    "qaida.locked_threshold": {
        "en": "Locked (80% Required)",
        "bn": "লকড (৮০% প্রয়োজন)",
        "hi": "लॉक (80% आवश्यक)",
        "it": "Bloccato (80% richiesto)"
    },
    "qaida.mastered_completed": {
        "en": "Mastered (Completed)",
        "bn": "মাস্টার্ড (সম্পন্ন)",
        "hi": "महारत हासिल (पूर्ण)",
        "it": "Padroneggiato (Completato)"
    },
    "qaida.lessons_progress": {
        "en": "{{done}}/{{total}} Lessons",
        "bn": "{{done}}/{{total}} পাঠ",
        "hi": "{{done}}/{{total}} पाठ",
        "it": "{{done}}/{{total}} Lezioni"
    },
    "qaida.step_boss_passed": {
        "en": "Step Boss Passed (80%+) ✓",
        "bn": "স্টেপ বস পাস (৮০%+) ✓",
        "hi": "स्टेप बॉस पास (80%+) ✓",
        "it": "Superato il boss del passo (80%+) ✓"
    },
    "qaida.step_boss_take_exam": {
        "en": "Take Step Boss Exam (80%+)",
        "bn": "স্টেপ বস পরীক্ষা দিন (৮০%+)",
        "hi": "स्टेप बॉस परीक्षा दें (80%+)",
        "it": "Fai l'esame del boss (80%+)"
    },
    "qaida.curriculum_subtitle": {
        "en": "Noorani Qaida · 17-Step Curriculum",
        "bn": "নূরানী ক্বায়দা · ১৭টি ধাপের পাঠ্যক্রম",
        "hi": "नूरानी कायदा · 17 चरणों का पाठ्यक्रम",
        "it": "Noorani Qaida · Programma in 17 passaggi"
    },
    "qaida.learning_stages_flow": {
        "en": "Letter Recognition → Joining → Harakat/Tanween → Sukun/Shaddah → Tajweed → Waqf & Recitation",
        "bn": "হরফ চেনা → সংযোগ → হারাকাত/তানবীন → সুকুন/শাদ্দাহ → তাজবীদ → ওয়াকফ ও তিলাওয়াত",
        "hi": "अक्षर पहचान → जोड़ना → हरकात/तनवीन → सुकून/शद् Fortাহ → तजवीद → वक़्फ़ और तिलावत",
        "it": "Riconoscimento lettere → Unione → Harakat/Tanween → Sukun/Shaddah → Tajweed → Waqf e recitazione"
    },
    "qaida.compact_step_title": {
        "en": "Step {{number}}: {{title}}",
        "bn": "ধাপ {{number}}: {{title}}",
        "hi": "चरण {{number}}: {{title}}",
        "it": "Passo {{number}}: {{title}}"
    },
    "qaida.lessons_completed": {
        "en": "{{done}}/{{total}} Lessons Completed",
        "bn": "{{done}}/{{total}} পাঠ সম্পন্ন",
        "hi": "{{done}}/{{total}} पाठ पूर्ण",
        "it": "{{done}}/{{total}} Lezioni completate"
    },
    "qaida.level_number": {
        "en": "Level {{number}}",
        "bn": "লেভেল {{number}}",
        "hi": "लेवल {{number}}",
        "it": "Livello {{number}}"
    },
    "qaida.view_map": {
        "en": "Map",
        "bn": "ম্যাপ",
        "hi": "नक्शा",
        "it": "Mappa"
    },
    "qaida.view_list": {
        "en": "List",
        "bn": "তালিকা",
        "hi": "सूची",
        "it": "Elenco"
    },
    "qaida.track_subtitle": {
        "en": "Step {{step}} · {{count}} Lessons",
        "bn": "ধাপ {{step}} · মোট {{count}}টি পাঠ",
        "hi": "चरण {{step}} · {{count}} पाठ",
        "it": "Passo {{step}} · {{count}} Lezioni"
    },
    "qaida.track_badge": {
        "en": "Track {{number}}",
        "bn": "ট্র্যাক {{number}}",
        "hi": "ट्रैक {{number}}",
        "it": "Percorso {{number}}"
    },
    "qaida.track_completed_lessons": {
        "en": "{{done}}/{{total}} Completed",
        "bn": "{{done}}/{{total}} সম্পন্ন",
        "hi": "{{done}}/{{total}} पूर्ण",
        "it": "{{done}}/{{total}} Completato"
    },
    "qaida.admin_all_lessons_open": {
        "en": "Admin Mode: All lessons unlocked",
        "bn": "এডমিন মোড: সকল পাঠ উন্মুক্ত",
        "hi": "एडमिन मोड: सभी पाठ अनलॉक",
        "it": "Modalità amministratore: tutte le lezioni sbloccate"
    },
    "qaida.lock_mode_sequential": {
        "en": "Lock Mode: Unlock sequentially",
        "bn": "লক মোড: ক্রমান্বয়ে আনলক",
        "hi": "लॉक मोड: क्रमिक अनलॉक",
        "it": "Modalità blocco: sblocco sequenziale"
    },
    "qaida.lesson_list_title": {
        "en": "Lesson List ({{count}} Lessons)",
        "bn": "পাঠ তালিকা ({{count}}টি পাঠ)",
        "hi": "पाठ सूची ({{count}} पाठ)",
        "it": "Elenco lezioni ({{count}} lezioni)"
    },
    "qaida.start_action": {
        "en": "Start!",
        "bn": "শুরু করো!",
        "hi": "शुरू करें!",
        "it": "Inizia!"
    },
    "qaida.lesson_reach_req": {
        "en": "Complete the previous lesson successfully to reach this one.",
        "bn": "আগের পাঠ সফলভাবে শেষ করে এই পাঠে পৌঁছাও।",
        "hi": "इस पाठ तक पहुँचने के लिए पिछला पाठ पूरा करें।",
        "it": "Completa con successo la lezione precedente per raggiungere questa."
    },
    "qaida.lesson_badge": {
        "en": "Lesson {{number}}",
        "bn": "পাঠ {{number}}",
        "hi": "पाठ {{number}}",
        "it": "Lezione {{number}}"
    },
    "qaida.checkpoint_exam_title": {
        "en": "Checkpoint Exam {{number}}",
        "bn": "চেকপয়েন্ট পরীক্ষা {{number}}",
        "hi": "चेकपॉइंट परीक्षा {{number}}",
        "it": "Esame checkpoint {{number}}"
    },
    "qaida.checkpoint_exam_subtitle": {
        "en": "Assessment of lessons {{start}} to {{end}}",
        "bn": "পাঠ {{start}} থেকে {{end}} এর মূল্যায়ন",
        "hi": "पाठ {{start}} से {{end}} का मूल्यांकन",
        "it": "Valutazione delle lezioni da {{start}} a {{end}}"
    },
    "qaida.checkpoint_exam_desc": {
        "en": "Test your knowledge from the previous 5 lessons. Passing score: 80/100.",
        "bn": "পূর্ববর্তী ৫টি পাঠের অর্জিত জ্ঞান যাচাই করুন। পাস নম্বর: ৮০/১০০।",
        "hi": "पिछले 5 पाठों के ज्ञान का परीक्षण करें। पास अंक: 80/100।",
        "it": "Verifica le tue conoscenze delle ultime 5 lezioni. Punteggio minimo: 80/100."
    },
    "qaida.checkpoint_q_title": {
        "en": "Checkpoint Question {{number}}: Which is the correct Arabic form of {{title}}?",
        "bn": "চেকপয়েন্ট প্রশ্ন {{number}}: {{title}}-এর সঠিক আরবি রূপ কোনটি?",
        "hi": "चेकपॉइंट प्रश्न {{number}}: {{title}} का सही अरबी रूप कौन सा है?",
        "it": "Domanda checkpoint {{number}}: Qual è la forma araba corretta di {{title}}?"
    },
    "qaida.checkpoint_correct_expl": {
        "en": "Correct! This is {{title}}.",
        "bn": "সঠিক! এটি {{title}}।",
        "hi": "सही! यह {{title}} है।",
        "it": "Corretto! Questa è {{title}}."
    },
    "qaida.final_exam_title": {
        "en": "{{title}} - Final Exam",
        "bn": "{{title}} - চূড়ান্ত পরীক্ষা",
        "hi": "{{title}} - अंतिम परीक्षा",
        "it": "{{title}} - Esame finale"
    },
    "qaida.final_exam_subtitle": {
        "en": "Track {{number}} Final Assessment",
        "bn": "ট্র্যাক {{number}} সমাপনী মূল্যায়ন",
        "hi": "ट्रैक {{number}} समापन मूल्यांकन",
        "it": "Valutazione finale percorso {{number}}"
    },
    "qaida.final_exam_desc": {
        "en": "Comprehensive questions from all lessons in the track. Passing unlocks the next track.",
        "bn": "সম্পূর্ণ ট্র্যাকের সকল পাঠ থেকে সমন্বিত প্রশ্ন। পাস করলে পরবর্তী ট্র্যাক উন্মুক্ত হবে।",
        "hi": "पूरे ट्रैक के सभी पाठों से प्रश्न। उत्तीर्ण होने पर अगला ट्रैक अनलॉक होगा।",
        "it": "Domande complete da tutte le lezioni del percorso. Superarlo sblocca il percorso successivo."
    },
    "qaida.final_q_title": {
        "en": "Final Question {{number}}: Which is the correct rule/form of {{title}}?",
        "bn": "চূড়ান্ত প্রশ্ন {{number}}: {{title}}-এর সঠিক রূপ/বিধান কোনটি?",
        "hi": "अंतिम प्रश्न {{number}}: {{title}} का सही रूप/नियम कौन सा है?",
        "it": "Domanda finale {{number}}: Qual è la forma/regola corretta di {{title}}?"
    },
    "qaida.final_correct_expl": {
        "en": "MashaAllah! You gave the correct answer.",
        "bn": "মাশাআল্লাহ! আপনি সঠিক উত্তর দিয়েছেন।",
        "hi": "माशाअल्लाह! आपने सही उत्तर दिया।",
        "it": "MashaAllah! Hai risposto correttamente."
    },
    "qaida.checkpoint_passed_badge": {
        "en": "Checkpoint {{number}} ✓",
        "bn": "চেকপয়েন্ট {{number}} ✓",
        "hi": "चेकपॉइंट {{number}} ✓",
        "it": "Checkpoint {{number}} ✓"
    },
    "qaida.track_passed_badge": {
        "en": "Track {{number}} Passed!",
        "bn": "ট্র্যাক {{number}} সমাপনী উত্তীর্ণ!",
        "hi": "ट्रैक {{number}} उत्तीर्ण!",
        "it": "Percorso {{number}} superato!"
    },
    "qaida.track_final_exam_label": {
        "en": "Final Exam",
        "bn": "চূড়ান্ত পরীক্ষা",
        "hi": "अंतिम परीक्षा",
        "it": "Esame finale"
    },
    "qaida.lesson_locked_snack": {
        "en": "This lesson is locked.",
        "bn": "পাঠটি লক করা রয়েছে।",
        "hi": "यह पाठ लॉक है।",
        "it": "Questa lezione è bloccata."
    },
    "qaida.completed_status": {
        "en": "Completed",
        "bn": "সম্পন্ন",
        "hi": "पूर्ण",
        "it": "Completato"
    },
    "qaida.passed_score_100": {
        "en": "Passed (100/100)",
        "bn": "পাস (১০০/১০০)",
        "hi": "पास (100/100)",
        "it": "Superato (100/100)"
    },
    "qaida.track_final_exam": {
        "en": "Track Final Exam",
        "bn": "ট্র্যাক ফাইনাল পরীক্ষা",
        "hi": "ट्रैक अंतिम परीक्षा",
        "it": "Esame finale percorso"
    },
    "qaida.certified_badge": {
        "en": "Certified",
        "bn": "সার্টিফায়েড",
        "hi": "प्रमाणित",
        "it": "Certificato"
    },
    "qaida.full_track_assessment": {
        "en": "{{title}} Full Assessment",
        "bn": "{{title}} সম্পূর্ণ মূল্যায়ন",
        "hi": "{{title}} संपूर्ण मूल्यांकन",
        "it": "Valutazione completa {{title}}"
    },
    # Qaida Lesson Screen
    "qaida.lesson.step_listen": {
        "en": "Listen",
        "bn": "শুনে বাছি",
        "hi": "सुनकर चुनें",
        "it": "Ascolta"
    },
    "qaida.lesson.step_form": {
        "en": "Forms",
        "bn": "রূপ চিনি",
        "hi": "রূপ पहचानें",
        "it": "Forme"
    },
    "qaida.lesson.step_dots": {
        "en": "Dot Puzzle",
        "bn": "বিন্দুর পাজল",
        "hi": "नुक़्ते की पहेली",
        "it": "Puzzle punti"
    },
    "qaida.lesson.step_memory": {
        "en": "Memory",
        "bn": "মনে আছে?",
        "hi": "याद है?",
        "it": "Ricordi?"
    },
    "qaida.lesson.step_pronounce": {
        "en": "Pronounce",
        "bn": "মুখে বলি",
        "hi": "उच्चारण करें",
        "it": "Pronuncia"
    },
    "qaida.lesson.step_complete": {
        "en": "Complete",
        "bn": "পাঠ শেষ",
        "hi": "सबक़ पूरा",
        "it": "Finito"
    },
    "qaida.lesson.exit_title": {
        "en": "Leave lesson?",
        "bn": "পাঠ থেকে বের হবে?",
        "hi": "क्या सबक़ छोड़ना चाहते हैं?",
        "it": "Vuoi uscire dalla lezione?"
    },
    "qaida.lesson.exit_message": {
        "en": "Your progress (step {{step}}) will be saved. You can resume anytime.",
        "bn": "তোমার অগ্রগতি (ধাপ {{step}}) সংরক্ষিত থাকবে। পরে যেকোনো সময় এখান থেকে শুরু করতে পারবে।",
        "hi": "आपकी प्रगति (चरण {{step}}) सुरक्षित रहेगी। आप कभी भी यहाँ से जारी रख सकते हैं।",
        "it": "I tuoi progressi (passo {{step}}) saranno salvati. Puoi riprendere in qualsiasi momento."
    },
    "qaida.lesson.keep_learning": {
        "en": "Keep Learning",
        "bn": "পড়তে থাকি",
        "hi": "पढ़ते रहें",
        "it": "Continua a studiare"
    },
    "qaida.lesson.exit": {
        "en": "Exit",
        "bn": "বের হই",
        "hi": "बाहर निकलें",
        "it": "Esci"
    },
    "qaida.lesson.makhraj_default": {
        "en": "Say the letter slowly and check your pronunciation with a teacher or parent.",
        "bn": "হরফটি ধীরে বলো এবং শিক্ষক/অভিভাবকের কাছে উচ্চারণ মিলিয়ে নাও।",
        "hi": "अक्षर को धीरे से बोलें और शिक्षक या अभिभावक से उच्चारण मिलाएं।",
        "it": "Pronuncia la lettera lentamente e confronta la pronuncia con un insegnante o genitore."
    },
    "qaida.lesson.makhraj_title": {
        "en": "Makhraj Guide",
        "bn": "শুরুর মাখরাজ নোট",
        "hi": "मख़रज गाइड",
        "it": "Guida al Makhraj"
    },
    "qaida.lesson.step_listen_title": {
        "en": "Listen & Choose Letter",
        "bn": "শব্দ শুনে হরফ বাছো",
        "hi": "आवाज़ सुनकर अक्षर चुनें",
        "it": "Ascolta e scegli la lettera"
    },
    "qaida.lesson.step_form_title": {
        "en": "Recognize Letter Forms",
        "bn": "হরফের রূপ চিনি",
        "hi": "अक्षर के रूप पहचानें",
        "it": "Riconosci le forme della lettera"
    },
    "qaida.lesson.step_dots_title": {
        "en": "Dot Puzzle",
        "bn": "বিন্দুর পাজল",
        "hi": "नुक़्ते की पहेली",
        "it": "Puzzle dei punti"
    },
    "qaida.lesson.step_memory_title": {
        "en": "Do You Remember?",
        "bn": "মনে আছে?",
        "hi": "क्या याद है?",
        "it": "Ti ricordi?"
    },
    "qaida.lesson.step_pronounce_title": {
        "en": "Say It Aloud",
        "bn": "মুখে বলি",
        "hi": "ज़ोर से बोलें",
        "it": "Pronuncia ad alta voce"
    },
    "qaida.lesson.step_counter": {
        "en": "{{current}} / {{total}}",
        "bn": "{{current}} / {{total}}",
        "hi": "{{current}} / {{total}}",
        "it": "{{current}} / {{total}}"
    },
    "qaida.lesson.next_step": {
        "en": "Next Step",
        "bn": "পরের ধাপে যাই",
        "hi": "अगले चरण पर जाएं",
        "it": "Passo successivo"
    },
    "qaida.lesson.prompt_listen": {
        "en": "Listen for “{{letter}}” and choose the letter.",
        "bn": "“{{letter}}” অক্ষরটি শুনে বেছে নাও।",
        "hi": "“{{letter}}” अक्षर सुनकर चुनें।",
        "it": "Ascolta “{{letter}}” e scegli la lettera."
    },
    "qaida.lesson.prompt_form": {
        "en": "This is another form of the same letter. Find the matching one.",
        "bn": "এটি একই হরফের আরেকটি রূপ। মিল আছে এমনটি খুঁজে নাও।",
        "hi": "यह उसी अक्षर का दूसरा रूप है। मिलता-जुलता रूप चुनें।",
        "it": "Questa è un'altra forma della stessa lettera. Trova quella corrispondente."
    },
    "qaida.lesson.prompt_dots": {
        "en": "Which dot pattern belongs on \"{{letter}}\"?",
        "bn": "কোন বিন্দুর টুকরোটি “{{letter}}” হরফে বসবে?",
        "hi": "\"{{letter}}\" पर कौन सा नुक़्ता आएगा?",
        "it": "Quale punto appartiene alla lettera \"{{letter}}\"?"
    },
    "qaida.lesson.prompt_memory": {
        "en": "Which one is the letter \"{{letter}}\"?",
        "bn": "“{{letter}}” অক্ষরটি কোনটি?",
        "hi": "\"{{letter}}\" अक्षर कौन सा है?",
        "it": "Qual è la lettera \"{{letter}}\"?"
    },
    "qaida.lesson.prompt_pronounce": {
        "en": "Say the Arabic name into the microphone: {{name}}",
        "bn": "মাইক্রোফোনে আরবি নামটি বলো: {{name}}",
        "hi": "माइक्रोफ़ोन में अरबी नाम बोलें: {{name}}",
        "it": "Pronuncia il nome arabo nel microfono: {{name}}"
    },
    "qaida.lesson.listen_audio": {
        "en": "Listen to Sound",
        "bn": "শব্দটি শুনি",
        "hi": "आवाज़ सुनें",
        "it": "Ascolta il suono"
    },
    "qaida.lesson.listen_hint_audio": {
        "en": "Listen and select the correct letter.",
        "bn": "শুনে সঠিক হরফটি বেছে নাও।",
        "hi": "सुनकर सही अक्षर चुनें।",
        "it": "Ascolta e scegli la lettera corretta."
    },
    "qaida.lesson.listen_hint_no_audio": {
        "en": "You can choose by looking at the sample even if audio does not play.",
        "bn": "অডিও না চললেও নমুনা দেখে হরফটি বেছে নিতে পারো।",
        "hi": "ऑडियो न चलने पर भी नमूना देखकर अक्षर चुन सकते हैं।",
        "it": "Puoi scegliere guardando l'esempio anche se l'audio non funziona."
    },
    "qaida.lesson.feedback_form_success": {
        "en": "MashaAllah! The letter form matched.",
        "bn": "মাশাআল্লাহ! হরফের রূপটি মিলেছে।",
        "hi": "माशाअल्लाह! अक्षर का रूप मिल गया।",
        "it": "MashaAllah! La forma della lettera corrisponde."
    },
    "qaida.lesson.dot_none": {
        "en": "No dot",
        "bn": "বিন্দু নেই",
        "hi": "कोई नुक़्ता नहीं",
        "it": "Nessun punto"
    },
    "qaida.lesson.dot_one_above": {
        "en": "1 above",
        "bn": "একটি ওপরে",
        "hi": "1 ऊपर",
        "it": "1 sopra"
    },
    "qaida.lesson.dot_one_below": {
        "en": "1 below",
        "bn": "একটি নিচে",
        "hi": "1 নিচে",
        "it": "1 sotto"
    },
    "qaida.lesson.dot_two_above": {
        "en": "2 above",
        "bn": "দুটি ওপরে",
        "hi": "2 ऊपर",
        "it": "2 sopra"
    },
    "qaida.lesson.dot_three_above": {
        "en": "3 above",
        "bn": "তিনটি ওপরে",
        "hi": "3 ऊपर",
        "it": "3 sopra"
    },
    "qaida.lesson.dot_two_below": {
        "en": "2 below",
        "bn": "দুটি নিচে",
        "hi": "2 নিচে",
        "it": "2 sotto"
    },
    "qaida.lesson.place_dots_instruction": {
        "en": "Place the correct dot on the letter",
        "bn": "হরফের গায়ে ঠিক বিন্দুটি বসাও",
        "hi": "अक्षर पर सही नुक़्ता लगाएं",
        "it": "Posiziona il punto corretto sulla lettera"
    },
    "qaida.lesson.feedback_dots_success": {
        "en": "Awesome! The dot placement is correct.",
        "bn": "দারুণ! বিন্দুর জায়গাটিও ঠিক হয়েছে।",
        "hi": "शानदार! नुक़्ते की जगह बिल्कुल सही है।",
        "it": "Fantastico! La posizione del punto è corretta."
    },
    "qaida.lesson.feedback_memory_success": {
        "en": "Spot on! Now it's time to say it yourself.",
        "bn": "ঠিক ধরেছ! এবার নিজের কণ্ঠে বলার পালা।",
        "hi": "बिल्कुल सही! अब खुद बोलने की बारी है।",
        "it": "Esatto! Ora tocca a te pronunciarla."
    },
    "qaida.lesson.feedback_correct_letter": {
        "en": "MashaAllah! That's correct.",
        "bn": "মাশাআল্লাহ! ঠিক চিনেছ।",
        "hi": "माशाअल्लाह! बिल्कुल सही पहचाना।",
        "it": "MashaAllah! Esatto."
    },
    "qaida.lesson.speak_calmly": {
        "en": "Say clearly: {{name}}",
        "bn": "শান্তভাবে বলো: {{name}}",
        "hi": "आराम से बोलें: {{name}}",
        "it": "Pronuncia con calma: {{name}}"
    },
    "qaida.lesson.recognized_words": {
        "en": "Heard: {{words}}",
        "bn": "শোনা গেছে: {{words}}",
        "hi": "सुना गया: {{words}}",
        "it": "Rilevato: {{words}}"
    },
    "qaida.lesson.stop_listening": {
        "en": "Stop Listening",
        "bn": "শোনা বন্ধ করো",
        "hi": "सुनना बंद करें",
        "it": "Ferma l'ascolto"
    },
    "qaida.lesson.press_to_speak": {
        "en": "Hold to Speak",
        "bn": "চেপে বলো",
        "hi": "दबाकर बोलें",
        "it": "Premi per parlare"
    },
    "qaida.lesson.no_stt_banner": {
        "en": "Arabic voice recognition is unavailable on this device. A parent can listen and confirm.",
        "bn": "এই ডিভাইসে আরবি voice recognition পাওয়া যায়নি। অভিভাবক শুনে সাহায্য করতে পারেন।",
        "hi": "इस डिवाइस पर अरबी वॉइस रिकग्निशन उपलब्ध नहीं है। अभिभावक सुनकर मदद कर सकते हैं।",
        "it": "Il riconoscimento vocale arabo non è disponibile su questo dispositivo. Un genitore può ascoltare e confermare."
    },
    "qaida.lesson.i_pronounced": {
        "en": "I have pronounced it",
        "bn": "আমি উচ্চারণ করে ফেলেছি",
        "hi": "मैंने उच्चारण कर लिया",
        "it": "Ho pronunciato"
    },
    "qaida.lesson.guardian_confirm": {
        "en": "Parent confirms",
        "bn": "অভিভাবক শুনে নিশ্চিত করবেন",
        "hi": "अभिभावक सुनकर पुष्टि करें",
        "it": "Il genitore conferma"
    },
    "qaida.lesson.voice_practice_note": {
        "en": "Voice recognition is basic practice. Hearing by a teacher or parent is essential for proper makhraj.",
        "bn": "ভয়েস মিলিয়ে দেখা একটি প্রাথমিক অনুশীলন। সঠিক মাখরাজের জন্য শিক্ষক/অভিভাবকের শোনা জরুরি।",
        "hi": "आवाज़ मिलाना एक बुनियादी अभ्यास है। सही मख़रज के लिए शिक्षक या अभिभावक का सुनना ज़रूरी है।",
        "it": "La verifica vocale è una pratica iniziale. L'ascolto di un insegnante o genitore è fondamentale per il makhraj corretto."
    },
    "qaida.lesson.feedback_try_again": {
        "en": "Try again! Look at the big letter and think calmly—you can do it!",
        "bn": "আবার চেষ্টা করো। বড় হরফটি দেখে ধীরে ভাবো—তুমি পারবে!",
        "hi": "फिर से कोशिश करें। बड़े अक्षर को देखकर सोचें—आप कर सकते हैं!",
        "it": "Riprova! Guarda la lettera grande e pensa con calma: puoi farcela!"
    },
    "qaida.lesson.audio_failed": {
        "en": "Cannot play audio on this device.",
        "bn": "এই ডিভাইসে শব্দ শোনানো যাচ্ছে না।",
        "hi": "इस डिवाइस पर ऑडियो नहीं चलाया जा सका।",
        "it": "Impossibile riprodurre l'audio su questo dispositivo."
    },
    "qaida.lesson.feedback_voice_excellent": {
        "en": "Great! Excellent pronunciation, MashaAllah!",
        "bn": "দারুণ! চমৎকার উচ্চারণ করেছ, মাশাআল্লাহ!",
        "hi": "शानदार! बेहतरीन उच्चारण किया, माशाअल्लाह!",
        "it": "Fantastico! Ottima pronuncia, MashaAllah!"
    },
    "qaida.lesson.feedback_voice_close": {
        "en": "Close! Say it slowly once more, then try again.",
        "bn": "কাছাকাছি—আরেকবার ধীরে বলো, তারপর চেষ্টা করো।",
        "hi": "बहुत करीब—एक बार धीरे से बोलें, फिर कोशिश करें।",
        "it": "Quasi! Pronuncia lentamente ancora una volta, poi riprova."
    },
    "qaida.lesson.feedback_mic_failed": {
        "en": "Microphone could not start. Try again or ask a parent.",
        "bn": "মাইক্রোফোন চালু হয়নি। আবার চেষ্টা করো বা অভিভাবকের সাহায্য নাও।",
        "hi": "माइक्रोफ़ोन शुरू नहीं हुआ। फिर से कोशिश करें या अभिभावक की मदद लें।",
        "it": "Il microfono non si è avviato. Riprova o chiedi aiuto a un genitore."
    },
    "qaida.lesson.guardian_help_title": {
        "en": "Parent's Help",
        "bn": "অভিভাবকের সাহায্য",
        "hi": "अभिभावक की सहायता",
        "it": "Aiuto del genitore"
    },
    "qaida.lesson.guardian_help_message": {
        "en": "Did the child attempt to say \"{{letter}}\"? Please confirm if it sounds correct.",
        "bn": "শিশুটি কি “{{letter}}” বলার চেষ্টা করেছে? শুনে ঠিক মনে হলে নিশ্চিত করুন।",
        "hi": "क्या बच्चे ने \"{{letter}}\" बोलने की कोशिश की? सही लगे तो पुष्टि करें।",
        "it": "Il bambino ha provato a dire \"{{letter}}\"? Conferma se sembra corretto."
    },
    "qaida.lesson.try_again": {
        "en": "Try Again",
        "bn": "আবার চেষ্টা",
        "hi": "फिर कोशिश करें",
        "it": "Riprova"
    },
    "qaida.lesson.confirmed_correct": {
        "en": "Heard it, it's correct",
        "bn": "শুনেছি, ঠিক বলেছে",
        "hi": "सुना है, सही बोला",
        "it": "Ho ascoltato, è corretto"
    },
    "qaida.lesson.feedback_guardian_confirmed": {
        "en": "Parent listened and confirmed.",
        "bn": "অভিভাবক উচ্চারণ শুনে নিশ্চিত করেছেন।",
        "hi": "अभिभावक ने सुनकर पुष्टि की।",
        "it": "Il genitore ha ascoltato e confermato."
    },
    "qaida.lesson.feedback_self_practice": {
        "en": "You practiced pronouncing it. Voice verification unavailable on this device.",
        "bn": "তুমি উচ্চারণের চেষ্টা করেছ। এই ডিভাইসে কণ্ঠ যাচাই করা যায়নি।",
        "hi": "आपने उच्चारण का अभ्यास किया। इस डिवाइस पर आवाज़ जांची नहीं जा सकी।",
        "it": "Hai fatto pratica di pronuncia. Verifica vocale non disponibile su questo dispositivo."
    },
    "qaida.lesson.finish_already_completed": {
        "en": "You already completed this lesson!",
        "bn": "এই পাঠটি আগেই শেষ করেছ!",
        "hi": "आपने यह सबक़ पहले ही पूरा कर लिया है!",
        "it": "Hai già completato questa lezione!"
    },
    "qaida.lesson.finish_all_done": {
        "en": "Completed all steps, MashaAllah!",
        "bn": "সব ধাপ শেষ করেছ, মাশাআল্লাহ!",
        "hi": "सभी चरण पूरे कर लिए, माशाअल्लाह!",
        "it": "Tutti i passaggi completati, MashaAllah!"
    },
    "qaida.lesson.finish_recap": {
        "en": "Listen · Recognize · Dot Puzzle · Quiz · Speak",
        "bn": "শোনা · রূপ চেনা · বিন্দুর পাজল · কুইজ · বলা",
        "hi": "सुनना · पहचानना · नुक़्ते की पहेली · क्विज़ · बोलना",
        "it": "Ascolta · Riconosci · Puzzle dei punti · Quiz · Parla"
    },
    "qaida.lesson.finish_xp_earned": {
        "en": "You earned +10 XP for completing this lesson!",
        "bn": "এই পাঠ শেষ করে +১০ XP পেয়েছ!",
        "hi": "यह सबक़ पूरा करके +10 XP मिले!",
        "it": "Hai ottenuto +10 XP completando questa lezione!"
    },
    "qaida.lesson.finish_xp_already": {
        "en": "You already received +10 XP for this lesson!",
        "bn": "এই পাঠের +১০ XP আগেই পেয়েছ!",
        "hi": "इस सबक़ के +10 XP पहले ही मिल चुके हैं!",
        "it": "Hai già ricevuto i +10 XP per questa lezione!"
    },
    "qaida.lesson.finish_button": {
        "en": "Finish Lesson",
        "bn": "পাঠ শেষ করি",
        "hi": "सबक़ पूरा करें",
        "it": "Termina lezione"
    },
    "qaida.lesson.next_lesson_button": {
        "en": "Next Lesson: {{title}}",
        "bn": "পরের পাঠ: {{title}}",
        "hi": "अगला सबक़: {{title}}",
        "it": "Prossima lezione: {{title}}"
    },
    "qaida.lesson.listen_letter_name": {
        "en": "Listen to letter name",
        "bn": "হরফের নাম শোনো",
        "hi": "अक्षर का नाम सुनें",
        "it": "Ascolta il nome della lettera"
    },
    # Qaida Activity Screen
    "qaida.activity.rules.core_rules": {
        "en": "Core Rules & Principles:",
        "bn": "মূল নিয়ম ও কানুন:",
        "hi": "मुख्य नियम और कायदे:",
        "it": "Regole e principi fondamentali:"
    },
    "qaida.activity.rules.letters_count": {
        "en": "Letters of this rule ({{count}}):",
        "bn": "এই নিয়মের হরফসমূহ ({{count}}টি):",
        "hi": "इस नियम के अक्षर ({{count}}):",
        "it": "Lettere di questa regola ({{count}}):"
    },
    "qaida.activity.rules.standard_examples": {
        "en": "Standard Example Words:",
        "bn": "আদর্শ উদাহরণ শব্দসমূহ:",
        "hi": "मानक उदाहरण शब्द:",
        "it": "Esempi tipici di parole:"
    },
    "qaida.activity.rules.understood_btn": {
        "en": "Understood, let's practice ➔",
        "bn": "বুঝেছি, অনুশীলন করি ➔",
        "hi": "समझ गए, अभ्यास करें ➔",
        "it": "Capito, facciamo pratica ➔"
    },
    "qaida.activity.rules.start_understood_btn": {
        "en": "Understood, start practice ➔",
        "bn": "বুঝেছি, অনুশীলন শুরু করি ➔",
        "hi": "समझ गए, अभ्यास शुरू करें ➔",
        "it": "Capito, inizia la pratica ➔"
    },
    "qaida.activity.rules.learn_and_start": {
        "en": "Learn the rules & start practice",
        "bn": "নিয়ম জেনে অনুশীলন শুরু করি",
        "hi": "नियम जानकर अभ्यास शुरू करें",
        "it": "Impara le regole e inizia la pratica"
    },
    "qaida.activity.rules.badge": {
        "en": "Rule",
        "bn": "নিয়ম",
        "hi": "नियम",
        "it": "Regola"
    },
    "qaida.activity.header.step_indicator": {
        "en": "Step {{slot}}/7 · {{title}}",
        "bn": "ধাপ {{slot}}/৭ · {{title}}",
        "hi": "चरण {{slot}}/7 · {{title}}",
        "it": "Passo {{slot}}/7 · {{title}}"
    },
    "qaida.activity.header.voice_guide": {
        "en": "Voice Guide",
        "bn": "ভয়েস গাইড",
        "hi": "वॉइस गाइड",
        "it": "Guida vocale"
    },
    "qaida.activity.header.quiet_mode_on": {
        "en": "Quiet Mode Active",
        "bn": "নীরব মোড সক্রিয়",
        "hi": "शांत मोड सक्रिय",
        "it": "Modalità silenziosa attiva"
    },
    "qaida.activity.header.quiet_mode_off": {
        "en": "Quiet Mode Off",
        "bn": "নীরব মোড বন্ধ",
        "hi": "शांत मोड बंद",
        "it": "Modalità silenziosa disattivata"
    },
    "qaida.activity.common.does_not_match": {
        "en": "Doesn't match, think again!",
        "bn": "মিলছে না, আবার ভাবো!",
        "hi": "मेल नहीं खा रहा, फिर से सोचें!",
        "it": "Non corrisponde, ripensaci!"
    },
    "qaida.activity.common.drag_or_tap_instruction": {
        "en": "Drag or tap from below to place:",
        "bn": "নিচ থেকে টেনে বা ট্যাপ করে বসাও:",
        "hi": "नीचे से खींचकर या टैप करके रखें:",
        "it": "Trascina o tocca dal basso per inserire:"
    },
    "qaida.activity.common.drag_or_tap_sort": {
        "en": "Drag or tap from below to arrange:",
        "bn": "নিচ থেকে টেনে বা ট্যাপ করে সাজাও:",
        "hi": "नीचे से खींचकर या टैप करके सजाएं:",
        "it": "Trascina o tocca dal basso per ordinare:"
    },
    "qaida.activity.common.drag_letters_box": {
        "en": "Drag letters into the box below (or tap):",
        "bn": "হরফগুলো টেনে নিচের ঘরে রাখো (অথবা ট্যাপ করো):",
        "hi": "अक्षरों को नीचे दिए गए बॉक्स में खींचें (या टैप करें):",
        "it": "Trascina le lettere nella casella sottostante (o tocca):"
    },
    "qaida.activity.common.items_placed": {
        "en": "{{count}} placed",
        "bn": "{{count}} টি রাখা হয়েছে",
        "hi": "{{count}} रखे गए हैं",
        "it": "{{count}} inseriti"
    },
    "qaida.activity.common.drag_here_or_tap": {
        "en": "Drag here or tap",
        "bn": "এখানে ড্র্যাগ করো অথবা ট্যাপ করো",
        "hi": "यहाँ खींचें या टैप करें",
        "it": "Trascina qui o tocca"
    },
    "qaida.activity.common.verify": {
        "en": "Verify",
        "bn": "যাচাই করুন",
        "hi": "जांचें",
        "it": "Verifica"
    },
    "qaida.activity.common.all_pairs_matched": {
        "en": "MashaAllah! All pairs matched!",
        "bn": "মাশাআল্লাহ! সব জোড়া মিলে গেছে!",
        "hi": "माशाअल्लाह! सभी जोड़े मिल गए!",
        "it": "MashaAllah! Tutte le coppie corrispondono!"
    },
    "qaida.activity.common.hint": {
        "en": "Hint",
        "bn": "ইঙ্গিত",
        "hi": "संकेत",
        "it": "Suggerimento"
    },
    "qaida.activity.common.help": {
        "en": "Help",
        "bn": "সহায়তা",
        "hi": "सहायता",
        "it": "Aiuto"
    },
    "qaida.activity.common.ok": {
        "en": "OK",
        "bn": "ঠিক আছে",
        "hi": "ठीक है",
        "it": "OK"
    },
    "qaida.activity.common.next_step": {
        "en": "Next Step ➔",
        "bn": "পরবর্তী ধাপ ➔",
        "hi": "अगला चरण ➔",
        "it": "Prossimo passo ➔"
    },
    "qaida.activity.common.try_again": {
        "en": "Try Again ↻",
        "bn": "আবার চেষ্টা করি ↻",
        "hi": "फिर कोशिश करें ↻",
        "it": "Riprova ↻"
    },
    "qaida.activity.common.great_job": {
        "en": "MashaAllah! Excellent!",
        "bn": "মাশাআল্লাহ! চমৎকার!",
        "hi": "माशाअल्लाह! बेहतरीन!",
        "it": "MashaAllah! Eccellente!"
    },
    "qaida.activity.common.think_carefully": {
        "en": "Let's think carefully again",
        "bn": "মনোযোগ দিয়ে আবার ভাবি",
        "hi": "ध्यान से फिर सोचें",
        "it": "Pensaci attentamente"
    },
    "qaida.activity.harakat.zabar": {
        "en": "Zabar",
        "bn": "যবর",
        "hi": "ज़बर",
        "it": "Zabar"
    },
    "qaida.activity.harakat.zer": {
        "en": "Zer",
        "bn": "যের",
        "hi": "ज़ेर",
        "it": "Zer"
    },
    "qaida.activity.harakat.pesh": {
        "en": "Pesh",
        "bn": "পেশ",
        "hi": "पेश",
        "it": "Pesh"
    },
    "qaida.activity.harakat.sound_aa": {
        "en": "aa",
        "bn": "আ",
        "hi": "आ",
        "it": "aa"
    },
    "qaida.activity.harakat.sound_ee": {
        "en": "ee",
        "bn": "ই",
        "hi": "ई",
        "it": "ee"
    },
    "qaida.activity.harakat.sound_oo": {
        "en": "oo",
        "bn": "উ",
        "hi": "ऊ",
        "it": "oo"
    },
    "qaida.activity.harakat.pronunciation": {
        "en": "Pronunciation: {{name}} ({{sound}} sound)",
        "bn": "উচ্চারণ: {{name}} ({{sound}}-কার)",
        "hi": "उच्चारण: {{name}} ({{sound}} ध्वनि)",
        "it": "Pronuncia: {{name}} (suono {{sound}})"
    },
    "qaida.activity.harakat.slide_select_instruction": {
        "en": "Slide or tap to choose the correct Harakat:",
        "bn": "স্লাইড বা ট্যাপ করে সঠিক হরকত বেছে নাও:",
        "hi": "स्लाइड या टैप करके सही हरकत चुनें:",
        "it": "Scorri o tocca per scegliere l'harakat corretto:"
    },
    "qaida.activity.madd.alif_1_full": {
        "en": "1 Alif (Normal)",
        "bn": "১ আলিফ (স্বাভাবিক)",
        "hi": "1 अलिफ़ (सामान्य)",
        "it": "1 Alif (Normale)"
    },
    "qaida.activity.madd.alif_2_full": {
        "en": "2 Alif (Medium)",
        "bn": "২ আলিফ (মাঝারি)",
        "hi": "2 अलिफ़ (मध्यम)",
        "it": "2 Alif (Medio)"
    },
    "qaida.activity.madd.alif_3_full": {
        "en": "3 Alif (Long)",
        "bn": "৩ আলিফ (দীর্ঘ)",
        "hi": "3 अलिफ़ (लंबा)",
        "it": "3 Alif (Lungo)"
    },
    "qaida.activity.madd.alif_4_full": {
        "en": "4 Alif (Maximum)",
        "bn": "৪ আলিফ (সর্বোচ্চ দীর্ঘ)",
        "hi": "4 अलिफ़ (अधिकतम)",
        "it": "4 Alif (Massimo)"
    },
    "qaida.activity.madd.alif_1": {
        "en": "1 Alif",
        "bn": "১ আলিফ",
        "hi": "1 अलिफ़",
        "it": "1 Alif"
    },
    "qaida.activity.madd.alif_2": {
        "en": "2 Alif",
        "bn": "২ আলিফ",
        "hi": "2 अलिफ़",
        "it": "2 Alif"
    },
    "qaida.activity.madd.alif_3": {
        "en": "3 Alif",
        "bn": "৩ আলিফ",
        "hi": "3 अलिफ़",
        "it": "3 Alif"
    },
    "qaida.activity.madd.alif_4": {
        "en": "4 Alif (Long)",
        "bn": "৪ আলিফ (দীর্ঘ)",
        "hi": "4 अलिफ़ (लंबा)",
        "it": "4 Alif (Lungo)"
    },
    "qaida.activity.madd.harakat_2": {
        "en": "2 Harakat",
        "bn": "২ হরকত",
        "hi": "2 हरकत",
        "it": "2 Harakat"
    },
    "qaida.activity.madd.harakat_3_4": {
        "en": "3-4 Harakat",
        "bn": "৩-৪ হরকত",
        "hi": "3-4 हरकत",
        "it": "3-4 Harakat"
    },
    "qaida.activity.madd.harakat_5": {
        "en": "5 Harakat",
        "bn": "৫ হরকত",
        "hi": "5 हरकत",
        "it": "5 Harakat"
    },
    "qaida.activity.madd.harakat_6": {
        "en": "6 Harakat",
        "bn": "৬ হরকত",
        "hi": "6 हरकत",
        "it": "6 Harakat"
    },
    "qaida.activity.madd.stretch_info": {
        "en": "Stretch: {{name}} · {{harakat}}",
        "bn": "টান: {{name}} · {{harakat}}",
        "hi": "खिंचाव: {{name}} · {{harakat}}",
        "it": "Estensione: {{name}} · {{harakat}}"
    },
    "qaida.activity.madd.controller_instruction": {
        "en": "Madd Stretch Controller: Drag to lengthen the sound",
        "bn": "মাদ্দ স্ট্রেচ কন্ট্রোলার: টেনে আওয়াজ লম্বা করো",
        "hi": "मद्द स्ट्रेच कंट्रोलर: आवाज़ को खींचकर लंबा करें",
        "it": "Controller Madd: trascina per allungare il suono"
    },
    "qaida.activity.shaddah.rule_formula": {
        "en": "Tashdeed = 1 Sukun + 1 Harakat (Double weight)",
        "bn": "তাশদীদ = ১ বার সাকিন + ১ বার হরকত (দ্বিগুণ ওজন)",
        "hi": "तशदीद = 1 साकिन + 1 हरकत (दोगुना वज़न)",
        "it": "Tashdid = 1 Sukun + 1 Harakat (Doppio peso)"
    },
    "qaida.activity.shaddah.first_press": {
        "en": "1st Press (Sukun)",
        "bn": "১ম চাপ (সাকিন)",
        "hi": "पहला दबाव (साकिन)",
        "it": "1a Pressione (Sukun)"
    },
    "qaida.activity.shaddah.second_press": {
        "en": "2nd Press (Harakat)",
        "bn": "২য় চাপ (হরকত)",
        "hi": "दूसरा दबाव (हरकत)",
        "it": "2a Pressione (Harakat)"
    },
    "qaida.activity.shaddah.press_hard_first": {
        "en": "Press firmly (1st press)",
        "bn": "শক্ত করে চাপ দাও (১ম চাপ)",
        "hi": "ज़ोर से दबाएं (पहला दबाव)",
        "it": "Premi con decisione (1a pressione)"
    },
    "qaida.activity.shaddah.press_again_second": {
        "en": "Press once more! (2nd press)",
        "bn": "আরেকবার চাপ দাও! (২য় চাপ)",
        "hi": "एक बार और दबाएं! (दूसरा दबाव)",
        "it": "Premi di nuovo! (2a pressione)"
    },
    "qaida.activity.shaddah.double_press_complete": {
        "en": "Double press complete! MashaAllah!",
        "bn": "দ্বিগুণ চাপ সম্পন্ন! মাশাল্লাহ!",
        "hi": "दोगुना दबाव पूरा हुआ! माशाअल्लाह!",
        "it": "Doppia pressione completata! MashaAllah!"
    },
    "qaida.activity.echo.title": {
        "en": "Echo Mode: Listen to teacher, then repeat yourself",
        "bn": "ইকো মোড: উস্তাদের কন্ঠে শুনো, তারপর নিজেই বলো",
        "hi": "इको मोड: उस्ताद की आवाज़ सुनें, फिर खुद बोलें",
        "it": "Modalità Echo: ascolta l'insegnante, poi ripeti tu"
    },
    "qaida.activity.echo.listen_teacher": {
        "en": "1. Listen to teacher's recitation",
        "bn": "১. উস্তাদের তিলাওয়াত শুনুন",
        "hi": "1. उस्ताद का पाठ सुनें",
        "it": "1. Ascolta la recitazione dell'insegnante"
    },
    "qaida.activity.echo.recording_speak": {
        "en": "Recording... speak now!",
        "bn": "রেকর্ড হচ্ছে... বলুন!",
        "hi": "रिकॉर्डिंग हो रही है... बोलें!",
        "it": "Registrazione in corso... parla ora!"
    },
    "qaida.activity.echo.recorded_success": {
        "en": "2. Your recitation has been recorded! 🎧",
        "bn": "২. আপনার পাঠ রেকর্ড হয়েছে! 🎧",
        "hi": "2. आपका पाठ रिकॉर्ड हो गया है! 🎧",
        "it": "2. La tua recitazione è stata registrata! 🎧"
    },
    "qaida.activity.echo.tap_to_speak": {
        "en": "2. Tap microphone and speak",
        "bn": "২. মাইক্রোফোনে ট্যাপ করে বলুন",
        "hi": "2. माइक्रोफ़ोन पर टैप करके बोलें",
        "it": "2. Tocca il microfono e parla"
    },
    "qaida.activity.echo.compare_prompt": {
        "en": "Compare with the teacher. How was it?",
        "bn": "উস্তাদের সাথে মিলিয়ে দেখো। কেমন হলো?",
        "hi": "उस्ताद के साथ मिलाकर देखें। कैसा रहा?",
        "it": "Confronta con l'insegnante. Com'è andata?"
    },
    "qaida.activity.echo.say_again": {
        "en": "Say Again",
        "bn": "আবার বলি",
        "hi": "फिर से बोलें",
        "it": "Ripeti"
    },
    "qaida.activity.echo.matched_check": {
        "en": "Matched! ✓",
        "bn": "মিলে গেছে! ✓",
        "hi": "मिल गया! ✓",
        "it": "Corrisponde! ✓"
    },
    "qaida.activity.reading.read_aloud_tap": {
        "en": "Read each letter aloud in order and tap:",
        "bn": "ক্রমান্বয়ে প্রতিটি হরফ মুখে জোরে পড়ো এবং ট্যাপ করো:",
        "hi": "प्रत्येक अक्षर ज़ोर से पढ़ें और टैप करें:",
        "it": "Leggi ad alta voce ogni lettera in ordine e tocca:"
    },
    "qaida.activity.reading.spot_mistake": {
        "en": "Spot the mistake: which part violates Tajweed or Harakat rules?",
        "bn": "ভুলটি শনাক্ত করো: নিচের শব্দে কোনটি তাজবীদ বা হরকতের নিয়মের বিপরীত?",
        "hi": "गलती पहचानें: कौन सा भाग तजवीद या हरकत नियमों के विपरीत है?",
        "it": "Individua l'errore: quale parte viola le regole del Tajweed o Harakat?"
    },
    "qaida.activity.reading.listen_correct_audio": {
        "en": "Listen to correct pronunciation",
        "bn": "সঠিক উচ্চারণ শুনুন",
        "hi": "सही उच्चारण सुनें",
        "it": "Ascolta la pronuncia corretta"
    },
    "qaida.activity.reading.where_is_mistake": {
        "en": "Where is the mistake?",
        "bn": "কোথায় ভুল রয়েছে?",
        "hi": "गलती कहाँ है?",
        "it": "Dov'è l'errore?"
    },
    "qaida.activity.reading.discover_rule": {
        "en": "Discover Tajweed rule: observe harakat & adjacent letters to identify rule",
        "bn": "তাজবীদ নিয়ম আবিষ্কার করো: হরকত ও সংলগ্ন হরফ লক্ষ্য করে বিধান চিহ্নিত করো",
        "hi": "तजवीद नियम खोजें: हरकत और आस-पास के अक्षरों को देखकर नियम पहचानें",
        "it": "Scopri la regola di Tajweed: osserva harakat e lettere adiacenti"
    },
    "qaida.activity.reading.ghunnah_instruction": {
        "en": "Complete Ghunnah through the nasal passage (1.5-2 Alifs)",
        "bn": "নাকের বাঁশিতে শব্দ ধরে রেখে গুন্নাহ সম্পূর্ণ করুন (১.৫–২ আলিফ)",
        "hi": "नाक से आवाज़ निकालते हुए गुन्ना पूरा करें (1.5-2 अलिफ़)",
        "it": "Completa la Ghunnah attraverso la cavità nasale (1.5-2 Alif)"
    },
    "qaida.activity.reading.ghunnah_success": {
        "en": "MashaAllah! Ghunnah successfully completed ✓",
        "bn": "মাশাআল্লাহ! গুন্নাহ সফলভাবে সম্পন্ন হয়েছে ✓",
        "hi": "माशाअल्लाह! गुन्ना सफलतापूर्वक पूरा हुआ ✓",
        "it": "MashaAllah! Ghunnah completata con successo ✓"
    },
    "qaida.activity.reading.ghunnah_holding": {
        "en": "Ghunnah in progress... keep holding...",
        "bn": "গুন্নাহ চলছে... ধরে রাখুন...",
        "hi": "गुन्ना जारी है... पकड़े रहें...",
        "it": "Ghunnah in corso... tieni premuto..."
    },
    "qaida.activity.reading.ghunnah_hold_below": {
        "en": "Hold down below",
        "bn": "নিচে চেপে ধরে রাখুন",
        "hi": "नीचे दबाकर रखें",
        "it": "Tieni premuto in basso"
    },
    "qaida.activity.reading.ghunnah_completed": {
        "en": "Completed!",
        "bn": "সম্পন্ন হয়েছে!",
        "hi": "पूरा हो गया!",
        "it": "Completato!"
    },
    "qaida.activity.reading.ghunnah_keep_holding": {
        "en": "Keep holding...",
        "bn": "ধরে রাখুন...",
        "hi": "पकड़े रहें...",
        "it": "Continua a tenere..."
    },
    "qaida.activity.reading.ghunnah_press_to_do": {
        "en": "Press & hold to do Ghunnah",
        "bn": "চেপে ধরে গুন্নাহ করুন",
        "hi": "दबाकर गुन्ना करें",
        "it": "Premi per fare Ghunnah"
    },
    "qaida.activity.games.trace_instruction": {
        "en": "Trace over the letter with your finger",
        "bn": "আঙুল দিয়ে হরফটির ওপর আঁকো",
        "hi": "उंगली से अक्षर पर रेखा खींचें",
        "it": "Traccia sopra la lettera con il dito"
    },
    "qaida.activity.games.trace_success": {
        "en": "MashaAllah! Letter tracing complete!",
        "bn": "মাশাআল্লাহ! হরফ আঁকা সম্পন্ন হয়েছে!",
        "hi": "माशाअल्लाह! अक्षर बनाना पूरा हुआ!",
        "it": "MashaAllah! Tracciamento completato!"
    },
    "qaida.activity.games.erase_and_redraw": {
        "en": "Clear and draw again",
        "bn": "মুছে আবার আঁকো",
        "hi": "मिटाकर फिर से बनाएं",
        "it": "Cancella e disegna di nuovo"
    },
    "qaida.activity.games.drawing_complete": {
        "en": "Drawing Complete ✓",
        "bn": "আঁকা সম্পন্ন ✓",
        "hi": "बनाना पूरा ✓",
        "it": "Disegno completato ✓"
    },
    "qaida.activity.games.completed_action": {
        "en": "I Completed It",
        "bn": "সম্পন্ন করেছি",
        "hi": "पूरा कर लिया",
        "it": "Ho completato"
    },
    "qaida.activity.games.odd_one_out": {
        "en": "Find the odd letter: tap the letter belonging to a different group",
        "bn": "ব্যতিক্রম হরফটি খুঁজুন: নিচের হরফগুলোর মধ্যে কোনটি ভিন্ন দলের স্পর্শ করে নির্বাচন করুন",
        "hi": "अलग अक्षर खोजें: नीचे दिए गए अक्षरों में से भिन्न अक्षर चुनें",
        "it": "Trova la lettera diversa: tocca quella che appartiene a un altro gruppo"
    },
    "qaida.activity.games.collect_letters": {
        "en": "Catch the letters:",
        "bn": "হরফ সংগ্রহ করো:",
        "hi": "अक्षर एकत्र करें:",
        "it": "Raccogli le lettere:"
    },
    "qaida.activity.games.caught_counter": {
        "en": "{{count}} / 3 caught",
        "bn": "{{count}} / ৩ টি ধরা হয়েছে",
        "hi": "{{count}} / 3 पकड़े गए",
        "it": "{{count}} / 3 raccolti"
    },
    "qaida.activity.games.target_label": {
        "en": "Target: ",
        "bn": "লক্ষ্য: ",
        "hi": "लक्ष्य: ",
        "it": "Obiettivo: "
    },
    "qaida.activity.games.catch_target_hint": {
        "en": "This is {{letter}}, tap target letter \"{{target}}\"!",
        "bn": "এটি {{letter}}, লক্ষ্য হরফ “{{target}}” স্পর্শ করো!",
        "hi": "यह {{letter}} है, लक्ष्य अक्षर \"{{target}}\" को छुएं!",
        "it": "Questa è {{letter}}, tocca la lettera \"{{target}}\"!"
    },
    "qaida.activity.games.sort_order_instruction": {
        "en": "Arrange in correct order (drag or tap):",
        "bn": "সঠিক ক্রমানুসারে সাজাও (টেনে বা স্পর্শ করে):",
        "hi": "सही क्रम में सजाएं (खींचकर या छूकर):",
        "it": "Ordina nella sequenza corretta (trascina o tocca):"
    },
    "qaida.activity.games.fill_empty_slots": {
        "en": "Drag or tap letters/words into empty slots below:",
        "bn": "নিচের হরফ/শব্দগুলো টেনে বা স্পর্শ করে খালি ঘরে বসাও:",
        "hi": "नीचे के अक्षरों/शब्दों को खींचकर खाली स्थान में रखें:",
        "it": "Inserisci lettere/parole negli spazi vuoti:"
    },
    "qaida.activity.games.puzzle_frame": {
        "en": "Puzzle Frame: drag or tap pieces into place",
        "bn": "পাজল ফ্রেম: টুকরোগুলো টেনে বা ট্যাপ করে বসাও",
        "hi": "पहेली फ़्रेम: टुकड़ों को खींचकर या टैप करके रखें",
        "it": "Puzzle: trascina o tocca i pezzi per posizionarli"
    },
    "qaida.activity.games.full_word": {
        "en": "Full word: {{word}}",
        "bn": "পূর্ণ শব্দ: {{word}}",
        "hi": "पूरा शब्द: {{word}}",
        "it": "Parola intera: {{word}}"
    },
    "qaida.activity.games.listen_fill_gaps": {
        "en": "Listen to melodic recitation and fill gaps (drag or tap):",
        "bn": "সুরে সুরে তিলাওয়াত শুনুন ও শূন্যস্থানে বসান (টেনে বা ট্যাপ করে):",
        "hi": "सस्वर पाठ सुनें और रिक्त स्थान भरें (खींचकर या टैप करके):",
        "it": "Ascolta la recitazione melodiosa e riempi gli spazi vuoti:"
    },
    "qaida.activity.games.pronunciation_a": {
        "en": "Pronunciation A",
        "bn": "উচ্চারণ A",
        "hi": "उच्चारण A",
        "it": "Pronuncia A"
    },
    "qaida.activity.games.pronunciation_b": {
        "en": "Pronunciation B",
        "bn": "উচ্চারণ B",
        "hi": "उच्चारण B",
        "it": "Pronuncia B"
    },
    "qaida.activity.games.listen_both_choose": {
        "en": "Listen to both pronunciations and select the correct one:",
        "bn": "উভয় উচ্চারণ শুনুন এবং সঠিকটি নির্বাচন করুন:",
        "hi": "दोनों उच्चारण सुनें और सही चुनें:",
        "it": "Ascolta entrambe le pronunce e seleziona quella corretta:"
    },
    "qaida.activity.games.word_a": {
        "en": "Word A",
        "bn": "শব্দ ক",
        "hi": "शब्द क",
        "it": "Parola A"
    },
    "qaida.activity.games.word_b": {
        "en": "Word B",
        "bn": "শব্দ খ",
        "hi": "शब्द ख",
        "it": "Parola B"
    },
    "qaida.activity.completion.boss_challenge_title": {
        "en": "Boss Challenge (Step Final Exam)",
        "bn": "বস চ্যালেঞ্জ (ধাপের চূড়ান্ত পরীক্ষা)",
        "hi": "बॉस चैलेंज (चरण की अंतिम परीक्षा)",
        "it": "Sfida Finale (Esame del Passo)"
    },
    "qaida.activity.completion.boss_challenge_sub": {
        "en": "Complete recitation verification with teacher.",
        "bn": "উস্তাদের সাথে বিশুদ্ধ তিলাওয়াত যাচাই সম্পন্ন করো।",
        "hi": "उस्ताद के साथ शुद्ध पाठ सत्यापन पूरा करें।",
        "it": "Completa la verifica della recitazione con l'insegnante."
    },
    "qaida.activity.completion.track_champion": {
        "en": "Alhamdulillah! Track Champion!",
        "bn": "আলহামদুলিল্লাহ! ট্র্যাক বিজয়ী!",
        "hi": "अल्हम्दुलिल्लाह! ट्रैक विजेता!",
        "it": "Alhamdulillah! Campione del percorso!"
    },
    "qaida.activity.completion.checkpoint_passed": {
        "en": "Passed Checkpoint Exam!",
        "bn": "চেকপয়েন্ট পরীক্ষায় উত্তীর্ণ!",
        "hi": "चेकपॉइंट परीक्षा उत्तीर्ण!",
        "it": "Superato l'esame del checkpoint!"
    },
    "qaida.activity.completion.awesome": {
        "en": "MashaAllah! Awesome!",
        "bn": "মাশাআল্লাহ! অসাধারণ!",
        "hi": "माशाअल्लाह! शानदार!",
        "it": "MashaAllah! Fantastico!"
    },
    "qaida.activity.completion.lesson_complete_title": {
        "en": "\"{{title}}\" Lesson Completed!",
        "bn": "“{{title}}” পাঠ সম্পন্ন হয়েছে!",
        "hi": "\"{{title}}\" सबक़ पूरा हो गया!",
        "it": "Lezione \"{{title}}\" completata!"
    },
    "qaida.activity.completion.score_correct": {
        "en": "{{correct}}/{{total}} correct",
        "bn": "{{correct}}/{{total}} সঠিক",
        "hi": "{{correct}}/{{total}} सही",
        "it": "{{correct}}/{{total}} corrette"
    },
    "qaida.activity.completion.next_lesson": {
        "en": "Next Lesson: {{title}}",
        "bn": "পরবর্তী পাঠ: {{title}}",
        "hi": "अगला सबक़: {{title}}",
        "it": "Prossima lezione: {{title}}"
    },
    "qaida.activity.completion.return_chapters": {
        "en": "Back to Chapters",
        "bn": "অধ্যায় তালিকায় ফিরুন",
        "hi": "अध्यायों की सूची पर लौटें",
        "it": "Torna ai capitoli"
    },
    "qaida.activity.skills.playing": {
        "en": "Playing...",
        "bn": "বাজছে...",
        "hi": "बज रहा है...",
        "it": "In riproduzione..."
    },
    "qaida.activity.skills.listen_pronounce": {
        "en": "Listen to pronunciation",
        "bn": "উচ্চারণ শুনুন",
        "hi": "उच्चारण सुनें",
        "it": "Ascolta la pronuncia"
    },
    "qaida.activity.skills.makhraj_label": {
        "en": "Makhraj: {{makhraj}}",
        "bn": "মাখরাজ: {{makhraj}}",
        "hi": "मख़रज: {{makhraj}}",
        "it": "Makhraj: {{makhraj}}"
    },
    "qaida.activity.skills.progress_title": {
        "en": "Skill Progress:",
        "bn": "দক্ষতার অগ্রগতি:",
        "hi": "कौशल प्रगति:",
        "it": "Progresso abilità:"
    },
    "qaida.activity.skills.mastered": {
        "en": "Mastered",
        "bn": "আয়ত্ত",
        "hi": "महारत हासिल",
        "it": "Padroneggiato"
    },
    "qaida.activity.skills.developing": {
        "en": "Developing",
        "bn": "উন্নতি হচ্ছে",
        "hi": "प्रगति पर",
        "it": "In sviluppo"
    },
    "qaida.activity.skills.check_passed": {
        "en": "Check Passed",
        "bn": "পাঠ যাচাই পাস",
        "hi": "जांच पास",
        "it": "Verifica superata"
    },
    "qaida.activity.skills.completed": {
        "en": "Completed",
        "bn": "পাঠ সম্পন্ন",
        "hi": "पूरा",
        "it": "Completato"
    },
    "qaida.activity.skills.practice_done": {
        "en": "Practice Done",
        "bn": "অনুশীলন শেষ",
        "hi": "अभ्यास पूरा",
        "it": "Pratica completata"
    },
    "qaida.activity.skills.in_progress": {
        "en": "In Progress",
        "bn": "চলছে",
        "hi": "जारी",
        "it": "In corso"
    },
    "qaida.activity.skills.not_started": {
        "en": "Not Started",
        "bn": "শুরু হয়নি",
        "hi": "शुरू नहीं हुआ",
        "it": "Non iniziato"
    }
}

locales = ["en", "bn", "hi", "it"]
# Automatically include any keys from existing locales/*.json into keys_data
loaded_locales = {}
for loc in locales:
    p = os.path.join("/Users/mdmansur/Desktop/apk/little_muslim/locales", f"{loc}.json")
    if os.path.exists(p):
        with open(p, "r", encoding="utf-8") as f:
            loaded_locales[loc] = json.load(f)

for k in loaded_locales.get("en", {}).keys():
    if k not in keys_data:
        keys_data[k] = {
            loc: loaded_locales.get(loc, {}).get(k, loaded_locales.get("en", {}).get(k, k))
            for loc in locales
        }

target_dirs = [
    "/Users/mdmansur/Desktop/apk/little_muslim/assets/locales",
    "/Users/mdmansur/Desktop/apk/little_muslim/locales"
]

for d in target_dirs:
    for loc in locales:
        file_path = os.path.join(d, f"{loc}.json")
        with open(file_path, "r", encoding="utf-8") as f:
            data = json.load(f)
        
        for k, translations in keys_data.items():
            data[k] = translations[loc]
            
        with open(file_path, "w", encoding="utf-8") as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
            f.write("\n")
        print(f"Updated {file_path}")

# Also update ARB bundles
arb_dir = "/Users/mdmansur/Desktop/apk/little_muslim/assets/l10n"
for loc in locales:
    arb_path = os.path.join(arb_dir, f"app_{loc}.arb")
    with open(arb_path, "r", encoding="utf-8") as f:
        arb_data = json.load(f)
    for k, translations in keys_data.items():
        arb_data[k] = translations[loc]
        arb_data[f"@{k}"] = {"description": f"{translations['bn']} ({k})"}
    with open(arb_path, "w", encoding="utf-8") as f:
        json.dump(arb_data, f, ensure_ascii=False, indent=2)
        f.write("\n")
    print(f"Updated {arb_path}")

# Also generate lib/l10n/static_translations.dart
static_dart_path = "/Users/mdmansur/Desktop/apk/little_muslim/lib/l10n/static_translations.dart"
with open(static_dart_path, "w", encoding="utf-8") as f:
    f.write("// AUTO-GENERATED - DO NOT EDIT MANUALLY\n")
    f.write("const Map<String, Map<String, String>> staticTranslations = {\n")
    for loc in locales:
        f.write(f'  "{loc}": {{\n')
        for k, translations in keys_data.items():
            val = translations[loc].replace('\\', '\\\\').replace('"', '\\"').replace('\n', '\\n')
            f.write(f'    "{k}": "{val}",\n')
        f.write("  },\n")
    f.write("};\n")
print(f"Updated {static_dart_path}")

print("All catalogs synchronized successfully!")
