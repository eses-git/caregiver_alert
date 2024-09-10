import 'package:flutter/material.dart';
import 'screens/settings.dart';

class CustomFloatingActionButton extends FloatingActionButton {
  final VoidCallback onPressed;
  final Color backgroundColor;
  final double elevation;

  CustomFloatingActionButton({
    required this.onPressed,
    required this.backgroundColor,
    required this.elevation,
    required Widget child,
  }) : super(
    onPressed: onPressed,
    backgroundColor: backgroundColor,
    elevation: elevation,
    child: child,
    // Set the desired height
  );

// You can add any additional custom properties or methods here if needed
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My App'),
      ),
      body: Center(
        child: Text('Welcome to my app!'),
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () {
          // Navigate to the settings screen
          Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
        },
        backgroundColor: Colors.blue,
        elevation: 9.0,
        child: Icon(Icons.settings),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}



void main() {
  runApp(MaterialApp(home: MainPage()));
}
