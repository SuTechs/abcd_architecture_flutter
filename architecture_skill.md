# ABCD Architecture Guidelines for AI Agents

Provide this document as context to AI agents modifying, generating, or reviewing code within this repository. 

ABCD Architecture enforces a strict unidirectional data flow designed for scalability and maintainability. It is a foundational architecture, not a specific application template. (Note: Todo is only a reference feature).

## Architectural Flow

Implement features adhering to the following strict boundary flow:

```text
Display -> Command -> API -> Command -> Bloc -> Display
```

### Layer Definitions

- **API (`lib/data/api/`)**: Interfaces with external services and defines backend contracts.
- **Bloc (`lib/data/bloc/`)**: Manages application and feature state.
- **Command (`lib/data/command/`)**: Orchestrates user actions, side effects, and state mutations.
- **Display (`lib/screens/`)**: Renders Flutter UI components.

### Supporting Structures

- **Models (`lib/data/data/`)**: Immutable `Freezed` data classes.
- **Shared Widgets (`lib/widgets/`)**: Reusable UI components.
- **Application Shell (`lib/app/`)**: Routing, configuration, and theme definitions.

Do not introduce external architectural patterns (e.g., Clean Architecture, MVVM) unless explicitly instructed by the user.

## Technology Stack

Utilize the established technology stack unless instructed otherwise:

- **State Management**: `flutter_riverpod`
- **Routing**: `go_router`
- **Serialization**: `freezed`, `json_serializable`
- **Local Storage**: `hive_ce`
- **Backend Implementations**: Firebase, Supabase, and REST (`dio`) behind `BaseApiService`
- **Monetization**: `google_mobile_ads`, `in_app_purchase`
- **Observability**: Firebase Analytics, Crashlytics, FCM
- **Validation**: `flutter_test`, `flutter_lints`

## Core Principles

- **No direct API access from UI**: Display components must never instantiate or call API services.
- **Unidirectional state observation**: Screens observe Bloc state and invoke Commands.
- **Centralized orchestration**: Commands orchestrate all user workflows (authentication, persistence, file uploads).
- **Decoupled API layer**: API services accept inputs and return outputs without knowledge of UI or State components.
- **Restricted Bloc mutation**: Blocs maintain state and expose synchronous mutation methods. They do not handle asynchronous side effects triggered by user actions.
- **Startup hydration**: Blocs may hydrate their initial state during startup if no user action is required.

## Pre-implementation Requirements

Before generating or modifying code:

1. Review the existing feature implementation that most closely matches the requested work.
2. Review `lib/data/api/core/base_api_service.dart` and `lib/data/api/providers.dart` for dependency injection patterns.
3. Verify existing route, bloc, and command naming conventions.
4. Utilize `rg` (ripgrep) to search for existing components before creating duplicates.
5. Conform to the repository's current stylistic conventions over external best practices.

## Layer Implementation Standards

### 1. Display Layer

**Location:** `lib/screens/<feature>/`

**Do:**
- Extend `ConsumerWidget` or `ConsumerStatefulWidget` when accessing Riverpod state.
- Utilize `ref.watch()` to observe Bloc state.
- Invoke Commands for user interactions.
- Implement discrete visual states (loading, empty, error, success).
- Reuse components from `lib/widgets/`.

**Do Not:**
- Interface directly with Firebase, Supabase, Dio, Hive, or `apiServiceProvider`.
- Implement data mapping or DTO conversions.
- Implement asynchronous workflow logic.

### 2. Command Layer

**Location:** `lib/data/command/<feature>/<feature>_command.dart`

**Do:**
- Extend `BaseCommand`.
- Access dependencies via inherited getters (`api`, `localStorage`, `userBloc`).
- Encapsulate business workflows and user-triggered actions.
- Validate inputs.
- Generate necessary identifiers and timestamps.
- Invoke API methods for persistence.
- Mutate Bloc state.
- Implement optimistic updates matching existing repository patterns.
- Revert or invalidate Bloc state upon API failure.
- Return scalar values or `Future<void>` to the Display layer.

**Do Not:**
- Accept `WidgetRef` or `Ref` as parameters from the Display layer.
- Import concrete backend SDK classes.
- Maintain mutable instance state outside of explicit lifecycle requirements.

### 3. Bloc Layer

**Location:** `lib/data/bloc/<feature>_bloc.dart`

**Do:**
- Implement `Notifier` or `AsyncNotifier` for state management.
- Maintain the single source of truth for the Display layer.
- Expose synchronous mutation helpers (e.g., `addLocally`, `updateLocally`).
- Observe other Blocs only for reactive state derivations.

**Do Not:**
- Handle user interaction workflows.
- Execute asynchronous CRUD operations targeting the API layer.
- Trigger UI side effects (e.g., Snackbars, dialogs).
- Maintain a dependency on `BuildContext`.

### 4. API Services

**Location:** `lib/data/api/`

**Do:**
- Maintain `BaseApiService` as an abstract, backend-agnostic interface.
- Define feature contracts via mixins in `lib/data/api/core/`.
- Implement concrete logic within backend-specific repositories (e.g., `lib/data/api/firebase/repo/`).
- Return strongly-typed `Freezed` application models.

**Do Not:**
- Import Display, Command, or Bloc components.
- Maintain awareness of application state or UI lifecycles.
- Return raw backend payloads (e.g., `DocumentSnapshot`, `Response`).

### 5. Data Models

**Location:** `lib/data/data/<feature>/<feature>_data.dart`

**Do:**
- Define models using `@freezed`.
- Include standard generation directives (`part '<name>.freezed.dart';`, `part '<name>.g.dart';`).
- Implement standard JSON serialization factories.
- Define `const <Model>._();` to support custom getters.
- Execute the build runner after modifications:
  ```bash
  dart run build_runner build --delete-conflicting-outputs
  ```

## Naming Conventions

Adhere to the following conventions:

- **Model Class**: `<Feature>Data` (e.g., `NoteData`)
- **API Mixin**: `<Feature>ApiMixin` (e.g., `NoteApiMixin`)
- **Bloc Class**: `<Feature>Bloc` (e.g., `NoteBloc`)
- **Bloc Provider**: `<feature>BlocProvider` (e.g., `noteBlocProvider`)
- **Command Class**: `<Feature>Command` (e.g., `NoteCommand`)
- **Routing Constant**: `AppRoutes.<feature>` (e.g., `AppRoutes.notes`)

## Feature Implementation Checklist

1. Define the `Freezed` data model.
2. Define the API mixin contract.
3. Implement the contract across enabled backend repositories.
4. Implement the Bloc state notifier.
5. Implement the Command to orchestrate actions.
6. Implement Display components in `lib/screens/<feature>/`.
7. Define navigation routes.
8. Implement test coverage.
9. Execute static analysis, format, and tests.

## Feature Templates

Reference these templates when generating new feature components.

### 1. API Mixin Contract

```dart
import '../../data/note/note_data.dart';

mixin NoteApiMixin {
  Future<List<NoteData>> getNotes(String userId);
  Future<NoteData> addNote(NoteData note);
  Future<void> updateNote(NoteData note);
  Future<void> deleteNote(String noteId);
}
```
**Requirement:** Append this mixin to `BaseApiService`.

### 2. Bloc Implementation

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/note/note_data.dart';

final noteBlocProvider =
    NotifierProvider<NoteBloc, List<NoteData>>(NoteBloc.new);

class NoteBloc extends Notifier<List<NoteData>> {
  @override
  List<NoteData> build() => [];

  void setNotes(List<NoteData> notes) {
    state = notes;
  }

  void addLocally(NoteData note) {
    state = [note, ...state];
  }

  void updateLocally(NoteData updatedNote) {
    state = [
      for (final note in state)
        if (note.id == updatedNote.id) updatedNote else note,
    ];
  }

  void deleteLocally(String id) {
    state = state.where((note) => note.id != id).toList();
  }
}
```

### 3. Command Implementation

```dart
import 'package:uuid/uuid.dart';

import '../../bloc/note_bloc.dart';
import '../../bloc/user_bloc.dart';
import '../../data/note/note_data.dart';
import '../base_command.dart';

class NoteCommand extends BaseCommand {
  static const _uuid = Uuid();

  Future<void> addNote(String title, String body) async {
    final user = ref.read(userBlocProvider);
    if (user.isGuest) return;

    final now = DateTime.now();
    final note = NoteData(
      id: _uuid.v4(),
      userId: user.id,
      title: title,
      body: body,
      createdAt: now,
      updatedAt: now,
    );

    final bloc = ref.read(noteBlocProvider.notifier);
    
    // Optimistic UI update
    bloc.addLocally(note);

    try {
      // API Persistence
      await api.addNote(note);
    } catch (_) {
      // Revert state on failure
      ref.invalidate(noteBlocProvider);
    }
  }
}
```

## Backend Integration Standards

### Mock Environment
- Persist data via `LocalStorageService` to survive application restarts.
- Maintain simple authentication patterns (e.g., static OTP `123456`).
- Mock must function entirely without external service configuration.

### Firebase Integration
- Initialize via `FirebaseInit.initialize()`.
- Access SDK functionality directly via `FirebaseNative`.
- Maintain stable, simple Firestore collection naming conventions.
- Treat successful bootstrap execution as the implicit dependency contract.
- Return `null` or `false` for expected user-action failures requiring graceful UI handling.

### Supabase Integration
- Read configuration keys (`URL`, `anon_key`, `web_client_id`) via `AppConfig`.
- Initialize via `SupabaseInit.initialize()`.
- Do not access `Supabase.instance.client` prior to successful initialization.
- Return `null` or `false` for expected user-action failures requiring graceful UI handling.

### REST Integration (HTTP)
- Access networking via `HttpNative` and `dio`.
- Define endpoint constants exclusively within repository mixins.
- Deserialize responses immediately into `Freezed` models.
- Return empty lists or null only when defining explicit absence of data.

## Monetization Rules

**Advertisements:** (`lib/widgets/ads/`)
- Utilize Google test ad unit IDs for debug builds.
- Retrieve production ad unit IDs from `AppConfig`.
- Suppress ad rendering for authenticated premium users.
- Rewarded ad callbacks must deterministically resolve to `true` or `false`.

**In-App Purchases:**
- Core logic resides in `iap_service.dart`, `purchase_command.dart`, `purchase_bloc.dart`, and `purchase_state.dart`.
- Utilize mock purchase plans during mock mode to ensure the premium flow remains fully testable offline.

## Testing Standards

**Command Testing Guidelines:**
- Instantiate `ProviderContainer` with overrides.
- Override `apiServiceProvider` with `MockService`.
- Override `localStorageProvider` with memory-based storage.
- Initialize the command via `BaseCommand.init(container)`.
- Dispose the container via `addTearDown(container.dispose)`.
- Await literal Futures or inspect synchronous optimistic state rather than implementing arbitrary delays (`Future.delayed`).

**UI Testing Guidelines:**
- Extract complex UI mathematics into isolated helper classes for unit testing.
- Test edge cases deterministically.

## Review and Validation Requirements

Prior to finalizing changes, verify:
- Zero API calls originate from the Display layer.
- New Commands inherit from `BaseCommand`.
- Generated files (`.g.dart`, `.freezed.dart`) are fully up-to-date.
- Implementations span all active backend repositories.
- Mock mode functions independently of external configuration.
- Premium users are correctly exempted from advertisements.
- Exposed configuration keys are documented in `README.md`.

## Identified Anti-Patterns

**Strictly avoid:**
- Passing `WidgetRef` instances into the Command layer.
- Defining application state variables within API services.
- Implementing backend SDK integrations directly within UI screens.
- Implementing user workflow orchestration inside Blocs.
- Modifying generated code (`.freezed.dart`, `.g.dart`) manually.
- Hardcoding production secrets, API keys, or AdMob identifiers.
- Catching exceptions without reverting or repairing optimistic state mutations.

## Interaction Guidelines for AI Agents

When interacting with the user regarding this architecture:

**During Implementation:**
- Execute the required code changes directly.
- Execute formatting, analysis, and tests when feasible.
- Provide a concise summary of the critical files modified.

**During Code Review:**
- Prioritize bugs, architectural violations, and risks.
- Provide explicit file and line references.
- Keep summaries secondary to actionable feedback.
