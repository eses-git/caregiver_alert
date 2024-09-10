import 'package:sqflite/sqflite.dart';

class AppSettings {
  final int id;
  final String appUserId; // Foreign key reference
  final String appAppId; // Foreign key reference
  final int isVoiceRecognition;
  final int isLocationPermission;
  final int isRecordingPermission;
  final int viaWhatsApp;
  final int viaSMS;
  final int viaTelegram;
  final int viaAPP;
  final DateTime lastUpdate;
  final String voiceCmdActivate;
  final String voiceCmdCancel;

  AppSettings({
    required this.id,
    required this.appUserId,
    required this.appAppId,
    required this.isVoiceRecognition,
    required this.isLocationPermission,
    required this.isRecordingPermission,
    required this.viaWhatsApp,
    required this.viaSMS,
    required this.viaTelegram,
    required this.viaAPP,
    required this.lastUpdate,
    required this.voiceCmdActivate,
    required this.voiceCmdCancel,
  });

  // Function to retrieve AppSettings by ID
  static Future<AppSettings?> getAppSettingsById(int settingsId, Database database) async {
    final List<Map<String, dynamic>> maps = await database.query(
      'appSettings',
      where: 'id = ?',
      whereArgs: [settingsId],
    );

    if (maps.isNotEmpty) {
      return AppSettings(
        id: maps[0]['id'],
        appUserId: maps[0]['app_userId'],
        appAppId: maps[0]['app_appId'],
        isVoiceRecognition: maps[0]['isVoiceRecognition'],
        isLocationPermission: maps[0]['isLocationPermission'],
        isRecordingPermission: maps[0]['isRecordingPermission'],
        viaWhatsApp: maps[0]['viaWhatsApp'],
        viaSMS: maps[0]['viaSMS'],
        viaTelegram: maps[0]['viaTelegram'],
        viaAPP: maps[0]['viaAPP'],
        lastUpdate: DateTime.parse(maps[0]['lastUpdate']),
        voiceCmdActivate: maps[0]['voiceCmdActivate'],
        voiceCmdCancel: maps[0]['voiceCmdCancel'],
      );
    } else {
      return null;
    }
  }

  // Function to insert AppSettings into the database
  static Future<void> insertAppSettings(AppSettings appSettings, Database database) async {
    await database.insert('appSettings', appSettings.toMap());
  }

  // Helper method to convert AppSettings object to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'app_userId': appUserId,
      'app_appId': appAppId,
      'isVoiceRecognition': isVoiceRecognition,
      'isLocationPermission': isLocationPermission,
      'isRecordingPermission': isRecordingPermission,
      'viaWhatsApp': viaWhatsApp,
      'viaSMS': viaSMS,
      'viaTelegram': viaTelegram,
      'viaAPP': viaAPP,
      'lastUpdate': lastUpdate.toIso8601String(),
      'voiceCmdActivate': voiceCmdActivate,
      'voiceCmdCancel': voiceCmdCancel,
    };
  }
}
