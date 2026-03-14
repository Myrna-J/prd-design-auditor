/**
 * pre-compact.js
 *
 * Hook: PreCompact
 * Description: Save state before context compaction
 *
 * Triggers when: Context is about to be compacted
 * Purpose: Preserve important session state before compaction
 */

let data = '';

process.stdin.on('data', (chunk) => {
  data += chunk;
});

process.stdin.on('end', () => {
  try {
    const input = JSON.parse(data);

    // Log compaction event
    console.error('[Hook] Context compaction in progress...');
    console.error('[Hook] Recent context is being preserved');

    // In a full implementation, this could:
    // - Save current working directory
    // - Save recent file changes
    // - Save important variables or state
    // - Create a checkpoint file

    // Pass through the original data
    console.log(data);
  } catch (error) {
    console.log(data);
  }
});
