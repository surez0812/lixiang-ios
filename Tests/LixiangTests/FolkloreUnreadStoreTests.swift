import XCTest
@testable import Lixiang
import LixiangCalendarCore

@MainActor
final class FolkloreUnreadStoreTests: XCTestCase {
    func testMarkReadPersistsByVersion() {
        let suite = UserDefaults(suiteName: "FolkloreUnreadTests-\(UUID().uuidString)")!
        defer { suite.removePersistentDomain(forName: suite.description) }
        let store = FolkloreUnreadStore(defaults: suite)
        let item = ContentFixtures.dongZhi
        XCTAssertFalse(store.isRead(item))
        store.markRead(item)
        XCTAssertTrue(store.isRead(item))
        // 版本升级后重新变未读
        var upgraded = item
        upgraded.version = item.version + 1
        XCTAssertFalse(store.isRead(upgraded))
        XCTAssertEqual(store.unreadCount([item, upgraded]), 1)
    }

    func testUnreadCount() {
        let suite = UserDefaults(suiteName: "FolkloreUnreadTests-\(UUID().uuidString)")!
        defer { suite.removePersistentDomain(forName: suite.description) }
        let store = FolkloreUnreadStore(defaults: suite)
        XCTAssertEqual(store.unreadCount(ContentFixtures.all), ContentFixtures.all.count)
        store.markRead(ContentFixtures.all[0])
        XCTAssertEqual(store.unreadCount(ContentFixtures.all), ContentFixtures.all.count - 1)
    }
}
