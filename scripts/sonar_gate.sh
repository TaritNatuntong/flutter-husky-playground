#!/bin/bash

# 1. ตั้งค่าตัวแปรสำหรับ Log
# สร้างโฟลเดอร์ logs ถ้ายังไม่มี
mkdir -p logs

# ตั้งชื่อไฟล์ log ตามวันเวลา (เช่น logs/sonar_20231025_120000.log)
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="logs/sonar_${TIMESTAMP}.log"

# ฟังก์ชันสำหรับเขียน Log (โชว์หน้าจอ + ลงไฟล์)
log_msg() {
    echo "[$(date +"%H:%M:%S")] $1" | tee -a "$LOG_FILE"
}

# ---------------------------------------------------------
# เริ่มการทำงาน
# ---------------------------------------------------------
log_msg "🚀 Starting SonarQube Analysis..."
log_msg "📝 Log file will be saved to: $LOG_FILE"

# 2. รัน Scanner
# - 2>&1 : รวม Error output เข้ากับ Standard output
# - tee -a : แสดงผลหน้าจอด้วย และเขียนลงไฟล์ด้วย
sonar-scanner \
  -Dsonar.login="sqp_86ab995cb815a2faee111644b7bc251bf05dd36e" \
  -Dsonar.qualitygate.wait=true \
  2>&1 | tee -a "$LOG_FILE"

# เก็บ Exit Code จากคำสั่ง sonar-scanner (ผ่าน pipe)
# Note: การใช้ pipe กับ tee จะทำให้ exit code เป็นของ tee (ซึ่งมักจะ 0)
# เราต้องใช้ ${PIPESTATUS[0]} เพื่อเอา exit code ของ sonar-scanner ตัวจริง
SCAN_EXIT_CODE=${PIPESTATUS[0]}

echo "" | tee -a "$LOG_FILE" # เว้นบรรทัด

# 3. ดึงข้อมูล Coverage จาก SonarQube API
echo "" | tee -a "$LOG_FILE"
log_msg "📊 Fetching Coverage Report..."

# ใช้ token จาก sonar-project.properties
COVERAGE_DATA=$(curl -s -u "sqp_c74bcb76413d2dd2dbd64bb2e3fd2465a1560f78:" \
  "http://localhost:9000/api/measures/component?component=flutter_husky_sonar&metricKeys=coverage,line_coverage,lines_to_cover,uncovered_lines")

# แสดงผล Coverage
if echo "$COVERAGE_DATA" | grep -q "coverage"; then
  COVERAGE=$(echo "$COVERAGE_DATA" | python3 -c "import sys, json; data = json.load(sys.stdin); measures = {m['metric']: m.get('value', 'N/A') for m in data['component'].get('measures', [])}; print(measures.get('coverage', 'N/A'))" 2>/dev/null)
  LINE_COVERAGE=$(echo "$COVERAGE_DATA" | python3 -c "import sys, json; data = json.load(sys.stdin); measures = {m['metric']: m.get('value', 'N/A') for m in data['component'].get('measures', [])}; print(measures.get('line_coverage', 'N/A'))" 2>/dev/null)
  LINES_TO_COVER=$(echo "$COVERAGE_DATA" | python3 -c "import sys, json; data = json.load(sys.stdin); measures = {m['metric']: m.get('value', 'N/A') for m in data['component'].get('measures', [])}; print(measures.get('lines_to_cover', 'N/A'))" 2>/dev/null)
  UNCOVERED=$(echo "$COVERAGE_DATA" | python3 -c "import sys, json; data = json.load(sys.stdin); measures = {m['metric']: m.get('value', 'N/A') for m in data['component'].get('measures', [])}; print(measures.get('uncovered_lines', 'N/A'))" 2>/dev/null)
  
  log_msg "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  log_msg "📈 Coverage Report:"
  log_msg "   Overall Coverage:    ${COVERAGE}%"
  log_msg "   Line Coverage:       ${LINE_COVERAGE}%"
  log_msg "   Lines to Cover:      ${LINES_TO_COVER}"
  log_msg "   Uncovered Lines:     ${UNCOVERED}"
  log_msg "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
else
  log_msg "⚠️  Coverage data not available yet"
fi

echo "" | tee -a "$LOG_FILE"

# 4. ตรวจสอบผลลัพธ์
if [ $SCAN_EXIT_CODE -eq 0 ]; then
  log_msg "✅ SonarQube Quality Gate PASSED!"
  exit 0
else
  log_msg "❌ SonarQube Quality Gate FAILED! (Exit code: $SCAN_EXIT_CODE)"
  log_msg "💡 Please check the full log at: $LOG_FILE"
  log_msg "🌐 Or check the report on SonarQube Server."
  exit 1
fi