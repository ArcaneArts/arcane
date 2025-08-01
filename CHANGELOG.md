# 5.3.15
* Improved liquid ass
* Added MagicTile and MagicFab

# 5.3.14
* Bar better size text

# 5.3.13
* GPT Markdown keeps making breaking changes on minor version bumps, pegging it to 1.1.2, no more automatic upgrades for you.

# 5.3.12
* Flow stuff
* Fix blur issues 

# 5.3.11
* Sync Upstream
* Add `FancyCard`, `FancyIcon`, `FancyProgress`
* Add `ButtonPanel` and `PanelButton`
* Add `BasicCard.spanned` to make it not center align across horizon

# 5.3.10
* Liquid Glass

# 5.3.9
* Open constraint for skeletonizer to support flutter 3.32
* Open constraint for value_layout_builder to support flutter 3.32
* Upgrade Shad Deps
* REMOVED `Supplier` and `Consumer` from utils
* Ui Fixes, Sync Upstream
* FABs now work on ArcaneScreens using RenderBox Children
* Fixed Doc Code preview tab not working

# 5.3.8
* Fix md widget not following semantic versioning

# 5.3.7
* Update to FireCrud 3

# 5.3.6
* BREAKING `ImageView` removed `thumbhash` property. Use Blurhash
* BREAKING `smooth_sheets` removed along with `KeyboardSheet`
* BREAKING removed `ChatBubble`. Use `ChatScreen`
* SYNC Upstream Fixes for PhoneInput & RadioGroup
* ADD `titleText`, `subtitleText`, `leadingIcon` to `ListTile`
* ADD `ArcaneDialog` now supports a default barrier color to darken the background
* FIX Chat Screen now supports Shift+Enter to make new lines
* FIX Chat Screen message bubbles now support using Markdown as their widget without breaking intrinsics / sizing issues caused by both us with intrinsics and from gpt_markdown for using spans.
* UPDATE `toxic` min to `>=1.3.3 <2.0.0` breaking `<1.3.3` hard dependencies
* UPDATE `desktop_drop` to `>=0.5.0 <0.7.0` to support `0.6.0`
* UPDATE `flutter_blurhash` to `>=0.8.2 <1.0.0` to support `0.9.0` (performance improvements)
* UPDATE `flutter_hooks` to `>=0.21.0 <0.22.0` breaking `<0.21.0` hard dependencies (basic renames)
* REMOVE `flutter_thumbhash` as it is no longer used in `ImageView` due to flickering issues. Use blurhash

# 5.3.5
* Added new component `Markdown` which builds in the style of Arcane, and supports Latex
* Added new component `TextSelect` which allows all children to be selectable and copied in the same selection group of each other.

# 5.3.4
* Chat box fixes

# 5.3.3
* Haptics fixes

# 5.3.2
* Haptics support & linkages. Added `ArcaneHaptics` in the `ArcaneTheme.haptics` property
* Added `Arcane.hapticXXX` methods

# 5.3.1
* App id accessed via $appId

# 5.3.0
* BREAKING required appId definition in `runApp`. This is to identify & anchor a hive location for arcane and any other subpackages that need it.

# 5.2.1
* Fix Magic Init

# 5.2.0
* Magic Initializers

# 5.1.0
* Init tasks & startup added `Arcane.registerInitializer` which allows other packages to setup runners to work with arcane.
* Improvements to `Autocomplete` mostly in keybinding intents
* Made use of `expressions` package in `Formatter`
* Input Feature improvements
* Deprecated `NumberInput` in favor of `TextField` with `InputFeature.spinner()`
* Add `showValuePredicate` to `ControlledSelect`
* Add `List<TextInputFormatter> submitFormatters` to `TextField`
* Add `resizeToAvoidBottomInset` to `Scaffold` defaults to true (change in functionality)

# 5.0.2
* Chat improvements and more options

# 5.0.1
* FEAT: Added `CycleButton`

# 5.0.0
* Sync Upstream
* FEAT: You no longer need to define arcane fonts in your pubspec to get icons & fonts. They just "work" now.
* FEAT: You can now change the scroll physics & behavior in `ArcaneTheme(scrollBehavior: ArcaneScrollBehavior(physics: ClampPhysics()))` for example
* FEAT: Added `.shimmer(loading: true)` as a widget extension. Also added ArcaneTheme for shimmer defaults
* FEAT: Added `ArcaneBlurMode.disabled` to the ArcaneTheme blur modes. 
* FEAT: All `Glass` widgets now use the `ArcaneBlur` instead of the shad `SurfaceBlur`
* BREAKING: Reverted placeholder now uses Widget instead of String. (and no we dont like it this way)
* FIX: Fixed a bug where the placeholder was not being displayed correctly in some cases om multiselect
* FIX: Dialog double border issues 

# 4.0.4
* Improved sliver / box detection

# 4.0.3
* Fix `TextField` placeholder causing a vertical misalignment of the cursor when the placeholder is multiline.
* Exposed `TextField` `stackAlignment` property, changed default from `center` to `topCenter`.
* Added `DashBorderMode` and `SolidBorderMode` to alter cards & text fields borders to a dashed line

# 4.0.2
* Fix `MutableText` not wrapping correctly in button mode.
* Added `mainAxisSize` property to `MutableText` when in button mode.
* Added `onEditingComplete`, `onEditingStarted` and `labelBilder` to `MutableText`
* Made `DeleteIconButton` an actual widget instead of a function

# 4.0.1
* Fix `ArcaneScreen` header showing with empty if not defined (thanks @NextdoorPsycho)

# 4.0.0

* Added `DeleteIconButton` to make it easier to have confirming delete buttons
* Added `DeleteMenuButton` to make it easier to have confirming delete menu buttons

### Upstream Additions
* Added `TimelineAnimatable` drive and withTotalDuration and transformWithController
* Added `FutureOrBuilder`
* Added `ToggleController` and `ControlledToggle`
* Added `DecorationExtension`
* Added a `CheckboxController` for the new `ControlledCheckbox`
* Added a `ChipInputController` for the new `ControlledChipInput`
* Added a `ColorInputController` for the new `ControlledColorInput`
* Added a `DatePickerController` for the new `ControlledDatePicker`
* Added a `RadioGroupController` for the new `ControlledRadioGroup`
* Added a `SliderController` for the new `ControlledSlider`
* Added a `SwitchController` for the new `ControlledSwitch`
* Added a `StarRatingController` for the new `ControlledStarRating`
* Added a `TimePickerController` for the new `ControlledTimePicker`
* Updated `ShadcnLocalizations`
* Added a `TextEditingController` for arcane native instead of using material
* Added a `RestorableTextEditingController`
* Added a `TextInput`
* Added a `DateInput`
* Added `enabled` to `ObjectFormField`
* Added `FormEntryInterceptor`
* Added `InputPart` `EditablePart` `FormattedInputData` and `FormattedValue`
* Added `TextInputFormatters`
* Added `searchPlaceholderWidget` to `PhoneInput` to allow `searchPlaceholder` to continue being a string
* Added Controllers to control controllers... `ComponentController` `ControlledComponentData` `ControlledComponentBuilder`

### Upstream Changes
* Nuked the `Select` widget to abstract it and make it more complicated, though there are no new features
* Nuked & Rewrote `AutoComplete`
* Changed `Calendar` to be stateful
* `OverlayCompleter`, `PopoverAnchor` & `DrawerWrapper` now wraps its builder in... another builder

## 3.14.0
* Added `ArcaneColorSchemes.oled`
* Sync Upstream
  * fix: sunarya-thito#181 Input OTP do not honour onSubmitted
  * Merge pull request sunarya-thito#182 from tmjee/otp-input
  * Check if mounted before updating children
  * Merge pull request sunarya-thito#184 from cranst0n/patch-1
  * Change withOpacity to withValues as per flutter breaking change guide
  * Fix component state mark
  * Remove non-alphanumeric filter on Avatar getInitials
  * Added IgnoreForm component
  * Fix icons dialog
  * Added WidgetStateProvider and updated StatedWidget implementation
  * TextField no longer wraps material TextField
  * Fix select scroll hover color
  * Reduced surface barrier size
  * Merge branch 'arcane' into master 

## 3.13.2
* Fixed an issue breaking `ArcaneSidebar` and `NavigationScreen` Drawers & Sidebars
* Added an option to `NavigationScreen` for `sidebarWidth`, `sidebarHeader`
* Added `ArcaneSidebarHeader` widget for easily creating sidebar headers in `NavigationScreen` and `ArcaneSidebar`
* `ExpansionBarSection` now uses `SliverVisibility`
* `ButtonBar` and `NavigationType.bottomNavigationBar` now support more compacted buttons before overflowing
* Added `ColorSchemes.lightOled()` and `ColorSchemes.darkOled()` or just `ColorSchemes.oled`

## 3.13.1
* Unify blurring under arcane blur
* Added `ArcaneBlurMode.frost` as an option (falls back to backdrop blur if not on impeller)
* Added `title`, `subtitle`, `actions`, to `ArcaneScreen` to macro simple Bars

## 3.13.0
* Sync Upstream
  * Tabs, TabList, and TabPane are now based on the new TabContainer
  * Fixed InputOTP onSubmit issue
  * Added onDropFailed on Sortable
  * Bump flutter dependency version to 3.29.0
  * Added TabPane component
  * Added Expanded option on NavigationBar, NavigationRail, and Sidebar
  * Fixed missing child in FormErrorBuilder
  * Fixed Toast component state
  * Fixed Progress component assertion
  * Refactored NavigationMenu children component
  * Refactored Navigation children components
  * Internal form rework
  * Fixed carousel controller disposal
  * Added SortableDragHandle
  * Improved Sortable animation
* Added `overrideButtonContent` to `MutableText` to override the appearance of the edit button icon widget
* Added `buttonGapWidth` to `MutableText` to set the gap between the text and the button defaults to 4
* Added `sidebarHeader` to `NavigationScreen` to allow for a header in the sidebar

## 3.12.2
* Sync Upstream Fixes
  * Fix sortable gesture issue with immediate drop after drag pick up
  * Updated popover example 1 & 4
  * #178 Fix missing child in FormErrorBuilder
  * Fix toast state
  * Fix progress assertion
* Added `emnptyLeadingSpace` property to `MenuButton` & `MenuLabel` to allow changing the leading space when no icon is specified. Defaults to 16 to remain unchanged if undefined.

## 3.12.1
* Sheets return their popped value

## 3.12.0
* BREAKING: Removed `ArcaneCheckbox` & `ArcaneCheckboxState` in favor of `Checkbox` & `CheckboxState`
* Added `maxLength` to `MutableText`
* Added `Expander` widget
* Added `children` property to `ListTile` which allows it to become an expansion tile

## 3.11.2
* Fix toARGB32() for logging for now

## 3.11.1
* Reorderable Lists

## 3.11.0
* Removed Routing

## 3.10.13
* Improved the `ArcaneSidebar` spacing & how it fits into fill screens
* Added `ArcaneScreen` to docs
* Documented use on `Section` & `Collection`

## 3.10.12
* OverflowMarquee no longer just burns render / build time when offscreen or when not animating
* Sync Upstream

## 3.10.11
* Performance Improvements

## 3.10.10
* More Shaders

## 3.10.9
* ADD `logAnnounce` methods
* Routing Fixes
* A bunch of shaders arrived and we dont know what they want from us.

## 3.10.8
* Remove InjectScreenFooter from children of FillScreen & SliverScreens
* Make InjectScreenFooter a nullable pylon so it can be removed
* Default Auto Edge false in ArcaneTheme
* ADD `GutterTheme.enabled` defaulted to true in ArcaneTheme
* ADD `Collection` & `Section`

## 3.10.7
* Additional Sliver Fixes
* ADD `ArcaneScreen` which switches between `FillScreen` and `SliverScreen` based on the child provided

## 3.10.6
* Sliver Fixes

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
