// Dialer configuration model allowing style overrides and a fallback callback.
import 'package:flutter/cupertino.dart';

import 'export.dart';

class DialerConfig {
  final List<DialerSlot> items; // Order: 1,2,3,4,Top
  final void Function(int index)? onItemPressed; // Fallback callback per slot
  final TextStyle? labelTextStyle; // Label style override
  final Color? actionBackgroundColor; // Circle background color
  final double? actionRadius; // Circle radius
  // FAB customization overrides
  final Color? fabColor;
  final IconData? fabIcon;

  // Dialer overlay customization overrides
  final Color? dialBorderColor; // defaults to fabColor or red
  final Color? dialOverlayColor; // defaults to Colors.black26
  final double? dialBlurSigma; // defaults to 10.0

  const DialerConfig({
    required this.items,
    this.onItemPressed,
    this.labelTextStyle,
    this.actionBackgroundColor,
    this.actionRadius,
    this.fabColor,
    this.fabIcon,
    this.dialBorderColor,
    this.dialOverlayColor,
    this.dialBlurSigma,
  });
}
