import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// SQLite database helper using singleton pattern
/// Manages all database operations for courses and todos
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  DatabaseHelper._internal();

  static const _dbName = 'doneeit.db';
  static const _dbVersion = 1;

  Database? _db;

  /// Lazy initialization of database connection
  /// Returns existing connection or creates new one
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  /// Initializes database and creates tables if they don't exist
  /// Creates courses and todos tables with proper schema
  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, _dbName);
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        // Courses table - stores course information
        await db.execute('''
          CREATE TABLE courses (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            color INTEGER NOT NULL,
            instructor TEXT,
            room TEXT
          )
        ''');

        // Todos table - stores to-do items, linked to courses
        await db.execute('''
          CREATE TABLE todos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            label TEXT,
            courseId INTEGER,
            description TEXT,
            deadline INTEGER,
            icon TEXT,
            isCompleted INTEGER NOT NULL DEFAULT 0,
            FOREIGN KEY(courseId) REFERENCES courses(id) ON DELETE SET NULL
          )
        ''');
      },
    );
  }

  // ========== COURSE OPERATIONS ==========

  /// Inserts a new course into the database
  /// Returns the ID of the newly inserted course
  Future<int> insertCourse(Map<String, dynamic> course) async {
    final db = await database;
    return db.insert('courses', course);
  }

  /// Retrieves all courses, ordered by ID (newest first)
  Future<List<Map<String, dynamic>>> getCourses() async {
    final db = await database;
    return db.query('courses', orderBy: 'id DESC');
  }

  /// Gets a single course by ID
  /// Returns null if course doesn't exist
  Future<Map<String, dynamic>?> getCourse(int id) async {
    final db = await database;
    final results = await db.query(
      'courses',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (results.isEmpty) return null;
    return results.first;
  }

  /// Updates an existing course
  /// Returns number of rows affected
  Future<int> updateCourse(int id, Map<String, dynamic> course) async {
    final db = await database;
    return db.update(
      'courses',
      course,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Checks if a course has any ongoing (incomplete) todos
  /// Returns true if course has incomplete todos, false otherwise
  Future<bool> hasOngoingTodos(int courseId) async {
    final db = await database;
    final results = await db.query(
      'todos',
      where: 'courseId = ? AND isCompleted = ?',
      whereArgs: [courseId, 0],
      limit: 1,
    );
    return results.isNotEmpty;
  }

  /// Gets the count of ongoing (incomplete) todos for a course
  /// Returns the number of incomplete todos
  Future<int> getOngoingTodosCount(int courseId) async {
    final db = await database;
    final results = await db.rawQuery(
      'SELECT COUNT(*) as count FROM todos WHERE courseId = ? AND isCompleted = ?',
      [courseId, 0],
    );
    return results.first['count'] as int;
  }

  /// Deletes a course by ID
  /// Returns number of rows deleted
  Future<int> deleteCourse(int id) async {
    final db = await database;
    return db.delete(
      'courses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ========== TODO OPERATIONS ==========

  /// Inserts a new todo into the database
  /// Returns the ID of the newly inserted todo
  Future<int> insertTodo(Map<String, dynamic> todo) async {
    final db = await database;
    return db.insert('todos', todo);
  }

  /// Retrieves all todos, ordered by ID (newest first)
  Future<List<Map<String, dynamic>>> getTodos() async {
    final db = await database;
    return db.query('todos', orderBy: 'id DESC');
  }

  /// Gets a single todo by ID
  /// Returns null if todo doesn't exist
  Future<Map<String, dynamic>?> getTodo(int id) async {
    final db = await database;
    final results = await db.query(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (results.isEmpty) return null;
    return results.first;
  }

  /// Updates an existing todo
  /// Returns number of rows affected
  Future<int> updateTodo(int id, Map<String, dynamic> todo) async {
    final db = await database;
    return db.update(
      'todos',
      todo,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Updates only the completion status of a todo
  /// Used for checkbox toggles
  Future<int> updateTodoCompletion(int id, bool isCompleted) async {
    final db = await database;
    return db.update(
      'todos',
      {'isCompleted': isCompleted ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Deletes a todo by ID
  /// Returns number of rows deleted
  Future<int> deleteTodo(int id) async {
    final db = await database;
    return db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}


