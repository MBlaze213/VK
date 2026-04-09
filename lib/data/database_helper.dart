import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('pos.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        total REAL,
        date TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE order_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_id INTEGER,
        product_name TEXT,
        price REAL,
        quantity INTEGER
      )
    ''');
  }

  // ✅ Insert Order
  Future<int> insertOrder(double total, String date) async {
    final db = await instance.database;
    return await db.insert('orders', {'total': total, 'date': date});
  }

  // ✅ Insert Items
  Future<void> insertOrderItem(
    int orderId,
    String name,
    double price,
    int qty,
  ) async {
    final db = await instance.database;
    await db.insert('order_items', {
      'order_id': orderId,
      'product_name': name,
      'price': price,
      'quantity': qty,
    });
  }

  // ✅ DAILY SALES
  Future<List<Map<String, dynamic>>> getDailySales() async {
    final db = await instance.database;

    return await db.rawQuery('''
    SELECT substr(date, 1, 10) as day, SUM(total) as total
    FROM orders
    GROUP BY day
    ORDER BY day DESC
  ''');
  }

  // ✅ MONTHLY SALES
  Future<List<Map<String, dynamic>>> getMonthlySales() async {
    final db = await instance.database;

    return await db.rawQuery('''
    SELECT substr(date, 1, 7) as month, SUM(total) as total
    FROM orders
    GROUP BY month
    ORDER BY month DESC
  ''');
  }
}
