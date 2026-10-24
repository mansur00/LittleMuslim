const fs = require('fs');
const path = require('path');

const targetFile = path.resolve(__dirname, '../lib/data/nurani_qaida_data.dart');
let content = fs.readFileSync(targetFile, 'utf8');

// 1. Fix letterSpecs distractors that had 'qaida.step.1.desc'
content = content.replace(/'qaida\.step\.1\.desc'/g, "'د'");

// 2. Fix _buildStep1Mufradat() extraction
const oldExtract = `    final lessons = <QaidaLessonInfo>[];
    for (var i = 0; i < letterSpecs.length; i++) {
      final spec = letterSpecs[i];
      final letterId = spec['id'] as String;
      final name = spec['name'] as String;
      final ar = spec['ar'] as String;
      final trans = spec['trans'] as String;
      final makhraj = spec['makhraj'] as String;
      final desc = spec['desc'] as String;
      final words = spec['words'] as List<String>;
      final distractors = spec['distractors'] as List<String>;
      final audio = spec['audio'] as String;

      final d1 = distractors[0];
      final d2 = distractors.length > 1 ? distractors[1] : 'ب';`;

const newExtract = `    final lessons = <QaidaLessonInfo>[];
    for (var i = 0; i < letterSpecs.length; i++) {
      final spec = letterSpecs[i];
      final letterId = spec['id'] as String;
      final ar = spec['ar'] as String;
      final nameKey = 'qaida.letter.' + (letterId == 'taa_heavy' ? 'toa' : (letterId == 'zaa_heavy' ? 'zoa' : (letterId == 'zaay' ? 'zay' : letterId))) + '.name';
      final makhrajKey = 'qaida.letter.' + (letterId == 'haa_small' ? 'ha_soft' : (letterId == 'baa' ? 'ba' : (letterId == 'taa' ? 'ta' : (letterId == 'thaa' ? 'tha' : (letterId == 'khaa' ? 'kha' : (letterId == 'daal' ? 'dal' : (letterId == 'dhaal' ? 'dhal' : (letterId == 'raa' ? 'ra' : (letterId == 'zaay' ? 'zay' : (letterId == 'saad' ? 'sad' : (letterId == 'daad' ? 'dad' : (letterId == 'taa_heavy' ? 'toa' : (letterId == 'zaa_heavy' ? 'zoa' : (letterId == 'faa' ? 'fa' : (letterId == 'qaaf' ? 'qaf' : (letterId == 'kaaf' ? 'kaf' : (letterId == 'laam' ? 'lam' : (letterId == 'waaw' ? 'waw' : (letterId == 'yaa' ? 'ya' : letterId))))))))))))))))))) + '.makhraj';
      final words = spec['words'] as List<String>;
      final distractors = spec['distractors'] as List<String>;
      final audio = spec['audio'] as String;

      final d1 = distractors[0];
      final d2 = distractors.length > 1 ? distractors[1] : 'ب';`;

content = content.replace(oldExtract, newExtract);

// In activity 2 and 4, replace trans with nameKey
content = content.replace(`          pairs: {
            ar: trans,
            d1: d1,
            d2: d2,
          },`, `          pairs: {
            ar: nameKey,
            d1: d1,
            d2: d2,
          },`);

content = content.replace(`          pairs: {
            ar: trans,
            d1: d1,
          },`, `          pairs: {
            ar: nameKey,
            d1: d1,
          },`);

// Replace QaidaLessonInfo in Step 1
const oldLesson1 = `      lessons.add(
        QaidaLessonInfo(
          id: 'step1_\$letterId',
          trackId: 'step_1_mufradat',
          lessonNumber: i + 1,
          title: 'qaida.step.1.title',
          subtitle: 'qaida.step.1.title',
          arabicDisplay: ar,
          description: desc,
          audioAsset: audio,
          makhraj: makhraj,
          exampleWords: words,
          activities: activities,
        ),
      );`;

const newLesson1 = `      lessons.add(
        QaidaLessonInfo(
          id: 'step1_\$letterId',
          trackId: 'step_1_mufradat',
          lessonNumber: i + 1,
          titleKey: nameKey,
          subtitleKey: 'qaida.step.1.title',
          arabicDisplay: ar,
          descriptionKey: 'qaida.step.1.desc',
          audioAsset: audio,
          makhrajKey: makhrajKey,
          exampleWords: words,
          activities: activities,
        ),
      );`;

content = content.replace(oldLesson1, newLesson1);

// Step 2 item['name'] crash fix
content = content.replace(`      final item = formItems[i];
      final l = item['letter'] as String;
      final name = item['name'] as String;
      final init = item['init'] as String;`, `      final item = formItems[i];
      final l = item['letter'] as String;
      final init = item['init'] as String;`);

// Step 17 pure Arabic options
content = content.replace(`          options: [
            'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
            'الرَّحْمٰنِ الرَّحِيمِ',
            'qaida.step.17.desc',
          ],`, `          options: [
            'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
            'الرَّحْمٰنِ الرَّحِيمِ',
            'مَالِكِ يَوْمِ الدِّينِ',
          ],`);

content = content.replace(`          sequenceItems: [
            'بِسْمِ اللَّهِ الرَّحْمٰنِ الرَّحِيمِ',
            'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
            'الرَّحْمٰنِ الرَّحِيمِ',
            'qaida.step.17.desc',
          ],`, `          sequenceItems: [
            'بِسْمِ اللَّهِ الرَّحْمٰنِ الرَّحِيمِ',
            'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
            'الرَّحْمٰنِ الرَّحِيمِ',
            'مَالِكِ يَوْمِ الدِّينِ',
          ],`);

content = content.replace(`          options: [
            'qaida.step.17.desc',
            'qaida.step.17.desc',
            'qaida.step.17.desc',
          ],`, `          options: [
            'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
            'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ',
            'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ',
          ],`);

// Now update all NuraniStepInfo phaseName, titleEn, title, description, gardenPlant
for (let s = 1; s <= 17; s++) {
  // Replace titleEn: '...', with titleKey: 'qaida.step.X.title',
  // Replace phaseName: '...', with phaseNameKey: 'qaida.step.X.phase_name',
  // Replace gardenPlant: '...', with gardenPlantKey: 'qaida.step.X.garden_plant',
  // Replace title: '...', with titleKey: 'qaida.step.X.title',
  // Replace description: '...', with descriptionKey: 'qaida.step.X.desc',
}

// Regex to replace all NuraniStepInfo titleEn and phaseName
content = content.replace(/titleEn:\s*'[^']+',\s*/g, '');
content = content.replace(/phaseName:\s*'[^']+',/g, (match, offset) => {
  // find preceding stepNumber
  const sub = content.substring(Math.max(0, offset - 300), offset);
  const m = sub.match(/stepNumber:\s*(\d+)/);
  const num = m ? m[1] : '1';
  return `phaseNameKey: 'qaida.step.${num}.phase_name',`;
});

content = content.replace(/gardenPlant:\s*'([^']+)',/g, "gardenPlantKey: '$1',");
content = content.replace(/title:\s*'qaida\.step\.(\d+)\.title',/g, "titleKey: 'qaida.step.$1.title',");
content = content.replace(/description:\s*'qaida\.step\.(\d+)\.desc',/g, "descriptionKey: 'qaida.step.$1.desc',");

fs.writeFileSync(targetFile, content, 'utf8');
console.log('Successfully updated nurani_qaida_data.dart');
