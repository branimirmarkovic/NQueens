# NQueens

N‑Queens puzzle game for iOS with multiple difficulty modes.

## How to Run
1. Open `/Users/branimirmarkovic/NQueens/NQueens.xcodeproj` in Xcode.
2. Select the `NQueens` scheme.
3. Choose an iOS Simulator or a connected device.
4. Press **Run** (`Cmd+R`).
If you don’t have that simulator installed, replace `iPhone 15` with any available device.

## How to Test
In Xcode: **Product → Test** (`Cmd+U`).

## Architecture Decisions
- The game engine is a separate package (`NQueenEngine`) to keep core logic isolated and testable.
- UI follows MVVM to separate view rendering from state and business rules.
- The board view model rebuilds from engine state to avoid UI/engine drift.
- Difficulty modes (Easy/Medium/Hard) are distinct and drive hint behavior.
- Persistence uses `UserDefaults` for the MVP to keep storage simple and local.

For a full rationale and trade‑offs, see [`DECISIONS.md`](DECISIONS.md).
