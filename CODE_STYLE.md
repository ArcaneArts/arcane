# CODE STYLE (Agent-Focused)

## Purpose
This document defines the expected Dart/Flutter style for this repository.

Agents must follow this file even when common LLM defaults disagree.

## Priority
1. Follow this file.
2. Follow existing local project patterns.
3. Prefer consistency over novelty.

## Core Rules

### 1) Type Discipline
- Never use `var` for normal variable declarations.
- Exception: `var` is allowed in switch-expression destructuring patterns when binding matched fields.
- Never use local `final`.
- Always explicitly type local variables and loop variables.
- Local `const` is allowed, but usually unnecessary unless there is a clear performance/readability reason.

Bad:
```dart
var x = 1;
final y = 2;
for (var i in items) {}
```

Good:
```dart
int x = 1;
int y = 2;
for (String i in items) {}
```

### 2) Constructor Parameters
- If a constructor has more than one parameter, use named parameters.
- Avoid mixing named + positional parameters.
- Exception: mixed params are allowed only when one positional param is used in ~90% of call sites.
- If there is a rare optional single parameter use case, a defaulted optional positional param is acceptable.

### 3) `required` vs Defaults
- Prefer `required` when there is no truly sensible default.
- Use defaults only when the default is the common real-world case.
- Do not force fake sentinel defaults just to avoid `required`.
- For non-nullable fields, defaults are common for flags/trips, not mandatory for everything.

### 4) Inlining (`=>`) and Method Shape
- Use `=>` for single-expression methods/getters in most cases.
- If a method has more than one external call or grows past ~10 lines, do not force inlining.
- Extract helper methods when chaining becomes visually dense.

Bad:
```dart
int size() {
  int value = items.length;
  return value;
}
```

Good:
```dart
int get size => items.length;
```

### 5) Braces and Guard Clauses
- Single-line guard clauses may omit braces only for very short `return`, `break`, or `continue`.
- For longer `throw` statements or formatter-wrapped lines, use braces.
- For normal condition bodies, use braces.

Good:
```dart
if (isReady) return;
if (!isValid) {
  throw Exception("Invalid state for operation X");
}
```

### 6) Nested Functions
- Avoid defining methods/functions inside methods.
- Soft-banned: there are rare valid cases, but usually extract a private helper instead.

### 7) Switch Usage
- Strong preference for switch expressions.
- Do not use regular switch statements.
- If the logic cannot be expressed as an inline mapping output, use `if`/`else` instead of a regular switch statement.
- Pattern-matching switch expressions are encouraged when they keep output mapping concise.

### 8) Callbacks
- Prefer inferred callback parameters when inference is available.
- Do not type callback lambda params unless needed.
- Keep callbacks to 3 params max.
- If more than 3 fields are needed, pass one data object/class instead.

Good:
```dart
SomeCallable c = (a, b) => a + b;
```

### 9) Null Safety Style
- Prefer `?.` and `??` over explicit null-check boilerplate.
- Avoid repeated `!` and repeated `?` noise through long code paths.
- If null is impossible in context, normalize once at top (`!` or fallback) then use non-null value.

Bad:
```dart
if (value != null) {
  doThing(value);
}
```

Good:
```dart
doThing(value ?? defaultValue);
```

### 10) Collection Construction
- Prefer collection literals with `if`, `for`, and spreads instead of many `add` calls.
- Exception: if logic/external checks dominate (roughly >40% of method complexity), staged `add` flow is acceptable.

Preferred style:
```dart
List<String> buildList() => [
  if (condition) ...["a", "b"],
  "c",
  for (String i in values) i,
];
```

### 11) Class Member Order
Use this order:
1. static fields
2. instance fields
3. constructors
4. factory constructors
5. static methods
6. getters
7. instance methods

### 12) Imports
- Never use relative imports.
- Always use `package:` imports, including local package files.
- Import ordering is not manually enforced (formatter handles it).

### 13) Comments
- Do not add comments by default.
- Code should be readable without comments.
- Add comments only if explicitly requested or truly unavoidable.

### 14) Logging
- Avoid adding logs unless needed.
- `print` is for temporary local debugging, not committed behavior.
- Prefer project logging helpers (`verbose`, `info`, `warn`, `success`, `error`, `network`) when persistent logging is required.
- Avoid log spam.

### 15) Async/Future Style
- If no `await` is used, do not mark method `async`.
- Prefer chaining (`.then`) when transforming existing futures in inline style.
- Use `async/await` when it significantly improves readability or control flow.
- If intentionally ignoring an exception, use `catch (_) {}`.
- Do not add analyzer-ignore comments for empty catches just to silence warnings.

Good:
```dart
Future<void> doWork() => Future.wait(tasks).then((_) => onDone());
```

### 16) Flutter Widget Style
- Prefer `StatelessWidget` until mutable state is actually needed.
- Prefer inline `build` expressions when reasonable.
- Prefer `Widget build(BuildContext context) => ...` when practical.
- Do not create private helper methods that build widget parts (`buildTile`, `buildRow`, etc.).
- If `build` gets too large, split into additional `StatelessWidget` classes.
- Widget extraction is preferred over build-helper methods for clarity and widget tree behavior.

### 17) Extensions, Top-Level APIs, and Helper Classes
- Strongly prefer extension methods on target objects over static helper methods that take the target as a parameter.
- Avoid top-level methods for app/domain logic to keep the global namespace clean.
- Prefer extensions for behavior and computed values that belong to an existing type.
- If extension methods are not appropriate and a true utility namespace is needed, use a helper class with a private constructor: `const HelperClass._();`.
- Utility methods in helper classes should be `static`.
- Top-level methods are allowed only for entry/wiring use cases such as `main()` and explicit app bootstrap registration functions.

## Canonical Class Template
```dart
class ExampleWidget extends StatelessWidget {
  static const int staticValue = 1;

  final int count;
  final String? label;

  const ExampleWidget({
    super.key,
    required this.count,
    this.label,
  });

  static String formatLabel(String value) => value.trim();

  int get safeLength => label?.length ?? 0;

  void doWork(int a, int b) => verbose("$a:$b");

  @override
  Widget build(BuildContext context) => Text(label ?? "");
}
```

## Testing Expectations
- If Dart unit tests are already set up for the touched area, update/add tests and run them.
- Flutter widget tests are not the default expectation unless explicitly requested.
- Runtime/manual app verification is acceptable for Flutter UI behavior.

## Agent Checklist (Before Finalizing Changes)
- No `var` used outside switch-expression destructuring patterns.
- No local `final` used.
- Loop variables are explicitly typed.
- Constructor params follow named/required rules.
- Single-expression methods/getters use `=>` where sensible.
- No unnecessary nested functions.
- Switch logic uses switch expressions (not regular switch statements).
- Callback params inferred when possible; 3-param max.
- Null handling uses `?.`, `??`, and one-time normalization.
- Collections built with literal + `if`/`for`/spreads when practical.
- Class member order matches project convention.
- Imports use `package:` only.
- No unnecessary comments.
- Logging is minimal and uses project logging helpers when needed.
- Async style avoids `async` without `await`.
- Ignored exceptions use `catch (_) {}`.
- Flutter UI split into widgets instead of build-helper methods.
- Extension methods are preferred over static helper APIs for target-bound behavior.
- No non-wiring top-level methods are introduced.
- Static helper classes (when needed) use `const ClassName._();`.

## Additional Do/Don't Examples

### Extensions vs Static Helpers
Don't:
```dart
class FolderFormatters {
  static String displayName(Folder folder) => folder.name.trim();
}
```

Do:
```dart
extension FolderFormatting on Folder {
  String get displayName => name.trim();
}
```

### Top-Level Logic
Don't:
```dart
String roleLabel(int role) => switch (role) {
  0 => "Owner",
  1 => "Editor",
  _ => "Viewer",
};
```

Do:
```dart
extension FolderRoleLabel on int {
  String get roleLabel => switch (this) {
    0 => "Owner",
    1 => "Editor",
    _ => "Viewer",
  };
}
```

### Static Helper Class Shape
Don't:
```dart
class SessionMath {
  static int progress(int current, int total) => ((current / total) * 100).round();
}
```

Do:
```dart
class SessionMath {
  const SessionMath._();

  static int progress(int current, int total) => ((current / total) * 100).round();
}
```

### Ignoring Exceptions
Don't:
```dart
try {
  return await load();
} catch (e) {}
```

Do:
```dart
try {
  return await load();
} catch (_) {}
```

## Large Canonical Example
```dart
class GuideSessionTile extends StatelessWidget {
  static const int staleAfterMinutes = 10;

  final GuideSession session;
  final Future<GuideSession?> Function(String sessionId) reload;
  final void Function(GuideSessionAction action) onAction;

  const GuideSessionTile({
    super.key,
    required this.session,
    required this.reload,
    required this.onAction,
  });

  factory GuideSessionTile.player({
    Key? key,
    required Guide guide,
    required Future<GuideSession?> Function(String sessionId) reload,
    required void Function(GuideSessionAction action) onAction,
  }) => GuideSessionTile(
    key: key,
    session: GuideSession(
      sessionId: guide.guideId,
      guideName: guide.name,
      ownerName: "Player",
      stepCount: guide.steps.length,
      currentStep: 0,
      status: SessionStatus.ready,
      updatedAtMs: DateTime.now().millisecondsSinceEpoch,
    ),
    reload: reload,
    onAction: onAction,
  );

  static String subtitleFor(GuideSession session) =>
      "${session.ownerDisplayName} • ${session.stepCount} steps";

  bool get isStale =>
      DateTime.now().millisecondsSinceEpoch - session.updatedAtMs >
      Duration(minutes: staleAfterMinutes).inMilliseconds;

  int get progressPercent => SessionMath.progress(session.currentStep, session.stepCount);

  String get statusLabel => switch (session) {
    GuideSession(status: SessionStatus.ready) => "Ready",
    GuideSession(status: SessionStatus.playing, currentStep: var step) => "Step $step",
    GuideSession(status: SessionStatus.paused) => "Paused",
    GuideSession(status: SessionStatus.completed) => "Completed",
  };

  Color statusColor(BuildContext context) => switch (session.status) {
    SessionStatus.ready => Theme.of(context).colorScheme.primary,
    SessionStatus.playing => Theme.of(context).colorScheme.tertiary,
    SessionStatus.paused => Theme.of(context).colorScheme.secondary,
    SessionStatus.completed => Theme.of(context).colorScheme.primaryFixed,
  };

  Future<void> refresh() => reload(session.sessionId).then((next) {
    if (next == null) return;
    onAction(GuideSessionAction.replace(next));
  }).catchError((_) {});

  @override
  Widget build(BuildContext context) => Card(
    onPressed: () => onAction(GuideSessionAction.open(session.sessionId)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(session.guideName),
        Text(subtitleFor(session)).muted,
        Row(
          children: [
            Icon(Icons.play_circle, color: statusColor(context)),
            Gap(8),
            Text(statusLabel),
            Gap(8),
            Text("$progressPercent%"),
          ],
        ),
        if (isStale)
          OutlineButton(
            onPressed: () => refresh(),
            child: Text("Refresh"),
          ),
      ],
    ).pad(12),
  );
}

extension GuideSessionStyle on GuideSession {
  String get ownerDisplayName => ownerName.trim().isEmpty ? "Unknown Owner" : ownerName.trim();
}

class SessionMath {
  const SessionMath._();

  static int progress(int current, int total) => total <= 0
      ? 0
      : ((current.clamp(0, total) / total) * 100).round();
}
```
