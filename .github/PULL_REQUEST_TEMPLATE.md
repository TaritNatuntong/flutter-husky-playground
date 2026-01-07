# 🎯 Summary
# 🔗 Related Issue
# 📱 UI Changes (Flutter Specific)
| Before | After |
|--------|-------|
| | |


# 🛠 Implementation Details
# ✅ Self-Review Checklist
Please check the following before asking for a review:

## General
- [ ] My code follows the style guidelines of this project (Linter passed).
- [ ] I have commented my code, particularly in hard-to-understand areas.
- [ ] I have performed a self-review of my own code.

## Flutter & State Management
- [ ] **Context Safety:** Checked `context.mounted` before using BuildContext across async gaps.
- [ ] **Rebuilds:** Minimized unnecessary widget rebuilds (used `const`, extracted widgets).
- [ ] **Dispose:** Controllers and Listeners are properly disposed.

## 🛡️ Logic & Edge Cases (Important!)
- [ ] **Math Safety:** Checked for negative values, division by zero, or overflows (e.g., HP < 0, Money < 0).
- [ ] **Null Safety:** Handled `null` values gracefully (no forced `!` operators unless 100% sure).
- [ ] **Race Conditions:** Prevented double-clicks on buttons or duplicate API calls.

## 🧪 Testing
- [ ] I have added tests that prove my fix is effective or that my feature works.
- [ ] **Boundary Testing:** I have tested edge cases (e.g., input = 0, input = negative, empty list).