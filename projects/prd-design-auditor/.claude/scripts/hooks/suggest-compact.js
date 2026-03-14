/**
 * suggest-compact.js
 *
 * Hook: PreToolUse (Edit, Write)
 * Description: Suggest manual compaction at logical intervals
 *
 * Triggers when: Edit or Write tools are used
 * Purpose: Remind user to consider manual context compaction during long sessions
 */

let data = '';

process.stdin.on('data', (chunk) => {
  data += chunk;
});

process.stdin.on('end', () => {
  try {
    const input = JSON.parse(data);

    // Calculate rough context usage (this is a simplified check)
    const contextLength = JSON.stringify(input).length;

    // Suggest compaction at approximately 100K characters
    if (contextLength > 100000 && contextLength % 50000 < 5000) {
      console.error('[Hook] Consider running: /compact - Manual context compaction');
      console.error('[Hook] This preserves recent context while reducing token usage');
    }

    // Pass through the original data
    console.log(data);
  } catch (error) {
    // If parsing fails, just pass through
    console.log(data);
  }
});
