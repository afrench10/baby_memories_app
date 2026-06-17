import SwiftUI
import CoreText

// ============================================================
// DESIGN TOKENS — the whole wireframe palette lives here.
// Iterating on the color scheme later = edit these values only.
// Mirrors the CSS variables from the design handoff.
// ============================================================

enum Theme {

    // MARK: Colors
    enum Palette {
        static let bg        = Color(hex: 0xE9E5DC) // page cream
        static let dotGrid   = Color(hex: 0xD9D4C8) // background dot pattern
        static let ink       = Color(hex: 0x2E2B27) // near-black ink
        static let inkSoft   = Color(hex: 0x3A352E) // body handwriting
        static let paper     = Color(hex: 0xFFFFFF) // card surface
        static let paperWarm = Color(hex: 0xFFFDF8) // warm card surface
        static let muted     = Color(hex: 0x9A9488) // meta text
        static let muted2    = Color(hex: 0x6F6A60) // secondary body
        static let muted3    = Color(hex: 0x8A857B) // captions
        static let line      = Color(hex: 0xC8C2B5) // dashed dividers
        static let lineSoft  = Color(hex: 0xB8B2A6) // dashed placeholders
        static let lineCard  = Color(hex: 0xC2BCB0) // faint borders
        static let rule      = Color(hex: 0xECE7DC) // thin hairline rules
        static let grab      = Color(hex: 0xDDD8CC) // sheet grab handle

        static let accent    = Color(hex: 0xC2755A) // terracotta accent
        static let accentBg  = Color(hex: 0xFAF3EE) // accent wash

        // striped image placeholder
        static let phA       = Color(hex: 0xECE8DF)
        static let phB       = Color(hex: 0xF6F3EC)
    }

    // MARK: Typography
    // Handwritten display = Kalam · monospace meta = Space Mono.
    // Falls back to system fonts gracefully if registration ever fails.
    enum Font {
        static func kalam(_ size: CGFloat, bold: Bool = false) -> SwiftUI.Font {
            .custom(bold ? "Kalam-Bold" : "Kalam-Regular", fixedSize: size)
        }
        static func mono(_ size: CGFloat, bold: Bool = false) -> SwiftUI.Font {
            .custom(bold ? "SpaceMono-Bold" : "SpaceMono-Regular", fixedSize: size)
        }
    }

    // MARK: Font registration (runtime — avoids Info.plist UIAppFonts wiring)
    static func registerFonts() {
        for name in ["Kalam-Regular", "Kalam-Bold", "SpaceMono-Regular", "SpaceMono-Bold"] {
            guard let url = Bundle.main.url(forResource: name, withExtension: "ttf") else { continue }
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
    }
}

// MARK: - Hex color helper
extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red:   Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue:  Double(hex & 0xFF) / 255,
            opacity: alpha
        )
    }
}

// MARK: - Sketchy hard offset shadow (no blur), like the wireframe's `box-shadow: 7px 7px 0`
extension View {
    func sketchShadow(_ offset: CGFloat = 7, opacity: Double = 0.10) -> some View {
        background(
            GeometryReader { geo in
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(Theme.Palette.ink.opacity(opacity))
                    .frame(width: geo.size.width, height: geo.size.height)
                    .offset(x: offset, y: offset)
            }
        )
    }
}
