import 'dart:async';

import 'package:flutter/material.dart';
import 'package:registro_ponto/src/ui/registro/registro-controller.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:registro_ponto/src/util/route_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistroWidget extends StatefulWidget {
  RegistroWidget({Key key}) : super(key: key);

  _RegistroWidgetState createState() => _RegistroWidgetState();
}

class _RegistroWidgetState extends State<RegistroWidget> {
  final RegistroController blocRegistro =
      BlocProvider.getBloc<RegistroController>();

  String _nomeEmpregado = 'Iara Castro';
  static final DateTime _now = DateTime.now();

  final int _mes = _now.month;
  final int _ano = _now.year;

  final buttonLabel = [
    'Iniciar Jornada',
    'Iniciar Intervalo',
    'Retornar do Intervalo',
    'Encerrar Jornarda',
    'Iniciar Jornada Extra',
    'Encerrar Jornada Extra'
  ];

  @override
  void initState() {
    super.initState();
    _startUpNomeEmpregado();
  }

  // obtain shared preferences
  Future<String> _getNomeFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    final nome = prefs.getString('nome_empregado');
    if (nome == null) {
      return 'Iara Castro';
    }
    return nome;
  }

  Future<void> _startUpNomeEmpregado() async {
    final prefs = await SharedPreferences.getInstance();
    var nomeEmpregado = await _getNomeFromSharedPref();
    prefs.setString('nome_empregado', _nomeEmpregado);

    setState(() {
      _nomeEmpregado = nomeEmpregado;
    });
  }

  @override
  Widget build(BuildContext context) {
    //final RegistroController blocRegistro = BlocProvider.getBloc<RegistroController>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Registro de Ponto App"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings_applications),
            onPressed: () {
              Navigator.of(context).pushNamed('/resumo',
                  arguments: new Competencia(mes: _mes, ano: _ano));
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          /*StreamBuilder(
            stream: blocRegistro.outNomeEmpregado,
            builder: (BuildContext context, AsyncSnapshot snapshot){
              return Text(
                        "${snapshot.data}",
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 26.0),
                      );
            },
          )*/
          Text(
            "$_nomeEmpregado",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 26.0),
          ),
          Text(
            "08:00 - 12:00 - 13:00 - 17:00",
            style: TextStyle(fontSize: 12.0),
          ),
          StreamBuilder(
            stream: blocRegistro.outDataHoje,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return Text(
                "${snapshot.data}",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0),
              );
            },
          ),
          StreamBuilder(
            stream: blocRegistro.registros,
            builder: (BuildContext context,
                AsyncSnapshot<List<RegistroDia>> snapshot) {
              if (snapshot.hasData && snapshot.data.length > 0) {
                return buildList(snapshot);
              } else if (snapshot.hasError) {
                return Text("Erro ao carregar os registros do dia");
              }
              return Center(child: Text("Nenhum registro para o dia"));
              //return Center(child: CircularProgressIndicator());
            },
          ),
          StreamBuilder(
              stream: blocRegistro.outIsJourneyCompleted,
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data == 6) {
                    return RaisedButton(
                        onPressed: null, child: Text(buttonLabel[0]));
                  } else {
                    return RaisedButton(
                      onPressed: blocRegistro.saveRegistro,
                      child: Text(buttonLabel[snapshot.data]),
                    );
                  }
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
        ],
      ),
    );
  }
}

Widget buildList(AsyncSnapshot<List<RegistroDia>> snapshot) {
  return ListView.separated(
    shrinkWrap: true,
    itemCount: snapshot.data.length,
    itemBuilder: (BuildContext context, int index) {
      RegistroDia registroDia = snapshot.data[index];
      return _tile(registroDia.label, registroDia.hora, registroDia.icon,
          registroDia.color);
    },
    separatorBuilder: (BuildContext context, int index) => const Divider(),
  );
}

ListTile _tile(String title, String data, IconData icon, Color color) =>
    ListTile(
      title: Text(data,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          )),
      trailing: Icon(
        icon,
        color: color,
      ),
      leading: Text(title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          )),
    );
