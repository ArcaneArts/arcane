## 3.1.6
* Added DateTime & DateTimeRange extensions for easier date manipulation

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
