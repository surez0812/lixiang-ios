# 源码交付 bundle preverify（83b4fa98）

- bundle：`P1/Lixiang-R14-source-83b4fa98.bundle`
- SHA256 `e68a07638330aeb62ab77a801481b1ac452d68c70ff15b7840b7bba6c014ad9a`
- HEAD `83b4fa981cda87770bd9a19b86254fd6bd2e85b7`
- QA 执行 `git bundle verify`：**okay**；完整历史；sha1。
- 仅 HEAD ref；不含额外分支引用（`git bundle list-heads` 只列 HEAD）。
- 用途：Codex/交付方 `git fetch` 审阅；不 push/不 merge。
- 矩阵不变 100/33/55；不代表代码验收。
