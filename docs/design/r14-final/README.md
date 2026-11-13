# 历象 R14 审核包

打开index.html。首页双卡已追加自适应高度与横向内容对齐，见HOME-TOOLS-UPDATE.md。当前R14设备范围：普通iPhone仅竖屏；Tabletop共享Open Portrait的669×951竖屏。12种模式、188张PNG/HTML。

HTML由review_r14.py生成；PNG沿用未变的R13设计，Tabletop直接复用对应Open Portrait图，关系见R14-RENDER-PROVENANCE.json。模式/HTML同构/PNG一致性见R14-MODE-VALIDATION.json；日期与标题DOM回归另附R14记录。

当前规范与文案为R14-DESIGN-SPEC.md、R14-COVERAGE.md、R14-COPY.md。其他R13及更早文档/脚本是历史或生成依赖，不能将其中普通iPhone横屏内容视作当前设计。原R13目录保留历史。PNG为离线设计合成，非浏览器/模拟器截图；动画核心与build12未改。
