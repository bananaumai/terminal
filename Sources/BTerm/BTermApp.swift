import SwiftUI

@main
struct BTermApp: App {
    @AppStorage("themeMode") private var storedThemeMode = ThemeMode.system.rawValue

    private var themeMode: ThemeMode {
        ThemeMode(rawValue: storedThemeMode) ?? .system
    }

    var body: some Scene {
        WindowGroup {
            TerminalRoot(themeMode: themeMode)
                .frame(minWidth: 640, minHeight: 400)
        }
        .defaultSize(width: 900, height: 580)
        .commands {
            ThemeCommands()
        }

        Settings {
            SettingsView()
                .frame(width: 360)
                .padding(24)
        }
    }
}

private struct TerminalRoot: View {
    @Environment(\.colorScheme) private var systemColorScheme
    let themeMode: ThemeMode

    var body: some View {
        TerminalScreen(colorScheme: themeMode.resolve(systemColorScheme: systemColorScheme))
    }
}

private struct ThemeCommands: Commands {
    @AppStorage("themeMode") private var storedThemeMode = ThemeMode.system.rawValue

    var body: some Commands {
        CommandMenu("Theme") {
            Picker("Theme", selection: $storedThemeMode) {
                ForEach(ThemeMode.allCases) { mode in
                    Text(mode.label).tag(mode.rawValue)
                }
            }
            .pickerStyle(.inline)
        }
    }
}

private struct SettingsView: View {
    @AppStorage("themeMode") private var storedThemeMode = ThemeMode.system.rawValue

    var body: some View {
        Form {
            Picker("Theme", selection: $storedThemeMode) {
                ForEach(ThemeMode.allCases) { mode in
                    Text(mode.label).tag(mode.rawValue)
                }
            }

            Text("Auto follows the macOS appearance. Set macOS Appearance to Auto to switch with day and night.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
