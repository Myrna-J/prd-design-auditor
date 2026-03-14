/**
 * check-console-log.js
 *
 * Hook: Stop
 * Description: Check for console.log in modified files after each response
 *
 * Triggers when: After each response is generated
 * Purpose: Warn about console.log statements that should be removed before commit
 */

const fs = require('fs');

let data = '';

process.stdin.on('data', (chunk) => {
  data += chunk;
});

process.stdin.on('end', () => {
  try {
    const input = JSON.parse(data);

    // Get list of modified files from the tool use results
    const modifiedFiles = [];

    // Check for Edit tool results
    if (input.tool_uses) {
      for (const use of input.tool_uses) {
        if (use.tool === 'Edit' || use.tool === 'Write') {
          const filePath = use.input?.file_path;
          if (filePath && (filePath.endsWith('.js') || filePath.endsWith('.ts') || filePath.endsWith('.jsx') || filePath.endsWith('.tsx'))) {
            modifiedFiles.push(filePath);
          }
        }
      }
    }

    // Check each modified file for console.log
    const violations = [];
    for (const filePath of modifiedFiles) {
      if (fs.existsSync(filePath)) {
        const content = fs.readFileSync(filePath, 'utf8');
        const lines = content.split('\n');
        lines.forEach((line, idx) => {
          if (/console\.log/.test(line) && !line.trim().startsWith('//')) {
            violations.push(`${filePath}:${idx + 1}`);
          }
        });
      }
    }

    if (violations.length > 0) {
      console.error('[Hook] ⚠️  console.log statements found:');
      violations.slice(0, 5).forEach(v => console.error(`   ${v}`));
      if (violations.length > 5) {
        console.error(`   ... and ${violations.length - 5} more`);
      }
      console.error('[Hook] Remove console.log before committing');
    }

    process.exit(0);
  } catch (error) {
    process.exit(0);
  }
});
