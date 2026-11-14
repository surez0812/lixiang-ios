# hero 剩余验收用例（phone/iPad 16:9、fallback、EN）

- 前置：新 immutable 包 + SHA/commit；真实设备窗口；不改 188 矩阵/内容。
- 当前 12 hero pending；本用例只补 Codex OPEN 项。

## A. 16:9 自适应容器（phone/iPad）
1. 明确定义：源图 16:9；详情容器应 `.aspectRatio(16/9, contentMode:.fill)` 或等价宽度驱动高度；固定220pt 是否接受由 PM/设计确认。
2. iPhone portrait：测量 hero 容器宽高比≈16:9；无上下/左右异常裁切；文字从 hero 下方正常开始。
3. iPad portrait/landscape：同页宽高比；无拉伸/压扁；大图不溢出。
4. 12 条至少抽查 dongzhi/qingming/yulanpen/chongyang + 1 长标题；记录容器 frame/截图。
5. 不接受“1024×576源图”替代跨设备渲染证据。

## B. missing-hero fallback
6. DEBUG 注入缺失 content id（不改 production 内容）；详情应显示 `winter` 图，非空白/破图/错 alt。
7. fallback alt =「岁时插画」；VoiceOver 读法合理。
8. 其它 11 id 不受影响；缓存不清空/不串图。
9. 截图 + 注入方式/包身份；无设备窗口则 NOT RUN。

## C. EN locale / VoiceOver
10. 若 App 仅有中文 UI locale：记录 **NOT RUN/不支持**，不得用 alt 元数据有 EN 当运行时通过。
11. 若支持 EN：切 locale，详情 hero alt/VoiceOver 读英文；与 zh/en mapping 一致。
12. 记录实际 locale/设置；不伪造。

## 证据
- 每项设备/尺寸/容器 frame/截图/包 SHA；fallback fixture；EN locale 日志。
- 内容行 85-90/163/174 仍 NOT RUN；矩阵不改；不发布。

## D. known-ID fallback label（新增 OPEN）
- 场景：已知 content id 的图片缺失/解码失败，或 DEBUG `-LixiangForceMissingHero`。
- 预期：画面 winter fallback **且** accessibilityLabel 同步改为中性 fallback（如“岁时插画”），不得仍播报该 id 原 alt。
- 步骤：forceMissing 打开 chongyang/qingming 详情；VoiceOver/accessibility tree 检查 label；确认画面 winter、label 非“菊花/垂柳”等原 alt。
- unknown id 仍用通用“岁时插画”；其它 id 不受影响；记录截图+label/日志。
- 当前 OPEN，等 dev 修复新包；内容行 NOT RUN；矩阵不改。
