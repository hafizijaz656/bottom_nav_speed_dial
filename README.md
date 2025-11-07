# Bottom Nav Speed Dial

Combine a Bottom Navigation Bar with a Speed Dial menu in one elegant, easy-to-use widget. This package lets you attach quick-action shortcuts directly within your bottom navigation experience, keeping your UI clean while enabling fast access to common actions.

![Demo Screenshot](assets/Screenshot_20251107_180008.png)

## Features
- Speed Dial + Bottom Navigation combined
- Highly customizable colors, icons, labels, and overlay
- Smooth, polished open/close animations
- Works with Material 3 and Dark/Light themes
- Simple integration with existing `IndexedStack` screens

## Installation
Add the package to your `pubspec.yaml`:

```
dependencies:
  bottom_nav_speed_dial: ^0.1.0 # Replace with the latest on pub.dev
```

Then run:

```
flutter pub get
```

## Import
Depending on your usage, import either the main widget or the models as well:

```
import 'package:bottom_nav_speed_dial/bottom_nav_speed_dial.dart';
// If you use DialerConfig or DialerSlot directly:
import 'package:bottom_nav_speed_dial/source/export.dart';
```

## Quick Start
```
BottomNavSpeedDial(
  screens: const [
    HomeScreen(),
    CalendarScreen(),
    AppointmentsScreen(),
    ProfileScreen(),
  ],
  bottomItems: const [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendar'),
    BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Appointments'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'My Profile'),
  ],
  // Optional: centerFabIndex defaults to 2. The widget inserts a center gap
  // if the items length is even, so you typically pass your normal items.
  dialerConfig: DialerConfig(
    fabColor: Colors.red,
    fabIcon: Icons.add,
    dialBorderColor: Colors.red,
    dialOverlayColor: Colors.black26,
    dialBlurSigma: 10.0,
    labelTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 11,
      fontWeight: FontWeight.w700,
    ),
    actionBackgroundColor: Colors.black,
    actionRadius: 28,
    items: const [
      DialerSlot(label: 'Dialer Item 1', icon: Icon(Icons.image)),
      DialerSlot(label: 'Dialer Item 2', icon: Icon(Icons.image)),
      DialerSlot(label: 'Dialer Item 3', icon: Icon(Icons.image)),
      DialerSlot(label: 'Dialer Item 4', icon: Icon(Icons.image)),
      DialerSlot(label: 'Top Dialer Item', icon: Icon(Icons.image)),
    ],
    // Optional: central callback if you prefer index-based handling (0..4)
    onItemPressed: (index) {
      // Implement your action routing here
    },
  ),
)
```

## Configuration
Bottom navigation and dialer are separately configurable to suit your UI.

### Bottom Navigation
- `screens` (`List<Widget>`) – pages shown via `IndexedStack`.
- `bottomItems` (`List<BottomNavigationBarItem>`) – items for the navigation bar.
- `currentIndex` (`int?`) – externally manage the selected index.
- `onIndexChanged` (`ValueChanged<int>?`) – callback when user taps a tab.
- `bottomNavBackgroundColor` (`Color?`) – background color of the bar.
- `selectedItemColor` (`Color?`), `unselectedItemColor` (`Color?`).
- `bottomNavType` (`BottomNavigationBarType?`).
- `showUnselectedLabels` (`bool?`).
- `centerFabIndex` (`int`) – index reserved for the FAB gap (default: 2). The widget prevents selecting this index and will auto-insert a center gap if the items length is even.

### DialerConfig
Use `DialerConfig` to customize the dialer’s look and behavior:

- `items` (`List<DialerSlot>`) – up to five items; fewer are auto-padded, more are truncated.
- `onItemPressed` (`ValueChanged<int>?`) – optional index-based handler (0..4).
- `labelTextStyle` (`TextStyle?`) – label styling above dialer buttons.
- `actionBackgroundColor` (`Color?`) – color of dialer action circles.
- `actionRadius` (`double?`) – radius of dialer action circles.
- `fabColor` (`Color?`) – override FAB color.
- `fabIcon` (`IconData?`) – override FAB icon.
- `dialBorderColor` (`Color?`) – ring border color for the dialer layers.
- `dialOverlayColor` (`Color?`) – overlay color behind the dialer (with blur).
- `dialBlurSigma` (`double?`) – overlay blur intensity.

### DialerSlot
Each slot contains the label and icon for an action plus an optional tap handler:

```
const DialerSlot(
  label: 'Dialer Item 1',
  icon: Icon(Icons.image),
  // Optional per-item handler. If omitted, `onItemPressed` is used.
)
```

## Behavior Notes
- Screens length must match the original `bottomItems` length.
- When the items length is even, a center placeholder is inserted to reserve the FAB gap; selection of that index is automatically disabled.
- The dialer always renders five positions (top + four lower). Missing items are padded with placeholders to avoid index errors.
- `onItemPressed` uses the following mapping: `0` and `1` bottom row (left/right), `2` and `3` middle row (left/right), `4` top.

## Example App
An example app is included in `example/`. Run it with:

```
cd example
flutter run
```

## Contributing
Issues, feature requests, and pull requests are welcome. Please open an issue if you encounter a bug or have an idea to improve the package. We’re open for collaboration.


## Contact
- Email: hafizijaz656@gmail.com
- Instagram: @hafizijaz1996
- Website: https://hafiz-ijaz-ul-hassan.web.app/

## License
This package is licensed under the MIT License. See `LICENSE` for details.



