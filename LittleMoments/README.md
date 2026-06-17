# Little Moments — iOS (SwiftUI)

Native build of **§1 Home** from the Baby Memory App wireframes: "who are we remembering?"

## Run it
1. Open `LittleMoments.xcodeproj` in Xcode (16+).
2. Pick an iPhone simulator and hit **Run** (⌘R).

No dependencies, no package manager — just the Xcode project.

## What's here
Home screen with **both** competing wireframe takes behind a segmented toggle so you
can compare them on-device before committing:

- **1A · Children as a list** — scannable rows, each with this month's memory count.
- **1B · Children as photo tiles** — face-first 2-up grid.

The sketch aesthetic is carried over faithfully: Kalam + Space Mono (bundled, registered
at launch), cream dot-grid background, 2.5px ink borders, hard offset shadows, and striped
photo placeholders.

## Iterating on the color palette
The entire palette lives in one place: `LittleMoments/Theme.swift` → `Theme.Palette`.
Change `accent`, `bg`, `ink`, etc. there and every screen updates. (Mirrors the
CSS-variable approach from the design handoff.)

## File map
| File | Role |
|------|------|
| `LittleMomentsApp.swift` | App entry point; registers fonts |
| `Theme.swift` | Color + type design tokens (**edit palette here**) |
| `Child.swift` | Model + sample data |
| `HomeView.swift` | §1 container + 1A/1B toggle |
| `ChildListCard.swift` | 1A list layout |
| `ChildTilesCard.swift` | 1B tiles layout |
| `WireframeComponents.swift` | Phone card, dot grid, stripe pattern, count chip |
| `Fonts/` | Kalam + Space Mono (OFL) |

## Not built yet (per scope)
Login workflow, and sections 2–4 (Month / Day / Capture). The flow strip in the design
shows where Home sits: **Home → Child → Month → Week/Day → Memory**.
