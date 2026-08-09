import AppKit
@preconcurrency import SwiftTerm
import SwiftUI

struct TerminalScreen: NSViewRepresentable {
    let colorScheme: ColorScheme

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeNSView(context: Context) -> LocalProcessTerminalView {
        let terminal = LocalProcessTerminalView(frame: .zero)
        terminal.processDelegate = context.coordinator
        terminal.autoresizingMask = [.width, .height]
        terminal.font = NSFont.monospacedSystemFont(ofSize: 13, weight: .regular)
        terminal.caretColor = .systemBlue
        terminal.getTerminal().setCursorStyle(.steadyBlock)
        terminal.linkReporting = .implicit

        context.coordinator.terminal = terminal
        context.coordinator.apply(colorScheme: colorScheme)

        let shell = Self.loginShell()
        terminal.startProcess(
            executable: shell,
            execName: "-" + URL(fileURLWithPath: shell).lastPathComponent,
            currentDirectory: FileManager.default.homeDirectoryForCurrentUser.path
        )

        DispatchQueue.main.async {
            terminal.window?.makeFirstResponder(terminal)
        }
        return terminal
    }

    func updateNSView(_ terminal: LocalProcessTerminalView, context: Context) {
        context.coordinator.apply(colorScheme: colorScheme)
    }

    static func dismantleNSView(_ terminal: LocalProcessTerminalView, coordinator: Coordinator) {
        terminal.processDelegate = nil
        terminal.terminate()
        coordinator.terminal = nil
    }

    private static func loginShell() -> String {
        let candidate = ProcessInfo.processInfo.environment["SHELL"] ?? "/bin/zsh"
        return FileManager.default.isExecutableFile(atPath: candidate) ? candidate : "/bin/zsh"
    }

    @MainActor
    final class Coordinator: NSObject, LocalProcessTerminalViewDelegate {
        weak var terminal: LocalProcessTerminalView?
        private var appliedColorScheme: ColorScheme?

        func apply(colorScheme: ColorScheme) {
            guard appliedColorScheme != colorScheme, let terminal else { return }
            appliedColorScheme = colorScheme

            switch colorScheme {
            case .light:
                terminal.nativeForegroundColor = NSColor(srgbRed: 0.10, green: 0.11, blue: 0.12, alpha: 1)
                terminal.nativeBackgroundColor = NSColor(srgbRed: 0.97, green: 0.97, blue: 0.96, alpha: 1)
                terminal.caretColor = .systemBlue
            case .dark:
                terminal.nativeForegroundColor = NSColor(srgbRed: 0.90, green: 0.91, blue: 0.92, alpha: 1)
                terminal.nativeBackgroundColor = NSColor(srgbRed: 0.07, green: 0.08, blue: 0.09, alpha: 1)
                terminal.caretColor = .systemCyan
            @unknown default:
                break
            }

            terminal.layer?.backgroundColor = terminal.nativeBackgroundColor.cgColor
            terminal.needsDisplay = true
        }

        nonisolated func sizeChanged(source: LocalProcessTerminalView, newCols: Int, newRows: Int) {}

        nonisolated func setTerminalTitle(source: LocalProcessTerminalView, title: String) {
            DispatchQueue.main.async {
                source.window?.title = title.isEmpty ? "tm" : title
            }
        }

        nonisolated func hostCurrentDirectoryUpdate(source: TerminalView, directory: String?) {}

        nonisolated func processTerminated(source: TerminalView, exitCode: Int32?) {
            DispatchQueue.main.async {
                source.window?.close()
            }
        }
    }
}
