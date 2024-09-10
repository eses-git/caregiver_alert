import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme.dart';
import 'app_localizations.dart';
import 'screens/privacy_policy_screen.dart';
import 'screens/language_selection_screen.dart';
import 'main_page.dart';
import 'fn/initialization.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: AppLocalizations.supportedLanguages.map(Locale.new),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      title: 'Hello World App',
    //  theme: MyDarkTheme.themeData,
      home: const InitialScreenDecider(),

    );
  }
}

class InitialScreenDecider extends StatelessWidget {
  const InitialScreenDecider({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkAgreementStatus(),
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          if (!snapshot.data! || snapshot.data==false) {
            // If agreement not accepted, show LanguageSelectionScreen
           return PrivacyPolicyScreen();
            // return LanguageSelectionScreen();
          } else {
            // If agreement accepted, show MainPage
            return MainPage();
          }
        } else {
          return PrivacyPolicyScreen();
        //  print('5555555555555555');
          // Default to LanguageSelectionScreen if unable to fetch preferences
        //  return LanguageSelectionScreen();
        }
      },
    );
  }

  Future<bool> _checkAgreementStatus() async {
    //here will be initializations backend functions
     // function responsable for initialization of phone generating keys, creatung database etc

    final prefs = await SharedPreferences.getInstance();
    bool? agreedToPrivacyPolicy = prefs.getBool('agreedToPrivacyPolicy');
    print('Agreed to Privacy Policy----------: $agreedToPrivacyPolicy');

    if (agreedToPrivacyPolicy == null) {
      // If the agreement status is not set, navigate to LanguageSelectionScreen
      return false;
    }
    return agreedToPrivacyPolicy;
  }
}


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello World App'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => SystemNavigator.pop(),
          ),
        ],
      ),
      body: const Center(child: Text('Hello World')),
    );
  }
}

class MyDarkTheme {
  static ThemeData get themeData => ThemeData(
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      color: Colors.black,
      titleTextStyle: TextStyle(color: Colors.green, fontSize: 20),
    ),
    textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.green,
      textTheme: ButtonTextTheme.primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.black,
      ),
    ),
  );
}