import Foundation

/// A child whose memories the app collects. Photo is a placeholder for now
/// (wireframe stage — real avatars come with the capture flow).
struct Child: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let age: String          // e.g. "14 months", "3 years"
    let memoriesThisMonth: Int

    static let sample: [Child] = [
        Child(name: "Maya", age: "14 months", memoriesThisMonth: 12),
        Child(name: "Theo", age: "3 years",  memoriesThisMonth: 5)
    ]
}
