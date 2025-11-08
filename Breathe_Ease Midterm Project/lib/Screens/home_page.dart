import 'package:flutter/material.dart';
import '../widgets/breath_view.dart';
import '../models/breathing_cycle.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Example cycles to pick from (OOP model usage)
  final List<BreathingCycle> cycles = [
    BreathingCycle(name: 'Relax (4-6)', inhaleSec: 4, holdSec: 0, exhaleSec: 6, color: Colors.teal),
    BreathingCycle(name: 'Box (4-4-4)', inhaleSec: 4, holdSec: 4, exhaleSec: 4, color: Colors.purple),
    BreathingCycle(name: 'Calm (3-3-3)', inhaleSec: 3, holdSec: 3, exhaleSec: 3, color: Colors.indigo),
  ];

  int selectedIndex = 0;
  bool isRunning = false;

  void onStartStop() {
    setState(() => isRunning = !isRunning);
  }

  void onNextCycle() {
    setState(() => selectedIndex = (selectedIndex + 1) % cycles.length);
  }

  void onPrevCycle() {
    setState(() => selectedIndex = (selectedIndex - 1 + cycles.length) % cycles.length);
  }

  @override
  Widget build(BuildContext context) {
    final cycle = cycles[selectedIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('BreatheEase'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'About',
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showAboutDialog(
                context: context,
                applicationName: 'BreatheEase',
                applicationVersion: '1.0',
                children: const [Text('Simple breathing guide demonstrating Flutter animations and OOP.')],
              );
            },
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // small header / chosen cycle row
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  IconButton(icon: const Icon(Icons.chevron_left), onPressed: onPrevCycle),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(cycle.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text('Inhale ${cycle.inhaleSec}s • Hold ${cycle.holdSec}s • Exhale ${cycle.exhaleSec}s',
                            style: const TextStyle(fontSize: 13, color: Colors.black54)),
                      ],
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.chevron_right), onPressed: onNextCycle),
                ],
              ),
            ),

            // animated breathing view
            Expanded(
              child: BreathView(
                cycle: cycle,
                autoStart: isRunning,
                onToggle: onStartStop,
              ),
            ),

            // control buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    onPressed: onStartStop,
                    icon: Icon(isRunning ? Icons.pause : Icons.play_arrow),
                    label: Text(isRunning ? 'Pause' : 'Start'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        // quick reset: stop then start to restart cycle visuals
                        isRunning = false;
                      });
                    },
                    icon: const Icon(Icons.replay),
                    label: const Text('Reset'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
