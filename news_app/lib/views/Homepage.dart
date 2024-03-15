import 'package:flutter/material.dart';
import 'package:news_app/views/Tabview/favorite.dart';
import 'package:news_app/views/Tabview/homepage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0; // To track the selected index of the bottom navigation bar

  final List<Widget> _pages = [
    // Replace these with your actual screens
    MyHomePage(),
    Favorite(),

  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: _pages[_currentIndex], // Display the selected page based on the index
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Fixed icons and labels
        selectedItemColor: Colors.blue, // Color for selected item
        unselectedItemColor: Colors.grey, // Color for unselected items
        currentIndex: _currentIndex, // Set the current selected index
        onTap: _onItemTapped, // Handle item taps
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_rounded),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_rounded),
            label: 'Favorite',
          ),

        ],
      ),
    );
  }
}
