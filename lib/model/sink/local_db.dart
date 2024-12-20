import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../classes/notification.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'gifts.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notifications (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        body TEXT NOT NULL,
        createdAt INTEGER NOT NULL
      )
    ''');
  }

  // Create
  Future<void> createNotification(Notification notification) async {
    final db = await database;
    await db.insert(
      'notifications',
      notification.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Read (Single Notification)
  Future<Notification?> getNotificationById(String id) async {
    final db = await database;
    final maps = await db.query(
      'notifications',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Notification.fromJson(maps.first);
    } else {
      return null; // No notification found
    }
  }

  // Read (All Notifications)
  Future<List<Notification>> getAllNotifications() async {
    final db = await database;
    final maps = await db.query('notifications');

    return List<Notification>.from(
        maps.map((map) => Notification.fromJson(map)));
  }

  // Update
  Future<void> updateNotification(Notification notification) async {
    final db = await database;
    await db.update(
      'notifications',
      notification.toJson(),
      where: 'id = ?',
      whereArgs: [notification.id],
    );
  }

  // Delete
  Future<void> deleteNotification(String id) async {
    final db = await database;
    await db.delete(
      'notifications',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Close Database
  Future<void> closeDatabase() async {
    final db = await _database;
    if (db != null) {
      await db.close();
    }
  }
}

void generateLocalDbData() async {
  final dbHelper = DatabaseHelper();

  // Create a new notification
  final notification = Notification(
    id: Uuid().v1(),
    title: 'New Message',
    body: 'You have received a new message.',
    createdAt: DateTime.now(),
  );
  await dbHelper.createNotification(notification);

  // Get all notifications
  final notifications = await dbHelper.getAllNotifications();
  print('All Notifications: $notifications');

  // Get a notification by ID
  final fetchedNotification = await dbHelper.getNotificationById('1');
  print('Fetched Notification: $fetchedNotification');

  // Update the notification
  final updatedNotification = Notification(
    id: notification.id,
    title: 'Updated Message',
    body: 'You have an updated message.',
    createdAt: notification.createdAt,
  );
  await dbHelper.updateNotification(updatedNotification);

  // Delete the notification
  await dbHelper.deleteNotification(notification.id);
}
