import SwiftUI

/// §4A · One-tap quick capture.
/// A bottom sheet from a global "+". Type the moment first; photo, tags and
/// date are all optional. The "+ photo" affordance opens the picker (§4B).
struct AddMemoryView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var selectedChild: String
    @State private var text = ""
    @State private var selectedTags: Set<String> = ["Funny"]

    private let allTags = ["Funny", "First ___", "Milestone", "Happy"]
    private let children = Child.sample.map(\.name)

    private enum CaptureRoute: Hashable { case photos }

    init(childName: String) {
        _selectedChild = State(initialValue: childName)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Capsule()
                        .fill(Theme.Palette.grab)
                        .frame(width: 40, height: 5)
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 14)

                    header.padding(.bottom, 12)
                    textField.padding(.bottom, 12)
                    tagPicker.padding(.bottom, 14)
                    actions
                }
                .padding(.horizontal, 14)
                .padding(.top, 14)
                .padding(.bottom, 22)
            }
            .background(Theme.Palette.paper)
            .navigationDestination(for: CaptureRoute.self) { _ in PhotoPickerView() }
        }
    }

    // MARK: New memory · child selector
    private var header: some View {
        HStack {
            Text("New memory")
                .font(Theme.Font.kalam(19, bold: true))
                .foregroundStyle(Theme.Palette.ink)
            Spacer()
            Menu {
                ForEach(children, id: \.self) { name in
                    Button(name) { selectedChild = name }
                }
            } label: {
                WPill(text: "\(selectedChild) \u{25BE}",
                      fg: Theme.Palette.muted2, border: Theme.Palette.lineCard)
            }
        }
    }

    // MARK: "What happened today?"
    private var textField: some View {
        TextField("What happened today?", text: $text, axis: .vertical)
            .font(Theme.Font.kalam(16))
            .foregroundStyle(Theme.Palette.ink)
            .tint(Theme.Palette.accent)
            .lineLimit(3...8)
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .padding(12)
            .frame(minHeight: 84, alignment: .topLeading)
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(Theme.Palette.ink, lineWidth: 2)
            )
    }

    // MARK: Optional tags
    private var tagPicker: some View {
        FlowLayout(spacing: 6) {
            ForEach(allTags, id: \.self) { tag in
                Button {
                    if selectedTags.contains(tag) { selectedTags.remove(tag) }
                    else { selectedTags.insert(tag) }
                } label: {
                    if selectedTags.contains(tag) {
                        WPill.accent(tag)
                    } else {
                        WPill(text: tag, fg: Theme.Palette.muted2, border: Theme.Palette.lineCard)
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: + photo · date · Save
    private var actions: some View {
        HStack(spacing: 10) {
            NavigationLink(value: CaptureRoute.photos) {
                CaptureSquare(text: "+ photo")
            }
            .buttonStyle(.plain)

            CaptureSquare(text: "today \u{25BE}")

            Button { dismiss() } label: {
                Text("Save")
                    .font(Theme.Font.kalam(17, bold: true))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 46)
                    .background(Theme.Palette.accent)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            .buttonStyle(.plain)
        }
    }
}

/// A 46×46 outlined square button (the "+ photo" / "today" affordances).
private struct CaptureSquare: View {
    let text: String
    var body: some View {
        Text(text)
            .font(Theme.Font.mono(8))
            .foregroundStyle(Theme.Palette.muted2)
            .multilineTextAlignment(.center)
            .frame(width: 46, height: 46)
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(Theme.Palette.ink, lineWidth: 2)
            )
    }
}

#Preview {
    Color.black.opacity(0.2).ignoresSafeArea()
        .sheet(isPresented: .constant(true)) {
            AddMemoryView(childName: "Maya")
                .presentationDetents([.fraction(0.62), .large])
                .presentationDragIndicator(.hidden)
        }
}
