import 'package:flutter/material.dart';
import 'screens/settings.dart';
import 'screens/personal_data.dart';
import 'screens/contacts.dart';

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
  );
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomFloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
            },
            backgroundColor: Colors.blue,
            elevation: 9.0,
            child: Icon(Icons.settings),
          ),
          SizedBox(height: 16),
          CustomFloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => PersonalDataScreen()));
            },
            backgroundColor: Colors.green,
            elevation: 9.0,
            child: Icon(Icons.person),
          ),
          SizedBox(height: 16),
          CustomFloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ContactsScreen()));
            },
            backgroundColor: Colors.orange,
            elevation: 9.0,
            child: Icon(Icons.contacts),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

void main() {
  runApp(MaterialApp(home: MainPage()));
}