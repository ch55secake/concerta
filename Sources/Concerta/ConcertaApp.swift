import AppKit
import SwiftUI

@MainActor
final class CaffeineController: ObservableObject {
    static let shared = CaffeineController()

    @Published var preventsSystemSleep = false {
        didSet { updateCaffeinate() }
    }

    @Published var keepsDisplayAwake = false {
        didSet { updateCaffeinate() }
    }

    @Published private(set) var errorMessage: String?

    private var process: Process?

    var isActive: Bool {
        preventsSystemSleep || keepsDisplayAwake
    }

    func stop() {
        if let process, process.isRunning {
            process.terminate()
        }
        process = nil
    }

    private func updateCaffeinate() {
        stop()
        errorMessage = nil

        var arguments: [String] = []
        if preventsSystemSleep {
            arguments.append("-i")
        }
        if keepsDisplayAwake {
            arguments.append("-d")
        }
        guard !arguments.isEmpty else { return }

        let caffeinate = Process()
        caffeinate.executableURL = URL(fileURLWithPath: "/usr/bin/caffeinate")
        caffeinate.arguments = arguments

        do {
            try caffeinate.run()
            process = caffeinate
        } catch {
            errorMessage = "Couldn’t start caffeinate: \(error.localizedDescription)"
        }
    }
}

private enum PillStatusIcon {
    static func make(active: Bool) -> NSImage {
        let image = NSImage(size: NSSize(width: 18, height: 18))
        image.lockFocus()

        NSColor.black.setStroke()

        var transform = AffineTransform()
        transform.translate(x: 9, y: 9)
        transform.rotate(byDegrees: 45)
        transform.translate(x: -9, y: -9)

        let capsuleRect = NSRect(x: 3.3, y: 5.4, width: 11.4, height: 7.2)
        let capsule = NSBezierPath(
            roundedRect: capsuleRect,
            xRadius: 3.6,
            yRadius: 3.6
        )
        capsule.lineWidth = 1.35
        capsule.transform(using: transform)
        capsule.stroke()

        let seam = NSBezierPath()
        seam.move(to: NSPoint(x: 9, y: 5.5))
        seam.line(to: NSPoint(x: 9, y: 12.5))
        seam.lineWidth = 1.1
        seam.transform(using: transform)
        seam.stroke()

        if active {
            let sparkle = NSBezierPath()
            sparkle.move(to: NSPoint(x: 14.5, y: 13.2))
            sparkle.line(to: NSPoint(x: 14.5, y: 16.2))
            sparkle.move(to: NSPoint(x: 13, y: 14.7))
            sparkle.line(to: NSPoint(x: 16, y: 14.7))
            sparkle.lineWidth = 1.2
            sparkle.lineCapStyle = .round
            sparkle.stroke()
        }

        image.unlockFocus()
        image.isTemplate = true
        return image
    }
}

@MainActor
final class ConcertaAppDelegate: NSObject, NSApplicationDelegate {
    func applicationWillTerminate(_ notification: Notification) {
        CaffeineController.shared.stop()
    }
}

@main
struct ConcertaApp: App {
    @NSApplicationDelegateAdaptor(ConcertaAppDelegate.self)
    private var appDelegate

    @StateObject private var caffeine = CaffeineController.shared

    var body: some Scene {
        MenuBarExtra {
            Toggle(isOn: $caffeine.preventsSystemSleep) {
                Label("Keep Mac awake", systemImage: "moon.zzz")
            }

            Toggle(isOn: $caffeine.keepsDisplayAwake) {
                Label("Keep display awake", systemImage: "sun.max")
            }

            if let errorMessage = caffeine.errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.secondary)
            }

            Divider()

            Button("Quit Concerta") {
                NSApplication.shared.terminate(nil)
            }
        } label: {
            Image(nsImage: PillStatusIcon.make(active: caffeine.isActive))
                .accessibilityLabel("Concerta")
        }
        .menuBarExtraStyle(.menu)
    }
}
