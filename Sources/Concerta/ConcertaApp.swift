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
    static func make(preventsSystemSleep: Bool, keepsDisplayAwake: Bool) -> NSImage {
        let image = NSImage(size: NSSize(width: 18, height: 18))
        image.lockFocus()

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

        if preventsSystemSleep || keepsDisplayAwake {
            let fillFraction: CGFloat = 0.5
            let inset: CGFloat = 1.1
            let fillRect = NSRect(
                x: capsuleRect.minX + inset,
                y: capsuleRect.minY + inset,
                width: (capsuleRect.width - 2 * inset) * fillFraction,
                height: capsuleRect.height - 2 * inset
            )
            let fill = NSBezierPath(
                roundedRect: fillRect,
                xRadius: 2.5,
                yRadius: 2.5
            )
            fill.transform(using: transform)
            NSColor.black.setFill()
            fill.fill()
        }

        NSColor.black.setStroke()
        capsule.lineWidth = 1.35
        capsule.transform(using: transform)
        capsule.stroke()

        let seam = NSBezierPath()
        seam.move(to: NSPoint(x: 9, y: 5.5))
        seam.line(to: NSPoint(x: 9, y: 12.5))
        seam.lineWidth = 1.1
        seam.transform(using: transform)
        seam.stroke()

        image.unlockFocus()
        image.isTemplate = true
        return image
    }
}

private enum UptimeDisplay {
    static func string(for uptime: TimeInterval) -> String {
        let totalMinutes = max(Int(uptime / 60), 0)
        let days = totalMinutes / (24 * 60)
        let hours = (totalMinutes / 60) % 24
        let minutes = totalMinutes % 60

        if days > 0 {
            return "\(days)d \(hours)h"
        }
        if totalMinutes >= 60 {
            return "\(totalMinutes / 60)h \(minutes)m"
        }
        return "\(totalMinutes)m"
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
            TimelineView(.periodic(from: .now, by: 60)) { _ in
                let uptime = UptimeDisplay.string(for: ProcessInfo.processInfo.systemUptime)

                HStack(spacing: 5) {
                    Image(nsImage: PillStatusIcon.make(
                        preventsSystemSleep: caffeine.preventsSystemSleep,
                        keepsDisplayAwake: caffeine.keepsDisplayAwake
                    ))
                    Text(uptime)
                        .font(.system(size: 12, weight: .regular, design: .monospaced))
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Concerta. System uptime \(uptime)")
            }
        }
        .menuBarExtraStyle(.menu)
    }
}
