import 'package:flutter/material.dart';

void main() => runApp(const QuizApp());

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Flashcards Quiz',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const QuizHomePage(),
    );
  }
}

class QuizHomePage extends StatefulWidget {
  const QuizHomePage({super.key});

  @override
  State<QuizHomePage> createState() => _QuizHomePageState();
}

class _QuizHomePageState extends State<QuizHomePage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  List<Map<String, String>> _flashcards = [
    {'question': 'What is Flutter?', 'answer': 'An open-source UI toolkit by Google.'},
    {'question': 'What language is used in Flutter?', 'answer': 'Dart.'},
    {'question': 'What is a Widget?', 'answer': 'The basic building block of a Flutter UI.'},
  ];

  int learnedCount = 0;
  bool _showAnswer = false;

  Future<void> _refreshList() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _flashcards = [
        {'question': 'What is State in Flutter?', 'answer': 'Data that can change during the app’s lifetime.'},
        {'question': 'What is Hot Reload?', 'answer': 'A feature to quickly see code changes in real-time.'},
        {'question': 'What is a StatefulWidget?', 'answer': 'A widget that maintains state.'},
      ];
      learnedCount = 0;
    });
  }

  void _addNewQuestion() {
    final newItem = {
      'question': 'New question at ${DateTime.now().toLocal()}',
      'answer': 'This was added dynamically!'
    };
    _flashcards.insert(0, newItem);
    _listKey.currentState!.insertItem(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshList,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              expandedHeight: 150,
              flexibleSpace: FlexibleSpaceBar(
                title: Text("Learned $learnedCount of ${_flashcards.length}"),
                background: Container(
                  color: Colors.blueAccent.withOpacity(0.4),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: AnimatedList(
                key: _listKey,
                initialItemCount: _flashcards.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index, animation) {
                  final item = _flashcards[index];
                  return SizeTransition(
                    sizeFactor: animation,
                    child: Dismissible(
                      key: Key(item['question']!),
                      background: Container(color: Colors.green, child: const Icon(Icons.check, color: Colors.white)),
                      onDismissed: (direction) {
                        setState(() {
                          _flashcards.removeAt(index);
                          learnedCount++;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Marked "${item['question']}" as learned')),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        elevation: 4,
                        child: ListTile(
                          title: Text(item['question']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: _showAnswer
                              ? Text(item['answer']!)
                              : const Text("Tap to reveal answer..."),
                          onTap: () {
                            setState(() => _showAnswer = !_showAnswer);
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewQuestion,
        child: const Icon(Icons.add),
      ),
    );
  }
}