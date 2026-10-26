const fs = require('fs');
const https = require('https');

const token = process.env.FIGMA_ACCESS_TOKEN;
if (!token) {
  console.error('ERROR: FIGMA_ACCESS_TOKEN environment variable is required.');
  process.exit(1);
}
const fileKey = process.env.FIGMA_FILE_KEY || 'c539ZFgBoEBwTzboYz9W1r';

const illusIds = ['6:17114', '6:17630', '6:18024', '6:18175', '6:19329', '6:17045', '6:17763'];

const url = 'https://api.figma.com/v1/images/' + fileKey + '?ids=' + illusIds.join(',') + '&format=svg';

https.get(url, { headers: { 'X-Figma-Token': token } }, res => {
  let b = '';
  res.on('data', d => b += d);
  res.on('end', () => {
    const urls = JSON.parse(b).images;
    fs.mkdirSync('scratch/figma_illus', { recursive: true });
    Object.entries(urls).forEach(([id, u]) => {
      https.get(u, sres => {
        let svg = '';
        sres.on('data', sd => svg += sd);
        sres.on('end', () => {
          const fname = 'scratch/figma_illus/illus_' + id.replace(':', '_') + '.svg';
          fs.writeFileSync(fname, svg);
          console.log('Saved', fname, 'Length:', svg.length);
        });
      });
    });
  });
});
