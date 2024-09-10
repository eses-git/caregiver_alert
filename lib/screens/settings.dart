import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../fn/settings.dart';
class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isZipped = false; // Initial value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'My Awesome App Settings',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20), // Add some spacing

            // Display the switch
            SwitchListTile(
              title: Text('Allow location with zip'),
              value: _isZipped,
              onChanged: (newValue) async {
                setState(() {
                  _isZipped = newValue;
                });

                // Call the function to handle location permissions
                await allowLocalization(context, _isZipped);
              },
            ),
          ],
        ),
      ),
    );
  }

}