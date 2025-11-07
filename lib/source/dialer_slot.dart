// Dialer slot structure
import 'package:flutter/material.dart';

class DialerSlot {
  final String label;
  final Widget icon;
  final VoidCallback? onTap;

  const DialerSlot({required this.label, required this.icon, this.onTap});
}