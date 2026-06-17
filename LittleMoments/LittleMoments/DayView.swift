import SwiftUI

/// §3A · Day = stack of blocks.
/// One day can hold several memories. Tags lead at the day level; each memory
/// renders below as a block (photo, quote, or note). Tap a block to open it.
struct DayView: View {
    let day: Day
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            PhoneCard {
                VStack(alignment: .leading, spacing: 0) {
                    header
                    Text("\(day.childName) · \(day.childAge)")
                        .font(Theme.Font.mono(9))
                        .foregroundStyle(Theme.Palette.muted)
                        .padding(.bottom, 12)
                    dayTags
                        .padding(.bottom, 14)

                    ForEach(day.memories) { memory in
                        NavigationLink(value: memory) { MemoryBlock(memory: memory) }
                            .buttonStyle(.plain)
                            .padding(.bottom, 12)
                    }
                    AddBlock()
                }
            }
            .frame(maxWidth: 360)
            .padding(.horizontal, 20)
            .padding(.vertical, 24)
            .frame(maxWidth: .infinity)
        }
        .background(DotGridBackground())
        .navigationBarBackButtonHidden(true)
        .navigationDestination(for: Memory.self) { MemoryDetailView(memory: $0) }
    }

    private var header: some View {
        HStack(spacing: 8) {
            Button { dismiss() } label: {
                Text("\u{2039}").font(Theme.Font.kalam(15, bold: true))
                    .foregroundStyle(Theme.Palette.ink)
            }
            .buttonStyle(.plain)
            Text(day.dateLabel)
                .font(Theme.Font.kalam(22, bold: true))
                .foregroundStyle(Theme.Palette.ink)
        }
        .padding(.bottom, 4)
    }

    private var dayTags: some View {
        HStack(spacing: 6) {
            ForEach(day.tags) { tag in
                if tag.isAccent { WPill.accent(tag.label) }
                else { WPill(text: tag.label, fg: Theme.Palette.muted, border: Theme.Palette.lineCard) }
            }
            WPill.neutral("+ tag")
        }
    }
}

// MARK: - A single memory rendered as a day block
private struct MemoryBlock: View {
    let memory: Memory

    var body: some View {
        Group {
            if memory.photoCaption != nil {
                photoBlock
            } else {
                textBlock
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .strokeBorder(Theme.Palette.ink, lineWidth: 2)
        )
    }

    // photo + caption underneath
    private var photoBlock: some View {
        VStack(spacing: 0) {
            StripePattern(bandWidth: 6)
                .frame(height: 130)
                .overlay(
                    Text(memory.photoCaption ?? "")
                        .font(Theme.Font.mono(9))
                        .foregroundStyle(Theme.Palette.muted3)
                )
            Text(memory.body)
                .font(Theme.Font.kalam(14))
                .foregroundStyle(Theme.Palette.inkSoft)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
                .padding(9)
        }
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    // standalone quote / note on a warm card
    private var textBlock: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(memory.style == .quote ? "QUOTE" : "NOTE")
                .font(Theme.Font.mono(8))
                .foregroundStyle(Theme.Palette.muted)
            Text(memory.body)
                .font(Theme.Font.kalam(16))
                .foregroundStyle(Theme.Palette.ink)
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(11)
        .background(Theme.Palette.paperWarm)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

// MARK: - Add affordance
private struct AddBlock: View {
    var body: some View {
        Text("+ Add to this day")
            .font(Theme.Font.kalam(15, bold: true))
            .foregroundStyle(Theme.Palette.muted)
            .frame(maxWidth: .infinity)
            .padding(12)
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [6, 5]))
                    .foregroundStyle(Theme.Palette.lineSoft)
            )
    }
}

#Preview {
    NavigationStack {
        DayView(day: MonthData.sample(for: Child.sample[0]).days[0])
    }
}
