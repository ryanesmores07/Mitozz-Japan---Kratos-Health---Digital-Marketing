import AppKit
import Foundation

struct OverlaySpec: Decodable {
    let width: Int
    let height: Int
    let output: String
    let lines: [String]
    let bubbleX: CGFloat
    let bubbleY: CGFloat
    let bubbleWidth: CGFloat
    let bubbleHeight: CGFloat
    let fontSize: CGFloat
}

func makeParagraphStyle() -> NSMutableParagraphStyle {
    let style = NSMutableParagraphStyle()
    style.lineBreakMode = .byWordWrapping
    style.alignment = .left
    style.lineSpacing = 4
    return style
}

guard CommandLine.arguments.count == 2 else {
    fputs("usage: swift tools/render-reel-overlay.swift <spec.json>\n", stderr)
    exit(1)
}

let specPath = CommandLine.arguments[1]
let specData = try Data(contentsOf: URL(fileURLWithPath: specPath))
let spec = try JSONDecoder().decode(OverlaySpec.self, from: specData)

let image = NSImage(size: NSSize(width: spec.width, height: spec.height))
image.lockFocus()

NSColor.clear.setFill()
NSRect(x: 0, y: 0, width: spec.width, height: spec.height).fill()

let bubbleRect = NSRect(
    x: spec.bubbleX,
    y: CGFloat(spec.height) - spec.bubbleY - spec.bubbleHeight,
    width: spec.bubbleWidth,
    height: spec.bubbleHeight
)

let bubblePath = NSBezierPath(roundedRect: bubbleRect, xRadius: 28, yRadius: 28)
NSColor(calibratedRed: 248/255, green: 251/255, blue: 253/255, alpha: 0.92).setFill()
bubblePath.fill()

NSColor(calibratedWhite: 1.0, alpha: 0.76).setStroke()
bubblePath.lineWidth = 1
bubblePath.stroke()

let shadow = NSShadow()
shadow.shadowColor = NSColor(calibratedRed: 18/255, green: 24/255, blue: 31/255, alpha: 0.16)
shadow.shadowBlurRadius = 24
shadow.shadowOffset = NSSize(width: 0, height: -8)
NSGraphicsContext.current?.saveGraphicsState()
shadow.set()
NSColor.clear.setFill()
bubblePath.fill()
NSGraphicsContext.current?.restoreGraphicsState()

let font =
    NSFont(name: "Hiragino Sans W6", size: spec.fontSize) ??
    NSFont(name: "Hiragino Sans", size: spec.fontSize) ??
    NSFont.systemFont(ofSize: spec.fontSize, weight: .semibold)
let attrs: [NSAttributedString.Key: Any] = [
    .font: font,
    .foregroundColor: NSColor(calibratedRed: 44/255, green: 50/255, blue: 58/255, alpha: 0.98),
    .paragraphStyle: makeParagraphStyle()
]

let text = spec.lines.joined(separator: "\n")
let textRect = NSRect(
    x: bubbleRect.minX + 24,
    y: bubbleRect.minY + 18,
    width: bubbleRect.width - 48,
    height: bubbleRect.height - 36
)

text.draw(with: textRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: attrs)

image.unlockFocus()

guard
    let tiff = image.tiffRepresentation,
    let rep = NSBitmapImageRep(data: tiff),
    let png = rep.representation(using: .png, properties: [:])
else {
    fputs("failed to encode png\n", stderr)
    exit(1)
}

try png.write(to: URL(fileURLWithPath: spec.output))
