import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Scrolling App',
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scrolling Demo'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CardPage()),
                );
              },
              child: Text('Show Cards'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListViewPage()),
                );
              },
              child: Text('Show ListView'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GridViewPage()),
                );
              },
              child: Text('Show GridView'),
            ),
          ],
        ),
      ),
    );
  }
}

// 1. Card Page
class CardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cards Example'),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        children: [
          Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text('First Card'),
            ),
          ),
          Card(
            color: Colors.yellow[100],
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text('Second Card'),
            ),
          ),
          Card(
            elevation: 10,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text('Third Card with Shadow'),
            ),
          ),
        ],
      ),
    );
  }
}

// 2. ListView Page
class ListViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ListView Example'),
        backgroundColor: Colors.orange,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.person),
            title: Text('John Doe'),
            subtitle: Text('Student'),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Jane Smith'),
            subtitle: Text('Teacher'),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Mike Johnson'),
            subtitle: Text('Developer'),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Sarah Wilson'),
            subtitle: Text('Designer'),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Tom Brown'),
            subtitle: Text('Manager'),
          ),
        ],
      ),
    );
  }
}

// 3. GridView Page
class GridViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GridView Example'),
        backgroundColor: Colors.purple,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          Container(
            color: Colors.red[100],
            margin: EdgeInsets.all(10),
            child: Center(child: Text('Item 1')),
          ),
          Container(
            color: Colors.blue[100],
            margin: EdgeInsets.all(10),
            child: Center(child: Text('Item 2')),
          ),
          Container(
            color: Colors.green[100],
            margin: EdgeInsets.all(10),
            child: Center(child: Text('Item 3')),
          ),
          Container(
            color: Colors.yellow[100],
            margin: EdgeInsets.all(10),
            child: Center(child: Text('Item 4')),
          ),
          Container(
            color: Colors.orange[100],
            margin: EdgeInsets.all(10),
            child: Center(child: Text('Item 5')),
          ),
          Container(
            color: Colors.pink[100],
            margin: EdgeInsets.all(10),
            child: Center(child: Text('Item 6')),
          ),
        ],
      ),
    );
  }
}