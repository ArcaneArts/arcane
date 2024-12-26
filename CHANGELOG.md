## 3.10.5
* Reduce default blur effect
* Improved debug logging

## 3.10.4
* Added .edgeBlur methods to widget extensions
* Added `EdgeTheme` to `ArcaneTheme` for `edgeBlur` defaults

## 3.10.2
* Added `ToastTheme` to `ArcaneTheme` supporting `location`, `showDuration` and `entryDuration`
* DOC example for `ArcaneShortcuts`
* FIX `SliverScreen` bar section header spacing

## 3.10.1
* Remove Gutter Logging
* ADD `defaultHeaderHeight` defaulting to 0 in arcane theme

## 3.10.0
* BREAKING: Removed the context parameter for `MenuButton` `onPressed`. If you need the menu button context specifically, use `onContextPressed` in the `MenuButton` instead. Both callbacks will fire if both are defined.
* BREAKING: Removed `Adaptive`
* BREAKING: Removed `AbstractArcaneTheme`
* BREAKING: Removed `FillScreen` & `SliverScreen` `minContentFraction` & `minContentWidth`
* ADD `GutterTheme` to `ArcaneTheme`
* ADD `ArcaneTheme.of(context)` for accessing themes
* ADD `messageGroupDistance` to `ChatTheme`
* ADD `NavigationTheme` to `ArcaneTheme` for `NavigationScreen` defaults
* ADD `ArcaneShortcuts` a much simpler shortcuts system for basic actions
* ADD `Arcane.pushReplacement` & `Arcane.pushAndRemoveUntil` for replacing routes

## 3.9.6
* Sync Upstream
* FEAT Chat message box now word wraps
* ADD ChatTheme for defaulting style in the ArcaneTheme
* ADD `SortableDragHandle` component for sortable items
* FIX TabPane sortable drop fallback
* FIX colors docs page
* FIX Chat Bubbles now show timestamps
* FIX Improved sortable animation and tab pane animation

## 3.9.5
* Sync Upstream 
* ADD `none` to `SortDirection`
* ADD `FadeScroll` effect for scrollables
* ADD `clipBehavior` prop to `SortableLayer`
* FIX `TableLayoutResult` widths & heights lists
* ADD locale for data table next, previous & columns
* ADD `TabPane`, `TabItem` for tabbed navigation

## 3.9.4
* Added InjectBarHeader

## 3.9.3
* Loosen dependency constraints

## 3.9.2
* ADD `MutableText` & `Text.mutable()` extension
* Fixed issues where the Sidebar Injector proliferated into nested sub screens via fabs, action buttons etc

## 3.9.1
* Updated Pylon to fix /#/ navigation when using ports without urlStrat
* Fixed navigator proliferation via pylons into nested sub-screens when using sidebar injectors

## 3.9.0
* Removed the use of PixelSnap widgets and replaced them with their originals
* ADD `CrossFadedTransition` for transitioning between two widgets
* Modified how chips work, removed `_ChipSuggestionItem` in chip
* Merged with upstream on master colorscheme fix
* BREAKING removed pixel snap promotion (Dont use PixelSnap.of(context) anymore)

## 3.8.3
* Upgrade pylon to include conduits

## 3.8.2
* FIX compilation on WASM caused by Pylon
* FIX Disabled the web title change on routing metadata to fix wasm builds

## 3.8.1
* ADD `ExpansionBarSection`
* DOC Sidebar Examples

## 3.8.0
* BREAKING: Removed `SidebarScreen`
* BREAKING: Overhauled `NavigationScreen`
  * Dramatically improved NavigationType.sidebar to use the new `ArcaneSidebar`
  * Drawers now also use the new `ArcaneSidebar`
  * `ArcaneSidebarExpansionToggle` now autocloses the drawer if in drawe
  * Added NavigationType.custom and `Widget Function(BuildContext, NavigationScreen, int)?customNavigationBuilder` for building it.
  * Along with `NavTab` you can now use `NavDivider` or just `NavWidget` to add custom widgets to the navigation. Currently only supported by drawers, rails, & sidebars.
  * DOC Updated `Screens` tab for new nav tabs (hiding custom)
* Updated Dependencies & Promoted UUID
* Synced & Updated Upstream
  * FIX `Sortable` not updating on data change
  * DOC reorganized several docs routes 
* FIX Spacing & Padding in `ArcaneSidebar`

## 3.7.6
* FIX failed compilation on master

## 3.7.5
* FIX `ArcaneFieldBool` checkbox tristate logic
* ADD `ArcaneSidebar` and `SidebarScreen` for creating sidebars
* DOC `SidebarScreen` example

## 3.7.4
* ADD `padding` to Checkbox, defaults to 8
* ADD `placeholder` to NumberInput
* ADD `pointerSignals` to NumberInput defaults to true
* ADD `ArcaneForm` for creating forms and mapping to models easily, WIP.
* ADD `barHeader` and `barFooter` to `Bar` which have zero padding & ignore safe area, but are in the bar's blur context
* Hide showXXX(context) methods in favor of dialog apis in arcane. You can still import these via `import 'package:arcane/generated/arcane_shadcn/src/components/menu/dropdown_menu.dart';` for example. 

## 3.7.3
* Widen dependency constraints
* Removed unused dependencies

## 3.7.2
* FIX critical issue with non arcane routes unnamed crash

## 3.7.1
* ADD Meta SEO overrides for ArcaneRoutes
* DOC Update Routing to include SEO

## 3.7.0
* ADD `GhostButtonMenu` to support ghost buttons menu launchers
* ADD `ArcaneRoute`
* FEAT ArcaneRouting is now possible with Pylon Codecs
* DOC Added documentation on routing.

## 3.6.2
* Upgrade Pylon

## 3.6.1
* Upgrade Pylon

## 3.6.0
* BREAKING: Removed Auth UI from Arcane

## 3.5.1
* Continued improvements on the new Table widget

## 3.5.0
* ADD `SignInButton` to support basically all the auth provider logos
* ADD `FontAwesomeIcons` (promoted in arcane.dart)
* ADD `ArcaneSignInProviderType` types for facebook & microsoft
* BREAKING `ArcaneAuthProvider`.`signInWithProvider` now requires `BuildContext`
* BREAKING now compatible with `arcane_auth` >=1.2.0

## 3.4.2
* Fix BasicCard onPressed not working
* Remove auth widgets

## 3.4.1
* FEAT Added `Sortable` component
* DOC Updated Total Component Count in Docs
* DOC Added `Sortable` example 1,2 & 3
* DOC Updated `Table` example 2
* DOC Updated `NumberInput` example
* FIX Changed Render Order on `Table` for frozen columns
* FIX Updated `NumberInput` design
* ADD `toDartSRC` utility on `ColorScheme` for generating Dart code from a mutated scheme

## 3.4.0
* FEAT `Table` now supports Resizing
* FEAT `ScrollableClient` + DOC
* FEAT Added support for frozen rows in `Table`
* ADD `Resizer` and `ResizerItem` for resizable panes and items
* ADD `SearchPredicate` and `SortDirection` utilities
* ADD the spin property to themes for hue spinning
* ADD the contrast property for themes to color filter themes
* ADD color filtering utilities for ColorSchemes
* FIX `CodeSnippet` copy error when context not mounted (toast)
* FIX `ColorInput` eye dropper icon size
* FIX `PhoneInput` `popupWidthConstraint` is now `flexible`
* FIX `Resizable` overhauled to better handle flexible panes
* REM File Picker example docs
* DOC `Resizable` examples
* DOC `Table` example 2

## 3.3.5
* Added the spin property to themes for hue spinning
* Added the contrast property for themes to color filter themes
* Added color filtering utilities for ColorSchemes

## 3.3.4
* Chat Screens support grouping, timestamps & fixed text styles / avatar alignment

## 3.3.3
* Expose TextField properties

## 3.3.2
* Sidebar Constraints for navigation screen

## 3.3.1
* Added Keyboard Shortcuts to the VFSView
* Lots of bugfixes with IOVFS

## 3.3.0
* Sync Upstream
* ADDED `Scaffold.backgroundColor`
* ADDED `leadingAlignment` and `trailingAlignment` to `TextField`
* BREAKING Removed `ResizablePane.flex()`, `ResizableContainerData`,
* BREAKING Renamed `Table` to `StaticTable` to use the new shadcn `Table` widget. The new `Table` widget is more unstable but offers more features.

## 3.2.3
* Added `VFS` `VFSView` and `IOVFS` for a Virtual Filesystem Viewer
* Added `FabGroup` and `context.dismissFabGroup()`

## 3.2.2
* Fix `CardCarousel`

## 3.2.1
* Pylons are automatically injected into popovers, menus, dropdowns, dialogs, drawers etc
* FEAT: Added `DialogTime` a time picker dialog
* FIX: `DialogDate` now supports `initialDate` correctly
* FIX: `DialogDateRange` now supports `initialRange` correctly
* FIX: `DialogDateMulti` now supports `initialDates` correctly
* BREAKING: `DialogDate` `initialRange` changed to `initialDate`
* BREAKING: `DialogDateMulti` `initialRange` changed to `initialDates`

## 3.2.0
* Added DateTime & DateTimeRange extensions for easier date manipulation
* Add WidgetStates to Clickable to allow control over the animation states
* Fix Color Picker HSL 
* Select Popover from anchorMinSize to anchorFixedSize
* Support Widget States on TextFields
* Add support for a `placeholderStyle` on TextFields. Defaults to a muted style or default if unspecified style.
* Added a `SearchBox` widget for easily adding search boxes
* Added a `SearchButton` widget for managing both `transactional` and `live` searches in a bar / card for example
* Bars now support injecting leading / trailing widgets in them via context using `InjectBarLeading` and `InjectBarTrailing` or just `InjectBarEnd`
* Added Arcane.closeDrawer(context) to close the topmost drawer
* Navigation Screen Tabs no longer have primary scaffolds if nav screen type is drawer
* Added `InjectScreenFooter` to inject a footer into a child `FillScreen` or `SliverScreen`
* BREAKING: `NavigationScreen`'s `NavTab.builder` is now simply `Widget Function(BuildContext context)` (footer passthrough removed)

## 3.1.5
* Added `DialogDate` a date picker dialog
* Added `DialogDateRange` a date range picker dialog
* Added `DialogDateMulti` a multi date picker dialog
* Added `leading` and `trailing` to `DialogCommand` for more customization
* Fixed dialogs spacing of buttons on the left
* Dialogs now use `PrimaryButton` for their primary buttons, not `SecondaryButton`
* Docs now include arcane localizations, fixes arcane examples in tome.

## 3.1.4
* Tables!

## 3.1.3
* Chat Screen UI

## 3.1.2
* Sync Upstream
* Make divider expands by default
* Call onChanged on number input when text field changed
* Added theme extension
* add icon gap to copyWith in collapsible
* Fixed calendar item visual for start and end selected range

## 3.1.1
* Sync Upstream

## 3.1.0
* BREAKING: Text Fields no longer require Widgets and only support Strings since we're wrapping mat text fields anyways
* Text Fields default to placeholderAlignment centerStart instead of topStart

## 3.0.9
* Added overrideSidebarGap to NavigationScreen

## 3.0.8
* Fix Options not showing in some views if InfoOption or ActionOption

## 3.0.7
* Searchable InfoOption & ActionOption widgets

## 3.0.6
* Settings InfoOption & ActionOption widgets

## 3.0.5
* Fix Dialogs using incorrect default barrier color

## 3.0.4
* Sync with shadcn_flutter (ref e1e67d5c83b11bda1377ba0fa0e08164a5e1c194) & Update Docs
* ArcaneDialogLauncher.open now returns a Future<T?> for the pop result

## 3.0.3
* New Documentation Added

## 3.0.2
* Changed default surface opacity from 0.5 to 0.66

## 3.0.1
* ContextMenu now has an enabled property (default true)
* NumberInput now has an onEditingComplete event
* Fix dialog backgrounds in themes with 100% surface opacity

## 3.0.0

### Features
* Dialogs are now in spec with shadcn
* New dialog type: DialogCommand, like a command palette
* Upgraded shadcn_flutter to latest version 0.0.21+ (ref 0c56f183241e40f19bb9fe46522daf238191ccd6)
* A documentation site is now available at https://tome.arcane.art which includes all shadcn reference + arcane.
* New widget: BasicCard which is a card with some basic in it. 
* New Widget: ArcaneArtsLogo
* New Menu Launcher Widgets: OutlineButtonMenu, TextButtonMenu, SecondaryButtonMenu, PrimaryButtonMenu to join IconButtonMenu
### Fixes
* dialog intrinsics & spacing issues
### Breaking Changes
* ArcaneThemes are now specified with `ArcaneTheme(scheme: ContrastedColorScheme.fromScheme(ColorSchemes.zinc))`
* Renamed PopupMenu to IconButtonMenu
* You need to add the fonts RadixIcons & BootstrapIcons to your pubspec.yaml (see README.md!)

## 2.5.8
* The command dialog
* The confirm text dialog

## 2.5.7
* Added scaledLeadingPadding to Checkbox widgets

## 2.5.6
* FEAT: SliverGutter

## 2.5.5
* FIX: popup menus allowing outside taps to go through
* Added .contain() widget extension for wrapping a container 

## 2.5.4
* FEAT: Image view now supports future urls and loads gracefully

## 2.5.3
* FEAT: Number field support on editing complete

## 2.5.2
* FEAT: Image View

## 2.5.1
* FIX: Checkbox state inversion

## 2.5.0
* FEAT: Checkbox List Tiles now support tristate
* BREAKING: Checkbox list tiles onChanged bool is now bool?

## 2.4.4
* Dark/light oled preset themes @NextdoorPsycho
* Upgrade dependencies

## 2.4.3
* Siderail & bar padding options

## 2.4.2
* Settings api

## 2.4.1
* Sidebars in nav screen type added

## 2.4.0
* BREAKING: Removed motion_blur shader, remove it from your pubspec.yaml

## 2.3.3
* Reinstate gutters

## 2.3.2
* Bar Actions

## 2.3.1
* Support sliver screens without headers

## 2.3.0
* BREAKING All screens need to now use FillScreen, SliverScreen or NavigationScreen
* Blur fixes
* Fab fixes
* Sizing fixes

## 2.2.6
* Fix fill in nav tabs breaking listener local position

## 2.2.5
* Added an expander screen for collapsible header bars

## 2.2.4
* Fix Safe Area on mobile
* Fix blur effect on impeller
* Motion Blur Effect Support

## 2.2.3
* Fix scrolling on macos touchpads

## 2.2.2
* BREAKING NavScreens no longer support scroll controller customization
* BREAKING: NavScreens no longer support selectedIndex or onIndexChanged as it is now managed in their state
* NavScreens now function like an IndexedStack

## 2.2.1
* BREAKING: Screen constructors support header instead of title/actions
* Pylon is now supported in popup menus
* Reused MultiSliver and adapted to allow const
* Added FabMenu widget for quickly creating popup menus

## 2.2.0
* BREAKING: Screen.slivers changed to Screen.sliver (use Screen.sliver: MultiSliver(children: []))
* BREAKING: Screen.children has been removed (use Screen.fill: ListView()/Row())
* BREAKING: NavScreen.slivers changed to NavScreen.sliver (use NavScreen.sliver: MultiSliver(children: []))
* BREAKING: NavScreen.children has been removed (use NavScreen.fill: ListView()/Row())
* Added Screen.basic() for a more scaffold-like experience
* Added Screen.list() for a more ListView-like experience
* Added Screen.listBuilder() for a more ListView.builder-like experience
* Added Screen.grid() for a more GridView-like experience
* Added Screen.gridBuilder() for a more GridView.builder-like experience
* Added Screen.custom() for a more custom sliver-like experience
* Added Screen.loading() for an easy loader experience

## 2.1.16
* Added sliver views SListView & SGridView to simplify Sliver Lists & Grids

## 2.1.15
* Floating Action Buttons
* Fixed an issue with nav screens with filled bottom bars showing in rail views
* Fixed List tiles

## 2.1.14
* Allow gutters to be disabled on scaffolds and nav tabs

## 2.1.13
* Screens & Nav Screens support fill property for regular children

## 2.1.12
* Radio Card fixes padding & border color

## 2.1.11
* Fixes

## 2.1.10
* TextFields now have autofocus

## 2.1.9
* Cards now have onPressed

## 2.1.8
* Card Carousel

## 2.1.7
* Popup menu theme fixes

## 2.1.6
* Improved List Tiles
* Docs

## 2.1.4
* Theme Fixes

## 2.1.1
* Theme Fixes

## 2.1.0
* All of shadcn_flutter without the js web hacks

## 2.0.7

* Gutters

## 1.0.1

* So many fixes

## 1.0.0

* So many things

## 0.0.1

* TODO: Describe initial release.
