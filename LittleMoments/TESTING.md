# Little Moments — Manual Test Suite (wireframe stage)

Use this to verify the prototype is **functional** before/while running it in the
iOS Simulator. It also doubles as a moderation script for parent UX sessions.

- **Scope:** navigation + interactions only. This is a navigable prototype, not a
  finished app — see [Known limitations](#known-limitations) before flagging bugs.
- **How to use:** run each case in order, check the box if **Actual = Expected**.
  Anything that doesn't match → jot it in [Bug log](#bug-log).
- **Target:** iPhone Simulator (any recent iPhone). Portrait orientation.

---

## 0. Pre-flight — build & launch

| # | Step | Expected |
|---|------|----------|
| P0.1 | Open `LittleMoments.xcodeproj` in Xcode | Project opens, no red errors in navigator |
| P0.2 | Select an iPhone simulator, press **Run (⌘R)** | App **compiles** and launches (first real compile — fix any errors before continuing) |
| P0.3 | App appears | Cream background with a faint **dot grid**; a phone-style card centered |
| P0.4 | Look at the fonts | Names/titles are **handwritten** (Kalam); small meta text is **monospace** (Space Mono). If everything is the default system font → bundled fonts didn't register |

> If P0.2 fails to compile, stop and send the error text — that's the fastest fix path.

---

## 1. Smoke test (2-minute happy path)

Run this first; if it all passes, the core flow works.

- [ ] **S1** Launch → Home shows **Little Moments** with **Maya** and **Theo**
- [ ] **S2** Tap **Maya** → Month view (header reads **Maya · March · '26**)
- [ ] **S3** Tap the **strawberry** card → Day view (**Sat, March 14**)
- [ ] **S4** Tap the **First steps!** photo block → Memory detail with a large photo
- [ ] **S5** Tap **‹ back** repeatedly → returns all the way to Home
- [ ] **S6** On the Month view, tap the **+** (bottom-right) → capture sheet slides up
- [ ] **S7** Type in the text field, tap **Save** → sheet dismisses

---

## 2. §1 — Home

| # | Step | Expected |
|---|------|----------|
| H1 | Observe default state | Segmented toggle shows **List / Tiles**, defaulting to **List**. Bottom caption: *1A · Children as a list* |
| H2 | Read the list rows | **Maya** — 14 months — **12 this mo.** (accent chip); **Theo** — 3 years — **5 this mo.**; a dashed **+ Add a child** row |
| H3 | Tap **Tiles** in the toggle | Switches to a 2-up grid: **Maya** tile, **Theo** tile, dashed **+ Add a child** tile. Caption: *1B · Children as photo tiles* |
| H4 | Tap **List** again | Returns to list layout (animated) |
| H5 | Tap **+ Add a child** (either layout) | **Nothing happens** — not yet wired (expected) |

---

## 3. Navigation — Home → Month

| # | Step | Expected |
|---|------|----------|
| N1 | From List, tap **Maya** | Pushes Month view; header child name = **Maya**, subheader age = **14 months old** |
| N2 | Go back, tap **Theo** | Month header now reads **Theo** / **3 years old** (header reflects the tapped child; memory *content* is shared sample data — expected) |
| N3 | From Tiles layout, tap a child tile | Same navigation works from tiles |

---

## 4. §2B — Month (narrative scroll)

Enter via Home → **Maya**.

| # | Step | Expected |
|---|------|----------|
| M1 | Read header | **‹ Maya** &nbsp; **March** &nbsp; **'26 ›**; subheader **8 memories · 14 months old** with a hairline under it |
| M2 | Read **Week 1** | Accent "Week 1" divider, then a card: tags **First ___** / **Happy**, a striped photo placeholder labeled *photo · first strawberry*, text *"Made the funniest face — loved it by bite three."* |
| M3 | Read **Week 2** | Accent "Week 2" divider, then a **warm-tinted** card: tag **Funny**, quote *"Mama, the moon is following our car. He's nosy."* (no photo) |
| M4 | Find the **+** button | Floating accent **+** pinned bottom-right; stays put when you scroll |
| M5 | Tap **‹ Maya** (top-left) | Returns to Home |

---

## 5. §3A — Day (stack of blocks)

Enter via Month → tap the **strawberry** card (Week 1).

| # | Step | Expected |
|---|------|----------|
| D1 | Read header | **‹ Sat, March 14**, then **Maya · 14 months** |
| D2 | Read day tags | **First ___**, **Funny** (accent) and a **+ tag** affordance |
| D3 | Count the blocks | Three: a **photo** block (*First strawberry. The face!! 🍓*), a **QUOTE** block (*More! More! … no.*, warm), a **photo** block (*Four wobbly steps…*), then **+ Add to this day** |
| D4 | Go back, tap the **moon-quote** card (Week 2) instead | Opens Day **Wed, March 11** with a **single** quote block |
| D5 | Tap **+ Add to this day** | Capture sheet opens (see §7) |

---

## 6. §3B — Memory detail

Enter via Day → tap a block.

| # | Step | Expected |
|---|------|----------|
| R1 | Tap the **First steps!** photo block | **Photo-forward**: large hero placeholder with **‹ back** (top-left) and tags **First ___ / Happy** overlaid (bottom-left); below: title **First steps!**, date **March 14, 2026 · 6:42pm**, note *Four wobbly steps…* |
| R2 | Tap **‹ back** on the photo | Returns to the Day |
| R3 | Tap the **QUOTE** block (*More! More! … no.*) | **Text-forward** variant: a **‹ back** row, a **Funny** tag, **no hero photo**, the quote shown large |
| R4 | Back out fully | ‹ back returns to Day; then Month; then Home |

---

## 7. §4A — Quick capture sheet

Open via the Month **+** (FAB) **or** Day **+ Add to this day**.

| # | Step | Expected |
|---|------|----------|
| C1 | Open the sheet | Slides up from the bottom; the screen behind **dims**. Grab handle on top, title **New memory** |
| C2 | Tap the child pill (**Maya ▾**) | A menu lists **Maya** and **Theo**; picking one updates the pill label |
| C3 | Tap the text field, type | Text is **editable**; the caret is **accent-colored**; the field grows with multiple lines |
| C4 | Tap tags | **Funny** starts selected (accent). Tapping toggles any tag between accent (on) and outline (off) |
| C5 | Tap **Save** | Sheet **dismisses** (nothing is persisted yet — expected) |
| C6 | Swipe the sheet down | Sheet dismisses; you can also drag it taller (large detent) |

---

## 8. §4B — Photo picker

Open via capture sheet → **+ photo**.

| # | Step | Expected |
|---|------|----------|
| B1 | Tap **+ photo** | Pushes the picker; header reads **Cancel · Choose a photo · Next** |
| B2 | Observe the grid | 3-column grid of 6 striped tiles; the **first** is selected (accent ring + ✓ badge) |
| B3 | Tap a different tile | Selection (ring + ✓) **moves** to the tapped tile |
| B4 | Read the detected row | **DETECTED** → **📅 Mar 14** + *auto-filled from photo* |
| B5 | Tap **Cancel** or **Next** | Returns to the capture sheet |

---

## 9. Cross-cutting checks

- [ ] **X1 Back behavior:** every pushed screen has a working back affordance; you can always return to Home
- [ ] **X2 No dead-ends:** you never get stuck on a screen with no way back
- [ ] **X3 Small device:** re-run the smoke test on **iPhone SE** — cards and the bottom sheet still fit, no clipping
- [ ] **X4 Large device:** re-run on **iPhone 15/16 Pro Max** — layout stays centered, not stretched
- [ ] **X5 Re-entry:** open the capture sheet, dismiss, reopen — it resets cleanly (no leftover text persistence is expected)

---

## Known limitations

These are **intentional at wireframe stage** — do **not** log them as bugs:

- **Nothing is saved.** Save / Next / Cancel just dismiss. Reopening capture starts fresh.
- **+ Add a child** does nothing yet.
- **Photos are placeholders** (striped patterns), not the real camera roll; the picker tiles and detected date are mock.
- **Date button (today ▾)** is non-functional.
- **Memory content is shared sample data** across children — Theo's month shows the same memories as Maya's, just with his name/age in the header.
- **No login / accounts** — deferred by design.
- **Colors are wireframe-stage**, intentionally low-fi; a palette pass is planned (all tokens live in `Theme.swift`).

---

## Bug log

| # | Screen | Steps to reproduce | Expected | Actual | Severity |
|---|--------|--------------------|----------|--------|----------|
|   |        |                    |          |        |          |
|   |        |                    |          |        |          |
