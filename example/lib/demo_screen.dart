import 'package:bottom_nav_speed_dial/source/export.dart';
import 'package:flutter/material.dart';
import 'package:bottom_nav_speed_dial/bottom_nav_speed_dial.dart';

class DemoScreen extends StatefulWidget {
  const DemoScreen({super.key});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  int _index = 0;

  final List<Widget> _screens = <Widget>[
    const Center(child: Text('Home Screen')),
    const Center(child: Text('Calendar Screen')),
    const Center(child: Text('Appointments Screen')),
    const Center(child: Text('My Profile Screen')),
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavSpeedDial(
      centerFabIndex: 2,
      currentIndex: _index,
      onIndexChanged: (i) => setState(() => _index = i),
      screens: _screens,
      // Dialer configuration model: five items and styling
      dialerConfig: DialerConfig(
        items: const [
          DialerSlot(
            label: 'Dialer Item 1',
            icon: Icon(Icons.medical_services, size: 16, color: Colors.white),
          ),
          DialerSlot(
            label: 'Dialer Item 2',
            icon: Icon(Icons.event_available, size: 16, color: Colors.white),
          ),
          DialerSlot(
            label: 'Dialer Item 3',
            icon: Icon(Icons.calendar_today, size: 16, color: Colors.white),
          ),
          DialerSlot(
            label: 'Dialer Item 4',
            icon: Icon(Icons.photo, size: 16, color: Colors.white),
          ),
          DialerSlot(
            label: 'Top Dialer Item',
            icon: Icon(Icons.receipt_long, size: 16, color: Colors.white),
          ),
        ],
        onItemPressed: (i) => debugPrint('Dialer item index tapped: $i'),
        labelTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
        actionBackgroundColor: Colors.black,
        actionRadius: 28,
      ),
      bottomNavBackgroundColor: Colors.white,
      selectedItemColor: Colors.deepOrange,
      unselectedItemColor: Colors.grey,
      bottomNavType: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
      bottomItems: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_outlined),
          activeIcon: Icon(Icons.calendar_month),
          label: 'Calendar',
        ),
        // center gap for FAB
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt_outlined),
          activeIcon: Icon(Icons.list_alt),
          label: 'Appointments',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'My Profile',
        ),
      ],
    );
  }
}
