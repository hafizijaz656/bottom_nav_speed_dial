library bottom_nav_speed_dial;

import 'dart:ui';
import 'package:flutter/material.dart';
import 'source/export.dart';

class BottomNavSpeedDial extends StatefulWidget {
  const BottomNavSpeedDial({
    super.key,
    required this.bottomItems,
    required this.screens,
    this.centerFabIndex = 2,
    this.currentIndex,
    this.onIndexChanged,
    this.bottomNavBackgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.bottomNavType,
    this.showUnselectedLabels,
    this.dialerConfig,
  });

  // Bottom Navigation customization
  final List<Widget> screens; // required list of screens for IndexedStack
  final List<BottomNavigationBarItem> bottomItems;
  final int centerFabIndex;
  final int? currentIndex;
  final ValueChanged<int>? onIndexChanged;
  final Color? bottomNavBackgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final BottomNavigationBarType? bottomNavType;
  final bool? showUnselectedLabels;

  // Dialer actions customization
  final DialerConfig? dialerConfig; // optional dialer configuration model

  @override
  State<BottomNavSpeedDial> createState() => _BottomNavSpeedDialState();
}

class _BottomNavSpeedDialState extends State<BottomNavSpeedDial>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> innerScaffoldKey = GlobalKey<ScaffoldState>();

  int _currentIndex = 0;
  bool isOnAddButtonOpen = false;
  String? _configError;
  late final DialerAnimation _dialAnim;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex ?? 0;
    _dialAnim = DialerAnimation.create(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _dialAnim.dispose();
    super.dispose();
  }

  /// Normalize bottom items to guarantee a center gap for the FAB when count is even.
  /// If the provided list has an even length, insert a placeholder at the midpoint.
  List<BottomNavigationBarItem> _normalizedBottomItems() {
    final List<BottomNavigationBarItem> items =
        List<BottomNavigationBarItem>.from(widget.bottomItems);
    if (items.length.isEven) {
      final int mid = items.length ~/ 2;
      items.insert(
        mid,
        const BottomNavigationBarItem(
          icon: SizedBox(),
          label: '',
        ),
      );
    }
    return items;
  }

  /// Build effective screens aligned to normalized bottom items, inserting a center placeholder as needed.
  List<Widget> _normalizedScreens(int targetLength, int centerIndex) {
    // Validate provided screens length against original bottomItems count.
    final int providedLen = widget.screens.length;
    final int itemsLen = widget.bottomItems.length;
    if (providedLen != itemsLen) {
      _configError =
          'Configuration error: screens length ($providedLen) must match bottomItems length ($itemsLen).';
    } else {
      _configError = null;
    }

    // If error, return a list of error widgets sized to targetLength with a center placeholder.
    if (_configError != null) {
      return List<Widget>.generate(targetLength, (i) {
        if (i == centerIndex) return const SizedBox.shrink();
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _configError!,
              style: const TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        );
      });
    }

    // No error: construct normalized screens.
    final List<Widget> provided = List<Widget>.from(widget.screens);
    if (provided.length == targetLength) {
      return provided;
    }
    if (provided.length == targetLength - 1) {
      final List<Widget> withCenter = <Widget>[];
      for (int i = 0; i < targetLength; i++) {
        if (i == centerIndex) {
          withCenter.add(const SizedBox.shrink());
        } else {
          final int sourceIndex = i < centerIndex ? i : i - 1;
          withCenter.add(provided[sourceIndex]);
        }
      }
      return withCenter;
    }
    // Fallback: repeat first screen to fill length (should not generally occur)
    return List<Widget>.generate(
        targetLength,
        (i) => i == centerIndex
            ? const SizedBox.shrink()
            : provided[i % provided.length]);
  }

  void onTabTapped(int index) {
    if (widget.onIndexChanged != null) {
      widget.onIndexChanged!(index);
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  void didUpdateWidget(covariant BottomNavSpeedDial oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != null &&
        widget.currentIndex != oldWidget.currentIndex) {
      _currentIndex = widget.currentIndex!;
    }
  }

  void onAddButtonTapped() {
    setState(() {
      isOnAddButtonOpen = !isOnAddButtonOpen;
      if (isOnAddButtonOpen) {
        _dialAnim.controller.forward();
      } else {
        _dialAnim.controller.reverse();
      }
    });
  }

  // Build five dialer slots (top + 4 others). If fewer provided, fill placeholders.
  List<DialerSlot> _buildDialerSlots() {
    final DialerConfig? cfg = widget.dialerConfig;
    List<DialerSlot> base = <DialerSlot>[];
    if (cfg != null) {
      base = List<DialerSlot>.from(cfg.items);
    }
    if (base.isEmpty) {
      _configError = 'At least 1 dialer item is required.';
    } else {
      _configError = null;
    }
    // Ensure exactly five slots: truncate excess and pad missing.
    if (base.length > 5) {
      base = base.sublist(0, 5);
    }
    while (base.length < 5) {
      base.add(const DialerSlot(label: '', icon: SizedBox.shrink()));
    }
    return base;
  }

  @override
  Widget build(BuildContext context) {
    // Normalize bottom items to ensure center gap when count is even.
    final List<BottomNavigationBarItem> items = _normalizedBottomItems();
    final int centerIndex = items.length ~/ 2; // Always center for FAB

    // Prevent selecting the center index programmatically.
    if (_currentIndex == centerIndex) {
      _currentIndex = centerIndex > 0
          ? centerIndex - 1
          : (centerIndex + 1 < items.length ? centerIndex + 1 : 0);
    }

    final List<Widget> screens = _normalizedScreens(items.length, centerIndex);

    return Scaffold(
      key: innerScaffoldKey,
      body: Stack(
        children: [
          IndexedStack(index: _currentIndex, children: screens),

          /// Blurred Add Menu Overlay with animation
          IgnorePointer(
            ignoring: !isOnAddButtonOpen,
            child: FadeTransition(
              opacity: _dialAnim.fade,
              child: Container(
                height: MediaQuery.of(context).size.height,
                color: widget.dialerConfig?.dialOverlayColor ?? Colors.black26,
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: widget.dialerConfig?.dialBlurSigma ?? 10.0,
                    sigmaY: widget.dialerConfig?.dialBlurSigma ?? 10.0,
                  ),
                  child: ScaleTransition(
                    scale: _dialAnim.scale,
                    child: _buildDialer(context),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _floatingButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Theme(
        data: ThemeData(splashColor: Colors.transparent),
        child: BottomNavigationBar(
          backgroundColor: widget.bottomNavBackgroundColor ?? Colors.white,
          showUnselectedLabels: widget.showUnselectedLabels ?? false,
          items: items,
          type: widget.bottomNavType ?? BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          selectedItemColor: widget.selectedItemColor ?? Colors.black,
          unselectedItemColor: widget.unselectedItemColor,
          onTap: (index) {
            if (index != centerIndex && !isOnAddButtonOpen) {
              onTabTapped(index);
            }
          },
          elevation: 10,
        ),
      ),
    );
  }

  Widget _floatingButton(BuildContext context) {
    return Container(
      height: 70,
      width: 70,
      margin: const EdgeInsets.only(top: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      child: GestureDetector(
        onTap: onAddButtonTapped,
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: widget.dialerConfig?.fabColor ?? Colors.red,
            borderRadius: BorderRadius.circular(80),
          ),
          child: RotationTransition(
            turns: _dialAnim.fabRotation,
            child: Icon(widget.dialerConfig?.fabIcon ?? Icons.add,
                color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildDialer(BuildContext context) {
    final List<DialerSlot> slots = _buildDialerSlots();
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        _dialerLayer(height: 160, width: 310),
        _dialerLayer(height: 100, width: 190),
        _dialerButtonsRow1(slots[0], slots[1]),
        _dialerButtonsRow2(slots[2], slots[3]),
        _dialerButtonsTop(slots[4]),
      ],
    );
  }

  Widget _dialerLayer({required double height, required double width}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(200),
          topRight: Radius.circular(200),
        ),
        border: Border.all(
          color: widget.dialerConfig?.dialBorderColor ??
              widget.dialerConfig?.fabColor ??
              Colors.red,
        ),
      ),
    );
  }

  Widget _dialerButtonsTop(DialerSlot top) {
    return Container(
      height: 220,
      alignment: Alignment.topCenter,
      width: 60,
      child: _dialerButtonCustom(
        top.label,
        top.icon,
        top.onTap ??
            (widget.dialerConfig?.onItemPressed != null
                ? () => widget.dialerConfig!.onItemPressed!(4)
                : null),
      ),
    );
  }

  Widget _dialerButtonsRow1(DialerSlot left, DialerSlot right) {
    return Container(
      height: 185,
      margin: const EdgeInsets.symmetric(horizontal: 70),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _dialerButtonCustom(
            left.label,
            left.icon,
            left.onTap ??
                (widget.dialerConfig?.onItemPressed != null
                    ? () => widget.dialerConfig!.onItemPressed!(0)
                    : null),
          ),
          _dialerButtonCustom(
            right.label,
            right.icon,
            right.onTap ??
                (widget.dialerConfig?.onItemPressed != null
                    ? () => widget.dialerConfig!.onItemPressed!(1)
                    : null),
          ),
        ],
      ),
    );
  }

  Widget _dialerButtonsRow2(DialerSlot left, DialerSlot right) {
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _dialerButtonCustom(
            left.label,
            left.icon,
            left.onTap ??
                (widget.dialerConfig?.onItemPressed != null
                    ? () => widget.dialerConfig!.onItemPressed!(2)
                    : null),
          ),
          _dialerButtonCustom(
            right.label,
            right.icon,
            right.onTap ??
                (widget.dialerConfig?.onItemPressed != null
                    ? () => widget.dialerConfig!.onItemPressed!(3)
                    : null),
          ),
        ],
      ),
    );
  }

  // Customizable dialer button: uses provided child as label, plus circle action.
  Widget _dialerButtonCustom(String label, Widget icon, VoidCallback? onTap) {
    return Column(
      children: [
        Text(
          label,
          style: widget.dialerConfig?.labelTextStyle ??
              const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
          textAlign: TextAlign.center,
        ),
        if (icon is! SizedBox) ...{
          const SizedBox(height: 5),
          GestureDetector(
            onTap: onTap == null
                ? null
                : () {
                    setState(() => isOnAddButtonOpen = false);
                    _dialAnim.controller.reverse();
                    onTap();
                  },
            child: CircleAvatar(
              radius: widget.dialerConfig?.actionRadius ?? 28,
              backgroundColor:
                  widget.dialerConfig?.actionBackgroundColor ?? Colors.black,
              child: icon,
            ),
          ),
        }
      ],
    );
  }
}



