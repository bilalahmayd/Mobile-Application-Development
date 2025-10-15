import 'package:flutter/material.dart';

void main() {
  runApp(TravelGuideApp());
}

class TravelGuideApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel Guide',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: MainScaffold(),
    );
  }
}

class MainScaffold extends StatefulWidget {
  @override
  _MainScaffoldState createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0; // 0: Home, 1: List, 2: About
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // Controller for the destination TextField on Home screen
  final TextEditingController _destinationController = TextEditingController();

  void _onSelectIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.of(context).pop(); // close drawer when an item is selected
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        destinationController: _destinationController,
      ),
      DestinationsListScreen(),
      AboutScreen(),
    ];

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Travel Guide'),
      ),
      drawer: _buildDrawer(),
      body: SafeArea(child: screens[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'List'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
        ],
      ),
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.teal),
            child: Center(
              child: Text('Travel Guide', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            selected: _selectedIndex == 0,
            onTap: () => _onSelectIndex(0),
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Destinations'),
            selected: _selectedIndex == 1,
            onTap: () => _onSelectIndex(1),
          ),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('About'),
            selected: _selectedIndex == 2,
            onTap: () => _onSelectIndex(2),
          ),
        ],
      ),
    );
  }
}

// ------------------ Home Screen ------------------
class HomeScreen extends StatelessWidget {
  final TextEditingController destinationController;
  HomeScreen({required this.destinationController});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Travel image (network image so you don't need to add assets)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80',
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 12),

          // Welcome container
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Welcome to Travel Guide — your simple companion to explore top destinations and landmarks around the world!',
              style: TextStyle(fontSize: 16),
            ),
          ),

          SizedBox(height: 12),

          // RichText slogan (bold + colorful)
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: 'Explore', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal)),
                TextSpan(text: ' the ', style: TextStyle(fontSize: 20, color: Colors.black87)),
                TextSpan(text: 'World', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
                TextSpan(text: ' with Us', style: TextStyle(fontSize: 20, color: Colors.black87)),
              ],
            ),
          ),

          SizedBox(height: 12),

          // TextField for destination name
          TextField(
            controller: destinationController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter a destination',
              prefixIcon: Icon(Icons.travel_explore),
            ),
          ),

          SizedBox(height: 12),

          // Buttons row
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    final text = destinationController.text.trim();
                    final message = text.isEmpty ? 'No destination entered' : 'Searching for "$text"';
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                    // For beginners: print to console too
                    print(message);
                  },
                  child: Text('Search'),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    destinationController.clear();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Destination cleared')));
                  },
                  child: Text('Clear'),
                ),
              ),
            ],
          ),

          SizedBox(height: 20),

          // A short explanation / hint area (optional)
          Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Tip: Use the menu (or bottom navigation) to view a list of destinations and learn about famous landmarks in the About section.',
                style: TextStyle(color: Colors.grey[700]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------ List Screen ------------------
class DestinationsListScreen extends StatelessWidget {
  final List<Map<String, String>> destinations = const [
    {'name': 'Paris', 'desc': 'The City of Light — art, fashion, and the Eiffel Tower.'},
    {'name': 'Rome', 'desc': 'Ancient history, the Colosseum, and vibrant streets.'},
    {'name': 'Tokyo', 'desc': 'Blend of modern tech and traditional shrines.'},
    {'name': 'New York', 'desc': 'The city that never sleeps — skyline and culture.'},
    {'name': 'Cairo', 'desc': 'Gateway to the Pyramids and Nile River history.'},
    {'name': 'Sydney', 'desc': 'Iconic Opera House and beautiful beaches.'},
    {'name': 'Rio de Janeiro', 'desc': 'Famous for its carnival, beaches, and Christ the Redeemer.'},
    {'name': 'Istanbul', 'desc': 'Where East meets West — grand bazaars and mosques.'},
    {'name': 'Bangkok', 'desc': 'Vibrant markets, temples, and street food culture.'},
    {'name': 'Marrakesh', 'desc': 'Colourful souks, palaces, and desert excursions.'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(12),
      itemCount: destinations.length,
      separatorBuilder: (_, __) => Divider(),
      itemBuilder: (context, index) {
        final item = destinations[index];
        return ListTile(
          leading: CircleAvatar(child: Text(item['name']!.substring(0, 1))),
          title: Text(item['name']!),
          subtitle: Text(item['desc']!),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Selected ${item['name']}')));
          },
        );
      },
    );
  }
}

// ------------------ About Screen (Grid of landmarks) ------------------
class AboutScreen extends StatelessWidget {
  final List<Map<String, String>> landmarks = const [
    {
      'title': 'Eiffel Tower',
      'image': 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?auto=format&fit=crop&w=800&q=60'
    },
    {
      'title': 'Great Wall',
      'image': 'https://images.unsplash.com/photo-1549887534-0d0b6f5d7a3b?auto=format&fit=crop&w=800&q=60'
    },
    {
      'title': 'Pyramids',
      'image': 'https://images.unsplash.com/photo-1505765052493-88d51c2f0d3b?auto=format&fit=crop&w=800&q=60'
    },
    {
      'title': 'Taj Mahal',
      'image': 'https://images.unsplash.com/photo-1526481280698-1f6a38b15bde?auto=format&fit=crop&w=800&q=60'
    },
    {
      'title': 'Statue of Liberty',
      'image': 'https://images.unsplash.com/photo-1508057198894-247b23fe5ade?auto=format&fit=crop&w=800&q=60'
    },
    {
      'title': 'Machu Picchu',
      'image': 'https://images.unsplash.com/photo-1505765052493-88d51c2f0d3b?auto=format&fit=crop&w=800&q=60'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GridView.builder(
        itemCount: landmarks.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.9,
        ),
        itemBuilder: (context, index) {
          final lm = landmarks[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    lm['image']!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 6),
              Center(
                child: Text(
                  lm['title']!,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
