import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/transferencia.dart';

class TransferenciaDao {
  static const String _tableName = 'transferencias';
  static const String _dbName = 'bank.db';
  static const String _createTableSql = '''
    CREATE TABLE $_tableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      valor REAL NOT NULL,
      numeroConta INTEGER NOT NULL
    )
  ''';

  static final TransferenciaDao _instance = TransferenciaDao._internal();
  factory TransferenciaDao() => _instance;
  TransferenciaDao._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _openDatabase();
    return _db!;
  }

  Future<Database> _openDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(_createTableSql);
      },
    );
  }

  Future<int> inserir(Transferencia transferencia) async {
    final db = await database;
    return db.insert(
      _tableName,
      transferencia.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Transferencia>> buscarTodas() async {
    final db = await database;
    final result = await db.query(_tableName, orderBy: 'id DESC');

    return result.map((map) => Transferencia.fromMap(map)).toList();
  }
}