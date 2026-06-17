import SwiftUI

/// §3B · Single memory, photo-forward.
/// When there IS a hero photo, let it breathe — tags and note sit underneath.
/// Text-only memories (a standalone quote) fall back to a clean text-forward
/// layout so a quote is still a complete memory.
struct MemoryDetailView: View {
    let memory: Memory
    @Environment(\.dismiss) private var dismiss

    private var hasPhoto: Bool { memory.photoCaption != nil }

    var body: some View {
        ScrollView {
            PhoneCard {
                VStack(alignment: .leading, spacing: 0) {
                    if hasPhoto {
                        hero
                            .padding(.bottom, 14)
                    } else {
                        backButton
                            .padding(.bottom, 10)
                        tagRow(onPhoto: false)
                            .padding(.bottom, 14)
                    }

                    if let title = memory.title {
                        Text(title)
                            .font(Theme.Font.kalam(21, bold: true))
                            .foregroundStyle(Theme.Palette.ink)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    Text(memory.detailDate)
                        .font(Theme.Font.mono(9))
                        .foregroundStyle(Theme.Palette.muted)
                        .padding(.top, memory.title == nil ? 0 : 4)
                        .padding(.bottom, 10)

                    Text(memory.body)
                        .font(Theme.Font.kalam(memory.title == nil ? 18 : 15))
                        .foregroundStyle(Theme.Palette.inkSoft)
                        .lineSpacing(3)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .frame(maxWidth: 360)
            .padding(.horizontal, 20)
            .padding(.vertical, 24)
            .frame(maxWidth: .infinity)
        }
        .background(DotGridBackground())
        .navigationBarBackButtonHidden(true)
    }

    // MARK: Hero photo with overlaid back + tags
    private var hero: some View {
        StripePattern(bandWidth: 7)
            .frame(height: 230)
            .overlay(alignment: .topLeading) {
                backChip.padding(12)
            }
            .overlay(alignment: .bottomLeading) {
                tagRow(onPhoto: true).padding(12)
            }
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(Theme.Palette.ink, lineWidth: 2)
            )
    }

    private var backChip: some View {
        Button { dismiss() } label: {
            Text("\u{2039} back")
                .font(Theme.Font.kalam(13, bold: true))
                .foregroundStyle(Theme.Palette.ink)
                .padding(.horizontal, 9)
                .padding(.vertical, 2)
                .background(Theme.Palette.paperWarm.opacity(0.8))
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private var backButton: some View {
        Button { dismiss() } label: {
            Text("\u{2039} back")
                .font(Theme.Font.kalam(15, bold: true))
                .foregroundStyle(Theme.Palette.muted)
        }
        .buttonStyle(.plain)
    }

    // Tags: white-on-photo variant for the hero, accent/neutral elsewhere.
    private func tagRow(onPhoto: Bool) -> some View {
        HStack(spacing: 6) {
            ForEach(memory.tags) { tag in
                if onPhoto {
                    WPill(text: tag.label,
                          fg: tag.isAccent ? Theme.Palette.accent : Theme.Palette.ink,
                          bg: Theme.Palette.paperWarm,
                          border: tag.isAccent ? Theme.Palette.accent : Theme.Palette.ink,
                          size: 9)
                } else if tag.isAccent {
                    WPill.accent(tag.label)
                } else {
                    WPill(text: tag.label, fg: Theme.Palette.muted, border: Theme.Palette.lineCard)
                }
            }
        }
    }
}

#Preview("Photo-forward (3B)") {
    NavigationStack {
        MemoryDetailView(memory: MonthData.sample(for: Child.sample[0]).days[0].memories[2])
    }
}

#Preview("Text-forward (quote)") {
    NavigationStack {
        MemoryDetailView(memory: MonthData.sample(for: Child.sample[0]).days[0].memories[1])
    }
}
