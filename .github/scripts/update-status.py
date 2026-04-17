#!/usr/bin/env python3
"""
Auto-update COORDINATOR_STATUS.md based on git commit info
Triggered by GitHub Actions workflow
"""

import sys
import re
from datetime import datetime

def update_coordinator_status(issue_num, status, commit_hash):
    """Update COORDINATOR_STATUS.md with new issue status"""
    
    file_path = "COORDINATOR_STATUS.md"
    
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
    except FileNotFoundError:
        print(f"Error: {file_path} not found")
        sys.exit(1)
    
    # Status mapping
    status_map = {
        'done': ('✅', 'DONE'),
        'progress': ('🟡', 'IN PROGRESS'),
        'pending': ('⏳', 'PENDING')
    }
    
    emoji, status_text = status_map.get(status, ('🟡', 'IN PROGRESS'))
    current_date = datetime.utcnow().strftime('%Y-%m-%d %H:%M UTC')
    
    # Find issue section
    pattern = rf"(#### Issue #{issue_num}:.*?\n- \*\*Status\*\*:.*?\n)"
    replacement = f"#### Issue #{issue_num}:\n- **Status**: {emoji} {status_text} (Commit: {commit_hash})\n- **Last Updated**: {current_date}\n"
    
    new_content = re.sub(pattern, replacement, content, flags=re.DOTALL)
    
    if new_content == content:
        print(f"⚠️ Could not find Issue #{issue_num} in COORDINATOR_STATUS.md")
        print("Patterns might need manual adjustment")
        return False
    
    # Write back
    try:
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(new_content)
        print(f"✅ Updated Issue #{issue_num}: {emoji} {status_text}")
        return True
    except Exception as e:
        print(f"Error writing file: {e}")
        return False

if __name__ == "__main__":
    if len(sys.argv) < 4:
        print("Usage: python update-status.py <ISSUE_NUM> <STATUS> <COMMIT_HASH>")
        sys.exit(1)
    
    issue_num = sys.argv[1]
    status = sys.argv[2].lower()
    commit_hash = sys.argv[3]
    
    success = update_coordinator_status(issue_num, status, commit_hash)
    sys.exit(0 if success else 1)
