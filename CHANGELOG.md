## 2.5.1
* Fix Checkbox state inversion

## 2.5.0
* Checkbox List Tiles now support tristate
* BREAKING Checkbox list tiles onChanged bool is now bool?

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
