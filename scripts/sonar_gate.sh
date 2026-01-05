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

# 3. ตรวจสอบผลลัพธ์
if [ $SCAN_EXIT_CODE -eq 0 ]; then
  log_msg "✅ SonarQube Quality Gate PASSED!"
  exit 0
else
  log_msg "❌ SonarQube Quality Gate FAILED! (Exit code: $SCAN_EXIT_CODE)"
  log_msg "💡 Please check the full log at: $LOG_FILE"
  log_msg "🌐 Or check the report on SonarQube Server."
  exit 1
fi