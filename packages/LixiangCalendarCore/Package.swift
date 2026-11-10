// swift-tools-version: 6.0
// LixiangCalendarCore — 历象 / Lixiang Almanac 历法领域层（骨架）。
//
// 本包当前只有骨架占位，**不含产品逻辑**；实现等视觉方向/PRD 门禁通过后开工。
// 依赖策略：历法内核使用 6tail/lunar-swift 1.1.9（MIT），**只有本包 Engine/ 适配层可以 import**；
// App/UI 层不得直接依赖 LunarSwift（便于将来替换/自研）。
import PackageDescription

let package = Package(
    name: "LixiangCalendarCore",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "LixiangCalendarCore", targets: ["LixiangCalendarCore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/6tail/lunar-swift.git", exact: "1.1.9"),
    ],
    targets: [
        .target(
            name: "LixiangCalendarCore",
            dependencies: [
                .product(name: "LunarSwift", package: "lunar-swift"),
            ]
        ),
        .testTarget(
            name: "LixiangCalendarCoreTests",
            dependencies: ["LixiangCalendarCore"]
        ),
    ]
)
