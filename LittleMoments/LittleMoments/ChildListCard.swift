import SwiftUI

// 1A · Children as a list
// Scannable rows, each showing this month's count. Calm, scales to many kids.
struct ChildListCard: View {
    let children: [Child]
    var onAddChild: () -> Void = {}

    var body: some View {
        PhoneCard {
            VStack(alignment: .leading, spacing: 0) {
                // top bar: app name + profile dot
                HStack {
                    Text("Little Moments")
                        .font(Theme.Font.kalam(20, bold: true))
                        .foregroundStyle(Theme.Palette.ink)
                    Spacer()
                    Circle()
                        .strokeBorder(Theme.Palette.ink, lineWidth: 2)
                        .frame(width: 26, height: 26)
                }
                .padding(.bottom, 18)

                Text("YOUR KIDS")
                    .font(Theme.Font.mono(10))
                    .tracking(1)
                    .foregroundStyle(Theme.Palette.muted)
                    .padding(.bottom, 10)

                VStack(spacing: 12) {
                    ForEach(children) { child in
                        NavigationLink(value: child) { ChildRow(child: child) }
                            .buttonStyle(.plain)
                    }
                    AddRow(label: "+ Add a child", action: onAddChild)
                }
            }
        }
        .frame(width: 282)
    }
}

private struct ChildRow: View {
    let child: Child
    var body: some View {
        HStack(spacing: 12) {
            StripePattern(bandWidth: 5)
                .frame(width: 48, height: 48)
                .clipShape(Circle())
                .overlay(Circle().strokeBorder(Theme.Palette.lineCard, lineWidth: 1.5))

            VStack(alignment: .leading, spacing: 1) {
                Text(child.name)
                    .font(Theme.Font.kalam(18, bold: true))
                    .foregroundStyle(Theme.Palette.ink)
                Text(child.age)
                    .font(Theme.Font.mono(10))
                    .foregroundStyle(Theme.Palette.muted)
            }
            Spacer()
            CountTag(text: "\(child.memoriesThisMonth) this mo.")
        }
        .padding(12)
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(Theme.Palette.ink, lineWidth: 2)
        )
    }
}

private struct AddRow: View {
    let label: String
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(label)
                .font(Theme.Font.kalam(16, bold: true))
                .foregroundStyle(Theme.Palette.muted)
                .frame(maxWidth: .infinity)
                .padding(14)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [6, 5]))
                        .foregroundStyle(Theme.Palette.lineSoft)
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        ZStack {
            DotGridBackground()
            ChildListCard(children: Child.sample)
        }
    }
}
