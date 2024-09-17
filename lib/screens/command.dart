import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../fn/voice_command.dart';
import '../fn/voice_recognition.dart';
import 'settings.dart'; // Import the settings screen
import '../classes/settings.dart';
//import 'package:voice_authentication/voice_authentication.dart'; // Import the voice authentication package

class CommandsScreen extends StatefulWidget {
  @override
  _CommandsScreenState createState() => _CommandsScreenState();
}

class _CommandsScreenState extends State<CommandsScreen> {
  stt.SpeechToText _speech = stt.SpeechToText();
  final Settings settings = Settings();
  bool _isListening = false;
  bool _isListeningForCancel = false;
  String _commandText = '';
  String _cancelCommandText = '';
  bool _isVoiceRecognition = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) => print('Speech status: $status'),
      onError: (error) => print('Speech error: $error'),
    );
    if (available) {
      setState(() {
        _isListening = true;
      });
      _speech.listen(onResult: (val) {
        setState(() {
          _commandText = val.recognizedWords;
        });
      });
    } else {
      setState(() => _isListening = false);
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() {
      _isListening = false;
    });
    print("command voice: $_commandText");
    setVoiceCmdActivate(_commandText);
  }

  void _startListeningForCancel() async {
    bool available = await _speech.initialize(
      onStatus: (status) => print('Speech status: $status'),
      onError: (error) => print('Speech error: $error'),
    );
    if (available) {
      setState(() {
        _isListeningForCancel = true;
      });
      _speech.listen(onResult: (val) {
        setState(() {
          _cancelCommandText = val.recognizedWords;
        });
      });
    } else {
      setState(() => _isListeningForCancel = false);
    }
    print("command cancel voice: $_commandText");
    setVoiceCmdCancel(_commandText);
  }

  void _stopListeningForCancel() {
    _speech.stop();
    setState(() {
      _isListeningForCancel = false;
    });
    print("cancel command voice: $_cancelCommandText");
    setVoiceCmdCancel(_cancelCommandText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Commands'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsScreen()),
            );
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Voice Commands',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: Text('Allow voice recognition'),
              value: _isVoiceRecognition,
              onChanged: (newValueVoice) async {
                setState(() {
                  _isVoiceRecognition = newValueVoice;
                });
                await allowVoiceRecognition(newValueVoice);
                if (newValueVoice) {
                  // Add user to permitted list using voice authentication
              //    await VoiceAuthentication().addUserToPermittedList();
                }
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isListening ? _stopListening : _startListening,
                  child: Text(_isListening ? 'Stop Listening' : 'Start Listening'),
                ),
                if (!_isListening)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text('Activation Command'),
                  ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isListeningForCancel ? _stopListeningForCancel : _startListeningForCancel,
                  child: Text(_isListeningForCancel ? 'Stop Listening' : 'Cancel Command'),
                ),
                if (!_isListeningForCancel)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text('Cancel Command'),
                  ),
              ],
            ),
            SizedBox(height: 20),
            if (_commandText.isNotEmpty)
              Text(
                'Recognized Command: $_commandText',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            if (_cancelCommandText.isNotEmpty)
              Text(
                'Recognized Cancel Command: $_cancelCommandText',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}