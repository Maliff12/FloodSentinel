import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String dbPath = await _getDatabasePath();
    print('Database path: $dbPath'); // Debug print the database path

    try {
      Database database = await openDatabase(
        dbPath,
        version: 9, // Incremented version to match changes
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
      return database;
    } catch (e) {
      print('Error initializing database: $e');
      rethrow;
    }
  }

  Future<String> _getDatabasePath() async {
    String databasesPath = await getDatabasesPath();
    return path.join(databasesPath, 'user_database.db');
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        email TEXT NOT NULL,
        password TEXT NOT NULL,
        referenceCode TEXT,
        departmentName TEXT,
        fullName TEXT,
        phoneNumber TEXT, -- New Field
        streetNumber TEXT,
        streetName TEXT,
        district TEXT,
        state TEXT,
        age TEXT,
        gender TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE departments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        referenceCode TEXT NOT NULL UNIQUE,
        departmentName TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE complaints (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        report TEXT NOT NULL,
        imagePath TEXT
      )
    ''');

    // Insert initial departments
    await db.insert('departments', {'referenceCode': 'P123', 'departmentName': 'Police Department'});
    await db.insert('departments', {'referenceCode': 'B123', 'departmentName': 'Fire Department'});
    // Add more departments as needed
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 5) {
      // Check if the 'departmentName' column already exists before adding it
      List<Map<String, dynamic>> columns = await db.rawQuery('PRAGMA table_info(users)');
      bool columnExists = columns.any((column) => column['name'] == 'departmentName');

      if (!columnExists) {
        await db.execute('''
          ALTER TABLE users ADD COLUMN departmentName TEXT
        ''');
      }
    }
    
    // Add a new column for phoneNumber if it's not present
    if (oldVersion < 9) {
      List<Map<String, dynamic>> columns = await db.rawQuery('PRAGMA table_info(users)');
      bool columnExists = columns.any((column) => column['name'] == 'phoneNumber');

      if (!columnExists) {
        await db.execute('''
          ALTER TABLE users ADD COLUMN phoneNumber TEXT
        ''');
      }
    }
  }

  Future<int> registerUser(
    String username,
    String email,
    String password,
    String referenceCode,
    String departmentName,
    String fullName,
    String phoneNumber, // New Field
    String streetNumber,
    String streetName,
    String district,
    String state,
    String age,
    String gender,
  ) async {
    final db = await database;
    var res = await db.insert(
      'users',
      {
        'username': username,
        'email': email,
        'password': password,
        'referenceCode': referenceCode,
        'departmentName': departmentName,
        'fullName': fullName,
        'phoneNumber': phoneNumber, // New Field
        'streetNumber': streetNumber,
        'streetName': streetName,
        'district': district,
        'state': state,
        'age': age,
        'gender': gender,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return res;
  }

  Future<String> getDepartmentName(String referenceCode) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query('departments',
        where: 'referenceCode = ?', whereArgs: [referenceCode], limit: 1);
    if (result.isNotEmpty) {
      return result.first['departmentName'];
    } else {
      return '';
    }
  }

  Future<bool> isUserAuthority(String username, String password) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query('users',
        where: 'username = ? AND password = ? AND referenceCode != ?', whereArgs: [username, password, '']);
    return result.isNotEmpty;
  }

  Future<bool> isCommunityUser(String username, String password) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query('users',
        where: 'username = ? AND password = ? AND referenceCode = ?', whereArgs: [username, password, '']);
    return result.isNotEmpty;
  }

  Future<int> insertComplaint(String report, String? imagePath) async {
    final db = await database;
    var res = await db.insert(
      'complaints',
      {
        'report': report,
        'imagePath': imagePath,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return res;
  }

  Future<List<Map<String, dynamic>>> fetchComplaints() async {
    final db = await database;
    List<Map<String, dynamic>> complaints = await db.query('complaints');
    return complaints;
  }

  Future<bool> updatePasswordByEmail(String email, String newPassword) async {
    final db = await database;
    int count = await db.update(
      'users',
      {'password': newPassword},
      where: 'email = ?',
      whereArgs: [email],
    );
    return count > 0;
  }

  // New method to fetch user data by username
  Future<Map<String, dynamic>> getUserData(String username) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return result.first;
    } else {
      // Handle the case when no user is found
      return {};
    }
  }

  // New method to update user profile
  Future<bool> updateUserProfile(
    String username,
    String email,
    String fullName,
    String phoneNumber, // New Field
    String streetNumber,
    String streetName,
    int age,
    String gender,
    String referenceCode,
    String state,
    String district,
  ) async {
    final db = await database;
    int count = await db.update(
      'users',
      {
        'email': email,
        'fullName': fullName,
        'phoneNumber': phoneNumber, // New Field
        'streetNumber': streetNumber,
        'streetName': streetName,
        'age': age.toString(),
        'gender': gender,
        'referenceCode': referenceCode,
        'state': state,
        'district': district,
      },
      where: 'username = ?',
      whereArgs: [username],
    );
    return count > 0;
  }
}
