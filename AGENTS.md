# Lixiang project working instructions

## Mandatory Lixiang UI design verification

User instruction,2026-11-14: Every Lixiang UI test/review must first read and execute the persistent skill **逐屏设计对照验收 / verify-ui-against-design**,ID `6af80b4391e88191b93cabdefa56ec42`, including `references/lixiang.md`.

Skill package: `c25/6af80b4391e88191b93cabdefa56ec42/verify-ui-against-design`; canonical resource `skill://user/6af80b4391e88191b93cabdefa56ec42/verify-ui-against-design/SKILL.md`. If unavailable, record the unavailable source, seek the current copy, and continue only checks supported by explicit user rules; never claim the skill was read or UI PASS without evidence.

For every device×pose×page×state, locate and actually view the matching final original, then compare implementation screenshots for layout/navigation/dimensions/fonts/colors/assets/interactions. Record immutable implementation commit/tar/executable hashes, design source/version/hash, actual screenshot and missing evidence. No matching original or actual screenshot means no UI PASS. Separate SOURCE_REVIEW,TEAM_EVIDENCE_REVIEW,INDEPENDENT_RUNTIME and distinguish reachability, UI, functional and performance conclusions.

Design lookup entry: docs/r14-design-handoff-20261113 at aa370f894a11dc7a4280089fdcda51dc1b78c96b in surez0812/lixiang-ios; local final source commonly /Users/surezhang/work/ZhaoYao/work/lixiang-design-handoff-20261113/docs/design/r14-final. These paths do not themselves prove a screen was read; user later corrections take precedence and must be cited in the report.

Duo Open Landscape: all5Tab buttons in right sidebar, no bottom TabBar; verify selection, touch interaction and content avoidance. Tabletop: independently observe PartiallyOpen+rotation, use OpenPortrait design. Tent: equivalent to ClosedLandscape by user agreement, label reuse and not independently tested. ClosedLandscape failure on old package: preserve evidence and move to other screens; only targeted retest after a fix. Preserve user/device data. User allows direct tests: quick actual-conflict check, no invented exclusive-window approval gate. content.ready log is not a rendered frame or proof Home visible.

Use existing authorized local bridge for reports/ACKs; do not overwrite old evidence or update188matrix without protocol authorization. No new publish/submit/merge or permission authority is created by this instruction.
