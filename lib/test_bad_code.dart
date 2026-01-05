// // lib/test_bad_code.dart

// // 1. Code Smell: Function ยาวและซับซ้อนเกินไป (Cognitive Complexity)
// void complexFunction(int number) {
//   // Code Smell: Unused variable (ประกาศแล้วไม่ใช้)

//   if (number > 0) {
//     if (number % 2 == 0) {
//       if (number > 10) {
//         if (number < 100) {
//           print("Number is complex"); // Code Smell: ใช้ print แทน logger
//         } else {
//           for (var i = 0; i < 10; i++) {
//             if (i == 5) {
//               break;
//             }
//           }
//         }
//       }
//     } else {
//       // Code Smell: Empty block (if ว่างเปล่า)
//     }
//   }
// }

// // 2. Duplication: ก๊อปฟังก์ชันข้างบนมาวางทั้งดุ้น (SonarQube เกลียดสิ่งนี้มาก)
// void complexFunctionDuplicate(int number) {
//   if (number > 0) {
//     if (number % 2 == 0) {
//       if (number > 10) {
//         if (number < 100) {
//           print("Number is complex");
//         } else {
//           for (var i = 0; i < 10; i++) {
//             if (i == 5) {
//               break;
//             }
//           }
//         }
//       }
//     } else {}
//   }
// }

// // 3. Duplication: ก๊อปอีกรอบเพื่อความชัวร์ (เพื่อให้ % Duplication พุ่ง)
// void complexFunctionDuplicate2(int number) {
//   if (number > 0) {
//     if (number % 2 == 0) {
//       if (number > 10) {
//         if (number < 100) {
//           print("Number is complex");
//         } else {
//           for (var i = 0; i < 10; i++) {
//             if (i == 5) {
//               break;
//             }
//           }
//         }
//       }
//     } else {}
//   }
// }
