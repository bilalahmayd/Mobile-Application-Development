import 'package:flutter/material.dart';

/// A simple OOP model for breathing cycles demonstrating:
/// - constructor
/// - named parameters
/// - getters / setters
/// - method(s)
class BreathingCycle {
  String name;
  int inhaleSec;
  int holdSec;
  int exhaleSec;
  Color color;

  BreathingCycle({
    required this.name,
    required this.inhaleSec,
    required this.holdSec,
    required this.exhaleSec,
    this.color = Colors.teal,
  });

  // total duration computed property (getter)
  int get totalSec => inhaleSec + holdSec + exhaleSec;

  // convenience method to describe cycle
  String describe() => '$name — $inhaleSec/$holdSec/$exhaleSec (s)';

  // setters with validation
  set setInhale(int s) {
    if (s > 0 && s < 60) inhaleSec = s;
  }
}
