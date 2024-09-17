import 'package:flutter/material.dart';
import '../fn/location.dart';
import '../fn/sms.dart';
import '../classes/settings.dart';
import '../fn/recording.dart';
import '../fn/whatsapp.dart';
import '../fn/telegram.dart';
import '../fn/app.dart';
import '../fn/voice_command.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'command.dart'; // Import the commands screen

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final Settings settings = Settings();
  bool _isLocation = false;
  bool _isRecordingPermission = false;
  bool _viaWhatsApp = false;
  bool _viaSMS = false;
  bool _viaTelegram = false;
  bool _viaAPP = false;

  // For speech recognition
  stt.SpeechToText _speech = stt.SpeechToText(); // Initialize here
  bool _isListening = false;
  String _commandText = '';

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _speech = stt.SpeechToText();
  }

  // Asynchronous method to load settings
  Future<void> _loadSettings() async {
    await settings.loadSettings();
    setState(() {
      _isLocation = settings.isLocationPermission;
      _isRecordingPermission = settings.isRecordingPermission;
      _viaWhatsApp = settings.viaWhatsApp;
      _viaSMS = settings.viaSMS;
      _viaTelegram = settings.viaTelegram;
      _viaAPP = settings.viaAPP;
    });
  }

  void _handleCommand(String command) {
    if (command.contains('location')) {
      setState(() {
        _isLocation = !_isLocation;
      });
      allowLocation(context, _isLocation);
    }  else if (command.contains('recording')) {
      setState(() {
        _isRecordingPermission = !_isRecordingPermission;
      });
      allowVoiceRecording(context, _isRecordingPermission);
    } else if (command.contains('WhatsApp')) {
      setState(() {
        _viaWhatsApp = !_viaWhatsApp;
      });
      allowWhatsApp(_viaWhatsApp);
    } else if (command.contains('SMS')) {
      setState(() {
        _viaSMS = !_viaSMS;
      });
      allowSMS(_viaSMS);
    } else if (command.contains('Telegram')) {
      setState(() {
        _viaTelegram = !_viaTelegram;
      });
      allowTelegram(_viaTelegram);
    } else if (command.contains('app')) {
      setState(() {
        _viaAPP = !_viaAPP;
      });
      allowAPP(_viaAPP);
    }
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
            SizedBox(height: 20),
            SwitchListTile(
              title: Text('Allow location'),
              value: _isLocation,
              onChanged: (newValueLocalization) async {
                setState(() {
                  _isLocation = newValueLocalization;
                });
                await allowLocation(context, newValueLocalization);
              },
            ),

            SwitchListTile(
              title: Text('Allow recording'),
              value: _isRecordingPermission,
              onChanged: (newValueRecording) async {
                setState(() {
                  _isRecordingPermission = newValueRecording;
                });
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
                await allowAPP(newViaAPP);
              },
            ),
            SizedBox(height: 20),


            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CommandsScreen()),
                );
              },
              child: Text('Go to Commands'),
            ),
          ],
        ),
      ),
    );
  }
}