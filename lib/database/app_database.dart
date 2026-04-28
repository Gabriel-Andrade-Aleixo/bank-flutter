import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/contato.dart';
import '../models/transferencia.dart';

Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), 'bank.db');

  return openDatabase(
    path,
    version: 3,
    onCreate: (db, version) async {
      await _createTables(db);
    },
    onUpgrade: (db, oldVersion, newVersion) async {
      await db.execute('DROP TABLE IF EXISTS transferencias');
      await db.execute('DROP TABLE IF EXISTS contatos');
      await _createTables(db);
    },
  );
}

Future<void> _createTables(Database db) async {
  await db.execute(
    'CREATE TABLE transferencias('
    'id INTEGER PRIMARY KEY AUTOINCREMENT, '
    'valor REAL NOT NULL, '
    'numero_conta INTEGER NOT NULL)',
  );

  await db.execute(
    'CREATE TABLE contatos('
    'id INTEGER PRIMARY KEY AUTOINCREMENT, '
    'nome TEXT NOT NULL, '
    'numero_conta INTEGER NOT NULL)',
  );
}

Future<int> salvarTransferencia(Transferencia transferencia) async {
  final Database db = await getDatabase();
  print('SALVANDO: ${transferencia.toMap()}');
  final id = await db.insert('transferencias', transferencia.toMap());
  print('ID INSERIDO: $id');
  return id;
}

Future<List<Transferencia>> buscarTransferencias() async {
  final Database db = await getDatabase();
  final result = await db.query('transferencias', orderBy: 'id DESC');
  print('RESULT DO BANCO: $result');
  return result.map((map) => Transferencia.fromMap(map)).toList();
}

Future<int> salvarContato(Contato contato) async {
  final Database db = await getDatabase();
  return db.insert('contatos', contato.toMap());
}

Future<List<Contato>> buscarContatos() async {
  final Database db = await getDatabase();
  final result = await db.query('contatos', orderBy: 'id DESC');
  return result.map((map) => Contato.fromMap(map)).toList();
}

Future<void> testarBanco({bool resetarBanco = false}) async {
  final String path = join(await getDatabasesPath(), 'bank.db');
  final File arquivoBanco = File(path);

  if (resetarBanco) {
    await deleteDatabase(path);
    print('**** Banco apagado para recriação');
  }

  final bool existe = await arquivoBanco.exists();

  if (existe) {
    print('**** Banco encontrado em: $path');
  } else {
    print('**** Banco NÃO existe ainda (será criado agora)');
  }

  final Database db = await getDatabase();

  final List<Map<String, dynamic>> tabelas = await db.rawQuery(
    "SELECT name FROM sqlite_master WHERE type='table';",
  );

  if (tabelas.isNotEmpty) {
    print('**** Tabelas encontradas:');
    for (final tabela in tabelas) {
      print('- ${tabela['name']}');
    }
  } else {
    print('XXXX Nenhuma tabela encontrada');
  }

  await db.close();
}
