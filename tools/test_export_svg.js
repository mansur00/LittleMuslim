const fs = require('fs');
const https = require('https');

const token = process.env.FIGMA_ACCESS_TOKEN;
if (!token) {
  console.error('ERROR: FIGMA_ACCESS_TOKEN environment variable is required.');
  process.exit(1);
}
const fileKey = process.env.FIGMA_FILE_KEY || 'c539ZFgBoEBwTzboYz9W1r';

const testIds = ['1:3412', '1:3', '1:3735', '6:20000', '6:20020', '6:27663', '6:28130'];

function getSvgUrls(ids, callback) {
  const url = `https://api.figma.com/v1/images/${fileKey}?ids=${ids.join(',')}&format=svg`;
  https.get(url, {
    headers: { 'X-Figma-Token': token }
  }, res => {
    let body = '';
    res.on('data', d => body += d);
    res.on('end', () => {
      const data = JSON.parse(body);
      callback(data.images);
    });
  }).on('error', console.error);
}

getSvgUrls(testIds, (images) => {
  console.log('SVG URLs received:', Object.keys(images).length);
  Object.entries(images).forEach(([id, svgUrl]) => {
    console.log(`Node ${id} -> ${svgUrl}`);
  });
});
