/**
 * evaluate-session.js
 *
 * Hook: SessionEnd
 * Description: Evaluate session for extractable patterns
 *
 * Triggers when: A Claude Code session ends
 * Purpose: Analyze session for reusable patterns and learning opportunities
 */

let data = '';

process.stdin.on('data', (chunk) => {
  data += chunk;
});

process.stdin.on('end', () => {
  try {
    const input = JSON.parse(data);

    console.error('[Hook] Evaluating session for patterns...');

    // Analyze the session for:
    // 1. Successful solutions to problems
    // 2. New code patterns used
    // 3. Commands that worked well
    // 4. Decisions made and their rationale

    // This is a placeholder for future pattern extraction
    // In a full implementation, this would:
    // - Parse the conversation transcript
    // - Identify successful problem-solving patterns
    // - Extract reusable code snippets
    // - Save to a skills database

    console.error('[Hook] Session evaluation complete');

    process.exit(0);
  } catch (error) {
    console.error('[Hook] Error evaluating session:', error.message);
    process.exit(0);
  }
});
