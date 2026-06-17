import SwiftUI

/// Home (§1 of the wireframes) — "who are we remembering?"
/// Hosts both competing takes (1A list / 1B tiles) behind a toggle so the
/// layout direction can be compared on-device before we commit to one.
struct HomeView: View {
    enum Layout: String, CaseIterable, Identifiable {
        case list  = "List"      // 1A
        case tiles = "Tiles"     // 1B
        var id: Self { self }
    }

    @State private var layout: Layout = .list
    private let children = Child.sample

    var body: some View {
        NavigationStack {
            ZStack {
                DotGridBackground()

                VStack(spacing: 22) {
                    Picker("Layout", selection: $layout) {
                        ForEach(Layout.allCases) { Text($0.rawValue).tag($0) }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 40)
                    .padding(.top, 8)

                    Spacer(minLength: 0)

                    Group {
                        switch layout {
                        case .list:  ChildListCard(children: children)
                        case .tiles: ChildTilesCard(children: children)
                        }
                    }
                    .transition(.opacity)

                    Spacer(minLength: 0)

                    Text(layout == .list ? "1A · Children as a list" : "1B · Children as photo tiles")
                        .font(Theme.Font.mono(10))
                        .foregroundStyle(Theme.Palette.muted3)
                        .padding(.bottom, 10)
                }
                .animation(.easeInOut(duration: 0.2), value: layout)
            }
            .navigationDestination(for: Child.self) { child in
                MonthView(data: .sample(for: child))
            }
        }
    }
}

#Preview {
    HomeView()
}
