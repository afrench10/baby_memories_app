import SwiftUI

// ============================================================
// Low-fi wireframe building blocks shared by both Home variants.
// ============================================================

/// Diagonal striped fill used for every image/photo placeholder
/// (the `repeating-linear-gradient(45deg, …)` from the design).
struct StripePattern: View {
    var bandWidth: CGFloat = 10   // one light+dark cycle spans 2× this in the design; here per-band
    var colorA: Color = Theme.Palette.phA
    var colorB: Color = Theme.Palette.phB

    var body: some View {
        Canvas { context, size in
            context.fill(Path(CGRect(origin: .zero, size: size)), with: .color(colorA))
            let diag = size.width + size.height
            var x = -size.height
            var i = 0
            while x < diag {
                if i % 2 == 0 {
                    var p = Path()
                    p.move(to: CGPoint(x: x, y: 0))
                    p.addLine(to: CGPoint(x: x + bandWidth, y: 0))
                    p.addLine(to: CGPoint(x: x + bandWidth + size.height, y: size.height))
                    p.addLine(to: CGPoint(x: x + size.height, y: size.height))
                    p.closeSubpath()
                    context.fill(p, with: .color(colorB))
                }
                x += bandWidth
                i += 1
            }
        }
    }
}

/// Cream page background with the subtle radial dot grid (22px).
struct DotGridBackground: View {
    var body: some View {
        Theme.Palette.bg.overlay(
            Canvas { context, size in
                let step: CGFloat = 22
                var y: CGFloat = 0
                while y < size.height {
                    var x: CGFloat = 0
                    while x < size.width {
                        let dot = Path(ellipseIn: CGRect(x: x, y: y, width: 1.6, height: 1.6))
                        context.fill(dot, with: .color(Theme.Palette.dotGrid))
                        x += step
                    }
                    y += step
                }
            }
        )
        .ignoresSafeArea()
    }
}

/// The rounded phone-card chrome (2.5px ink border + hard offset shadow + grab handle).
struct PhoneCard<Content: View>: View {
    @ViewBuilder var content: Content

    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(Theme.Palette.grab)
                .frame(width: 64, height: 6)
                .padding(.top, 2)
                .padding(.bottom, 16)
            content
        }
        .padding(.horizontal, 14)
        .padding(.top, 14)
        .padding(.bottom, 18)
        .background(Theme.Palette.paper)
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .strokeBorder(Theme.Palette.ink, lineWidth: 2.5)
        )
        .sketchShadow()
    }
}

/// A metadata tag chip. Accent tags (firsts / milestones) get the terracotta
/// treatment; neutral tags use a faint outline.
struct TagPill: View {
    let tag: Tag
    var body: some View {
        Text(tag.label)
            .font(Theme.Font.mono(9))
            .foregroundStyle(tag.isAccent ? Theme.Palette.accent : Theme.Palette.muted3)
            .padding(.horizontal, 7)
            .padding(.vertical, 2)
            .background(tag.isAccent ? Theme.Palette.accentBg : Color.clear)
            .clipShape(Capsule())
            .overlay(
                Capsule().strokeBorder(
                    tag.isAccent ? Theme.Palette.accent : Theme.Palette.lineCard,
                    lineWidth: 1.5
                )
            )
    }
}

/// Simple wrapping layout for tag chips (flex-wrap equivalent).
struct FlowLayout: Layout {
    var spacing: CGFloat = 6

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var x: CGFloat = 0, y: CGFloat = 0, rowHeight: CGFloat = 0
        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if x + size.width > maxWidth && x > 0 {
                x = 0; y += rowHeight + spacing; rowHeight = 0
            }
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
        return CGSize(width: proposal.width ?? x, height: y + rowHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX, y = bounds.minY, rowHeight: CGFloat = 0
        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if x + size.width > bounds.maxX && x > bounds.minX {
                x = bounds.minX; y += rowHeight + spacing; rowHeight = 0
            }
            view.place(at: CGPoint(x: x, y: y), anchor: .topLeading, proposal: ProposedViewSize(size))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}

/// A flexible tag/affordance pill (the larger size used on the Day and Memory
/// screens, and the white-on-photo overlay variant on the §3B hero).
struct WPill: View {
    let text: String
    var fg: Color
    var bg: Color = .clear
    var border: Color
    var size: CGFloat = 10

    var body: some View {
        Text(text)
            .font(Theme.Font.mono(size))
            .foregroundStyle(fg)
            .padding(.horizontal, 9)
            .padding(.vertical, 3)
            .background(bg)
            .clipShape(Capsule())
            .overlay(Capsule().strokeBorder(border, lineWidth: 1.5))
    }

    /// Accent (firsts / milestones) pill.
    static func accent(_ text: String) -> WPill {
        WPill(text: text, fg: Theme.Palette.accent, bg: Theme.Palette.accentBg,
              border: Theme.Palette.accent)
    }
    /// Neutral outline pill (e.g. "+ tag").
    static func neutral(_ text: String) -> WPill {
        WPill(text: text, fg: Theme.Palette.muted, border: Theme.Palette.lineCard)
    }
}

/// The global "+" capture button (floating action button).
struct AddButton: View {
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            Text("+")
                .font(Theme.Font.kalam(32, bold: true))
                .foregroundStyle(.white)
                .frame(width: 60, height: 60)
                .background(Theme.Palette.accent)
                .clipShape(Circle())
                .overlay(Circle().strokeBorder(Theme.Palette.ink, lineWidth: 2))
                .sketchShadow(5, opacity: 0.18)
        }
        .buttonStyle(.plain)
    }
}

/// Accent "12 this mo." count chip.
struct CountTag: View {
    let text: String
    var body: some View {
        Text(text)
            .font(Theme.Font.mono(10))
            .foregroundStyle(Theme.Palette.accent)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(Theme.Palette.accentBg)
            .clipShape(Capsule())
            .overlay(Capsule().strokeBorder(Theme.Palette.accent, lineWidth: 1.5))
    }
}
