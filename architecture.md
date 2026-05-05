# ABCD Architecture Overview

This document provides a high-level summary of the ABCD architecture. It is intentionally concise to prevent architectural drift.

- Consult [README.md](README.md) for developer onboarding and repository documentation.
- Consult [architecture_skill.md](architecture_skill.md) for strict AI agent guidelines and implementation rules.

These two documents serve as the authoritative references for this architecture.

## Technology Stack

The repository utilizes the following core technologies:
- **State Management**: Riverpod
- **Routing**: GoRouter
- **Data Models**: Freezed
- **Local Storage**: Hive CE
- **Backend Integrations**: Firebase, Supabase, and REST implementations
- **Monetization**: Google Mobile Ads, In-App Purchases
- **Observability**: Firebase Analytics, Crashlytics

Refer to the [Tech Stack](README.md#tech-stack) section in the README for complete package details.

## Architecture Layers

The architecture consists of four distinct layers:

| Layer | Prefix | Responsibility | Path |
|---|---|---|---|
| **API** | **A** | Interfaces with external services and defines backend contracts. | `lib/data/api/` |
| **Bloc** | **B** | Manages application and feature state. | `lib/data/bloc/` |
| **Command** | **C** | Orchestrates user actions, side effects, API calls, and state updates. | `lib/data/command/` |
| **Display** | **D** | Renders UI state and invokes Commands. | `lib/screens/` |

Supporting structural directories:
- `lib/data/data/`: Immutable `Freezed` data models.
- `lib/widgets/`: Reusable UI components.
- `lib/app/`: Application configuration, routing, and theme definitions.

## Architectural Flow

```text
Display -> Command -> API -> Command -> Bloc -> Display
```

**Core Directives:**
- The Display layer must never invoke API services directly.
- The API layer must never import components from the Display, Command, or Bloc layers.
- The Bloc layer maintains state and exposes synchronous mutation methods.
- The Command layer coordinates all asynchronous, user-driven workflows.
- Blocs may hydrate their initial state during application startup if no user interaction is required.

## Adding a Feature

Implement new features by adhering to the following sequence:

1. Define the data model in `lib/data/data/`.
2. Define the API mixin contract in `lib/data/api/core/`.
3. Implement the API methods across all enabled backend repositories.
4. Implement the Bloc state notifier in `lib/data/bloc/`.
5. Implement the Command in `lib/data/command/`.
6. Implement the UI screens in `lib/screens/`.
7. Configure routes, add shared widgets, and implement tests as necessary.
