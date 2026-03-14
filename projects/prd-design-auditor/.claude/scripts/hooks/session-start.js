/**
 * session-start.js
 *
 * Hook: SessionStart
 * Description: Load previous context and detect package manager on new session
 *
 * Triggers when: A new Claude Code session starts
 * Purpose: Initialize session state and detect project configuration
 */

const fs = require('fs');
const path = require('path');

// Detect package manager
function detectPackageManager(cwd) {
  const managers = [
    { name: 'pnpm', file: 'pnpm-lock.yaml' },
    { name: 'yarn', file: 'yarn.lock' },
    { name: 'bun', file: 'bun.lockb' },
    { name: 'npm', file: 'package-lock.json' }
  ];

  for (const manager of managers) {
    if (fs.existsSync(path.join(cwd, manager.file))) {
      return manager.name;
    }
  }
  return 'npm'; // default
}

// Main hook execution
try {
  const cwd = process.cwd();
  const packageManager = detectPackageManager(cwd);

  console.error(`[Hook] Session started in: ${cwd}`);
  console.error(`[Hook] Detected package manager: ${packageManager}`);

  // Could load previous session state here
  const stateFile = path.join(cwd, '.claude', 'session-state.json');
  if (fs.existsSync(stateFile)) {
    console.error('[Hook] Previous session state found');
  }
} catch (error) {
  // Silently fail - session start hooks shouldn't block the session
}
