import Foundation

/// A piece of searchable metadata on a memory ("First ___", "Funny", "Happy").
/// `isAccent` marks the standout tags (firsts / milestones) drawn in the accent color.
struct Tag: Identifiable, Hashable {
    let id = UUID()
    let label: String
    var isAccent: Bool = false
}

/// One memory in the month. The body is the headline — it can be a written note
/// under a photo, or a quote that stands entirely on its own (no photo needed).
struct Memory: Identifiable, Hashable {
    enum Style { case note, quote }

    let id = UUID()
    let week: Int
    let tags: [Tag]
    let photoCaption: String?   // nil → text-only memory
    let body: String
    let style: Style
}

/// A child's month of memories — the unit the narrative-scroll view renders.
struct MonthData {
    let childName: String
    let monthName: String
    let yearShort: String       // e.g. "26"
    let ageLabel: String        // e.g. "14 months old"
    let memoryCount: Int        // total in the month (may exceed what's shown)
    let memories: [Memory]

    /// Weeks that actually contain memories, in order.
    var weeks: [Int] { Array(Set(memories.map(\.week))).sorted() }
    func memories(in week: Int) -> [Memory] { memories.filter { $0.week == week } }

    /// Sample month for a child — mirrors §2B of the wireframe (Maya · March '26).
    static func sample(for child: Child) -> MonthData {
        MonthData(
            childName: child.name,
            monthName: "March",
            yearShort: "26",
            ageLabel: "\(child.age) old",
            memoryCount: 8,
            memories: [
                Memory(
                    week: 1,
                    tags: [Tag(label: "First ___", isAccent: true), Tag(label: "Happy")],
                    photoCaption: "photo · first strawberry",
                    body: "Made the funniest face — loved it by bite three.",
                    style: .note
                ),
                Memory(
                    week: 2,
                    tags: [Tag(label: "Funny", isAccent: true)],
                    photoCaption: nil,
                    body: "\u{201C}Mama, the moon is following our car. He\u{2019}s nosy.\u{201D}",
                    style: .quote
                )
            ]
        )
    }
}
