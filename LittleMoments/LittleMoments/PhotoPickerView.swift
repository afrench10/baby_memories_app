import SwiftUI

/// §4B · Start from a photo.
/// Pick from the camera roll the parent already has; the date auto-fills from
/// the photo's metadata. Pushed from the §4A quick-capture sheet.
struct PhotoPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selected = 0

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 3)

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                header.padding(.bottom, 14)

                LazyVGrid(columns: columns, spacing: 4) {
                    ForEach(0..<6, id: \.self) { index in
                        Button { selected = index } label: {
                            PhotoTile(isSelected: index == selected)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.bottom, 14)

                detected
            }
            .padding(.horizontal, 14)
            .padding(.top, 14)
            .padding(.bottom, 22)
        }
        .background(Theme.Palette.paper)
        .navigationBarBackButtonHidden(true)
    }

    // MARK: Cancel · Choose a photo · Next
    private var header: some View {
        HStack {
            Button { dismiss() } label: {
                Text("Cancel")
                    .font(Theme.Font.kalam(14, bold: true))
                    .foregroundStyle(Theme.Palette.muted)
            }
            .buttonStyle(.plain)
            Spacer()
            Text("Choose a photo")
                .font(Theme.Font.kalam(16, bold: true))
                .foregroundStyle(Theme.Palette.ink)
            Spacer()
            Button { dismiss() } label: {
                Text("Next")
                    .font(Theme.Font.kalam(14, bold: true))
                    .foregroundStyle(Theme.Palette.accent)
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: Auto-detected date
    private var detected: some View {
        VStack(alignment: .leading, spacing: 6) {
            Rectangle()
                .fill(Theme.Palette.rule)
                .frame(height: 1.5)
                .padding(.bottom, 6)
            Text("DETECTED")
                .font(Theme.Font.mono(9))
                .foregroundStyle(Theme.Palette.muted)
            HStack(spacing: 8) {
                WPill(text: "\u{1F4C5} Mar 14", fg: Theme.Palette.ink, border: Theme.Palette.lineCard)
                Text("auto-filled from photo")
                    .font(Theme.Font.mono(11))
                    .foregroundStyle(Theme.Palette.muted)
            }
        }
    }
}

private struct PhotoTile: View {
    let isSelected: Bool
    var body: some View {
        StripePattern(bandWidth: 5)
            .aspectRatio(1, contentMode: .fit)
            .overlay(alignment: .topTrailing) {
                if isSelected {
                    Text("\u{2713}")
                        .font(Theme.Font.mono(8, bold: true))
                        .foregroundStyle(.white)
                        .frame(width: 12, height: 12)
                        .background(Theme.Palette.accent)
                        .clipShape(Circle())
                        .padding(2)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 7, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 7, style: .continuous)
                    .strokeBorder(
                        isSelected ? Theme.Palette.accent : Theme.Palette.lineCard,
                        lineWidth: isSelected ? 2 : 1.5
                    )
            )
    }
}

#Preview {
    NavigationStack { PhotoPickerView() }
}
