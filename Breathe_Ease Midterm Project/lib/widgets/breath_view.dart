import 'dart:math' as Math;
import 'package:flutter/material.dart';
import '../models/breathing_cycle.dart';

class BreathView extends StatefulWidget {
  final BreathingCycle cycle;
  final bool autoStart;
  final VoidCallback onToggle; // parent toggles run state

  const BreathView({
    super.key,

    required this.cycle,
    this.autoStart = false,
    required this.onToggle,
  });

  @override
  State<BreathView> createState() => _BreathViewState();
}

class _BreathViewState extends State<BreathView> with TickerProviderStateMixin {
  AnimationController? _breathController;
  Animation<double>? _scaleAnim;
  AnimationController? _dotsController;

  String phaseText = 'Ready';
  bool showPhaseText = true;
  Duration totalDuration = const Duration(seconds: 7);

  @override
  void initState() {
    super.initState();
    _setupControllers();
    if (widget.autoStart) {
      _start();
    }
  }

  @override
  void didUpdateWidget(covariant BreathView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cycle != widget.cycle) {
      _setupControllers();
    }
    if (widget.autoStart && !(_breathController?.isAnimating ?? false)) {
      _start();
    } else if (!widget.autoStart && (_breathController?.isAnimating ?? false)) {
      _stop();
    }
  }

  void _setupControllers() {
    _breathController?.dispose();
    _dotsController?.dispose();

    totalDuration = Duration(
      seconds: widget.cycle.inhaleSec + widget.cycle.holdSec + widget.cycle.exhaleSec,
    );

    final totalSeconds = totalDuration.inSeconds > 0 ? totalDuration.inSeconds : 1;

    _breathController = AnimationController(vsync: this, duration: totalDuration);

    final items = <TweenSequenceItem<double>>[];
    if (widget.cycle.inhaleSec > 0) {
      items.add(TweenSequenceItem(
        tween: Tween(begin: 0.75, end: 1.25).chain(CurveTween(curve: Curves.easeOut)),
        weight: widget.cycle.inhaleSec.toDouble(),
      ));
    }
    if (widget.cycle.holdSec > 0) {
      items.add(TweenSequenceItem(
        tween: ConstantTween(1.25),
        weight: widget.cycle.holdSec.toDouble(),
      ));
    }
    if (widget.cycle.exhaleSec > 0) {
      items.add(TweenSequenceItem(
        tween: Tween(begin: 1.25, end: 0.75).chain(CurveTween(curve: Curves.easeIn)),
        weight: widget.cycle.exhaleSec.toDouble(),
      ));
    }
    if (items.isEmpty) {
      items.add(TweenSequenceItem(tween: ConstantTween(1.0), weight: 1.0));
    }

    _scaleAnim = TweenSequence<double>(items).animate(_breathController!);

    final inhaleEnd = widget.cycle.inhaleSec / totalSeconds;
    final holdEnd = (widget.cycle.inhaleSec + widget.cycle.holdSec) / totalSeconds;

    _breathController!.addListener(() {
      final t = _breathController!.value;
      if (t < inhaleEnd) {
        _setPhase('Breathe In', true);
      } else if (t < holdEnd) {
        _setPhase(widget.cycle.holdSec > 0 ? 'Hold' : 'Breathe Out', true);
      } else {
        _setPhase('Breathe Out', true);
      }
    });

    _breathController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _breathController!.forward(from: 0.0); // continuous
      }
    });

    _dotsController = AnimationController(vsync: this, duration: totalDuration);
    _dotsController!.addStatusListener((s) {
      if (s == AnimationStatus.completed) _dotsController!.forward(from: 0.0);
    });

    if (widget.autoStart) {
      _start();
    }
  }

  void _setPhase(String text, bool show) {
    if (phaseText != text || showPhaseText != show) {
      setState(() {
        phaseText = text;
        showPhaseText = show;
      });
    }
  }

  @override
  void dispose() {
    _breathController?.dispose();
    _dotsController?.dispose();
    super.dispose();
  }

  void _start() {
    _breathController?.forward(from: 0.0);
    _dotsController?.forward(from: 0.0);
    // DO NOT call widget.onToggle() here (parent controls run state)
  }

  void _stop() {
    _breathController?.stop();
    _dotsController?.stop();
    // DO NOT call widget.onToggle() here
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.cycle.color;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          AnimatedCrossFade(
            firstChild:
            _buildStatusCard('Ready to breathe', 'Tap Start to begin your session', color, false),
            secondChild:
            _buildStatusCard('Relax', 'Follow the circle and breathe slowly', color, true),
            crossFadeState:
            (_breathController?.isAnimating ?? false) ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 400),
          ),

          const SizedBox(height: 28),

          // Fixed breathing area (single core circle only)
          Expanded(
            child: Center(
              child: AnimatedBuilder(
                animation: Listenable.merge(_listenableMerge()),
                builder: (context, child) {
                  final scale = _scaleAnim?.value ?? 1.0;
                  final dotsValue = _dotsController?.value ?? 0.0;

                  // breathing area size
                  const double boxSize = 300.0;
                  final center = boxSize / 2;

                  return SizedBox(
                    width: boxSize,
                    height: boxSize,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Only one core circle that scales (the actual breathing indicator)
                        Transform.scale(
                          scale: scale,
                          child: Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: color.withOpacity(0.16), width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: color.withOpacity(0.08),
                                  blurRadius: 12 * scale,
                                  spreadRadius: 2 * scale,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(Icons.self_improvement, size: 36, color: Colors.black54),
                            ),
                          ),
                        ),

                        // Dots around the core inside the same box (positions relative to box center)
                        ...List.generate(8, (i) {
                          final start = (i * 0.06).clamp(0.0, 1.0);
                          final end = ((i * 0.06) + 0.25).clamp(0.0, 1.0);
                          double t = 0.0;
                          if (dotsValue >= start && dotsValue <= end) {
                            t = (dotsValue - start) / (end - start);
                          } else if (dotsValue > end) {
                            t = 1.0;
                          } else {
                            t = 0.0;
                          }
                          final dotScale = 0.6 + 0.6 * t * scale;
                          final opacity = (0.2 + 0.8 * t).clamp(0.0, 1.0);
                          final angle = (i / 8) * 2 * Math.pi;
                          final radius = (boxSize * 0.45) * (scale); // relative radius within box

                          final dx = center + radius * Math.cos(angle) - 8;
                          final dy = center + radius * Math.sin(angle) - 8;

                          return Positioned(
                            left: dx,
                            top: dy,
                            child: Opacity(
                              opacity: opacity,
                              child: Transform.scale(
                                scale: dotScale,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: color.withOpacity(0.95),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),

                        // phase text
                        Positioned(
                          bottom: 8,
                          child: AnimatedOpacity(
                            opacity: showPhaseText ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 400),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.95),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
                              ),
                              child: Text(
                                phaseText,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Listenable> _listenableMerge() {
    final list = <Listenable>[];
    if (_breathController != null) list.add(_breathController!);
    if (_dotsController != null) list.add(_dotsController!);
    return list;
  }

  Widget _buildStatusCard(String title, String subtitle, Color color, bool active) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: active ? color.withOpacity(0.12) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: active ? color.withOpacity(0.16) : Colors.transparent),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.14), shape: BoxShape.circle),
            child: Icon(Icons.self_improvement, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(color: Colors.black54, fontSize: 13)),
            ]),
          ),
          AnimatedOpacity(
            opacity: active ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: Icon(active ? Icons.check_circle : Icons.circle, color: color),
          ),
        ],
      ),
    );
  }
}
