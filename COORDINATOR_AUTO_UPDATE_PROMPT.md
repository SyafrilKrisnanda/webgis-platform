<!--
AUTO-UPDATE COORDINATOR STATUS PROMPT TEMPLATE
Gunakan prompt ini di AWAL setiap session untuk issue #9-#19
Copy ke chat sebagai system instruction atau di awal conversation
-->

# 🤖 Coordinator Auto-Update Protocol

**Instruksi untuk setiap Agent Session (Issue #9-#19):**

---

## Protokol Update Otomatis

### **DI AWAL Session:**

Tampilkan ini ke user:

```
🎯 Session Issue: [ISSUE_NUMBER] - [ISSUE_TITLE]
📊 Assigned Agent: [AGENT_NAME]
📝 Update Target: COORDINATOR_STATUS.md
⏱️ Auto-update: ON (setiap milestone)
```

### **SETIAP MILESTONE** (bukan hanya di akhir):

1. Setelah AC selesai (partial atau full)
2. Setelah major blocker terselesaikan
3. Setelah commit ke git

**Jalankan perintah ini di terminal:**

```bash
cd /path/to/webgis-platform
# (1) Get current issue status
CURRENT_AC=$(git log --oneline -1 | head -20)

# (2) Generate update snippet
echo "📝 Updating COORDINATOR_STATUS.md..."

# (3) Update file (manual atau script)
# ... actual update di file sesuai progress
```

### **FORMAT UPDATE ke COORDINATOR_STATUS.md:**

Untuk issue yang baru selesai satu AC:

```markdown
### Issue #[N]: [Title]

- **Status**: 🟡 IN PROGRESS (5/7 AC done)
- **Completed AC**:
  - ✓ AC 1
  - ✓ AC 2
  - ✓ AC 5
- **In Progress**:
  - 🟨 AC 3 (80% done)
- **Pending**:
  - ⏳ AC 4, AC 6, AC 7
- **Last Commit**: [hash] - [message]
- **Blockers**: None / [description]
- **Next Unblock**: #[X] ready
- **Est. Completion**: [date]
```

Untuk issue yang fully complete:

```markdown
### Issue #[N]: [Title]

- **Status**: ✅ DONE (Commit: [hash])
- **Completed**:
  - ✓ [AC 1]
  - ✓ [AC 2]
  - ✓ [AC 3]
  - ✓ [AC 4]
  - ✓ [AC 5]
  - ✓ [AC 6]
  - ✓ [AC 7]
- **Blockers**: None
- **Next Unblock**: #[X], #[Y] ready
- **Completed**: [date]
```

### **TIMING:**

- ⏱️ Update minimal di **halfway point** (50% AC done)
- ⏱️ Update final di **completion** (100% AC done)
- ⏱️ Update urgent saat **blocker terselesaikan**

---

## Prompt untuk Agent Session

**Copy & Paste ke setiap issue chat:**

```
Kamu sekarang bekerja di Issue #[N]: [TITLE]

Setiap saat ada progress:
1. Di 50% AC selesai → update COORDINATOR_STATUS.md (status 🟡 IN PROGRESS)
2. Di 100% selesai → update COORDINATOR_STATUS.md (status ✅ DONE)
3. Ada blocker → update COORDINATOR_STATUS.md (catat di section Blockers)

Update format:
- Edit file: c:\\Users\\Synner\\Desktop\\Development\\webgis-platform\\COORDINATOR_STATUS.md
- Section mana: Cari "### Issue #[N]:" terus update status + AC checklist
- Format: Lihat COORDINATOR_AUTO_UPDATE_PROMPT.md di root

Jangan forget:
- Commit ke git setelah milestone
- Update dengan commit hash terbaru
- Catat tanggal completion
```

---

## Alternatif: Bash Script Auto-Update

Jika mau super otomatis, buat script `update-status.sh`:

```bash
#!/bin/bash
# Usage: ./update-status.sh 9 "✅ DONE" "DRF configured, GeoDjango connected, Health endpoint working"

ISSUE_NUM=$1
STATUS=$2
NOTES=$3
COMMIT=$(git log -1 --oneline)

# Update COORDINATOR_STATUS.md (automated)
# Find issue section, replace status and notes
sed -i "s/### Issue #${ISSUE_NUM}:.*/### Issue #${ISSUE_NUM}: [AUTO-UPDATE]\n- **Status**: ${STATUS} (${COMMIT})\n- **Notes**: ${NOTES}/" COORDINATOR_STATUS.md

echo "✅ Updated Issue #${ISSUE_NUM} in COORDINATOR_STATUS.md"
```

Usage:

```bash
./update-status.sh 9 "🟡 IN PROGRESS" "DRF configured, waiting on GeoDjango"
./update-status.sh 9 "✅ DONE" "All AC completed, ready for #11"
```

---

## Summary

| Method              | Effort | Reliability | Recommended For             |
| ------------------- | ------ | ----------- | --------------------------- |
| **Manual update**   | Low    | High        | Small team, clear hand-offs |
| **Prompt template** | Low    | High        | Default option              |
| **Bash script**     | Medium | Very High   | Automation-focused team     |

**Recommend**: Gunakan **prompt template** di setiap session chat, minimal update di milestone 50% dan 100%.
