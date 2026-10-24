const fs = require('fs');
const path = require('path');

const ROOT = path.resolve(__dirname, '..');
const LOCALES = ['en', 'bn', 'hi', 'it'];

const rawStories = JSON.parse(fs.readFileSync(path.join(ROOT, 'tools', 'scratch_seerah_stories.json'), 'utf8'));

function decodeUnicode(str) {
  try {
    return JSON.parse(`"${str}"`);
  } catch (e) {
    return str;
  }
}

// Translations dictionary for all 23 stories
const seerahData = {
  abu_umair: {
    title: {
      en: "Abu Umair's Little Bird Friend",
      hi: "अबू उमैर का छोटा परिंदा दोस्त",
      it: "Il Piccolo Uccellino di Abu Umair"
    },
    subtitle: {
      en: "The Prophet's gentle behavior with children",
      hi: "बच्चों के साथ नबीजी का कोमल व्यवहार",
      it: "Il dolce comportamento del Profeta con i bambini"
    },
    readTime: { en: "2 mins", hi: "2 मिनट", it: "2 min" },
    reference: { en: "Sahih Bukhari 6203", hi: "सहीह बुखारी 6203", it: "Sahih Bukhari 6203" },
    body: {
      en: "Anas (RA)'s younger brother Abu Umair had a small pet bird. When the Prophet visited their home, he would lovingly ask the boy about his little bird. He paid careful attention even to the small joys of children.",
      hi: "अनस (रज़ि.) के छोटे भाई अबू उमैर के पास एक छोटा परिंदा था। जब नबीजी उनके घर आते, तो प्यार से बच्चे का हाल पूछते और परिंदे के बारे में बात करते। वे बच्चों की छोटी-छोटी खुशियों का भी ध्यान रखते थे।",
      it: "Il fratellino di Anas (RA), Abu Umair, aveva un piccolo uccellino domestico. Quando il Profeta faceva visita alla loro casa, chiedeva con affetto al bambino del suo uccellino, prestando attenzione alle piccole gioie dei bambini."
    },
    lesson: {
      en: "To build a warm bond with someone, listen carefully to what brings them joy.",
      hi: "किसी से अच्छा रिश्ता बनाने के लिए उसकी पसंद की बातें ध्यान से सुनें।",
      it: "Per costruire un legame sincero con qualcuno, ascolta con cura ciò che gli porta gioia."
    }
  },
  hasan_kindness: {
    title: {
      en: "Affection for Hasan (RA)",
      hi: "हसन (रज़ि.) के प्रति स्नेह",
      it: "L'Affetto per Hasan (RA)"
    },
    subtitle: {
      en: "Showing mercy is a noble habit",
      hi: "दया दिखाना हमारी खूबसूरत आदत है",
      it: "Mostrare misericordia è una nobile virtù"
    },
    readTime: { en: "2 mins", hi: "2 मिनट", it: "2 min" },
    reference: { en: "Sahih Bukhari 5997", hi: "सहीह बुखारी 5997", it: "Sahih Bukhari 5997" },
    body: {
      en: "One day the Prophet kissed his grandson Hasan (RA). A bystander remarked that he had never kissed any of his own children. The Prophet explained: He who does not show mercy will not be shown mercy.",
      hi: "एक दिन नबीजी ने अपने नवासे हसन (रज़ि.) को प्यार किया। पास खड़े एक व्यक्ति ने कहा कि उसने कभी अपने बच्चों को नहीं चूमा। नबीजी ने समझाया: जो दया नहीं करता, उस पर दया नहीं की जाती।",
      it: "Un giorno il Profeta baciò suo nipote Hasan (RA). Un uomo presente disse di non aver mai baciato i propri figli. Il Profeta spiegò: Chi non mostra misericordia non riceverà misericordia."
    },
    lesson: {
      en: "Always treat both young and old with tenderness and mercy.",
      hi: "छोटे-बड़े सभी के साथ दया और स्नेह का व्यवहार करें।",
      it: "Tratta sempre grandi e piccoli con tenerezza e misericordia."
    }
  },
  first_revelation: {
    title: {
      en: "The First Revelation in Cave Hira",
      hi: "ग़ारे हिरा में पहली वह्यी",
      it: "La Prima Rivelazione nella Caverna di Hira"
    },
    subtitle: {
      en: "A new beginning of knowledge and truth",
      hi: "ज्ञान और सत्य की एक नई शुरुआत",
      it: "Un nuovo inizio di conoscenza e verità"
    },
    readTime: { en: "3 mins", hi: "3 मिनट", it: "3 min" },
    reference: { en: "Sahih Bukhari 3", hi: "सहीह बुखारी 3", it: "Sahih Bukhari 3" },
    body: {
      en: "Before prophethood, Muhammad spent quiet contemplative time in Cave Hira. There, the first revelation came to him. Khadijah (RA) comforted him with courage and stood firmly by his side. Thus began the transmission of the Quranic message.",
      hi: "नुबुव्वत से पहले मुहम्मद ग़ारे हिरा में तन्हाई में समय बिताते थे। वहाँ उन पर पहली वह्यी आई। ख़दीजा (रज़ि.) ने उन्हें हिम्मत और तसल्ली दी और उनका साथ दिया। इस तरह क़ुरआन के संदेश की शुरुआत हुई।",
      it: "Prima della profezia, Muhammad trascorreva momenti di silenziosa riflessione nella caverna di Hira. Lì ricevette la prima rivelazione. Khadijah (RA) lo rassicurò con coraggio e gli stette accanto con fermezza."
    },
    lesson: {
      en: "Give strength to family in difficult times and stand with the truth.",
      hi: "मुश्किल समय में परिवार का हौसला बढ़ाएं और सच का साथ दें।",
      it: "Dona forza alla famiglia nei momenti difficili e sostieni la verità."
    }
  },
  zamzam_baby: {
    title: {
      en: "The Story of Zamzam Water",
      hi: "आबे ज़मज़म की कहानी",
      it: "La Storia dell'Acqua di Zamzam"
    },
    subtitle: {
      en: "The reward of trusting in Allah",
      hi: "अल्लाह पर भरोसे का इनाम",
      it: "La ricompensa della fiducia in Allah"
    },
    readTime: { en: "3 mins", hi: "3 मिनट", it: "3 min" },
    reference: { en: "Sahih Bukhari 3184", hi: "सहीह बुखारी 3184", it: "Sahih Bukhari 3184" },
    body: {
      en: "Hajar (RA) found herself alone in the desert of Makkah with her infant Ismail. As the water ran out, she ran between the hills of Safa and Marwah searching for water. By Allah's decree, the well of Zamzam sprang from beneath the child's feet.",
      hi: "हाजरा (रज़ि.) अपने छोटे बच्चे इस्माईल के साथ मक्का के मरुस्थल में अकेली रह गईं। पानी ख़त्म होने पर वे सफ़ा और मरवा पहाड़ियों के बीच दौड़ीं। अल्लाह के हुक्म से बच्चे के पैरों के पास से ज़मज़म का चश्मा फूटा।",
      it: "Hajar (RA) si trovò sola nel deserto di Mecca con il piccolo Ismail. Esaurita l'acqua, corse tra le colline di Safa e Marwah. Per volere di Allah, la sorgente di Zamzam sgorgò dai piedi del bambino."
    },
    lesson: {
      en: "Trust in Allah even in the greatest hardships; He never abandons us.",
      hi: "बड़ी से बड़ी मुसीबत में भी अल्लाह पर भरोसा रखें; वे कभी हमें अकेला नहीं छोड़ते।",
      it: "Confida in Allah anche nelle prove più grandi; Egli non ci abbandona mai."
    }
  },
  kaaba_corner: {
    title: {
      en: "Arbitration at the Rebuilding of the Kaaba",
      hi: "काबा के पुनर्निर्माण में नबीजी का फ़ैसला",
      it: "La Mediazione per la Ricostruzione della Kaaba"
    },
    subtitle: {
      en: "Resolving tribal disputes with wisdom",
      hi: "क़बीलों के विवाद को बुद्धिमत्ता से सुलझाना",
      it: "Risolvere le dispute tribali con saggezza"
    },
    readTime: { en: "3 mins", hi: "3 मिनट", it: "3 min" },
    reference: { en: "Sirat Ibn Hisham", hi: "सीरत इब्न हिशाम", it: "Sirat Ibn Hisham" },
    body: {
      en: "When rebuilding the Kaaba, the tribes argued over who would place the Black Stone. The young Muhammad placed the stone on a cloak and had every tribal leader hold an edge, resolving the conflict peacefully.",
      hi: "काबा के पुनर्निर्माण के दौरान क़बीलों में झगड़ा हुआ कि हजर-ए-अस्वद कौन रखेगा। नबीजी ने चादर पर पत्थर रखा और सभी क़बीलाई सरदारों को चादर थमाकर शांति से मसला हल किया।",
      it: "Durante la ricostruzione della Kaaba, le tribù disputarono su chi dovesse collocare la Pietra Nera. Il giovane Muhammad pose la pietra su un mantello e fece sollevare i lembi a ciascun capo tribù."
    },
    lesson: {
      en: "Resolve disagreements with wisdom, justice, and collective participation.",
      hi: "बुद्धिमत्ता, न्याय और मिल-जुलकर विवादों का समाधान करें।",
      it: "Risolvi i disaccordi con saggezza, giustizia e partecipazione collettiva."
    }
  },
  khadija_trust: {
    title: {
      en: "Khadijah (RA)'s Steadfast Faith",
      hi: "ख़दीजा (रज़ि.) का दृढ़ विश्वास",
      it: "La Fede Incrollabile di Khadijah (RA)"
    },
    subtitle: {
      en: "Support and trust in times of distress",
      hi: "कठिनाई के समय भरोसा और सहारा",
      it: "Sostegno e fiducia nei momenti di prova"
    },
    readTime: { en: "3 mins", hi: "3 मिनट", it: "3 min" },
    reference: { en: "Sahih Bukhari 3", hi: "सहीह बुखारी 3", it: "Sahih Bukhari 3" },
    body: {
      en: "When the Prophet received revelation and feared for himself, Khadijah reassured him: 'By Allah, Allah will never disgrace you, for you maintain ties of kinship, help the poor, and support the truth.'",
      hi: "जब नबीजी पर वह्यी आई, तो ख़दीजा ने ढांढस बंधाया: 'अल्लाह की क़सम, अल्लाह आपको कभी रुसवा नहीं करेगा, क्योंकि आप रिश्ते जोड़ते हैं, गरीबों की मदद करते हैं और सच का साथ देते हैं।'",
      it: "Quando il Profeta ricevette la rivelazione, Khadijah lo rassicurò: 'Per Allah, Egli non ti umilierà mai: tu unisci i legami di parentela, aiuti i bisognosi e sostieni la verità.'"
    },
    lesson: {
      en: "Good character and service to humanity earn divine protection and human trust.",
      hi: "नेक चरित्र और लोगों की सेवा से अल्लाह की हिफ़ाज़त और भरोसा हासिल होता है।",
      it: "Il nobile carattere e l'aiuto agli altri meritano la protezione divina e la stima della gente."
    }
  },
  bilal_patience: {
    title: {
      en: "The Patience of Bilal (RA)",
      hi: "बिलाल (रज़ि.) का सब्र",
      it: "La Pazienza di Bilal (RA)"
    },
    subtitle: {
      en: "Steadfastness upon faith under persecution",
      hi: "सताए जाने पर भी ईमान पर अडिग रहना",
      it: "Fermezza nella fede di fronte alla persecuzione"
    },
    readTime: { en: "3 mins", hi: "3 मिनट", it: "3 min" },
    reference: { en: "Sunan Ibn Majah 150", hi: "सुनन इब्न माजह 150", it: "Sunan Ibn Majah 150" },
    body: {
      en: "Under the scorching desert heat, heavy rocks were placed on Bilal's chest to force him to renounce Islam. Yet his heart remained firm and his tongue repeated: 'Ahad, Ahad' (Allah is One).",
      hi: "तपती धूप में बिलाल के सीने पर भारी पत्थर रखे गए ताकि वे ईमान छोड़ दें। लेकिन उनका दिल अडिग रहा और ज़ुबान से निकला: 'अहद, अहद' (अल्लाह एक है)।",
      it: "Sotto il sole cocente del deserto, pesanti pietre furono poste sul petto di Bilal per fargli rinnegare l'Islam. Eppure il suo cuore rimase saldo e ripeté: 'Ahad, Ahad' (Allah è Uno)."
    },
    lesson: {
      en: "True faith cannot be broken by worldly pressure or hardship.",
      hi: "सच्चा ईमान किसी भी सांसारिक दबाव या मुश्किल से नहीं डगमगाता।",
      it: "La vera fede non viene scalfita dalle difficoltà terrene."
    }
  },
  anas_servant: {
    title: {
      en: "Ten Years in the Prophet's Care",
      hi: "नबीजी की सोहबत में दस साल",
      it: "Dieci Anni Accanto al Profeta"
    },
    subtitle: {
      en: "Gentleness and compassion toward assistants",
      hi: "मददगारों के साथ नम्रता और करुणा",
      it: "Gentilezza e compassione verso chi aiuta"
    },
    readTime: { en: "2 mins", hi: "2 मिनट", it: "2 min" },
    reference: { en: "Sahih Muslim 2309", hi: "सहीह मुस्लिम 2309", it: "Sahih Muslim 2309" },
    body: {
      en: "Anas (RA) served the Prophet for ten years. He said: 'He never once said 'Uff' to me, nor did he ask why I did something or why I failed to do something.'",
      hi: "अनस (रज़ि.) ने दस साल नबीजी की सेवा की। उन्होंने कहा: 'नबीजी ने कभी मुझे 'उफ़' तक नहीं कहा, न कभी डांटा कि यह क्यों किया या वह क्यों नहीं किया।'",
      it: "Anas (RA) servì il Profeta per dieci anni e testimoniò: 'Non mi disse mai 'Uff', né mi rimproverò chiedendomi perché avessi fatto o non fatto qualcosa.'"
    },
    lesson: {
      en: "Treat domestic workers, assistants, and younger ones with immense gentleness.",
      hi: "मददगारों, कर्मचारियों और छोटों के साथ अत्यंत नम्रता से पेश आएं।",
      it: "Tratta con immensa gentilezza chi lavora per te e i più giovani."
    }
  },
  migration_madina: {
    title: {
      en: "The Hijrah to Madinah",
      hi: "मदीना की हिजरत",
      it: "L'Egira verso Medina"
    },
    subtitle: {
      en: "Trust in Allah and strategic planning",
      hi: "अल्लाह पर भरोसा और सूझबूझ भरी योजना",
      it: "Fiducia in Allah e saggia pianificazione"
    },
    readTime: { en: "4 mins", hi: "4 मिनट", it: "4 min" },
    reference: { en: "Sahih Bukhari 3905", hi: "सहीह बुखारी 3905", it: "Sahih Bukhari 3905" },
    body: {
      en: "When the Quraysh plotted against the Prophet, he migrated to Madinah with Abu Bakr (RA). Taking refuge in Cave Thawr, Abu Bakr worried, but the Prophet said: 'Do not grieve; indeed Allah is with us.'",
      hi: "जब क़ुरैश ने साज़िश रची, तो नबीजी हज़रत अबू बक्र (रज़ि.) के साथ मदीना हिजरत कर गए। ग़ारे सौर में अबू बक्र चिंतित हुए, तो नबीजी ने कहा: 'चिंता मत करो, अल्लाह हमारे साथ है।'",
      it: "Quando i Quraysh tramarono contro il Profeta, egli emigrò a Medina con Abu Bakr (RA). Rifugiatisi nella caverna di Thawr, il Profeta rassicurò l'amico: 'Non temere, Allah è con noi.'"
    },
    lesson: {
      en: "Combine careful effort with complete reliance on Allah.",
      hi: "पूरी कोशिश करने के बाद मुकम्मल भरोसा अल्लाह पर रखें।",
      it: "Unisci l'impegno accurato alla totale fiducia in Allah."
    }
  },
  badr_dua: {
    title: {
      en: "The Supplication at Badr",
      hi: "बद्र के मैदान में दुआ",
      it: "La Supplica di Badr"
    },
    subtitle: {
      en: "Turning to Allah with humility before the trial",
      hi: "परीक्षा से पहले अल्लाह के सामने गिड़गिड़ाना",
      it: "Rivolgersi ad Allah con umiltà prima della prova"
    },
    readTime: { en: "3 mins", hi: "3 मिनट", it: "3 min" },
    reference: { en: "Sahih Muslim 1763", hi: "सहीह मुस्लिम 1763", it: "Sahih Muslim 1763" },
    body: {
      en: "On the eve of the Battle of Badr, the Prophet spent the night in tearful supplication, raising his hands so high his cloak fell. Allah answered and granted victory to the believers.",
      hi: "बद्र की लड़ाई से पहले नबीजी ने रात भर रो-रोकर दुआ की, यहाँ तक कि उनकी चादर गिर गई। अल्लाह ने दुआ क़बूल की और मोमिनों को जीत बख़्शी।",
      it: "Alla vigilia della battaglia di Badr, il Profeta passò la notte in preghiera piangendo e supplicando Allah, che esaudì la sua invocazione concedendo la vittoria."
    },
    lesson: {
      en: "Supplication is the believer's greatest weapon in any difficulty.",
      hi: "दुआ किसी भी मुश्किल में मोमिन का सबसे बड़ा सहारा और हथियार है।",
      it: "La supplica è la più grande arma del credente in ogni difficoltà."
    }
  },
  conquest_mercy: {
    title: {
      en: "Mercy at the Conquest of Makkah",
      hi: "फ़तह-ए-मक्का पर आम माफ़ी",
      it: "La Misericordia alla Conquista di Mecca"
    },
    subtitle: {
      en: "Forgiving those who persecuted you",
      hi: "ज़ुल्म करने वालों को भी माफ़ करना",
      it: "Perdonare coloro che hanno perseguitato"
    },
    readTime: { en: "3 mins", hi: "3 मिनट", it: "3 min" },
    reference: { en: "Sunan al-Kubra 18275", hi: "सुनन अल-कुबरा 18275", it: "Sunan al-Kubra 18275" },
    body: {
      en: "When the Prophet entered Makkah victorious, the people who had driven him out and hurt him stood before him. Instead of revenge, he announced: 'Go, for you are free.'",
      hi: "जब नबीजी फ़तह के साथ मक्का में दाख़िल हुए, तो जिन्होंने सताया था वे सामने खड़े थे। बदले के बजाय नबीजी ने फ़रमाया: 'जाओ, आज तुम सब आज़ाद हो।'",
      it: "Quando il Profeta entrò vittorioso a Mecca, coloro che lo avevano perseguitato tremavano. Anziché vendicarsi, egli proclamò: 'Andate, siete tutti liberi.'"
    },
    lesson: {
      en: "The greatest victory lies in forgiveness, humility, and mercy.",
      hi: "सबसे बड़ी जीत माफ़ी, विनम्रता और दया में है।",
      it: "La più grande vittoria risiede nel perdono, nell'umiltà e nella misericordia."
    }
  },
  taif_patience: {
    title: {
      en: "Patience and Forgiveness at Taif",
      hi: "ताइफ़ का सब्र और माफ़ी",
      it: "La Pazienza e il Perdono a Taif"
    },
    subtitle: {
      en: "Praying for guidance for those who hurt you",
      hi: "चोट पहुँचाने वालों के लिए भी हिदायत की दुआ",
      it: "Pregare per la guida di chi ci ferisce"
    },
    readTime: { en: "4 mins", hi: "4 मिनट", it: "4 min" },
    reference: { en: "Sahih Bukhari 3231", hi: "सहीह बुखारी 3231", it: "Sahih Bukhari 3231" },
    body: {
      en: "When the people of Taif stoned the Prophet and injured him, the angel of mountains offered to crush the town. The Prophet replied: 'No, I hope Allah brings from their descendants people who will worship Him alone.'",
      hi: "जब ताइफ़ वालों ने नबीजी पर पत्थर बरसाए, तो फ़रिश्ते ने बस्ती को तबाह करने की इजाज़त मांगी। नबीजी ने फ़रमाया: 'नहीं, मुझे उम्मीद है कि इनकी औलाद अल्लाह की इबादत करेगी।'",
      it: "Quando la gente di Taif ferì il Profeta con sassi, l'angelo offrì di distruggere la città. Il Profeta rispose: 'No, spero che dalle loro generazioni nascano credenti devoti ad Allah.'"
    },
    lesson: {
      en: "Wish guidance and good even for those who wrong you.",
      hi: "बुराई करने वालों के लिए भी भलाई और हिदायत की कामना करें।",
      it: "Augura il bene e la retta via anche a chi ti fa del male."
    }
  },
  suleiman_wisdom: {
    title: {
      en: "Wisdom of the Ant",
      hi: "चींटी की बुद्धिमत्ता",
      it: "La Saggezza della Formica"
    },
    subtitle: {
      en: "Caring for all living creatures",
      hi: "सभी जीवों के प्रति संवेदनशीलता",
      it: "Prendersi cura di ogni creatura vivente"
    },
    readTime: { en: "3 mins", hi: "3 मिनट", it: "3 min" },
    reference: { en: "Quran 27:18-19", hi: "क़ुरआन 27:18-19", it: "Corano 27:18-19" },
    body: {
      en: "Prophet Sulaiman (AS) heard an ant warning her colony to seek shelter so the army wouldn't crush them unknowingly. Sulaiman smiled and praised Allah for granting him the wisdom to understand.",
      hi: "हज़रत सुलेमान (अ.) ने एक चींटी को सुना जो अपनी साथी चींटियों को बिल में छिपने को कह रही थी। सुलेमान मुस्कुराए और इस समझ के लिए अल्लाह का शुक्र अदा किया।",
      it: "Il Profeta Sulaiman (AS) udì una formica avvisare le compagne di mettersi al riparo. Sulaiman sorrise e ringraziò Allah per avergli donato la comprensione."
    },
    lesson: {
      en: "Every tiny creature has value; always walk the earth with mindfulness.",
      hi: "हर छोटे जीव का महत्व है; ज़मीन पर हमेशा ध्यान और दया से चलें।",
      it: "Ogni piccola creatura ha valore; cammina sulla terra con consapevolezza."
    }
  },
  madinah_brotherhood: {
    title: {
      en: "The Brotherhood of Madinah",
      hi: "मदीना का भाईचारा (मुवाख़ात)",
      it: "La Fratellanza di Medina"
    },
    subtitle: {
      en: "Selfless sharing between Muhajirun and Ansar",
      hi: "मुहाजिरीन और अंसार के बीच निस्वार्थ सहयोग",
      it: "La condivisione disinteressata tra Muhajirun e Ansar"
    },
    readTime: { en: "3 mins", hi: "3 मिनट", it: "3 min" },
    reference: { en: "Sahih Bukhari 2293", hi: "सहीह बुखारी 2293", it: "Sahih Bukhari 2293" },
    body: {
      en: "In Madinah, the Prophet paired each immigrant from Makkah with a local helper from Madinah. The Ansar shared their homes, wealth, and farms selflessly with their new brothers.",
      hi: "मदीना में नबीजी ने मक्का से आए मुहाजिरों और मदीना के अंसार के बीच भाईचारा स्थापित किया। अंसार ने अपने घर, दौलत और बाग़ निस्वार्थ भाव से बांट लिए।",
      it: "A Medina, il Profeta istituì la fratellanza tra i migranti di Mecca e gli Ansar locali. Gli Ansar condivisero case, beni e campi con generosità esemplare."
    },
    lesson: {
      en: "Share generously with others and build genuine community brotherhood.",
      hi: "दूसरों के साथ उदारता से बांटें और सच्चा भाईचारा क़ायम करें।",
      it: "Condividi generosamente con gli altri e coltiva una sincera fratellanza."
    }
  },
  uhud_wound: {
    title: {
      en: "Steadfastness at Uhud",
      hi: "उहुद के मैदान में सब्र",
      it: "La Costanza a Uhud"
    },
    subtitle: {
      en: "Remaining steadfast when plans face adversity",
      hi: "मुश्किल घड़ी में भी सब्र और दुआ",
      it: "Rimanere saldi quando si affrontano le avversità"
    },
    readTime: { en: "4 mins", hi: "4 मिनट", it: "4 min" },
    reference: { en: "Sahih Bukhari 4073", hi: "सहीह बुखारी 4073", it: "Sahih Bukhari 4073" },
    body: {
      en: "When the Prophet was wounded at Uhud and blood flowed on his face, he wiped the blood and prayed: 'O Allah, forgive my people, for they do not know.'",
      hi: "जब उहुद की जंग में नबीजी ज़ख़्मी हुए और चेहरे से ख़ून बहा, तो उन्होंने ख़ून पोंछते हुए दुआ की: 'ऐ अल्लाह, मेरी क़ौम को माफ़ फ़रमा, क्योंकि वे नहीं जानते।'",
      it: "Quando il Profeta fu ferito a Uhud, si asciugò il sangue dal volto e pregò: 'O Allah, perdona il mio popolo, poiché non sa.'"
    },
    lesson: {
      en: "Meet adversity with prayer and patience rather than resentment.",
      hi: "विपत्ति का सामना गुस्से के बजाय सब्र और दुआ से करें।",
      it: "Affronta le avversità con preghiera e pazienza anziché con rancore."
    }
  },
  marriage_khadija: {
    title: {
      en: "Trust in Character: Khadijah (RA)",
      hi: "किरदार की सच्चाई: हज़रत ख़दीजा",
      it: "La Fiducia nel Carattere: Khadijah (RA)"
    },
    subtitle: {
      en: "Honesty in trade and life shines bright",
      hi: "कारोबार और ज़िंदगी में ईमानदारी की चमक",
      it: "L'onestà nel lavoro e nella vita quotidiana"
    },
    readTime: { en: "3 mins", hi: "3 मिनट", it: "3 min" },
    reference: { en: "Sirat Ibn Hisham", hi: "सीरत इब्न हिशाम", it: "Sirat Ibn Hisham" },
    body: {
      en: "Khadijah entrusted Muhammad with her trade caravan because of his honesty (Al-Amin). Impressed by his integrity, trustworthiness, and noble manners, she chose him as her lifelong companion.",
      hi: "हज़रत ख़दीजा ने नबीजी की ईमानदारी (अल-अमीन) देखकर अपना व्यापारिक क़ाफ़िला उन्हें सौंपा। उनके सत्यवादी और अमानतदार आचरण से प्रभावित होकर उन्होंने शादी का प्रस्ताव भेजा।",
      it: "Khadijah affidò al giovane Muhammad la sua carovana commerciale per la sua nota lealtà (Al-Amin). Ammirata dalla sua integrità, lo scelse come compagno di vita."
    },
    lesson: {
      en: "Honesty and integrity in work earn lasting respect and trust.",
      hi: "काम और लेनदेन में ईमानदारी से हमेशा सम्मान और भरोसा मिलता है।",
      it: "L'onestà e l'integrità nel lavoro fanno guadagnare rispetto e fiducia duraturi."
    }
  },
  isra_miraj: {
    title: {
      en: "The Night Journey (Isra and Mi'raj)",
      hi: "मेराज का सफ़र",
      it: "Il Viaggio Notturno (Isra e Mi'raj)"
    },
    subtitle: {
      en: "The gift of five daily prayers",
      hi: "पाँच वक़्त की नमाज़ का तोहफ़ा",
      it: "Il dono delle cinque preghiere quotidiane"
    },
    readTime: { en: "4 mins", hi: "4 मिनट", it: "4 min" },
    reference: { en: "Sahih Bukhari 349", hi: "सहीह बुखारी 349", it: "Sahih Bukhari 349" },
    body: {
      en: "In a single night, the Prophet was taken from Makkah to Jerusalem, and then ascended through the heavens where Allah gifted the Muslim community the five daily prayers.",
      hi: "एक ही रात में नबीजी को मक्का से बैतुल मुक़द्दस ले जाया गया, और फिर आसमानों की सैर कराई गई जहाँ अल्लाह ने उम्मत को पाँचों नमाज़ों का तोहफ़ा दिया।",
      it: "In una sola notte, il Profeta fu condotto da Mecca a Gerusalemme e ascese ai cieli, dove Allah donò alla comunità dei credenti le cinque preghiere quotidiane."
    },
    lesson: {
      en: "Daily prayer is our direct conversation and spiritual ascension to Allah.",
      hi: "पाँचों नमाज़ें अल्लाह से सीधा संपर्क और मोमिन का मेराज हैं।",
      it: "La preghiera quotidiana è la nostra conversazione diretta con Allah."
    }
  },
  arqam_house: {
    title: {
      en: "The House of Al-Arqam",
      hi: "दार-ए-अरक़म की सीख",
      it: "La Casa di Al-Arqam"
    },
    subtitle: {
      en: "Learning and growing in small circles",
      hi: "छोटे दायरे में ज्ञान और तरबियत",
      it: "Imparare e crescere nei piccoli circoli"
    },
    readTime: { en: "3 mins", hi: "3 मिनट", it: "3 min" },
    reference: { en: "Tarikh al-Tabari", hi: "तारीख़ अल-तबरी", it: "Tarikh al-Tabari" },
    body: {
      en: "In the early days of Islam, believers met secretly at the house of young Al-Arqam to study the Quran, pray together, and support one another in faith.",
      hi: "इस्लाम के शुरुआती दौर में मोमिन नौजवान अरक़म के घर चुपचाप जमा होते थे ताकि क़ुरआन सीख सकें, नमाज़ पढ़ सकें और एक-दूसरे को सहारा दे सकें।",
      it: "Nei primi giorni dell'Islam, i credenti si riunivano nella casa del giovane Al-Arqam per imparare il Corano e sostenersi a vicenda nella fede."
    },
    lesson: {
      en: "Dedicate time to learning in peaceful and supportive environments.",
      hi: "सीखने और समझने के लिए शांत और सहयोगी माहौल बनाएं।",
      it: "Dedica del tempo all'apprendimento in ambienti sereni e solidali."
    }
  },
  farewell_sermon: {
    title: {
      en: "The Farewell Sermon",
      hi: "ख़ुतबा-ए-हुज्जतुल विदा",
      it: "Il Sermone d'Addio"
    },
    subtitle: {
      en: "Universal equality and human dignity",
      hi: "समानता और मानव गरिमा का संदेश",
      it: "Uguaglianza universale e dignità umana"
    },
    readTime: { en: "4 mins", hi: "4 मिनट", it: "4 min" },
    reference: { en: "Musnad Ahmad 22978", hi: "मुसनद अहमद 22978", it: "Musnad Ahmad 22978" },
    body: {
      en: "At Mount Arafat, the Prophet declared: 'All mankind is from Adam and Eve. An Arab has no superiority over a non-Arab, nor a white person over a black person, except by piety.'",
      hi: "अरफ़ात के मैदान में नबीजी ने फ़रमाया: 'तमाम इंसान आदम और हव्वा से हैं। किसी अरबी को ग़ैर-अरबी पर और किसी गोरे को काले पर तक़वे के सिवा कोई फ़ज़ीलत नहीं।'",
      it: "Sul monte Arafat, il Profeta proclamò: 'Tutti gli esseri umani discendono da Adamo ed Eva. Un arabo non è superiore a un non arabo se non per pietà e timor di Dio.'"
    },
    lesson: {
      en: "All human beings are equal; honor and nobility come only through righteous deeds.",
      hi: "तमाम इंसान बराबर हैं; सम्मान और श्रेष्ठता केवल अच्छे आचरण से मिलती है।",
      it: "Tutti gli esseri umani sono uguali; la nobiltà deriva solo dalle azioni rette."
    }
  },
  hadith_smile: {
    title: {
      en: "Smiling is Charity",
      hi: "मुस्कुराना भी सदक़ा है",
      it: "Sorridere è Carità"
    },
    subtitle: {
      en: "Spreading joy and light around you",
      hi: "आसपास खुशियाँ और उजाला फैलाना",
      it: "Diffondere gioia e serenità intorno a sé"
    },
    readTime: { en: "2 mins", hi: "2 मिनट", it: "2 min" },
    reference: { en: "Jami at-Tirmidhi 1956", hi: "जामी अत-तिर्मिज़ी 1956", it: "Jami at-Tirmidhi 1956" },
    body: {
      en: "Jarir (RA) said: 'The Prophet never looked at me except with a warm smile on his blessed face.' A sincere smile warms hearts and is recorded as charity.",
      hi: "जरीर (रज़ि.) ने कहा: 'नबीजी ने जब भी मुझे देखा, उनके चेहरे पर एक प्यारी मुस्कान थी।' दिल से मुस्कुराना दिलों को जोड़ता है और सदक़ा लिखा जाता है।",
      it: "Jarir (RA) disse: 'Il Profeta non mi guardò mai senza un sorriso accogliente sul volto.' Un sorriso sincero riscalda i cuori ed è registrato come carità."
    },
    lesson: {
      en: "Greet everyone with warmth and a cheerful countenance.",
      hi: "सभी से मुस्कुराहट और गर्मजोशी से मिलें।",
      it: "Accogli tutti con calore e un sorriso sincero."
    }
  },
  food_sharing: {
    title: {
      en: "Sharing the Blessing of Food",
      hi: "खाने में बरकत और साझेदारी",
      it: "La Benedizione del Cibo Condiviso"
    },
    subtitle: {
      en: "Food for two is sufficient for three",
      hi: "दो का खाना तीन के लिए काफ़ी है",
      it: "Il cibo per due è sufficiente per tre"
    },
    readTime: { en: "2 mins", hi: "2 मिनट", it: "2 min" },
    reference: { en: "Sahih Bukhari 5392", hi: "सहीह बुखारी 5392", it: "Sahih Bukhari 5392" },
    body: {
      en: "The Prophet taught: 'The food of two people is sufficient for three, and the food of three is sufficient for four.' Eating together brings barakah (divine blessing).",
      hi: "नबीजी ने फ़रमाया: 'दो का खाना तीन के लिए और तीन का खाना चार के लिए काफ़ी होता है।' मिल-जुलकर खाने में बरकत होती है।",
      it: "Il Profeta insegnò: 'Il cibo di due è sufficiente per tre, e il cibo di tre basta per quattro.' Mangiare insieme porta benedizione (barakah)."
    },
    lesson: {
      en: "Share food and hospitality willingly; it multiplies blessings.",
      hi: "खुशी-खुशी खाना बांटें; इससे बरकत बढ़ती है।",
      it: "Condividi il cibo con generosità; la condivisione moltiplica le benedizioni."
    }
  },
  muadh_kindness: {
    title: {
      en: "Advice to Mu'adh (RA)",
      hi: "मुआज़ (रज़ि.) को प्यारी नसीहत",
      it: "Il Consiglio a Mu'adh (RA)"
    },
    subtitle: {
      en: "Teaching gently and making matters easy",
      hi: "आसानी पैदा करना और नफ़रत न फैलाना",
      it: "Insegnare con dolcezza e facilitare le cose"
    },
    readTime: { en: "3 mins", hi: "3 मिनट", it: "3 min" },
    reference: { en: "Sahih Bukhari 6125", hi: "सहीह बुखारी 6125", it: "Sahih Bukhari 6125" },
    body: {
      en: "Sending Mu'adh to Yemen, the Prophet advised him: 'Make things easy and do not make them difficult; give glad tidings and do not repel people.'",
      hi: "मुआज़ को यमन भेजते समय नबीजी ने नसीहत की: 'आसानी पैदा करो और मुश्किल मत बनाओ; खुशियाँ बांटो और लोगों को दूर मत करो।'",
      it: "Inviando Mu'adh nello Yemen, il Profeta gli raccomandò: 'Rendete le cose facili e non difficili; annunciate buone novelle e non allontanate la gente.'"
    },
    lesson: {
      en: "Approach education and religion with gentleness, patience, and facilitation.",
      hi: "दीन और तालीम में हमेशा आसानी, नर्मी और प्यार से काम लें।",
      it: "Accostati all'educazione con dolcezza, pazienza e facilità."
    }
  },
  ashab_suffa: {
    title: {
      en: "The Companions of the Bench (Suffah)",
      hi: "असहाब-ए-सुफ़्फ़ा की लगन",
      it: "I Compagni della Panca (Suffah)"
    },
    subtitle: {
      en: "Dedication to sacred knowledge and simplicity",
      hi: "ज्ञान की लगन और सादगी भरा जीवन",
      it: "Dedizione alla conoscenza e semplicità di vita"
    },
    readTime: { en: "3 mins", hi: "3 मिनट", it: "3 min" },
    reference: { en: "Sahih Bukhari 6452", hi: "सहीह बुखारी 6452", it: "Sahih Bukhari 6452" },
    body: {
      en: "At the rear of the Prophet's Mosque lived students of knowledge who dedicated their lives to learning the Quran and Sunnah in noble simplicity. The Prophet cared for them as a father.",
      hi: "मस्जिद-ए-नबवी के एक चबूतरे (सुफ़्फ़ा) पर ऐसे तालिब-ए-इल्म रहते थे जिन्होंने क़ुरआन-सुन्नत सीखने में ज़िंदगी लगाई। नबीजी उनका पिता की तरह ख़्याल रखते थे।",
      it: "Nel retro della Moschea del Profeta vivevano studenti dediti alla ricerca del sapere e allo studio del Corano in nobile semplicità. Il Profeta si prendeva cura di loro come un padre."
    },
    lesson: {
      en: "Honoring knowledge and supporting students is a virtuous path.",
      hi: "ज्ञान का सम्मान करना और सीखने वालों की मदद करना बहुत बड़ा काम है।",
      it: "Onorare la conoscenza e sostenere gli studenti è una via virtuosa."
    }
  }
};

// Build Bengali map from parsed stories
const bnMap = {};
for (const s of rawStories) {
  bnMap[s.id] = {
    title: decodeUnicode(s.title),
    subtitle: decodeUnicode(s.subtitle),
    readTime: decodeUnicode(s.readTime),
    reference: decodeUnicode(s.reference),
    body: decodeUnicode(s.body),
    lesson: decodeUnicode(s.lesson),
  };
}

// Generate new keys to inject
const newKeys = { en: {}, bn: {}, hi: {}, it: {} };

for (const s of rawStories) {
  const id = s.id;
  const trans = seerahData[id];
  const bn = bnMap[id];

  // en
  newKeys.en[`seerah.story.${id}.title`] = trans.title.en;
  newKeys.en[`seerah.story.${id}.subtitle`] = trans.subtitle.en;
  newKeys.en[`seerah.story.${id}.read_time`] = trans.readTime.en;
  newKeys.en[`seerah.story.${id}.reference`] = trans.reference.en;
  newKeys.en[`seerah.story.${id}.body`] = trans.body.en;
  newKeys.en[`seerah.story.${id}.lesson`] = trans.lesson.en;

  // bn
  newKeys.bn[`seerah.story.${id}.title`] = bn.title;
  newKeys.bn[`seerah.story.${id}.subtitle`] = bn.subtitle;
  newKeys.bn[`seerah.story.${id}.read_time`] = bn.readTime;
  newKeys.bn[`seerah.story.${id}.reference`] = bn.reference;
  newKeys.bn[`seerah.story.${id}.body`] = bn.body;
  newKeys.bn[`seerah.story.${id}.lesson`] = bn.lesson;

  // hi
  newKeys.hi[`seerah.story.${id}.title`] = trans.title.hi;
  newKeys.hi[`seerah.story.${id}.subtitle`] = trans.subtitle.hi;
  newKeys.hi[`seerah.story.${id}.read_time`] = trans.readTime.hi;
  newKeys.hi[`seerah.story.${id}.reference`] = trans.reference.hi;
  newKeys.hi[`seerah.story.${id}.body`] = trans.body.hi;
  newKeys.hi[`seerah.story.${id}.lesson`] = trans.lesson.hi;

  // it
  newKeys.it[`seerah.story.${id}.title`] = trans.title.it;
  newKeys.it[`seerah.story.${id}.subtitle`] = trans.subtitle.it;
  newKeys.it[`seerah.story.${id}.read_time`] = trans.readTime.it;
  newKeys.it[`seerah.story.${id}.reference`] = trans.reference.it;
  newKeys.it[`seerah.story.${id}.body`] = trans.body.it;
  newKeys.it[`seerah.story.${id}.lesson`] = trans.lesson.it;
}

// Merge into locales/*.json and assets/locales/*.json
for (const loc of LOCALES) {
  for (const dir of ['locales', 'assets/locales']) {
    const p = path.join(ROOT, dir, `${loc}.json`);
    const data = JSON.parse(fs.readFileSync(p, 'utf8'));
    Object.assign(data, newKeys[loc]);
    fs.writeFileSync(p, JSON.stringify(data, null, 2) + '\n', 'utf8');
  }

  const arbPath = path.join(ROOT, 'assets/l10n', `app_${loc}.arb`);
  const arb = JSON.parse(fs.readFileSync(arbPath, 'utf8'));
  for (const [k, v] of Object.entries(newKeys[loc])) {
    arb[k] = v;
    if (loc === 'en') arb[`@${k}`] = { description: `Translation for ${k}` };
  }
  fs.writeFileSync(arbPath, JSON.stringify(arb, null, 2) + '\n', 'utf8');
}

console.log('Merged all 23 Seerah stories across all 4 catalogs.');
