import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:registro_ponto/src/model/registro.dart';
import 'package:registro_ponto/src/repository/registro_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:intl/intl.dart';

class RegistroController extends BlocBase {
  final _registroRepository = RegistroRepository();
  final _registroController = BehaviorSubject<List<RegistroDia>>();

  get registros => _registroController.stream;

  RegistroController() {
    getRegistros();
    getCountRegistrosByMesAndDia();
  }

  getCountRegistrosByMesAndDia() async {
    final DateTime now = DateTime.now();
    final int dia = now.day;
    final int mes = now.month;
    final int ano = now.year;

    int count =
        await _registroRepository.countRegistroByAnoAndMesAndDia(ano, mes, dia);

    _countRegistrosController.sink.add(count);
  }

  //fluxo para a quantidade de registros no dia
  var _countRegistrosController = BehaviorSubject<int>.seeded(0);
  Stream<int> get outIsJourneyCompleted => _countRegistrosController.stream;

  getRegistros() async {
    final DateTime now = DateTime.now();
    final int dia = now.day;
    final int mes = now.month;
    final int ano = now.year;

    List<RegistroDia> registrosDia = new List<RegistroDia>();

    List<Registro> resultadoConsulta =
        await _registroRepository.getRegistrosByAnoAndMesAndDia(ano, mes, dia);
    for (var registro in resultadoConsulta) {
      String label = registro.isEntrada ? 'Entrada:' : 'Saída';
      DateTime horaDia = new DateTime.fromMillisecondsSinceEpoch(registro.hora);
      String hora = DateFormat("H:mm").format(horaDia);
      IconData icon =
          registro.isEntrada ? Icons.arrow_downward : Icons.arrow_upward;
      Color color = registro.isEntrada ? Colors.green : Colors.red;
      registrosDia.add(new RegistroDia(
          id: registro.id, label: label, hora: hora, icon: icon, color: color));
    }

    //_countRegistrosController.sink.add(registrosDia.length);
    _registroController.sink.add(registrosDia);
  }

  /*static final _nomeEmpregado = "Nome do Empregado";

  //fluxo variável com os dados Empregado
  var _nomeEmpregadoController = BehaviorSubject<String>.seeded(_nomeEmpregado);
  Stream<String> get outNomeEmpregado => _nomeEmpregadoController.stream;
  */

  //fluxo para a data de hoje
  var _dataHoraController = BehaviorSubject<String>.seeded(atualDate());
  Stream<String> get outDataHoje => _dataHoraController.stream;

  //fluxo para a Lista de Registros
  //var _registrosDiaController = BehaviorSubject<List<RegistroDia>>();
  //Stream<List<RegistroDia>> get outRegistrosDia => _registrosDiaController.stream;

  static String atualDate() {
    final DateTime now = DateTime.now();
    String formattedDate =
        DateFormat("EEE, d 'de' MMMM 'de' yyyy", "pt_br").format(now);
    return formattedDate;
  }

  saveRegistro() async {
    final DateTime now = DateTime.now();
    final int dia = now.day;
    final int mes = now.month;
    final int ano = now.year;

    bool isEntrada = await _registroRepository.nextIsEntrada(ano, mes, dia);

    var newRegistro = new Registro();
    newRegistro.empregadoId = 1;
    newRegistro.empregadorId = 1;
    newRegistro.dia = dia;
    newRegistro.mes = mes;
    newRegistro.hora = now.millisecondsSinceEpoch;
    newRegistro.isEntrada = isEntrada;
    newRegistro.ano = ano;

    await _registroRepository.insertRegistro(newRegistro);
    getRegistros();
    getCountRegistrosByMesAndDia();
  }

  @override
  void dispose() {
    //_nomeEmpregadoController.close();
    _registroController.close();
    _dataHoraController.close();
    _countRegistrosController.close();
    super.dispose();
  }
}

class RegistroDia {
  int id;
  String label;
  String hora;
  IconData icon;
  Color color;

  RegistroDia({this.id, this.label, this.hora, this.icon, this.color});
}
