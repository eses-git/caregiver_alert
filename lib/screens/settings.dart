import 'package:flutter/material.dart';
import '../fn/location.dart';
import '../fn/sms.dart';
import '../fn/voice_recognition.dart'; // Adjust import if not needed
import '../classes/settings.dart';
import '../fn/recording.dart';
import '../fn/whatsapp.dart';
import '../fn/telegram.dart';
import '../fn/app.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final Settings settings = Settings();
  bool _isLocation = false;
  bool _isVoiceRecognition =false;
  bool _isRecordingPermission =false;
  bool _viaWhatsApp = false;
  bool _viaSMS = false;
  bool _viaTelegram = false;
  bool _viaAPP =false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // Asynchronous method to load settings
  Future<void> _loadSettings() async {
    await settings.loadSettings();
    setState(() {
      _isLocation = settings.isLocationPermission;
      _isVoiceRecognition = settings.isVoiceRecognition;
      _isRecordingPermission = settings.isRecordingPermission;
      _viaWhatsApp = settings.viaWhatsApp;
      _viaSMS = settings.viaSMS;
      _viaTelegram = settings.viaTelegram;
      _viaAPP = settings.viaAPP;
    });
  }

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


            SwitchListTile(
            title: Text('Allow location'),
            value: _isLocation,
            onChanged: (newValueLocalization) async {
            setState(() {
              _isLocation = newValueLocalization;
            });
                // Update the setting in secure storage
                await allowLocation(context, newValueLocalization);
              },
            ),
            SwitchListTile(
              title: Text('Allow voice recogition'),
              value: _isVoiceRecognition,
              onChanged: (newValueVoice) async {
                setState(() {
                  _isVoiceRecognition = newValueVoice;
                });
                // Update the setting in secure storage
                await allowVoiceRecognition(newValueVoice);
              },
            ),
            SwitchListTile(
              title: Text('Allow recording'),
              value: _isRecordingPermission,
              onChanged: (newValueRecording) async {
                setState(() {
                  _isRecordingPermission = newValueRecording;
                });
                // Update the setting in secure storage
                await allowVoiceRecording(context, newValueRecording);
              },
            ),
            SwitchListTile(
              title: Text('Message via WhatsApp?'),
              value: _viaWhatsApp,
              onChanged: (newViaWhatsApp) async {
                setState(() {
                  _viaWhatsApp = newViaWhatsApp;
                });
                // Update the setting in secure storage
                await allowWhatsApp(newViaWhatsApp);
              },
            ),
            SwitchListTile(
              title: Text('Message via SMS?'),
              value: _viaSMS,
              onChanged: (newViaSMS) async {
                setState(() {
                  _viaSMS = newViaSMS;
                });
                // Update the setting in secure storage
                await allowSMS(newViaSMS);
              },
            ),
            SwitchListTile(
              title: Text('Message via Telegram?'),
              value: _viaTelegram,
              onChanged: (newViaTelegram) async {
                setState(() {
                  _viaTelegram = newViaTelegram;
                });
                // Update the setting in secure storage
                await allowTelegram(newViaTelegram);
              },
            ),
            SwitchListTile(
              title: Text('Message via Application?'),
              value: _viaAPP,
              onChanged: (newViaAPP) async {
                setState(() {
                  _viaAPP = newViaAPP;
                });
                // Update the setting in secure storage
                await allowAPP(newViaAPP);
              },
            ),
          ],
        ),
      ),
    );
  }
}
