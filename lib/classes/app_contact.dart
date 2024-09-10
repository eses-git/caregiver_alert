import 'package:sqflite/sqflite.dart';

class AppContact {
  final int id;
  final String name;
  final String appUserId; // Foreign key reference
  final String number;
  final String publicKey;
  final String appAppId; // Foreign key reference

  AppContact({
    required this.id,
    required this.name,
    required this.appUserId,
    required this.number,
    required this.publicKey,
    required this.appAppId,
  });

  // Function to retrieve an AppContact by ID
  static Future<AppContact?> getAppContactById(int contactId, Database database) async {
    final List<Map<String, dynamic>> maps = await database.query(
      'appContact',
      where: 'id = ?',
      whereArgs: [contactId],
    );

    if (maps.isNotEmpty) {
      return AppContact(
        id: maps[0]['id'],
        name: maps[0]['name'],
        appUserId: maps[0]['app_userId'],
        number: maps[0]['number'],
        publicKey: maps[0]['publicKey'],
        appAppId: maps[0]['app_appId'],
      );
    } else {
      return null;
    }
  }

  // Function to insert an AppContact into the database
  static Future<void> insertAppContact(AppContact appContact, Database database) async {
    await database.insert('appContact', appContact.toMap());
  }

  // Helper method to convert AppContact object to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'app_userId': appUserId,
      'number': number,
      'publicKey': publicKey,
      'app_appId': appAppId,
    };
  }
}
