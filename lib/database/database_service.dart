import "dart:async";

import "package:sqflite/sqflite.dart";
import 'package:path_provider/path_provider.dart';

class DatabaseService {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initialize();
    return _database!;
  }

  Future<Database> _initialize () async {
    var appDir = await getApplicationDocumentsDirectory();
    var dbPath = "${appDir.path}/flutter_RMS.db";
    var database = await openDatabase(
      dbPath,
      version: 1,
      onCreate: _onCreate,
      onConfigure: _onConfigure,
      singleInstance: true,
    );
    return database;
  }

  Future _onCreate(Database db, int version) async {
    // await db.execute();
    await db.execute("""
      CREATE TABLE tables (
        id INTEGER PRIMARYKEY AUTO_INCREMENT,
        t_no INTEGER,
        is_reserved INTEGER 
      );
    """);

    await db.execute("""
      CREATE TABLE role (
        role_id INTEGER PRIMARYKEY,
        role_des TEXT
      );
    """);

    await db.execute("""
      CREATE TABLE customer (
        cus_id INTEGER PRIMARYKEY AUTO_INCREMENT,
        cus_hash TEXT
      );
    """);

    await db.execute("""
      CREATE TABLE users (
        user_id INTEGER PRIMARYKEY AUTO_INCREMENT,
        user_name TEXT,
        password TEXT,
        role_id INTEGER,
        FOREIGN KEY (role_id) REFERENCES role (role_id) ON DELETE NO ACTION ON UPDATE NO ACTION,
      );
    """);

    await db.execute("""
      CREATE TABLE food_menu (
        food_id INTEGER PRIMARYKEY AUTO_INCREMENT,
        food_nm TEXT NOT NULL,
        food_des TEXT
      );
    """);

    await db.execute("""
      CREATE TABLE order_placement (
        op_id INTEGER PRIMARYKEY AUTO_INCREMENT,
        cus_id INTEGER,
        user_id INTEGER,
        food_id INTEGER,
        qty INTEGER,
        FOREIGN KEY (cus_id) REFERENCES customer (cus_id) ON DELETE NO ACTION ON UPDATE NO ACTION,
        FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE NO ACTION ON UPDATE NO ACTION,
        FOREIGN KEY (food_id) REFERENCES food_menu (food_id) ON DELETE NO ACTION ON UPDATE NO ACTION,
      );
    """);

    await db.execute("""
      CREATE TABLE bill (
        bill_id INTEGER PRIMARYKEY AUTO_INCREMENT,
        cus_id INTEGER,
        bill_amount text,
        FOREIGN KEY (cus_id) REFERENCES customer (cus_id) ON DELETE NO ACTION ON UPDATE NO ACTION,
      );
    """);

    // // Insert initial data using batch
    // Batch batch = db.batch();
    // // ============================================================================================
    // // INSERTING INTO "USERS" TABLE
    // batch.insert('role', {"role_id": 1, "role_des": "admin"});
    // batch.insert('role', {"role_id": 2, "role_des": "manager"});
    // batch.insert('role', {"role_id": 3, "role_des": "waiter"});
    // // INSERTING INTO "FOOD MENU" TABLE
    // batch.insert('food_menu', {'food_nm': "Burger", "food_des": "Anda wala burger"});
    // batch.insert('food_menu', {'food_nm': "Pizza", "food_des": "Gol Gol Pijja"});
    // batch.insert('food_menu', {'food_nm': "Shawarma", "food_des": "Chicken Shawarma"});
    // batch.insert('food_menu', {'food_nm': "Peanut Butter", "food_des": "[Moongh-phali + Makhan] wala kala jam"});
    // // INSERTING INTO "TABLES" TABLE
    // for (int i=1; i<=10; ++i) {
    //   batch.insert('tables', {"t_no": i, "is_reserved": 0});
    // }
    // // INSERTING INTO "USERS" TABLE
    // batch.insert('users', {"user_name": "admin", "password": "admin", "role_id": 1});
    // batch.insert('users', {"user_name": "nofil", "password": "nofil", "role_id": 2});
    // batch.insert('users', {"user_name": "daniyal", "password": "daniyal", "role_id": 2});
    // batch.insert('users', {"user_name": "waseem", "password": "1waseem9", "role_id": 3});
    // batch.insert('users', {"user_name": "osama", "password": "1osama9", "role_id": 3});
    // batch.insert('users', {"user_name": "haseeb", "password": "1haseeb9", "role_id": 3});
    // batch.insert('users', {"user_name": "anwar", "password": "1anwar9", "role_id": 3});
    // batch.insert('users', {"user_name": "tauseef", "password": "1tauseef9", "role_id": 3});
    // // ============================================================================================
    // await batch.commit(noResult: true);
  }

  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  // ====================================================================
  //                      ALL METHODS TO USE FOR DB
  // ====================================================================
  Future<Map<String, dynamic>?> authenticateUser(String username, String password) async {
    print("authenticateUser");
    List<Map<String, dynamic>> users = await _database!.rawQuery('''
      SELECT * FROM users WHERE user_name = ? AND password = ?
    ''', [username, password]);
    if (users.isNotEmpty) {
      return users.first;
    } else {
      return null;
    }
  }

  void openDatabaseConnection() {}
}