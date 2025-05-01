import 'package:busybee/JSON/task.dart';
import 'package:busybee/JSON/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabseHelper {
  // Singleton instance
  String current_user="";
  static final DatabseHelper _instance = DatabseHelper._internal();
  factory DatabseHelper() => _instance;
  DatabseHelper._internal();

  final String databasename = 'madproject.db';
  Users? currentUser;
  bool logedin = false;
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databasename);
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create users table
    await db.execute('''
      CREATE TABLE users(
        userid INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        userEmail TEXT NOT NULL,
        userPassword TEXT NOT NULL
      )''');

    // Create tasks table
    await db.execute('''
      CREATE TABLE tasks(
        taskId INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        isCompleted INTEGER NOT NULL,
        dueDate TEXT,
        userId INTEGER,
        FOREIGN KEY (userId) REFERENCES users(userid)
      )''');
  }

  Future<bool> signIn(Users user) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ? AND userPassword = ?',
      whereArgs: [user.username, user.userPassword],
    );

    if (result.isNotEmpty) {
      currentUser = Users.fromMap(result.first);
      logedin = true;
      
      // Save user ID to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('currentUserId', currentUser!.userid!);
      saveUsername(currentUser!.username);
      savePassword(currentUser!.userPassword);
      saveEmail(currentUser!.userEmail!);
      return true;
    }
    return false;
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('currentUserId');
    currentUser = null;
    logedin = false;
  }

  Future<String> signUp(Users user) async {
    final db = await database;
    try {
      final existingUsers = await db.query(
        'users',
        where: 'username = ?',
        whereArgs: [user.username],
      );

      if (existingUsers.isNotEmpty) return "0";

      final result = await db.insert('users', user.toMap());
      return result.toString();
    } catch (e) {
      return "Error: $e";
    }
  }

  Future<void> reloadCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('currentUserId');
    
    if (userId != null) {
      final db = await database;
      final result = await db.query(
        'users',
        where: 'userid = ?',
        whereArgs: [userId]
      );
      
      if (result.isNotEmpty) {
        currentUser = Users.fromMap(result.first);
        logedin = true;
      }
    }
  }

  Future<void> UpdateUserData(String username, String email, String password) async {
    final db = await database;
    //print("Updating user data: $username, $email, $password");
    await db.update(
      'users',
      {
        'username': username,
        'userEmail': email,
        'userPassword': password,
      },
      where: 'userid = ?',
      whereArgs: [currentUser!.userid],
    );
    saveUsername(username);
    savePassword(password);
    saveEmail(email);
  }
  Future<int> addTask(Task task) async {
    final db = await database;
    return await db.insert('tasks', task.toMap());
  }

  Future<List<Task>> gettask(Users user) async {
    final db = await database;
    final maps = await db.query(
      'tasks',
      where: 'userId = ?',
      whereArgs: [user.userid],
    );
    return List.generate(maps.length, (i) => Task.fromMap(maps[i]));
  }

  Future<int> updateTask(Task task) async {
    final db = await database;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'taskId = ?',
      whereArgs: [task.taskId],
    );
  }

  Future<int> deleteTask(String taskId) async {
    final db = await database;
    return await db.delete(
      'tasks',
      where: 'taskId = ?',
      whereArgs: [taskId],
    );
  }

  // Future<void> printAllUsers() async {
  //   final db = await database;
  //   final result = await db.query('users');
  //   print('All users: $result');
  // }

  // Future<void> printAllTasks() async {
  //   final db = await database;
  //   final result = await db.query('tasks');
  //   print('All tasks: $result');
  // }

  Future<void> deleteOldDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databasename);
    await deleteDatabase(path);
    //print('Old database deleted');
  }

  // Keep original method names with typos as they were
  Future<Users?> getCurrentUser(String usrname) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [usrname],
    );
    //print('Current user: $result'); 
    return result.isNotEmpty ? Users.fromMap(result.first) : null;
  }

  void saveUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
  }
  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }
  void savePassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('password', password);
  }
  Future<String?> getPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('password');
  }
  void saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
  }
  Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }
}