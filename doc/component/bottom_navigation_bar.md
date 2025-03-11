# Bottom Navigation Bar

The bottom navigation bar components provide a way to create navigation bars with icon-based tabs at the bottom of a screen. There are two main components in this system: `ButtonBar` and `IconTab`.

## Overview

- **ButtonBar**: A container for displaying a row of selectable icon tabs
- **IconTab**: A individual tab with icon, optional label, and built-in selected state styling

ButtonBar handles the overall layout and selection state, while IconTab renders individual navigation items with appropriate styling based on the selected state.

## ButtonBar

ButtonBar displays a row of IconTab instances evenly spaced within a bar. It keeps track of which tab is currently selected and renders each tab with its appropriate selected state.

### Constructor

```dart
const ButtonBar({
  Key? key,
  int selectedIndex = 0,
  required List<IconTab> buttons
});
```

### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `selectedIndex` | `int` | The index of the currently selected tab |
| `buttons` | `List<IconTab>` | The list of icon tabs to display in the bar |

## IconTab

IconTab represents an individual tab in the bottom navigation bar. It displays an icon with optional selection styling and can be configured with both a normal and selected icon state.

### Constructor

```dart
const IconTab({
  Key? key,
  required IconData icon,
  IconData? selectedIcon,
  String? label,
  VoidCallback? onPressed
});
```

### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `icon` | `IconData` | The icon to display (when not selected) |
| `selectedIcon` | `IconData?` | Optional alternate icon to display when selected (if null, uses `icon`) |
| `label` | `String?` | Optional text label to display with the icon |
| `onPressed` | `VoidCallback?` | Function to call when the tab is pressed |

## Usage Examples

### Basic Bottom Navigation Bar

```dart
ButtonBar(
  selectedIndex: _currentIndex,
  buttons: [
    IconTab(
      icon: Icons.home,
      selectedIcon: Icons.home_filled,
      label: "Home",
      onPressed: () => setState(() => _currentIndex = 0),
    ),
    IconTab(
      icon: Icons.search,
      selectedIcon: Icons.search_filled,
      label: "Search",
      onPressed: () => setState(() => _currentIndex = 1),
    ),
    IconTab(
      icon: Icons.notifications,
      selectedIcon: Icons.notifications_filled,
      label: "Notifications",
      onPressed: () => setState(() => _currentIndex = 2),
    ),
    IconTab(
      icon: Icons.person,
      selectedIcon: Icons.person_filled,
      label: "Profile",
      onPressed: () => setState(() => _currentIndex = 3),
    ),
  ],
)
```

### In a Scaffold

```dart
Scaffold(
  body: _pages[_currentIndex], // Array of page widgets
  bottomNavigationBar: ButtonBar(
    selectedIndex: _currentIndex,
    buttons: [
      IconTab(
        icon: Icons.dashboard,
        label: "Dashboard",
        onPressed: () => setState(() => _currentIndex = 0),
      ),
      IconTab(
        icon: Icons.calendar_today,
        label: "Calendar",
        onPressed: () => setState(() => _currentIndex = 1),
      ),
      IconTab(
        icon: Icons.settings,
        label: "Settings",
        onPressed: () => setState(() => _currentIndex = 2),
      ),
    ],
  ),
)
```

## Implementation Details

- When a tab is selected, it automatically displays in the theme's primary color
- The ButtonBar component is built on top of the Bar component
- The selection state is passed to tabs through a Pylon context value

## Notes

- ButtonBar automatically evenly spaces the tabs using `MainAxisAlignment.spaceEvenly`
- Currently, labels are only used for accessibility and are not displayed visually by default
- It's recommended to keep the number of tabs between 3-5 for best usability
