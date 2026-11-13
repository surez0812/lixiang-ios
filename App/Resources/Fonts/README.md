# Noto Serif SC（R14 内置衬线）

- 来源：Noto CJK（https://github.com/notofonts/noto-cjk）Simplified Chinese Serif OTF
- 文件：`NotoSerifSC-Regular.otf`（PostScript `NotoSerifCJKsc-Regular`）、`NotoSerifSC-Bold.otf`（`NotoSerifCJKsc-Bold`）
- 许可：SIL Open Font License 1.1；**无 Reserved Font Name（RFN）声明**（字体 name 表无 RFN，版权为 Adobe 2017–2024）；许可证全文见同目录 `OFL.txt`，版权/许可署名保留
- 处理：用 `fontTools.subset` 子集化（GB2312 全字符 + App 内 UI/经文/宜忌全部字符，共 7145 字符 + Latin/标点），保留原 PostScript 名与 name 表版权/OFL 字段
- 用途：`D1Typography.serifFont` 优先使用；缺失时回退系统 serif
