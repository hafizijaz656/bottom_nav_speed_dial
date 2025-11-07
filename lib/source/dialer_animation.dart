import 'package:flutter/material.dart';

/// Encapsulates dialer animations and controller lifecycle.
class DialerAnimation {
  final AnimationController controller;
  final Animation<double> fade;
  final Animation<double> scale;
  final Animation<double> fabRotation;

  DialerAnimation._({
    required this.controller,
    required this.fade,
    required this.scale,
    required this.fabRotation,
  });

  /// Factory to create the dialer animation set.
  static DialerAnimation create({
    required TickerProvider vsync,
    Duration duration = const Duration(milliseconds: 250),
  }) {
    final AnimationController controller =
        AnimationController(vsync: vsync, duration: duration);
    final CurvedAnimation curve = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    final Animation<double> fade = Tween<double>(begin: 0, end: 1).animate(curve);
    final Animation<double> scale = Tween<double>(begin: 0.9, end: 1).animate(curve);
    final Animation<double> fabRotation = Tween<double>(begin: 0, end: 45 / 360).animate(curve);

    return DialerAnimation._(
      controller: controller,
      fade: fade,
      scale: scale,
      fabRotation: fabRotation,
    );
  }

  void dispose() {
    controller.dispose();
  }
}