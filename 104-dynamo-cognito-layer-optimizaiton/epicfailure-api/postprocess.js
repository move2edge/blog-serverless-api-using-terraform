// epicfailure-api/postprocess.js

// This script performs post-processing on transpiled JavaScript files in the 'dist' directory.
// It replaces specific require statements with the correct paths for AWS Lambda layers.
// The script processes all .js files in the specified directory and its subdirectories.

const fs = require('fs');
const path = require('path');

const directoryPath = path.join(__dirname, 'dist'); // Adjust the path to your transpiled output directory

function processFile(filePath) {
  let content = fs.readFileSync(filePath, 'utf8');
  content = content.replace(/require\("@shared-layer\/services"\)/g, 'require("/opt/nodejs/node18/services")');
  content = content.replace(/require\("@shared-layer\/models"\)/g, 'require("/opt/nodejs/node18/models")');
  fs.writeFileSync(filePath, content, 'utf8');
}

function processDirectory(directoryPath) {
  fs.readdirSync(directoryPath).forEach((file) => {
    const fullPath = path.join(directoryPath, file);
    if (fs.lstatSync(fullPath).isDirectory()) {
      processDirectory(fullPath);
    } else if (fullPath.endsWith('.js')) {
      processFile(fullPath);
    }
  });
}

processDirectory(directoryPath);
