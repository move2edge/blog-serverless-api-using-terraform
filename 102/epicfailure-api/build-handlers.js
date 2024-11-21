// epicfailure-api/sbuild-handlers.js
// This script uses esbuild to bundle each handler along with its dependencies into a single file.
// It reads the handlers directory, filters out unnecessary files, and bundles each handler into the dist directory.

const fs = require('fs');
const path = require('path');
const esbuild = require('esbuild');

const handlersDir = path.join(__dirname, 'src', 'handlers');
const outputDir = path.join(__dirname, 'dist', 'handlers');

if (!fs.existsSync(outputDir)) {
  fs.mkdirSync(outputDir, { recursive: true });
}

fs.readdir(handlersDir, (err, files) => {
  if (err) {
    console.error('Error reading handlers directory:', err);
    process.exit(1);
  }

  files = files.filter(file => file !== '.DS_Store'); // Ignore .DS_Store files (macOS)

  files.forEach(file => {
      const outfilename = file.replace('.ts', '.js');

      esbuild.build({
        entryPoints: [path.join(handlersDir, file)],
        bundle: true,
        outfile: path.join('dist', 'handlers', outfilename),
        external: ['aws-sdk'], // Exclude AWS SDK since it's available in the Lambda runtime
        platform: 'node',
        target: 'node18',
      }).catch(() => process.exit(1));
  });
});