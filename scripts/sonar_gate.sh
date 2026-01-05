#!/bin/sh

echo "📡 Starting SonarQube Analysis..."
echo "⏳ This might take a while (uploading & waiting for report)..."

# รัน Scanner
# -Dsonar.login : ใส่ Token ของคุณ (ควรเก็บใน Environment Variable เพื่อความปลอดภัย)
# -Dsonar.qualitygate.wait=true : หัวใจสำคัญ! สั่งให้รอผล Pass/Fail

sonar-scanner \
  -Dsonar.login="YOUR_SONAR_TOKEN_HERE" \
  -Dsonar.qualitygate.wait=true

# เก็บค่าผลลัพธ์
exit_code=$?

if [ $exit_code -eq 0 ]; then
  echo "✅ SonarQube Quality Gate Passed!"
  exit 0
else
  echo "❌ SonarQube Quality Gate FAILED!"
  echo "Please check the report on the server to fix issues."
  exit 1
fi