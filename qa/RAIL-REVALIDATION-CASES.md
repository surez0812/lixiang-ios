# Duo OpenLandscape rail 复验用例（阻塞解除后）

- 前次：`b6c6e33f` 包 hash 对，但真实 OpenLandscape 持续 loading，无 home.appear/firstContentFrame/LXRAIL frame → **NOT ACCEPTED**。
- 前置：修复包 + 真实 R14-Duo OpenLandscape；浅/深；不 Force；矩阵不改。

## A. 启动到可用 Home（硬门禁）
1. 真实 Open+rotate；记录 scene/geo/canvas/rail。
2. console 同 run 必须出现 `home.appear`、`firstContentFrame`、`LXRAIL frame=`；不得只有 content.ready/loading。
3. 截图必须显示真实 Home，不是「正在准备今日」。
4. 记录 process_start/prepare.done/content.ready/firstContentFrame；注记 instrumentation 非 compositor 呈现确认。
- 未满足以上 → **BLOCKED/NOT RUN**，不得进入 geometry 判定。

## B. rail 几何（逐屏原稿）
5. global frame：right23/w50/h252/top401（safe-area 折算后）；5 slot×48、tab44、icon25。
6. 与 `home-duo-open-landscape.html/png` 并排；偏移/尺寸/圆角/间距。
7. 5 tab 实际点击到达；浅/深；颜色/字号/材质。

## C. 内容避让
8. 每个 tab/route：内容不被 rail 遮挡；月历/黄历/列表/countdown 数字/详情正文可读；末项可点。
9. 滚动/点击后 rail 稳定；到达≠PASS。

## D. 记录
10. 每屏截图 + LXRAIL frame + 原稿对照；未达门禁保持 NOT RUN/BLOCKED。
11. compact 初始胶囊压卡边由 PM/设计决策；不与 rail 混写；不发布。
