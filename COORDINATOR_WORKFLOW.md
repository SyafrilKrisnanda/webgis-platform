# 🎯 Panduan Lengkap: Workflow Coordinator Auto-Update

**Tujuan**: Setiap agent session untuk issue #9-#19 auto-update status di COORDINATOR_STATUS.md

---

## 📋 SETUP SATU KALI (Done Once)

### 1. Buat script executable

```bash
cd c:\Users\Synner\Desktop\Development\webgis-platform
chmod +x update-coordinator-status.sh
```

### 2. Verify script berfungsi

```bash
./update-coordinator-status.sh --help
# Atau coba dry-run:
./update-coordinator-status.sh 9 "progress" "Testing..."
```

---

## 🚀 WORKFLOW SETIAP ISSUE SESSION

### **Step 1: Buka Chat Baru untuk Issue (e.g., Issue #9)**

Copy-paste prompt ini sebagai context/system instruction:

```
╔══════════════════════════════════════════════════════════════════════════╗
║ 🎯 WEBGIS COORDINATOR SESSION - ISSUE #[N]                              ║
║ Auto-Update Mode: ON                                                      ║
╚══════════════════════════════════════════════════════════════════════════╝

SESSION CONTEXT:
- Issue #[N]: [ISSUE_TITLE]
- Assigned Agent: [AGENT_NAME]
- Status Target: COORDINATOR_STATUS.md
- Auto-update: Milestone-based (50% & 100%)

WORKFLOW:
1. Setiap saat AC selesai (50% atau lebih) → run update script
2. Setiap saat blocker terselesaikan → run update script
3. Saat issue 100% done → run final update + commit

UPDATE COMMAND (run di terminal saat progress):
  ./update-coordinator-status.sh 9 "progress" "✓ AC1, ✓ AC2, 🟨 AC3 (80%)"
  ./update-coordinator-status.sh 9 "done" "All AC completed, ready for #10"

GIT COMMIT SETELAH UPDATE:
  git add .
  git commit -m "Progress Issue #9: [description of what done]"
  git push

STATUS REFERENCE:
- ✅ DONE = 100% AC complete
- 🟡 PROGRESS = 50%+ AC done
- ⏳ PENDING = Not started / blocked

Need help? Ask me to run the update or check status.
```

---

### **Step 2: Saat Milestone (50% AC Done)**

Di terminal **dalam workspace**:

```bash
cd c:\Users\Synner\Desktop\Development\webgis-platform

# Jalankan update script dengan status progress
./update-coordinator-status.sh 9 "progress" "DRF installed, health endpoint done, ⏳ GeoDjango config"

# Commit ke git
git add COORDINATOR_STATUS.md
git commit -m "Progress Issue #9: 50% AC done - DRF & health endpoint working"
git push
```

**Expected output:**

```
📝 Updating Issue #9...
   Status: 🟡 IN PROGRESS
   Commit: abc1234 - [latest commit message]
   Date: 2026-04-18 10:30 UTC
✅ Updated Issue #9 in COORDINATOR_STATUS.md

📋 Next steps:
   1. ✅ Already updated COORDINATOR_STATUS.md
   2. Commit: git add COORDINATOR_STATUS.md && git commit -m 'Update Issue #9 status'
   3. Push: git push
```

---

### **Step 3: Saat Completion (100% AC Done)**

```bash
cd c:\Users\Synner\Desktop\Development\webgis-platform

# Jalankan update script dengan status done
./update-coordinator-status.sh 9 "done" "All 5 AC completed - DRF, GeoDjango, health endpoint, CORS, migrations"

# Commit ke git
git add COORDINATOR_STATUS.md
git commit -m "Complete Issue #9: Bootstrap Django, DRF, GeoDjango ✅"
git push
```

---

### **Step 4: Check Status (Optional)**

Lihat COORDINATOR_STATUS.md untuk verify update:

```bash
# View recent updates
grep -A 5 "### Issue #9:" COORDINATOR_STATUS.md
```

Or open file: `COORDINATOR_STATUS.md`

---

## 📊 COMMAND REFERENCE

### Update Status Progress

```bash
./update-coordinator-status.sh 9 "progress" "✓ AC1, 🟨 AC2 (75%)"
./update-coordinator-status.sh 10 "progress" "Working on auth endpoints"
```

### Mark as Done

```bash
./update-coordinator-status.sh 9 "done" "All acceptance criteria met"
./update-coordinator-status.sh 12 "done" "Upload parser tested with GeoJSON & KML"
```

### Mark as Pending (if blocked)

```bash
./update-coordinator-status.sh 11 "pending" "Awaiting Issue #9 completion"
```

---

## 🔄 FULL WORKFLOW EXAMPLE (Issue #9)

**Day 1 - Morning (Start)**

```bash
# Start work on Issue #9
# ... code code code ...

# Midday - 50% done
./update-coordinator-status.sh 9 "progress" "DRF configured, health endpoint working, ⏳ GeoDjango setup"
git add COORDINATOR_STATUS.md
git commit -m "Progress Issue #9: DRF configured & health endpoint ready"
git push
```

**Day 2 - Afternoon (Done)**

```bash
# Finish Issue #9
# ... more coding ...

# Final - 100% done
./update-coordinator-status.sh 9 "done" "All 5 AC complete - ready for #11 dependency"
git add COORDINATOR_STATUS.md
git commit -m "Complete Issue #9: Backend bootstrap ready ✅"
git push

# Check status
grep -A 10 "### Issue #9:" COORDINATOR_STATUS.md
```

**Coordinator Updates Project View:**

```
# Coordinator auto-detects via COORDINATOR_STATUS.md
- Issue #9 ✅ DONE → triggers Batch 2 assignment (#11)
- Next: Assign #11 to architect
```

---

## ⚠️ TROUBLESHOOTING

### Script not found

```bash
# Check location
ls -la update-coordinator-status.sh

# Make executable
chmod +x update-coordinator-status.sh
```

### File not updating

```bash
# Check file exists
ls -la COORDINATOR_STATUS.md

# Manual check - view the file
cat COORDINATOR_STATUS.md | grep "Issue #9"
```

### Git push fails

```bash
# Check git config
git config user.name
git config user.email

# Or just focus on file update, push later
```

---

## 📝 COORDINATOR CHECKLIST (When receiving update)

When coordinator sees update in COORDINATOR_STATUS.md:

- [ ] Verify commit hash is recent
- [ ] Check if dependencies are now unblocked
- [ ] Assign next batch if ready
- [ ] Update milestone tracking
- [ ] Report progress to team

---

## 🎬 QUICK START (Copy-Paste Ready)

**For Issue #9 Start:**

```bash
cd c:\Users\Synner\Desktop\Development\webgis-platform

# Saat 50% done:
./update-coordinator-status.sh 9 "progress" "DRF & health endpoint working"
git add COORDINATOR_STATUS.md && git commit -m "Progress #9: 50% done" && git push

# Saat selesai:
./update-coordinator-status.sh 9 "done" "All AC complete"
git add COORDINATOR_STATUS.md && git commit -m "Complete #9: Bootstrap Django ✅" && git push
```

---

**Status**: Ready to use! Coordinator akan track via COORDINATOR_STATUS.md setiap update. 🚀
