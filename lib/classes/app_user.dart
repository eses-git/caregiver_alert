import 'package:sqflite/sqflite.dart';

class AppUser {
  final String userId;
  final String name;
  final String email;
  final String phone;
  final DateTime dateCreation;
  final String appAppId; // Foreign key reference
  final String publicKey;

  AppUser({
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.dateCreation,
    required this.appAppId,
    required this.publicKey,
  });

  // Function to retrieve an AppUser by userId
  static Future<AppUser?> getAppUserById(String userId, Database database) async {
    final List<Map<String, dynamic>> maps = await database.query(
      'appUser',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    if (maps.isNotEmpty) {
      return AppUser(
        userId: maps[0]['userId'],
        name: maps[0]['name'],
        email: maps[0]['email'],
        phone: maps[0]['phone'],
        dateCreation: DateTime.parse(maps[0]['dateCreation']),
        appAppId: maps[0]['app_appId'],
        publicKey: maps[0]['publicKey'],
      );
    } else {
      return null;
    }
  }
  // Method to update user by userId
  static Future<void> updateAppUser(AppUser user, Database db) async {
    await db.update(
      'appUser',
      user.toMap(),
      where: 'userId = ?',  // Specify the condition to update by userId
      whereArgs: [user.userId],
    );
    print("User updated successfully: ${user.userId}");
  }
  // Function to insert an AppUser into the database
  static Future<void> insertAppUser(AppUser appUser, Database database) async {
    await database.insert('appUser', appUser.toMap());
  }

  // Helper method to convert AppUser object to a map
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'phone': phone,
      'dateCreation': dateCreation.toIso8601String(),
      'app_appId': appAppId,
      'publicKey': publicKey,
    };
  }

}
