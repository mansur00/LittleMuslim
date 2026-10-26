const fs = require('fs');
const https = require('https');

const token = process.env.FIGMA_ACCESS_TOKEN;
if (!token) {
  console.error('ERROR: FIGMA_ACCESS_TOKEN environment variable is required.');
  process.exit(1);
}
const fileKey = process.env.FIGMA_FILE_KEY || 'c539ZFgBoEBwTzboYz9W1r';

function fetchDoc() {
  const req = https.get('https://api.figma.com/v1/files/' + fileKey, {
    headers: {
      'X-Figma-Token': token,
      'User-Agent': 'Node.js/FigmaImporter'
    }
  }, (res) => {
    let body = '';
    res.on('data', chunk => body += chunk);
    res.on('end', () => {
      if (res.statusCode !== 200) {
        console.error('Failed with status:', res.statusCode, body);
        return;
      }
      const data = JSON.parse(body);
      fs.writeFileSync('scratch/figma_doc.json', JSON.stringify(data, null, 2), 'utf8');
      console.log('Figma document saved to scratch/figma_doc.json');
      
      const inventory = [];
      function traverse(node, pageName, parentName = '') {
        const type = node.type;
        const name = node.name;
        const id = node.id;
        const box = node.absoluteBoundingBox || {};
        
        // Check if component, frame, instance, or vector group
        if (['FRAME', 'COMPONENT', 'COMPONENT_SET', 'INSTANCE', 'GROUP'].includes(type)) {
          inventory.push({
            id,
            name,
            type,
            page: pageName,
            parent: parentName,
            width: box.width,
            height: box.height,
            childCount: (node.children || []).length
          });
        }
        if (node.children) {
          node.children.forEach(child => traverse(child, pageName, name));
        }
      }

      data.document.children.forEach(page => {
        traverse(page, page.name);
      });

      console.log('Total inventory nodes:', inventory.length);
      fs.writeFileSync('scratch/figma_inventory.json', JSON.stringify(inventory, null, 2), 'utf8');

      // Print summary per page
      data.document.children.forEach(page => {
        console.log(`\n=================== PAGE: ${page.name} (${page.id}) ===================`);
        (page.children || []).forEach(child => {
          console.log(`- [${child.type}] "${child.name}" (ID: ${child.id}) [${Math.round(child.absoluteBoundingBox?.width || 0)}x${Math.round(child.absoluteBoundingBox?.height || 0)}]`);
          if (child.children && child.children.length > 0 && child.children.length <= 15) {
            child.children.forEach(sub => {
              console.log(`    * [${sub.type}] "${sub.name}" (ID: ${sub.id}) [${Math.round(sub.absoluteBoundingBox?.width || 0)}x${Math.round(sub.absoluteBoundingBox?.height || 0)}]`);
            });
          }
        });
      });
    });
  });
  req.on('error', console.error);
}

fs.mkdirSync('scratch', { recursive: true });
fetchDoc();
