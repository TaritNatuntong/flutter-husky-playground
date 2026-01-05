// ignore_for_file: avoid_print

import 'dart:io';

void main(List<String> args) {
  // 1. อ่านไฟล์ข้อความที่ Git ส่งมาให้
  final file = File(args[0]);
  final commitMsg = file.readAsStringSync().trim();

  // 2. กำหนดกฎ (Regex): ต้องขึ้นต้นด้วยคำเหล่านี้ ตามด้วย : และเว้นวรรค
  // ตัวอย่างที่ผ่าน: "feat: add login", "fix: bug #12", "chore: cleanup"
  final regex = RegExp(
    r'^(feat|fix|docs|style|refactor|perf|test|chore|revert)(\(.+\))?: .+$',
  );

  // 3. ตรวจสอบ
  if (!regex.hasMatch(commitMsg)) {
    print('\n❌ ---------------------------------------------------');
    print('⛔ COMMIT MESSAGE REJECTED');
    print('---------------------------------------------------');
    print('Your commit message: "$commitMsg"');
    print('\n⚠️  Pattern required: <type>: <description>');
    print('✅ Example: "feat: add new login button"');
    print('✅ Example: "fix: crash on startup"');
    print('✅ Allowed types: feat, fix, docs, style, refactor, test, chore');
    print('---------------------------------------------------\n');

    exit(1); // ส่งค่า 1 เพื่อบอก Git ว่า "ห้าม Commit!"
  }
}
