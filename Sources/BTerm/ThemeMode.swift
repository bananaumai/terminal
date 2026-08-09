import SwiftUI

enum ThemeMode: String, CaseIterable, Identifiable {
    case system
    case light
    case dark

    var id: Self { self }

    var label: String {
        switch self {
        case .system: "Auto"
        case .light: "Light"
        case .dark: "Dark"
        }
    }

    func resolve(systemColorScheme: ColorScheme) -> ColorScheme {
        switch self {
        case .system: systemColorScheme
        case .light: .light
        case .dark: .dark
        }
    }
}
