import 'package:intl/intl.dart';
import 'package:registro_ponto/src/model/registro.dart';
import 'package:registro_ponto/src/ui/resumo/resumo-controller.dart';
import 'package:registro_ponto/src/util/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class RegistroDao {
  final dbHelper = DatabaseHelper.instance;

  Future<int> createRegistro(Registro registro) async {
    final db = await dbHelper.db;
    var result = db.insert(tableRegistro, registro.toDatabaseJson());
    return result;
  }
  
  Future<int> updateRegistro(Registro registro) async {
    final db = await dbHelper.db;

    var result = await db.update(tableRegistro, registro.toDatabaseJson(),
        where: "id = ?", whereArgs: [registro.id]);

    return result;
  }

  Future<bool> nextIsEntrada(int ano, int mes, int dia) async {
    final dbClient = await dbHelper.db;
    List<Map> result = await dbClient.query(tableRegistro,
        columns: [columnIsEntrada],
        where: '$columnAno = ? and $columnDia = ? and $columnMes = ?',
        whereArgs: [ano, dia, mes],
        orderBy: '$columnId DESC',
        limit: 1);
    
    if (result.length > 0) {
      Registro registro = new Registro.fromDatabaseJson(result.first);
      return !(registro.isEntrada);
    }
    return true;
  }

  Future<Registro> getRegistro(int id) async {
    final dbClient = await dbHelper.db;
    List<Map> result = await dbClient.query(tableRegistro,
        columns: [columnId, columnAno, columnMes, columnDia, columnHora, columnIsEntrada],
        where: '$columnId = ?',
        whereArgs: [id]);
 
    if (result.length > 0) {
      return new Registro.fromDatabaseJson(result.first);
    }
 
    return null;
  }

  Future<int> getCountByAnoAndMesAndDia(int ano, int mes, int dia) async {
    final dbClient = await dbHelper.db;
    return Sqflite.firstIntValue(await dbClient.rawQuery('SELECT COUNT(*) FROM $tableRegistro WHERE dia = $dia and mes = $mes and ano = $ano'));
  }

  Future<ResumoDia> getResumoDia(int ano, int mes, int dia) async {
    final db = await dbHelper.db;
    //Duration x = DateTime.now().difference(DateTime.now());
    //x.inMinutes;
    List<Map<String, dynamic>> result = await db.query(tableRegistro, 
      columns: [columnId, columnAno, columnMes, columnDia, columnHora, columnIsEntrada],
      where: '$columnAno = ? and $columnMes = ? and $columnDia = ?',
      whereArgs: [ano, mes, dia],
      orderBy: '$columnId',
      );
    
    List<Registro> registros = result.isNotEmpty ? result.map( (item) => Registro.fromDatabaseJson(item)).toList() : [];
    
    Duration duration = new Duration();
    String diaSemana = _getDiaDaSemana(DateTime(ano, mes, dia).weekday);
    String descricao = "";
    int saldo = 0;

    if (registros.length == 0) {
      return ResumoDia(dia: dia, diaSemana: diaSemana, saldo: -8, descricao: "Nenhum registro para o dia");
    }

    if(registros.length % 2 == 0) {
      for (var i = 0; i < registros.length; i+=2) {
        var registroA = registros[i];
        var registroB = registros[i+1];

        duration += DateTime.fromMillisecondsSinceEpoch(registroB.hora).difference(DateTime.fromMillisecondsSinceEpoch(registroA.hora));
      }
      saldo = duration.inMinutes;
    } else {
      descricao = "Jornada não finalizada";
    }

    //TODO a DESCRIÇÃO deve considerar a jornada do empregado para o dia em questão. Ainda não implementado.
    var resumoDia = new ResumoDia(dia: dia, diaSemana: diaSemana, saldo: saldo, descricao: descricao);

    return resumoDia;
  }

  String _getDiaDaSemana(int weekday) {
    switch (weekday) {
      case (DateTime.monday):
        return "Segunda-feira";
      case (DateTime.tuesday):
        return "Terça-feira";
      case (DateTime.wednesday):
        return "Quarta-feira";
      case (DateTime.thursday):
        return "Quinta-feira";
      case (DateTime.friday):
        return "Sexta-Feira";
      case (DateTime.saturday):
        return "Sábado";
      case (DateTime.sunday):
        return "Domingo";
    }
    return "";
  }

  Future<List<Registro>> getRegistrosByAnoAndMesAndDia(int ano, int mes, int dia) async {
    final db = await dbHelper.db;
    List<Map<String, dynamic>> result = await db.query(tableRegistro, 
      columns: [columnId, columnAno, columnMes, columnDia, columnHora, columnIsEntrada],
      where: '$columnAno = ? and $columnMes = ? and $columnDia = ?',
      whereArgs: [ano, mes, dia]);

    List<Registro> registros = result.isNotEmpty ? result.map( (item) => Registro.fromDatabaseJson(item)).toList() : [];
    
    return registros;
  }

  Future<List<ResumoDia>> getResumoDiaByMesAndAno(int ano, int mes) async {
    print('%%%% Consultando o banco pelos Resumos...');
    DateTime teste = new DateTime(ano, mes+1, 0);
    int ultimoDia = teste.day;
    
    List<ResumoDia> resumos = new List();
    for (var i = 1; i < ultimoDia+1; i++) {
      ResumoDia resumoDia = await getResumoDia(ano, mes, i);
      resumos.add(resumoDia);
    }

    return resumos;
  }

  Future<Map<int, List<String>>> getRegistrosByDia(int ano, int mes, int dia) async {
    print('%%%% Consultando o banco pelos registros por dia....');
    List<String> horarios = [];
    List<Registro> registros = await getRegistrosByAnoAndMesAndDia(ano, mes, dia);
    for (var reg in registros) {
      DateTime horaDia = new DateTime.fromMillisecondsSinceEpoch(reg.hora);
      String hora = DateFormat("H:mm").format(horaDia);
      horarios.add(hora);
    }
    
    Map<int, List<String>> result;
    result.addEntries([MapEntry(dia, horarios)]);

    return result;
  }

  Future<Map<int, List<String>>> getRegistrosByMes(int ano, int mes) async {
    DateTime ultimoDiaMes = new DateTime(ano, mes+1, 0);
    int ultimoDia = ultimoDiaMes.day;

    Map<int, List<String>> result;

    for (var i = 1; i < ultimoDia+1; i++) {
      Map<int, List<String>> resultadoDia = await getRegistrosByDia(ano, mes, i);
      result.addAll(resultadoDia);
    }
    return result;
  }
}