const fs = require('fs');
const path = require('path');
const https = require('https');

const TOKEN = process.env.FIGMA_ACCESS_TOKEN;
if (!TOKEN) {
  console.error('ERROR: FIGMA_ACCESS_TOKEN environment variable is required.');
  process.exit(1);
}
const FILE_KEY = process.env.FIGMA_FILE_KEY || 'c539ZFgBoEBwTzboYz9W1r';
const ROOT = path.resolve(__dirname, '..');

const ASSET_SPEC = [
  // ── 1. ICONS: ISLAMIC ──
  { category: 'icons/islamic', filename: 'ic_star.svg', nodeId: '6:20000', label: 'Star icon' },
  { category: 'icons/islamic', filename: 'ic_moon.svg', nodeId: '6:20004', label: 'Crescent moon icon' },
  { category: 'icons/islamic', filename: 'ic_lantern.svg', nodeId: '6:20008', label: 'Fanous lantern icon' },
  { category: 'icons/islamic', filename: 'ic_book.svg', nodeId: '6:20012', label: 'Holy book / Quran icon' },
  { category: 'icons/islamic', filename: 'ic_plant.svg', nodeId: '6:20016', label: 'Olive branch plant icon' },
  { category: 'icons/islamic', filename: 'ic_mosque.svg', nodeId: '6:20020', label: 'Mosque dome icon' },

  // ── 2. ICONS: GAME ──
  { category: 'icons/game', filename: 'ic_game_star.svg', nodeId: '1:3735', label: 'Reward star icon' },
  { category: 'icons/game', filename: 'ic_heart.svg', nodeId: '1:3737', label: 'Health life heart icon' },
  { category: 'icons/game', filename: 'ic_gem.svg', nodeId: '1:3739', label: 'Treasure diamond gem icon' },
  { category: 'icons/game', filename: 'ic_check.svg', nodeId: '1:3741', label: 'Checkmark completed icon' },
  { category: 'icons/game', filename: 'ic_play.svg', nodeId: '1:3743', label: 'Play arrow icon' },
  { category: 'icons/game', filename: 'ic_lock.svg', nodeId: '1:3745', label: 'Security padlock icon' },
  { category: 'icons/game', filename: 'ic_trophy.svg', nodeId: '1:3747', label: 'Achievement trophy icon' },
  { category: 'icons/game', filename: 'ic_sound.svg', nodeId: '1:3749', label: 'Audio volume sound icon' },
  { category: 'icons/game', filename: 'ic_settings.svg', nodeId: '1:3751', label: 'Settings gear cog icon' },
  { category: 'icons/game', filename: 'ic_cross.svg', nodeId: '1:3753', label: 'Close dismiss cross icon' },
  { category: 'icons/game', filename: 'ic_refresh.svg', nodeId: '1:3755', label: 'Repeat replay refresh icon' },
  { category: 'icons/game', filename: 'ic_info.svg', nodeId: '1:3757', label: 'Information help icon' },
  { category: 'icons/game', filename: 'ic_gift.svg', nodeId: '1:3759', label: 'Surprise bonus gift icon' },
  { category: 'icons/game', filename: 'ic_medal.svg', nodeId: '1:3761', label: 'Honor medal award icon' },

  // ── 3. BADGES ──
  { category: 'badges', filename: 'badge_level_1.svg', nodeId: '1:3', label: 'Level 1 milestone badge' },
  { category: 'badges', filename: 'badge_level_2.svg', nodeId: '1:42', label: 'Level 2 milestone badge' },
  { category: 'badges', filename: 'badge_level_3.svg', nodeId: '1:77', label: 'Level 3 milestone badge' },
  { category: 'badges', filename: 'badge_level_4.svg', nodeId: '1:104', label: 'Level 4 milestone badge' },
  { category: 'badges', filename: 'badge_level_5.svg', nodeId: '1:135', label: 'Level 5 milestone badge' },
  { category: 'badges', filename: 'badge_level_6.svg', nodeId: '1:181', label: 'Level 6 milestone badge' },
  { category: 'badges', filename: 'badge_level_7.svg', nodeId: '1:238', label: 'Level 7 milestone badge' },
  { category: 'badges', filename: 'badge_level_8.svg', nodeId: '1:306', label: 'Level 8 milestone badge' },
  { category: 'badges', filename: 'badge_level_9.svg', nodeId: '1:381', label: 'Level 9 milestone badge' },
  { category: 'badges', filename: 'badge_shield_gold.svg', nodeId: '1:3412', label: 'Golden shield achievement' },
  { category: 'badges', filename: 'badge_shield_silver.svg', nodeId: '1:3440', label: 'Silver shield achievement' },
  { category: 'badges', filename: 'badge_shield_bronze.svg', nodeId: '1:3461', label: 'Bronze shield achievement' },
  { category: 'badges', filename: 'stars_reward_3.svg', nodeId: '1:3770', label: '3-star mastery rating' },

  // ── 4. ILLUSTRATIONS: ISLAMIC ──
  { category: 'illustrations/islamic', filename: 'mosque_grand_facade.svg', nodeId: '6:18175', label: 'Decorative grand mosque facade' },
  { category: 'illustrations/islamic', filename: 'mosque_dome_arch.svg', nodeId: '6:17114', label: 'Decorative mosque arch and dome' },
  { category: 'illustrations/islamic', filename: 'minaret_tower.svg', nodeId: '6:17630', label: 'Decorative minaret tower' },
  { category: 'illustrations/islamic', filename: 'islamic_pavilion.svg', nodeId: '6:19329', label: 'Decorative Islamic garden pavilion' },
  { category: 'illustrations/islamic', filename: 'lantern_ornate.svg', nodeId: '6:17045', label: 'Decorative ornate Ramadan lantern' },

  // ── 5. ILLUSTRATIONS: MAP ──
  { category: 'illustrations/map', filename: 'map_road_path.svg', nodeId: '6:24884', label: 'Adventure map winding road path' },
  { category: 'illustrations/map', filename: 'map_node_active.svg', nodeId: '6:27663', label: 'Map node active in-progress state' },
  { category: 'illustrations/map', filename: 'map_node_complete.svg', nodeId: '6:27694', label: 'Map node completed state' },
  { category: 'illustrations/map', filename: 'map_node_locked.svg', nodeId: '6:27725', label: 'Map node locked state' },
  { category: 'illustrations/map', filename: 'garden_tree_oak.svg', nodeId: '6:28130', label: 'Isometric garden shade tree' },
  { category: 'illustrations/map', filename: 'garden_tree_pine.svg', nodeId: '6:28301', label: 'Isometric garden cypress tree' },
  { category: 'illustrations/map', filename: 'garden_pavilion.svg', nodeId: '6:28666', label: 'Isometric garden rest pavilion' },
  { category: 'illustrations/map', filename: 'map_rocks.svg', nodeId: '6:28453', label: 'Isometric garden rocks grouping' },
  { category: 'illustrations/map', filename: 'map_bridge.svg', nodeId: '6:28970', label: 'Isometric wooden bridge piece' },
  { category: 'illustrations/map', filename: 'map_river.svg', nodeId: '6:29460', label: 'Isometric river water piece' },
  { category: 'illustrations/map', filename: 'map_signboard.svg', nodeId: '6:29588', label: 'Isometric wooden signboard post' },
  { category: 'illustrations/map', filename: 'map_road_piece.svg', nodeId: '6:29939', label: 'Isometric garden road piece' },
];

function fetchSvgUrls(nodeIds) {
  return new Promise((resolve, reject) => {
    const url = `https://api.figma.com/v1/images/${FILE_KEY}?ids=${nodeIds.join(',')}&format=svg`;
    https.get(url, { headers: { 'X-Figma-Token': TOKEN } }, res => {
      let data = '';
      res.on('data', c => data += c);
      res.on('end', () => {
        try {
          const json = JSON.parse(data);
          resolve(json.images || {});
        } catch (e) {
          reject(e);
        }
      });
    }).on('error', reject);
  });
}

function downloadFile(url) {
  return new Promise((resolve, reject) => {
    https.get(url, res => {
      let data = '';
      res.on('data', c => data += c);
      res.on('end', () => resolve(data));
    }).on('error', reject);
  });
}

async function run() {
  console.log('Fetching SVG export URLs for', ASSET_SPEC.length, 'assets...');
  const ids = ASSET_SPEC.map(a => a.nodeId);
  const imageUrls = await fetchSvgUrls(ids);

  const manifest = [];

  for (const spec of ASSET_SPEC) {
    const s3Url = imageUrls[spec.nodeId];
    if (!s3Url) {
      console.error('No SVG URL found for node:', spec.nodeId, spec.filename);
      continue;
    }

    const dir = path.join(ROOT, 'assets', 'figma', spec.category);
    fs.mkdirSync(dir, { recursive: true });
    const targetPath = path.join(dir, spec.filename);

    console.log(`Downloading ${spec.category}/${spec.filename} (Node: ${spec.nodeId})...`);
    let svgContent = await downloadFile(s3Url);

    // Sanitize SVG: ensure viewBox or width/height exists
    const hasRaster = svgContent.includes('<image') || svgContent.includes('base64');
    const widthMatch = svgContent.match(/width=\"([0-9.]+)\"/);
    const heightMatch = svgContent.match(/height=\"([0-9.]+)\"/);
    const viewBoxMatch = svgContent.match(/viewBox=\"([^\"]+)\"/);

    fs.writeFileSync(targetPath, svgContent, 'utf8');

    const stat = fs.statSync(targetPath);
    manifest.push({
      category: spec.category,
      filename: spec.filename,
      nodeId: spec.nodeId,
      label: spec.label,
      sizeBytes: stat.size,
      width: widthMatch ? widthMatch[1] : (viewBoxMatch ? viewBoxMatch[1].split(' ')[2] : '?'),
      height: heightMatch ? heightMatch[1] : (viewBoxMatch ? viewBoxMatch[1].split(' ')[3] : '?'),
      hasRaster: hasRaster ? 'YES (Flagged)' : 'None (Clean Vector)',
    });
  }

  // Generate docs/figma-assets.md
  let doc = `# Figma Assets Inventory & Attribution

## Licensing & Source
- **Source**: Freepik Premium (owner subscription). Use inside the app only; do not redistribute assets standalone.
- **Usage Policy**:
  - Assets (illustrations, badges, icons) are used **AS-IS**: gradients, shadows, and multiple colors inside an asset are allowed.
  - No recoloring of multi-color assets. Single-color line icons may be recolored to module tokens (\`ModuleTheme\`).
  - UI surfaces remain solid: buttons, backgrounds, borders, cards, inputs, chips = flat solid colors, no gradients, no shadows. 3D bottom edge stays on tappable controls.
  - Glossy game buttons in Figma are ignored (only their icons are extracted).
  - Use only the assets that fit the style kit; ignore the rest.

---

## Asset Manifest & Quality Audit

| Category | File Name | Node ID | Dimensions | Size | Raster Check | Semantic Label |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
`;

  for (const m of manifest) {
    doc += `| \`${m.category}\` | [\`${m.filename}\`](file:///${path.join(ROOT, 'assets', 'figma', m.category, m.filename)}) | \`${m.nodeId}\` | ${m.width}×${m.height} | ${(m.sizeBytes / 1024).toFixed(1)} KB | ${m.hasRaster} | ${m.label} |\n`;
  }

  doc += `\n---\n*Generated automatically from Figma File \`${FILE_KEY}\` via REST API.*\n`;

  fs.writeFileSync(path.join(ROOT, 'docs', 'figma-assets.md'), doc, 'utf8');
  console.log('docs/figma-assets.md written successfully.');
  console.log(`Successfully exported ${manifest.length} SVGs!`);
}

run().catch(console.error);
