import XCTest
@testable import BTerm

final class ThemeModeTests: XCTestCase {
    func testStoredValuesRemainStable() {
        XCTAssertEqual(ThemeMode.system.rawValue, "system")
        XCTAssertEqual(ThemeMode.light.rawValue, "light")
        XCTAssertEqual(ThemeMode.dark.rawValue, "dark")
    }

    func testSystemDoesNotForceAColorScheme() {
        XCTAssertNil(ThemeMode.system.preferredColorScheme)
    }
}
