import Foundation

/// A piece of searchable metadata on a memory ("First ___", "Funny", "Happy").
/// `isAccent` marks the standout tags (firsts / milestones) drawn in the accent color.
struct Tag: Identifiable, Hashable {
    let id = UUID()
    let label: String
    var isAccent: Bool = false
}

/// One memory — the atomic unit (§3). The body is the headline: a written note
/// under a photo, or a quote that stands entirely on its own (no photo needed).
struct Memory: Identifiable, Hashable {
    enum Style { case note, quote }

    let id = UUID()
    let week: Int
    let dayLabel: String        // "Sat, March 14" — links a memory to its Day
    let detailDate: String      // "March 14, 2026 · 6:42pm" — shown on the detail (§3B)
    let tags: [Tag]
    let title: String?          // "First steps!" — the §3B headline (nil for bare quotes)
    let photoCaption: String?   // label inside the placeholder; nil → text-only memory
    let body: String
    let style: Style
}

/// A single calendar day's worth of memories (§3A). Tags lead at the day level;
/// each memory renders as a content block below.
struct Day: Identifiable, Hashable {
    let id = UUID()
    let dateLabel: String       // "Sat, March 14"
    let childName: String
    let childAge: String
    let tags: [Tag]
    let memories: [Memory]
}

/// A child's month of memories — drives the §2B narrative scroll, and links each
/// teased memory to the full Day (§3A) behind it.
struct MonthData {
    let childName: String
    let monthName: String
    let yearShort: String       // e.g. "26"
    let ageLabel: String        // e.g. "14 months old"
    let memoryCount: Int        // total in the month (may exceed what's teased)
    let narrative: [Memory]     // the cards shown in the month scroll
    let days: [Day]             // full day contents reached by tapping a card

    /// Weeks that actually contain teased memories, in order.
    var weeks: [Int] { Array(Set(narrative.map(\.week))).sorted() }
    func narrativeMemories(in week: Int) -> [Memory] { narrative.filter { $0.week == week } }
    func day(for label: String) -> Day? { days.first { $0.dateLabel == label } }

    /// Sample month — mirrors §2B (the scroll), §3A (Sat March 14 as a stack of
    /// blocks) and §3B (the "First steps!" photo-forward memory).
    static func sample(for child: Child) -> MonthData {
        let first  = { (l: String) in Tag(label: l, isAccent: true) }
        let plain  = { (l: String) in Tag(label: l) }

        // §3A — Sat, March 14: a day that holds several memories.
        let strawberry = Memory(
            week: 1, dayLabel: "Sat, March 14", detailDate: "March 14, 2026 · 9:20am",
            tags: [first("First ___"), first("Funny")], title: "First strawberry",
            photoCaption: "photo / video", body: "First strawberry. The face!! 🍓", style: .note
        )
        let moreQuote = Memory(
            week: 1, dayLabel: "Sat, March 14", detailDate: "March 14, 2026",
            tags: [first("Funny")], title: nil,
            photoCaption: nil, body: "\u{201C}More! More! ... no.\u{201D}", style: .quote
        )
        // §3B — the photo-forward "hero photo" memory.
        let firstSteps = Memory(
            week: 1, dayLabel: "Sat, March 14", detailDate: "March 14, 2026 · 6:42pm",
            tags: [first("First ___"), plain("Happy")], title: "First steps!",
            photoCaption: "photo / video",
            body: "Four wobbly steps from the couch to me. We both screamed. Theo clapped.",
            style: .note
        )
        // §2B week-2 memory: a quote standing on its own.
        let moon = Memory(
            week: 2, dayLabel: "Wed, March 11", detailDate: "March 11, 2026",
            tags: [first("Funny")], title: nil, photoCaption: nil,
            body: "\u{201C}Mama, the moon is following our car. He\u{2019}s nosy.\u{201D}", style: .quote
        )

        let marchFourteen = Day(
            dateLabel: "Sat, March 14", childName: child.name, childAge: child.age,
            tags: [first("First ___"), first("Funny")],
            memories: [strawberry, moreQuote, firstSteps]
        )
        let marchEleven = Day(
            dateLabel: "Wed, March 11", childName: child.name, childAge: child.age,
            tags: [first("Funny")], memories: [moon]
        )

        // §2B narrative teasers (kept exactly as the approved month scroll).
        let strawberryTease = Memory(
            week: 1, dayLabel: "Sat, March 14", detailDate: "March 14, 2026",
            tags: [first("First ___"), plain("Happy")], title: nil,
            photoCaption: "photo · first strawberry",
            body: "Made the funniest face — loved it by bite three.", style: .note
        )

        return MonthData(
            childName: child.name, monthName: "March", yearShort: "26",
            ageLabel: "\(child.age) old", memoryCount: 8,
            narrative: [strawberryTease, moon],
            days: [marchFourteen, marchEleven]
        )
    }
}
