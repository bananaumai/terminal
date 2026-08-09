import XCTest
@testable import BTerm

final class ThemeModeTests: XCTestCase {
    func testStoredValuesRemainStable() {
        XCTAssertEqual(ThemeMode.system.rawValue, "system")
        XCTAssertEqual(ThemeMode.light.rawValue, "light")
        XCTAssertEqual(ThemeMode.dark.rawValue, "dark")
    }

    func testAutoAlwaysResolvesFromCurrentSystemAppearance() {
        XCTAssertEqual(ThemeMode.system.resolve(systemColorScheme: .dark), .dark)
        XCTAssertEqual(ThemeMode.system.resolve(systemColorScheme: .light), .light)
    }

    func testReturningFromDarkToAutoRestoresSystemLightAppearance() {
        XCTAssertEqual(ThemeMode.dark.resolve(systemColorScheme: .light), .dark)
        XCTAssertEqual(ThemeMode.system.resolve(systemColorScheme: .light), .light)
    }
}
