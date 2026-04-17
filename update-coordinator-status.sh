#!/bin/bash

# WebGIS Platform - Coordinator Status Auto-Update Script
# Usage: ./update-coordinator-status.sh <ISSUE_NUM> <STATUS> [notes]
# Example: ./update-coordinator-status.sh 9 "done" "All AC completed"

set -e

ISSUE_NUM=$1
STATUS_INPUT=$2
NOTES=${3:-""}
COORDINATOR_FILE="COORDINATOR_STATUS.md"

# Validate inputs
if [ -z "$ISSUE_NUM" ] || [ -z "$STATUS_INPUT" ]; then
  echo "❌ Usage: ./update-coordinator-status.sh <ISSUE_NUM> <STATUS> [notes]"
  echo "   Example: ./update-coordinator-status.sh 9 'done' 'DRF configured, GeoDjango connected'"
  exit 1
fi

# Get latest commit info
COMMIT_HASH=$(git log -1 --pretty=format:"%h" 2>/dev/null || echo "unknown")
COMMIT_MSG=$(git log -1 --pretty=format:"%s" 2>/dev/null || echo "no commit")
CURRENT_DATE=$(date '+%Y-%m-%d %H:%M UTC')

# Normalize status input
case "${STATUS_INPUT,,}" in
  done|complete|✅)
    STATUS_EMOJI="✅"
    STATUS_TEXT="DONE"
    ;;
  progress|inprogress|working|🟡)
    STATUS_EMOJI="🟡"
    STATUS_TEXT="IN PROGRESS"
    ;;
  pending|ready|⏳)
    STATUS_EMOJI="⏳"
    STATUS_TEXT="PENDING"
    ;;
  *)
    echo "❌ Unknown status: $STATUS_INPUT"
    echo "   Use: done, progress, or pending"
    exit 1
    ;;
esac

# Check if file exists
if [ ! -f "$COORDINATOR_FILE" ]; then
  echo "❌ File not found: $COORDINATOR_FILE"
  exit 1
fi

# Update the file (simple sed replacement)
# Find the issue section and update status line

echo "📝 Updating Issue #$ISSUE_NUM..."
echo "   Status: $STATUS_EMOJI $STATUS_TEXT"
echo "   Commit: $COMMIT_HASH - $COMMIT_MSG"
echo "   Date: $CURRENT_DATE"

# Create backup
cp "$COORDINATOR_FILE" "${COORDINATOR_FILE}.backup.$(date +%s)"

# Update status line for the issue
sed -i "s/^#### Issue #${ISSUE_NUM}:.*/#### Issue #${ISSUE_NUM}: [AUTO-UPDATE $STATUS_TEXT]\n- **Status**: $STATUS_EMOJI $STATUS_TEXT (Commit: $COMMIT_HASH)\n- **Last Update**: $CURRENT_DATE\n- **Notes**: $NOTES/" "$COORDINATOR_FILE" 2>/dev/null || true

echo "✅ Updated Issue #$ISSUE_NUM in COORDINATOR_STATUS.md"
echo ""
echo "📋 Next steps:"
echo "   1. Verify changes in COORDINATOR_STATUS.md"
echo "   2. Commit: git add COORDINATOR_STATUS.md && git commit -m 'Update Issue #$ISSUE_NUM status'"
echo "   3. Push: git push"
