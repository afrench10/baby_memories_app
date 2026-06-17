import SwiftUI

/// §2B · Narrative scroll — the month as a story you scroll.
/// Weeks are gentle dividers; each memory is a card whose content is the
/// headline. Text-only memories (a quote alone) live here as equals.
struct MonthView: View {
    let data: MonthData
    @Environment(\.dismiss) private var dismiss
    @State private var showAdd = false

    var body: some View {
        ScrollView {
            PhoneCard {
                VStack(alignment: .leading, spacing: 0) {
                    header
                    subheader
                    ForEach(data.weeks, id: \.self) { week in
                        WeekDivider(week: week)
                            .padding(.bottom, 10)
                        ForEach(data.narrativeMemories(in: week)) { memory in
                            memoryRow(memory)
                                .padding(.bottom, 14)
                        }
                    }
                }
            }
            .frame(maxWidth: 360)
            .padding(.horizontal, 20)
            .padding(.vertical, 24)
            .frame(maxWidth: .infinity)
        }
        .background(DotGridBackground())
        .navigationBarBackButtonHidden(true)
        .navigationDestination(for: Day.self) { DayView(day: $0) }
        .overlay(alignment: .bottomTrailing) {
            AddButton { showAdd = true }.padding(20)
        }
        .sheet(isPresented: $showAdd) {
            AddMemoryView(childName: data.childName)
                .presentationDetents([.fraction(0.62), .large])
                .presentationDragIndicator(.hidden)
                .presentationCornerRadius(22)
        }
    }

    // Each card opens the full day behind it (§3A).
    @ViewBuilder
    private func memoryRow(_ memory: Memory) -> some View {
        if let day = data.day(for: memory.dayLabel) {
            NavigationLink(value: day) { MemoryCard(memory: memory) }
                .buttonStyle(.plain)
        } else {
            MemoryCard(memory: memory)
        }
    }

    // MARK: Header — ‹ Maya     March     '26 ›
    private var header: some View {
        HStack(spacing: 8) {
            Button { dismiss() } label: {
                Text("\u{2039} \(data.childName)")
                    .font(Theme.Font.kalam(15, bold: true))
                    .foregroundStyle(Theme.Palette.ink)
            }
            .buttonStyle(.plain)

            Spacer(minLength: 0)

            Text(data.monthName)
                .font(Theme.Font.kalam(20, bold: true))
                .foregroundStyle(Theme.Palette.ink)

            Spacer(minLength: 0)

            Text("'\(data.yearShort) \u{203A}")
                .font(Theme.Font.mono(10))
                .foregroundStyle(Theme.Palette.muted)
        }
        .padding(.bottom, 6)
    }

    // MARK: Subheader — "8 memories · 14 months old" + hairline
    private var subheader: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("\(data.memoryCount) memories · \(data.ageLabel)")
                .font(Theme.Font.mono(9))
                .foregroundStyle(Theme.Palette.muted)
                .padding(.bottom, 8)
            Rectangle()
                .fill(Theme.Palette.rule)
                .frame(height: 1.5)
        }
        .padding(.bottom, 12)
    }
}

// MARK: - Week divider
private struct WeekDivider: View {
    let week: Int
    var body: some View {
        HStack(spacing: 8) {
            Text("Week \(week)")
                .font(Theme.Font.kalam(13, bold: true))
                .foregroundStyle(Theme.Palette.accent)
            Rectangle()
                .fill(Theme.Palette.rule)
                .frame(height: 1.5)
        }
    }
}

// MARK: - Memory card
private struct MemoryCard: View {
    let memory: Memory

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // tags
            HStack(spacing: 6) {
                ForEach(memory.tags) { TagPill(tag: $0) }
            }

            // optional photo
            if let caption = memory.photoCaption {
                StripePattern(bandWidth: 6)
                    .frame(height: 96)
                    .overlay(
                        Text(caption)
                            .font(Theme.Font.mono(9))
                            .foregroundStyle(Theme.Palette.muted3)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .strokeBorder(
                                style: StrokeStyle(lineWidth: 1.5, dash: [4, 3])
                            )
                            .foregroundStyle(Theme.Palette.lineCard)
                    )
            }

            // body — the headline
            Text(memory.body)
                .font(Theme.Font.kalam(memory.style == .quote ? 17 : 14))
                .foregroundStyle(memory.style == .quote ? Theme.Palette.ink : Theme.Palette.inkSoft)
                .lineSpacing(memory.style == .quote ? 3 : 2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(memory.style == .quote ? Theme.Palette.paperWarm : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(Theme.Palette.ink, lineWidth: 2)
        )
    }
}

#Preview {
    NavigationStack {
        MonthView(data: .sample(for: Child.sample[0]))
    }
}
