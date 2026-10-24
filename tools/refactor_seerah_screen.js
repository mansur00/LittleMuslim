const fs = require('fs');
const path = require('path');

const ROOT = path.resolve(__dirname, '..');
const storiesRaw = JSON.parse(fs.readFileSync(path.join(ROOT, 'tools', 'scratch_seerah_stories.json'), 'utf8'));

const lines = [];
lines.push('class _SeerahStory {');
lines.push('  const _SeerahStory({');
lines.push('    required this.id,');
lines.push('    required this.iconType,');
lines.push('    required this.accent,');
lines.push('    required this.color,');
lines.push('  });');
lines.push('');
lines.push('  final String id;');
lines.push('  final VectorIconType iconType;');
lines.push('  final Color accent;');
lines.push('  final Color color;');
lines.push('');
lines.push('  String getLocalizedTitle(BuildContext context) =>');
lines.push("      context.t('seerah.story.' + id + '.title');");
lines.push('');
lines.push('  String getLocalizedSubtitle(BuildContext context) =>');
lines.push("      context.t('seerah.story.' + id + '.subtitle');");
lines.push('');
lines.push('  String getLocalizedReadTime(BuildContext context) =>');
lines.push("      context.t('seerah.story.' + id + '.read_time');");
lines.push('');
lines.push('  String getLocalizedReference(BuildContext context) =>');
lines.push("      context.t('seerah.story.' + id + '.reference');");
lines.push('');
lines.push('  String getLocalizedBody(BuildContext context) =>');
lines.push("      context.t('seerah.story.' + id + '.body');");
lines.push('');
lines.push('  String getLocalizedLesson(BuildContext context) =>');
lines.push("      context.t('seerah.story.' + id + '.lesson');");
lines.push('}');
lines.push('');
lines.push('const _stories = [');

for (const s of storiesRaw) {
  lines.push('  _SeerahStory(');
  lines.push(`    id: '${s.id}',`);
  lines.push(`    iconType: ${s.iconType},`);
  lines.push(`    accent: ${s.accent},`);
  lines.push(`    color: ${s.color},`);
  lines.push('  ),');
}
lines.push('];');

const seerahFile = path.join(ROOT, 'lib', 'screens', 'seerah', 'seerah_screen.dart');
const content = fs.readFileSync(seerahFile, 'utf8');

const startMarker = 'class _SeerahStory {';
const endMarker = 'class SeerahScreen extends StatelessWidget {';

const startIndex = content.indexOf(startMarker);
const endIndex = content.indexOf(endMarker);

if (startIndex === -1 || endIndex === -1) {
  console.error('Markers not found!');
  process.exit(1);
}

const newContent = content.substring(0, startIndex) + lines.join('\n') + '\n\n' + content.substring(endIndex);
fs.writeFileSync(seerahFile, newContent, 'utf8');
console.log('Successfully refactored seerah_screen.dart!');
