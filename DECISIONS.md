## Decisions & Assumptions

### Board Size Range
- **Why:** Larger boards reduce readability and touch precision on small screens and increase the computational cost of move validation, hints, and future solving features. This can lead to slower engine responses, higher CPU and battery usage, and more complex state management, including concurrency and timing concerns. Smaller boards are also easier to support initially, especially if an auto-solver is introduced later, since solver complexity grows non-linearly with board size.
- **Alternative:** Allow a wide board-size range (e.g., 4–20).
- **Decision:** Limit the range to small/medium sizes for the MVP (e.g., 4–12). This keeps the UI readable, ensures fast and predictable engine responses, reduces CPU and battery impact, and avoids unnecessary complexity in state management and future solver optimization.

### Difficulty Modes (Easy/Medium/Hard)
- **Why:** Players have different skill levels, and the puzzle benefits from progressive difficulty. Easy should prevent conflicts, Medium can allow conflicts with visual feedback, and Hard removes hints to emphasize strategy.
- **Alternative:** Single mode with a fixed hint behavior for all players.
- **Decision:** Provide three distinct modes with clearly different feedback rules to improve onboarding and replay value without introducing additional game content. The implementation was relatively low-cost since most of the required engine functionality already existed, while the impact on overall player experience and engagement is significant.

### Local Game Persistence
- **Why:** The game is fully offline-friendly, and players should be able to continue where they left off without relying on a network connection. There is currently no need for a backend (authentication, multiplayer, cloud sync), so adding server infrastructure would introduce unnecessary complexity.
- **Alternative:** Use backend sync or session-only storage.
- **Decision:** Use local storage as the lowest-risk and fastest approach for an MVP. It keeps the architecture simple while meeting current requirements. With the existing storage abstraction in place, it will be relatively easy to replace local persistence with server-based sync in the future.

---

## Non-Goals

### Online Sync / Multiplayer
- **Why excluded:** The MVP focuses on a fast, single-player experience. Introducing backend infrastructure would slow delivery and add operational complexity.
- **Next step:** Define a versioned game-state schema (board size, queen positions, moves, mode), keep persistence behind a sync-ready abstraction, and outline a simple conflict strategy (e.g., last-write-wins). Add migration tests and a lightweight sync interface for future use.
- **Risks:** Future integration may require data migrations and adjustments to state management, networking, and error handling.

### Auto-Solver
- **Why excluded:** An auto-solver requires significant development and optimization effort and does not directly improve the core MVP gameplay loop.
- **Next step:** Define a solver API (board in, moves out), introduce a solver strategy protocol, and run solving logic on a background thread with cancellation and timeout support. Add benchmarks and a time budget per solve.
- **Risks:** Solver logic can impact performance and responsiveness if not carefully optimized and isolated from the main UI thread.

### 100% Test Coverage & Full UI Test Suite
- **Why excluded:** Achieving full coverage and comprehensive UI testing is time-intensive and not required to validate core MVP functionality.
- **Next step:** Define a realistic coverage target per module, add critical UI smoke tests for main user flows, and focus unit tests on engine logic and view models. Incrementally expand UI tests around regressions and high-risk areas.
- **Risks:** Lower coverage may allow edge-case regressions; limited UI tests may delay detection of layout or navigation issues.

### Advanced Animations and Visual Effects
- **Why excluded:** Visual polish is valuable but not essential for validating core gameplay in the MVP.
- **Next step:** Define an animation layer (timing and easing), add hooks for UI state transitions, and include snapshot or regression tests to protect layout. Measure performance impact before enabling by default.
- **Risks:** Adding animations later can affect frame timing, performance, and interaction responsiveness if not carefully optimized.

---

## Trade-offs

### Separate Engine Package
- **Decision:** Keep the game engine as a separate package.
- **Alternatives:**  
  - Keep the engine inside the main app target.  
  - Extract it later after MVP.
- **Why chosen:**  
  - Improves testability and isolation of core logic.  
  - Reduces risk of UI changes affecting engine behavior.  
  - Enables reuse across projects if needed.
- **Trade-off:** Slightly more setup now vs. cleaner architecture and safer iteration.

### Persistence via UserDefaults
- **Decision:** Use `UserDefaults` for persistence.
- **Alternatives:**  
  - Core Data  
  - File-based storage
- **Why chosen:**  
  - Minimal setup and fast implementation for small state.  
  - Sufficient for current requirements (single device, small data).  
  - Storage abstraction allows replacement later.
- **Trade-off:** Limited flexibility vs. faster MVP delivery.

### Rebuild ViewModel from Engine State
- **Decision:** Rebuild the board view model from engine state on refresh.
- **Alternatives:**  
  - Mutate the view model incrementally on each action.  
  - Maintain a separate local board model.
- **Why chosen:**  
  - Keeps UI strictly consistent with engine truth.  
  - Simplifies conflict and available-position rendering.  
  - Reduces state drift bugs.
- **Trade-off:** Extra computation per refresh vs. correctness and stability.

### MVVM UI Architecture
- **Decision:** Use MVVM for UI architecture.
- **Alternatives:**  
  - MVC with view controllers owning logic  
  - Redux/Composable Architecture with a global store
- **Why chosen:**  
  - Separates UI rendering from state and business logic.  
  - Improves testability of view logic and state changes.  
  - Scales well for multiple screens without heavy framework overhead.
- **Trade-off:** More boilerplate than MVC vs. clearer boundaries and easier testing.

### Hard Mode Rules (No Hints + Move Limit)
- **Decision:** Hard mode has no visual hints and enforces a move limit.
- **Alternatives:**  
  - No move limit, only remove hints.  
  - Apply move limits to all modes.
- **Why chosen:**  
  - Keeps Hard mode meaningfully different without changing core rules.  
  - Adds strategic pressure while keeping Easy/Medium friendly.  
  - Avoids penalizing casual players in lower modes.
- **Trade-off:** Higher difficulty in Hard mode vs. clearer differentiation and replay value.

---

## What I’d Do Differently With More Time

### Connect Persistence to Full Game Flow (2–3h)
- **Current:** Storage layer exists but is not fully integrated into all game flows.
- **Improvement:** Wire persistence into start, move, reset, and resume flows.
- **Why deferred:** Prioritized core gameplay and UI behavior for MVP.

### Refactor Complex View Layout (3–5h)
- **Current:** One complex view handles too much layout logic.
- **Improvement:** Split into smaller components, extract shared styling, and move logic into view models.
- **Why deferred:** Focused on shipping core gameplay and correctness first.

### Performance & Responsiveness Profiling (3–5h)
- **Current:** Performance assumptions are based on manual testing and constraints.
- **Improvement:** Use Instruments to profile frame time and CPU usage and define performance budgets.
- **Why deferred:** Gameplay features and stability were higher priority for MVP.

### App Root & Dependency Lifecycle Review (2–4h)
- **Current:** App root and dependency setup work for MVP but were implemented quickly.
- **Improvement:** Clarify ownership and lifecycles, tighten dependency boundaries, and document initialization and teardown flows.
- **Why deferred:** Prioritized feature delivery and core architecture validation.


---


## WHY I STOPPED HERE


**1. Dark Mode Support**
- **Why stopped**: The theme system exists but needs a full color audit and contrast testing
- **Next step**: Define dark palette tokens and update board/error/queen colors
- **Risk**: Poor contrast can make the board unreadable
- **When to add**: After initial UX feedback or App Store review notes

**2. Sound Effects**
- **Why stopped**: Time prioritization; low ROI vs
implementation effort
- **Next step**: AVFoundation + asset creation (2-3 hours)
- **Risk**: Annoying if overused; needs volume settings
- **When to add**: After core features validated with users
