# NQueens

N‑Queens puzzle game for iOS with multiple difficulty modes.

## How to Run

1. Clone the repository from terminal:
   git clone https://github.com/branimirmarkovic/NQueens.git
2. Select the `NQueens` scheme.
3. Choose an iOS Simulator or a connected device.
4. Press **Run** (`Cmd+R`).

## How to Test
In Xcode: **Product → Test** (`Cmd+U`).

## Architecture Decisions

- **Modular engine**  
  The core game logic is extracted into a dedicated Swift package, `NQueenEngine`, keeping it isolated from the UI layer. This improves testability, clarity, and makes the engine easy to review or reuse independently.

- **MVVM for the UI layer**  
  The app follows the MVVM pattern to separate view rendering from state management and business logic. Views stay lightweight and declarative, while view models coordinate with the engine and expose UI-ready state.

- **Testability as a priority**  
  Key parts of the system are covered with unit tests, especially the game engine and game state transitions. This ensures correctness of the core algorithm and provides confidence when making changes.


For a full rationale and trade‑offs, see [`DECISIONS.md`](DECISIONS.md).

## 📂 Where is the Core Logic?

**Start here:**
1. [NQueenEngine/Sources/NQueenEngine/Engine/NQueensEngine.swift](NQueenEngine/Sources/NQueenEngine/Engine/NQueensEngine.swift) — Conflict detection algorithm  
2. [NQueens/Features/GameBoard/ViewModel/GameBoardViewModel.swift](NQueens/Features/GameBoard/ViewModel/GameBoardViewModel.swift) — SwiftUI state manager  
3. [NQueens/Features/GameBoard/View/GameBoardView.swift](NQueens/Features/GameBoard/View/GameBoardView.swift) — Main UI


## 🏭 If This Went to Production
*What I'd add before shipping to 200M Chess.com users:*
### Monitoring & Analytics
- Crash reporting (Sentry / Firebase Crashlytics)
- User analytics: win rate by board size, avg solve time,
abandon rate
- Performance metrics: conflict detection latency (p50, p95,
p99)
- **Why**: Data-driven optimization
### Performance
- Profile with Instruments (Time Profiler, Allocations)
### Resilience
- Graceful error handling (best times save fails → log &
continue)
- State persistence (restore game after app crash)
### Accessibility
- Enhanced VoiceOver ("Queen threatening 2 others")
- Color blind mode (pattern overlay instead of red)
- Dynamic Type support
- Haptic feedback on queen placement
- Dark Mode support
### Security & Privacy
- Encrypt best times if syncing to iCloud
- GDPR-compliant analytics opt-in
- App Store privacy labels
### Scaling
challenges
- If adding backend: User accounts, leaderboards, daily
- If >1M users: CDN for assets, database optimization
