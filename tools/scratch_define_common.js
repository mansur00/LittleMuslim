const fs = require('fs');
const path = require('path');

const ROOT = path.resolve(__dirname, '..');
const chapters = JSON.parse(fs.readFileSync(path.join(ROOT, 'tools', 'scratch_basics_chapters.json'), 'utf8'));

// Common UI strings translations
const commonStrings = {
  'basics.pause.title': {
    en: 'Take a break from learning?',
    bn: 'পড়া থেকে বিরতি নেবে?',
    hi: 'क्या पढ़ाई से ब्रेक लेना चाहते हैं?',
    it: 'Vuoi fare una pausa dallo studio?'
  },
  'basics.pause.body': {
    en: 'Your progress will be saved. You can resume anytime.',
    bn: 'তোমার শেখার অগ্রগতি সেভ থাকবে। পরে এখান থেকেই শুরু করতে পারবে।',
    hi: 'आपकी प्रगति सुरक्षित रहेगी। आप कभी भी फिर से शुरू कर सकते हैं।',
    it: 'I tuoi progressi saranno salvati. Puoi riprendere in qualsiasi momento.'
  },
  'basics.pause.continue': {
    en: 'Continue',
    bn: 'চালিয়ে যাই',
    hi: 'जारी रखें',
    it: 'Continua'
  },
  'basics.pause.exit': {
    en: 'Exit',
    bn: 'বের হই',
    hi: 'बाहर निकलें',
    it: 'Esci'
  },
  'basics.stage.intro': {
    en: 'Lesson 1',
    bn: 'পাঠ ১',
    hi: 'पाठ 1',
    it: 'Lezione 1'
  },
  'basics.stage.story': {
    en: 'Story',
    bn: 'গল্প',
    hi: 'कहानी',
    it: 'Storia'
  },
  'basics.stage.reflect': {
    en: 'Reflect {current}/10',
    bn: 'ভাবি {current}/১০',
    hi: 'विचार {current}/10',
    it: 'Rifletti {current}/10'
  },
  'basics.stage.quiz': {
    en: 'Quiz {current}/10',
    bn: 'কুইজ {current}/১০',
    hi: 'प्रश्नोत्तरी {current}/10',
    it: 'Quiz {current}/10'
  },
  'basics.stage.result': {
    en: 'Result',
    bn: 'ফলাফল',
    hi: 'परिणाम',
    it: 'Risultato'
  },
  'basics.header.title': {
    en: 'Basic Islamic Learning',
    bn: 'মৌলিক ইসলাম শিক্ষা',
    hi: 'बुनियादी इस्लामी शिक्षा',
    it: 'Educazione Islamica di Base'
  },
  'basics.header.subtitle': {
    en: 'Learn through stories, apply in life',
    bn: 'গল্পে শিখি, কাজে লাগাই',
    hi: 'कहानियों से सीखें, जीवन में अपनाएं',
    it: 'Impara con le storie, applica nella vita'
  },
  'basics.intro.know_easily': {
    en: 'Learn Simply',
    bn: 'সহজ করে জানি',
    hi: 'आसानी से सीखें',
    it: 'Impara Facilmente'
  },
  'basics.intro.next_story': {
    en: 'Next Lesson: Read Story',
    bn: 'পরের পাঠ: গল্প পড়ি',
    hi: 'अगला पाठ: कहानी पढ़ें',
    it: 'Prossima Lezione: Leggi la Storia'
  },
  'basics.story.short_story': {
    en: 'A Short Story',
    bn: 'একটি ছোট্ট গল্প',
    hi: 'एक छोटी कहानी',
    it: 'Una Breve Storia'
  },
  'basics.story.think_story': {
    en: 'Think About the Story',
    bn: 'গল্প নিয়ে ভাবি',
    hi: 'कहानी पर विचार करें',
    it: 'Pensa alla Storia'
  },
  'basics.reflect.title': {
    en: 'Reflect on the Story',
    bn: 'গল্পটি নিয়ে একটু ভাবো',
    hi: 'कहानी पर थोड़ा विचार करें',
    it: 'Rifletti sulla Storia'
  },
  'basics.reflect.subtitle': {
    en: '10 short questions — answer in your mind.',
    bn: '১০টি ছোট প্রশ্ন—নিজের মনে উত্তর দাও।',
    hi: '10 छोटे प्रश्न—अपने मन में उत्तर दें।',
    it: '10 brevi domande: rispondi nella tua mente.'
  },
  'basics.reflect.hint': {
    en: 'Think of the answer in your own words. Proceed when ready.',
    bn: 'নিজের ভাষায় উত্তর ভাবো। প্রস্তুত হলে পরের প্রশ্নে যাও।',
    hi: 'अपने शब्दों में उत्तर सोचें। तैयार होने पर आगे बढ़ें।',
    it: 'Pensa alla risposta con parole tue. Procedi quando sei pronto.'
  },
  'basics.reflect.take_quiz': {
    en: 'Take the 10 Quizzes',
    bn: 'এবার ১০টি কুইজ দিই',
    hi: 'अब 10 प्रश्नोत्तरी हल करें',
    it: 'Fai i 10 Quiz'
  },
  'basics.reflect.next_question': {
    en: 'Next Reflection Question',
    bn: 'পরের ভাবনার প্রশ্ন',
    hi: 'अगला विचारणीय प्रश्न',
    it: 'Prossima Domanda di Riflessione'
  },
  'basics.quiz.title': {
    en: 'Do you remember what you learned?',
    bn: 'শেখাটা মনে আছে?',
    hi: 'क्या आपको याद है?',
    it: 'Ricordi cosa hai imparato?'
  },
  'basics.quiz.subtitle': {
    en: '10 quizzes — pick the correct answer.',
    bn: '১০টি কুইজ—সঠিক উত্তর বেছে নাও।',
    hi: '10 प्रश्नोत्तरी—सही उत्तर चुनें।',
    it: '10 quiz: scegli la risposta corretta.'
  },
  'basics.quiz.question_counter': {
    en: 'Question {current} / {total}',
    bn: 'প্রশ্ন {current} / {total}',
    hi: 'प्रश्न {current} / {total}',
    it: 'Domanda {current} / {total}'
  },
  'basics.quiz.correct_feedback': {
    en: 'Correct answer! MashaAllah.',
    bn: 'সঠিক উত্তর! মাশাআল্লাহ।',
    hi: 'सही उत्तर! माशाअल्लाह।',
    it: 'Risposta corretta! MashaAllah.'
  },
  'basics.quiz.wrong_feedback': {
    en: 'Incorrect answer. Correct answer: {correct}',
    bn: 'উত্তরটি ভুল হয়েছে। সঠিক উত্তর: {correct}',
    hi: 'गलत उत्तर। सही उत्तर: {correct}',
    it: 'Risposta errata. Risposta corretta: {correct}'
  },
  'basics.quiz.check_answer': {
    en: 'Check Answer',
    bn: 'উত্তর মিলিয়ে দেখি',
    hi: 'उत्तर जांचें',
    it: 'Controlla Risposta'
  },
  'basics.quiz.see_result': {
    en: 'See Results',
    bn: 'ফলাফল দেখি',
    hi: 'परिणाम देखें',
    it: 'Vedi Risultati'
  },
  'basics.quiz.next_question': {
    en: 'Next Question',
    bn: 'পরের প্রশ্ন',
    hi: 'अगला प्रश्न',
    it: 'Prossima Domanda'
  },
  'basics.quiz.skip_question': {
    en: 'Skip Question',
    bn: 'প্রশ্নটি এড়িয়ে যাই',
    hi: 'प्रश्न छोड़ें',
    it: 'Salta Domanda'
  },
  'basics.result.title': {
    en: 'Quiz Results',
    bn: 'কুইজের ফলাফল',
    hi: 'प्रश्नोत्तरी परिणाम',
    it: 'Risultati del Quiz'
  },
  'basics.result.perfect': {
    en: 'MashaAllah! You answered all questions correctly!',
    bn: 'মাশাআল্লাহ! তুমি সব প্রশ্নের সঠিক উত্তর দিয়েছো!',
    hi: 'माशाअल्लाह! आपने सभी प्रश्नों के सही उत्तर दिए!',
    it: 'MashaAllah! Hai risposto correttamente a tutte le domande!'
  },
  'basics.result.good': {
    en: 'Well done! You successfully completed the chapter.',
    bn: 'খুব ভালো! তুমি সফলভাবে অধ্যায়টি সম্পন্ন করেছ।',
    hi: 'बहुत बढ़िया! आपने सफलतापूर्वक अध्याय पूरा किया।',
    it: 'Ben fatto! Hai completato con successo il capitolo.'
  },
  'basics.result.retry_advice': {
    en: 'You tried well! Re-read the chapter to do even better.',
    bn: 'তুমি চেষ্টা করেছো! অধ্যায়টি আবার পড়ে আরও ভালো করতে পারো।',
    hi: 'आपने अच्छा प्रयास किया! दोबारा पढ़कर बेहतर कर सकते हैं।',
    it: 'Ottimo tentativo! Rileggi il capitolo per migliorare.'
  },
  'basics.result.xp_earned': {
    en: '+25 XP Earned!',
    bn: '+২৫ XP অর্জিত হয়েছে!',
    hi: '+25 XP अर्जित!',
    it: '+25 XP Guadagnati!'
  },
  'basics.result.xp_already': {
    en: '+25 XP Already Earned',
    bn: '+২৫ XP আগেই অর্জিত হয়েছে',
    hi: '+25 XP पहले ही अर्जित',
    it: '+25 XP Già Ottenuti'
  },
  'basics.result.correct_label': {
    en: 'Correct',
    bn: 'সঠিক',
    hi: 'सही',
    it: 'Corretto'
  },
  'basics.result.wrong_label': {
    en: 'Wrong',
    bn: 'ভুল',
    hi: 'गलत',
    it: 'Errato'
  },
  'basics.result.skipped_label': {
    en: 'Skipped',
    bn: 'এড়ানো',
    hi: 'छोड़ा गया',
    it: 'Saltato'
  },
  'basics.result.retry_btn': {
    en: 'Retry Quiz',
    bn: 'কুইজ পুনরায় দিন (Retry)',
    hi: 'प्रश्नोत्तरी पुनः प्रयास करें',
    it: 'Riprova il Quiz'
  },
  'basics.result.back_to_list': {
    en: 'Back to Chapters',
    bn: 'অধ্যায় তালিকায় ফিরুন',
    hi: 'अध्याय सूची पर लौटें',
    it: 'Torna ai Capitoli'
  },
  'basics.result.read_from_start': {
    en: 'Read Chapter from Beginning',
    bn: 'অধ্যায়টি শুরু থেকে আবার পড়ুন',
    hi: 'अध्याय शुरू से फिर पढ़ें',
    it: 'Leggi il Capitolo dall\'Inizio'
  },
  'basics.card.chapter_n': {
    en: 'Chapter {number}',
    bn: 'অধ্যায় {number}',
    hi: 'अध्याय {number}',
    it: 'Capitolo {number}'
  },
  'basics.card.completed_status': {
    en: 'Completed · Quiz {score}/10 · Re-read anytime',
    bn: 'সম্পন্ন · কুইজ {score}/১০ · চাইলে আবার পড়ো',
    hi: 'पूर्ण · प्रश्नोत्तरी {score}/10 · कभी भी पुनः पढ़ें',
    it: 'Completato · Quiz {score}/10 · Rileggi quando vuoi'
  },
  'basics.card.locked_status': {
    en: 'Unlocks after previous chapter',
    bn: 'আগের অধ্যায় শেষ হলে খুলবে',
    hi: 'पिछले अध्याय के बाद खुलेगा',
    it: 'Si sblocca dopo il capitolo precedente'
  },
  'basics.card.resume_status': {
    en: 'Resume from here',
    bn: 'এখান থেকে আবার শুরু করো',
    hi: 'यहाँ से फिर शुरू करें',
    it: 'Riprendi da qui'
  },
  'basics.card.default_status': {
    en: 'Story · 10 Reflections · 10 Quizzes',
    bn: 'ছবি · গল্প · ১০ ভাবনা · ১০ কুইজ',
    hi: 'कहानी · 10 विचार · 10 प्रश्नोत्तरी',
    it: 'Storia · 10 Riflessioni · 10 Quiz'
  },
  'basics.card.remember_story': {
    en: 'Remember the Story',
    bn: 'গল্পের কথা মনে রাখি',
    hi: 'कहानी याद रखें',
    it: 'Ricorda la Storia'
  },
  'basics.card.see_understand_learn': {
    en: 'Observe · Understand · Learn',
    bn: 'দেখি · বুঝি · শিখি',
    hi: 'देखें · समझें · सीखें',
    it: 'Osserva · Comprendi · Impara'
  },

  // 10 Reflection questions
  'basics.reflect.q1': {
    en: 'What does this lesson make you think about?',
    bn: 'এই কথাটি তোমাকে কী ভাবায়?',
    hi: 'यह बात आपको क्या सोचने पर मजबूर करती है?',
    it: 'Cosa ti fa pensare questa lezione?'
  },
  'basics.reflect.q2': {
    en: 'What good deed can you do keeping this in mind?',
    bn: 'এটি মনে রাখলে তুমি কী ভালো কাজ করতে পারো?',
    hi: 'इसे याद रखकर आप कौन सा अच्छा काम कर सकते हैं?',
    it: 'Quale buona azione puoi fare tenendo a mente questo?'
  },
  'basics.reflect.q3': {
    en: 'What is an example of this in your own life?',
    bn: 'তোমার জীবনে এর একটি উদাহরণ কী?',
    hi: 'आपके अपने जीवन में इसका क्या उदाहरण है?',
    it: 'Qual è un esempio di questo nella tua vita?'
  },
  'basics.reflect.q4': {
    en: 'Does this teach you to help others?',
    bn: 'এটি কি তোমাকে কারও উপকার করতে শেখায়?',
    hi: 'क्या यह आपको दूसरों की मदद करना सिखाता है?',
    it: 'Questo ti insegna ad aiutare gli altri?'
  },
  'basics.reflect.q5': {
    en: 'What other questions come to your mind about this?',
    bn: 'এ বিষয়ে তোমার মনে আর কী প্রশ্ন আসে?',
    hi: 'इस विषय पर आपके मन में और क्या सवाल आते हैं?',
    it: 'Quali altre domande ti vengono in mente su questo?'
  },
  'basics.reflect.q6': {
    en: 'Who will you ask for help when things are difficult?',
    bn: 'কঠিন হলে কার কাছে সাহায্য চাইবে?',
    hi: 'कठिन समय में आप किससे मदद मांगेंगे?',
    it: 'A chi chiederai aiuto nei momenti difficili?'
  },
  'basics.reflect.q7': {
    en: 'How will you put this into practice starting today?',
    bn: 'আজ থেকেই কীভাবে এটি কাজে লাগাবে?',
    hi: 'आज से ही आप इसे कैसे अमल में लाएंगे?',
    it: 'Come lo metterai in pratica a partire da oggi?'
  },
  'basics.reflect.q8': {
    en: 'What will you share with your family about this?',
    bn: 'তোমার পরিবারের সঙ্গে এ নিয়ে কী কথা বলবে?',
    hi: 'इस बारे में आप अपने परिवार से क्या बात करेंगे?',
    it: 'Cosa condividerai con la tua famiglia su questo?'
  },
  'basics.reflect.q9': {
    en: 'How can you remind yourself if you forget this?',
    bn: 'এটি ভুলে গেলে কীভাবে মনে করতে পারো?',
    hi: 'यदि आप इसे भूल जाएं तो कैसे याद रख सकते हैं?',
    it: 'Come puoi ricordarlo se dovessi dimenticarlo?'
  },
  'basics.reflect.q10': {
    en: 'What is the most important lesson from this chapter?',
    bn: 'এই অধ্যায় থেকে সবচেয়ে জরুরি শিক্ষা কোনটি?',
    hi: 'इस अध्याय से सबसे महत्वपूर्ण सीख कौन सी है?',
    it: 'Qual è la lezione più importante di questo capitolo?'
  },

  // Templates
  'template.current_prefix': {
    en: 'Current: ',
    bn: 'চলমান: ',
    hi: 'वर्तमान: ',
    it: 'In corso: '
  },
  'template.step_word': {
    en: 'Step',
    bn: 'ধাপ',
    hi: 'चरण',
    it: 'Passo'
  },
  'template.lesson_word': {
    en: 'Lesson',
    bn: 'পাঠ',
    hi: 'पाठ',
    it: 'Lezione'
  },
  'template.age_word': {
    en: 'Age',
    bn: 'বয়স',
    hi: 'उम्र',
    it: 'Età'
  },
  'template.question_word': {
    en: 'Question',
    bn: 'প্রশ্ন',
    hi: 'प्रश्न',
    it: 'Domanda'
  },
  'template.pass_mark_note': {
    en: ' (Pass mark 80%)',
    bn: ' (পাস মার্ক ৮০%)',
    hi: ' (उत्तीर्ण 80%)',
    it: ' (Pass 80%)'
  },
  'template.n_lessons': {
    en: '{n} Lessons',
    bn: '{n}টি পাঠ',
    hi: '{n} पाठ',
    it: '{n} lezioni'
  },
  'template.n_steps': {
    en: '{n} Steps',
    bn: '{n}টি ধাপ',
    hi: '{n} चरण',
    it: '{n} passaggi'
  },
  'template.track_exam_passed': {
    en: 'Track {n} Exam Passed!',
    bn: 'ট্র্যাক {n} সমাপনী উত্তীর্ণ!',
    hi: 'ट्रैक {n} परीक्षा उत्तीर्ण!',
    it: 'Esame percorso {n} superato!'
  },
  'template.surah_ayah': {
    en: 'Surah {s} · Ayah {a}',
    bn: 'সূরা নম্বর {s} · আয়াত {a}',
    hi: 'सूरा {s} · आयत {a}',
    it: 'Sura {s} · Versetto {a}'
  },
  'template.learn_letter': {
    en: 'Learn {letter}',
    bn: '{letter} চিনি',
    hi: 'सीखें {letter}',
    it: 'Impara {letter}'
  },
  'template.listen_choose_letter': {
    en: 'Listen for “{letter}” and choose the letter.',
    bn: '“{letter}” অক্ষরটি শুনে বেছে নাও।',
    hi: '“{letter}” को सुनें और अक्षर चुनें।',
    it: 'Ascolta “{letter}” e scegli la lettera.'
  },
  'template.which_letter': {
    en: 'Which is the letter “{letter}”?',
    bn: '“{letter}” অক্ষরটি কোনটি?',
    hi: '“{letter}” अक्षर कौन सा है?',
    it: 'Quale lettera è “{letter}”?'
  },
  'template.which_dot': {
    en: 'Which dot piece belongs on the letter “{letter}”?',
    bn: 'কোন বিন্দুর টুকরোটি “{letter}” হরফে বসবে?',
    hi: 'कौन सा बिंदु टुकड़ा अक्षर “{letter}” पर लगेगा?',
    it: 'Quale punto appartiene alla lettera “{letter}”?'
  },
  'template.letter_name': {
    en: 'Letter {name}',
    bn: '{name} হরফ',
    hi: 'अक्षर {name}',
    it: 'Lettera {name}'
  },
  'template.letter_colon': {
    en: 'Letter: {rest}',
    bn: 'হরফ: {rest}',
    hi: 'अक्षर: {rest}',
    it: 'Lettera: {rest}'
  },
  'template.teacher': {
    en: 'Teacher: {teacher}',
    bn: 'শিক্ষক: {teacher}',
    hi: 'शिक्षक: {teacher}',
    it: 'Insegnante: {teacher}'
  }
};

console.log('Defined common strings:', Object.keys(commonStrings).length);
fs.writeFileSync(path.join(ROOT, 'tools', 'scratch_common_strings.json'), JSON.stringify(commonStrings, null, 2));
