import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String tableRegistro = 'registroTable';
final String columnId = 'id';
final String columnEmpregadoId = 'empregado_id';
final String columnEmpregadorId = 'empregador_id';
final String columnHora = 'hora';
final String columnIsEntrada = 'is_entrada';
final String columnDia = 'dia';
final String columnMes = 'mes';
final String columnAno = 'ano';

final String tableUsuario = 'usuarioTable';
final String columnCpf = 'cpf';
final String columnPassword = 'password';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper();

  //factory DatabaseHelper() => instance;

  Database _db;

  //DatabaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) return _db;

    _db = await initDb();

    return _db;
  }

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'registro.db');
//    await deleteDatabase(path); // just for testing

    var db = await openDatabase(path, version: 3, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $tableRegistro( ' +
        '$columnId INTEGER PRIMARY KEY, ' +
        '$columnEmpregadoId INTEGER, ' +
        '$columnEmpregadorId INTEGER, ' +
        '$columnHora INTEGER, ' +
        '$columnIsEntrada BOOLEAN, ' +
        '$columnDia INTEGER, ' +
        '$columnMes INTEGER, ' +
        '$columnAno INTEGER )');

    await db.execute('CREATE TABLE $tableUsuario( ' +
        '$columnCpf STRING PRIMARY KEY, ' +
        '$columnPassword STRING )');
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
