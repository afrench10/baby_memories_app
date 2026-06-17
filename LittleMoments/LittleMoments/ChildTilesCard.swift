import SwiftUI

// 1B · Children as photo tiles
// Warmer, face-first. Best for 1–4 kids; the photo is the hook.
struct ChildTilesCard: View {
    let children: [Child]
    var onAddChild: () -> Void = {}
    var onOpenChild: (Child) -> Void = { _ in }

    private let columns = [GridItem(.flexible(), spacing: 12),
                           GridItem(.flexible(), spacing: 12)]

    var body: some View {
        PhoneCard {
            VStack(alignment: .leading, spacing: 14) {
                Text("Little Moments")
                    .font(Theme.Font.kalam(20, bold: true))
                    .foregroundStyle(Theme.Palette.ink)

                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(children) { child in
                        Button { onOpenChild(child) } label: { ChildTile(child: child) }
                            .buttonStyle(.plain)
                    }
                    Button(action: onAddChild) { AddTile() }
                        .buttonStyle(.plain)
                }
            }
        }
        .frame(width: 282)
    }
}

private struct ChildTile: View {
    let child: Child
    var body: some View {
        StripePattern(bandWidth: 6)
            .aspectRatio(1, contentMode: .fit)
            .overlay(alignment: .bottomLeading) {
                Text(child.name)
                    .font(Theme.Font.kalam(18, bold: true))
                    .foregroundStyle(Theme.Palette.ink)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 1)
                    .background(Theme.Palette.paperWarm.opacity(0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    .padding(10)
            }
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(Theme.Palette.ink, lineWidth: 2)
            )
    }
}

private struct AddTile: View {
    var body: some View {
        Color.clear
            .aspectRatio(1, contentMode: .fit)
            .overlay(
                Text("+ Add\na child")
                    .multilineTextAlignment(.center)
                    .font(Theme.Font.kalam(15, bold: true))
                    .foregroundStyle(Theme.Palette.muted)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [6, 5]))
                    .foregroundStyle(Theme.Palette.lineSoft)
            )
    }
}

#Preview {
    ZStack {
        DotGridBackground()
        ChildTilesCard(children: Child.sample)
    }
}
