# 🧩 Pokédex Showcase

Pokédex Showcase is a modular iOS application built with SwiftUI and Swift Concurrency, focused on exploring real-world architectural decisions, async flows, navigation patterns, and state management in a scalable way.

This project was intentionally designed as a showcase and learning playground. The goal is not visual perfection, but clarity of structure, reasoning, and trade-offs commonly faced in production iOS applications.


## 🎮 Demo & Evidence

A full demo video, feature walkthrough, edge cases, and deep link evidence are documented in the Pull Request below (could not record long videos due file sixe to add in the PR):

🔗 **Pull Request (source of truth)**  
https://github.com/TheusMartins/PokemonSwiftUI/pull/1

The PR includes:
- Pokémon listing by generation
- Navigation to Pokémon details
- Add and remove Pokémon from a persistent team
- Error and loading states
- Light and Dark mode
- Deep linking support (listing, generation selection, details)

This approach keeps the README concise while allowing the PR to act as a living, reviewable artifact.


## 🧱 Architecture Overview

The app follows an MVVM-based architecture using SwiftUI as the rendering layer and ViewModels as the main state and business orchestration units.

The project was modularized using Tuist. Tuist is not required to run the project locally, as all generated artifacts are committed, but it was used to enforce clear module boundaries and scalable composition.

The app is split into two major types of modules: Feature Modules and Core Modules.  
Each type follows a different folder and responsibility structure.


## 📦 Feature Modules

Feature modules encapsulate complete user flows. Each feature owns its UI, business logic, navigation, and composition.

Inside feature modules, the folder structure is intentionally flat and grouped by flow. Requests, repositories, views, view models, and routes live close to each other to make navigation and maintenance straightforward.

This prioritizes:
- Discoverability
- Faster onboarding
- Clear ownership of behavior

### 🧬 PokedexListing

Responsible for:
- Fetching Pokémon generations
- Listing Pokémon by selected generation
- Local search and filtering
- Routing to Pokémon details

Pokémon Details lives inside the PokedexListing feature as part of the same flow. This demonstrates how a feature can own multiple screens while still exposing a clean routing interface.

Although Pokémon Details belongs to the listing flow, it is implemented as a separate route and builder. This allows the screen to be instantiated independently and mirrors real-world scenarios where a screen belongs to a feature but still needs to be decoupled.

### 🧍 PokemonTeam

Responsible for:
- Displaying the user’s Pokémon team
- Persisted data loading
- Member removal with confirmation
- Empty and error states

PokemonTeam is fully independent from PokedexListing and Pokémon Details. It does not rely on listing or navigation state and can evolve separately.

### 🎯 Feature Demo Apps

Each feature module can be run in isolation using its own Demo App.

This allows:
- Faster local iteration
- Smaller build times
- Easier debugging
- Feature-level ownership
- Reuse of features in other applications

This setup mirrors real production environments where features can be developed, tested, and evolved independently before being integrated into a larger app.


## 🧠 Core Modules

Core modules provide shared infrastructure and abstractions. Unlike feature modules, they are organized by responsibility rather than by flow.

The folder structure in core modules is more layered, separating concerns such as protocols, implementations, helpers, and models. This reflects the fact that core modules deal primarily with abstractions and cross-cutting concerns.

### 🎨 CoreDesignSystem

All visual components and UI templates in the project include SwiftUI previews for both Light and Dark modes.

This applies to:
- Reusable components
- Larger UI templates
- Feedback elements such as loading, error, and empty states

Each preview explicitly renders both color schemes. This was done intentionally to simulate a real onboarding experience in a production project.

The goal is to allow a newcomer to:
- Visually explore components without running the app
- Understand layout, spacing, and behavior in isolation
- Quickly validate Light and Dark mode behavior
- Experiment safely without touching feature code

This approach significantly reduces cognitive load during onboarding and encourages experimentation directly from Xcode previews, which is especially valuable in modular projects with shared design systems.

### 🌐 CoreNetworking

Responsible for:
- Request abstractions
- Typed endpoints
- Async and await-based networking
- Decoupling networking from feature logic

### 💾 CorePersistence

Responsible for:
- Pokémon team storage
- Business rules such as maximum team size and duplicates
- Explicit domain errors
- Async-safe access

This module owns business invariants and does not make UI assumptions.

### 🖼 CoreRemoteImage

Responsible for:
- Remote image loading abstraction
- Centralized handling of loading, failure, and placeholders

## 🧭 Navigation Strategy

Each feature module is responsible for its own navigation flow.

Navigation is handled using:
- NavigationStack
- Explicit route enums
- Feature-level routers
- Builders for async dependency composition

The app layer acts mainly as a coordinator, delegating navigation ownership to feature modules. This avoids global routers and prevents navigation logic from leaking across unrelated features.

## 🔗 Deep Linking

Deep linking is supported by routing directly into feature navigation stacks.

The app acts as a navigation maestro. It receives a deep link, resolves the destination, and delegates navigation to the appropriate feature module.

This approach enables:
- Server-driven navigation scenarios
- Entry from any screen to any other screen
- Predictable and testable navigation behavior

Deep linking could be further modularized if needed, but the current structure already enforces clear navigation boundaries.

## 🧪 Testing Strategy

All business logic and ViewModel behavior is covered by unit tests.

Tests follow a clear narrative style:
- Given an initial state
- When an action happens
- Then the expected state is asserted

Tests focus on:
- State transitions
- Async flows
- Error handling
- Business rules

Snapshot testing was intentionally skipped to keep the scope focused on logic and behavior.

## 🛣 Roadmap and Possible Improvements

Planned or intentionally out-of-scope items:
- UI automation using Maestro
- Snapshot tests
- CI pipeline using Fastlane
- Certificate management and TestFlight deployment
- More advanced server-driven navigation experiments

These tools and topics are part of my regular background but were not the focus of this project.

## ⚙️ Setup

This project uses an Xcode workspace due to inter-module dependencies.

To run the app:

```bash
git clone <repo-url>
cd PokedexShowcase
cd Projects/App
open PokedexShowcase.xcworkspace
