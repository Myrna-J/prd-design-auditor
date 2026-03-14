/**
 * session-end.js
 *
 * Hook: SessionEnd
 * Description: Persist session state on end
 *
 * Triggers when: A Claude Code session ends
 * Purpose: Save important session state for recovery
 */

const fs = require('fs');
const path = require('path');

let data = '';

process.stdin.on('data', (chunk) => {
  data += chunk;
});

process.stdin.on('end', () => {
  try {
    const input = JSON.parse(data);

    console.error('[Hook] Session ending - saving state...');

    // Collect session state
    const state = {
      endedAt: new Date().toISOString(),
      workingDirectory: process.cwd(),
      // Add more state as needed
    };

    // Save state file (if .claude directory exists)
    const stateDir = path.join(process.cwd(), '.claude');
    const stateFile = path.join(stateDir, 'session-state.json');

    if (fs.existsSync(stateDir)) {
      fs.writeFileSync(stateFile, JSON.stringify(state, null, 2));
      console.error('[Hook] Session state saved to: session-state.json');
    }

    process.exit(0);
  } catch (error) {
    console.error('[Hook] Error saving session state:', error.message);
    process.exit(0);
  }
});
