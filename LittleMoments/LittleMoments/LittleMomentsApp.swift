import SwiftUI

@main
struct LittleMomentsApp: App {
    init() {
        Theme.registerFonts()   // register bundled Kalam + Space Mono at launch
    }

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
