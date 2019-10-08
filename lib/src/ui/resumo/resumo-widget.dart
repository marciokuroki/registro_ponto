import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:registro_ponto/src/ui/registro/registro-controller.dart';
import 'package:registro_ponto/src/ui/resumo/resumo-controller.dart';
import 'package:registro_ponto/src/util/route_generator.dart';

class ResumoWidget extends StatefulWidget {
  final int mes;
  final int ano;

  ResumoWidget({Key key, @required this.mes, @required this.ano})
      : super(key: key);

  _ResumoWidgetState createState() => _ResumoWidgetState(mes: mes, ano: ano);
}

class _ResumoWidgetState extends State<ResumoWidget> {
  final ResumoController blocResumo = BlocProvider.getBloc<ResumoController>();

  final int mes;
  final int ano;

  _ResumoWidgetState({this.mes, this.ano});

  @override
  void initState() {
    super.initState();
  }

  

  /*_generateAndViewPDF(context) async {
    blocResumo.getRegistroByCompetencia(ano, mes);
    final pdf = pdfLib.Document();

    Map<int, List<String>> registros = blocResumo.registrosByMes;
    
    pdf.addPage(
      pdfLib.MultiPage(
        build: (context) => [
          pdfLib.Table.fromTextArray(context: context, data: <List<String>>[<String>['1ª Entrada', '1ª Saída', '2ª Entrada', '2ª Saída', 'Entrada - Extra', 'Saída - Extra'], 
          ...registros.map((item) => {item.map( (hora) => [hora])}),
          ]),
        ],
      )
    );
  }

  List<String> _retornaHorarios(List<String> horarios) {
    if(horarios.length < 6) {
      horarios.fillRange(horarios.length, 6, '');
    }
    return horarios;
  }*/

  @override
  Widget build(BuildContext context) {
    blocResumo.getDadosCompetencia(ano, mes);
    print('#### competência:' + mes.toString() + '/' + ano.toString());
    final Key key1 = const Key('__KEY1__');
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: () => {
              //_generateAndViewPDF(context)
            },
          ),
        ],
      ),
      body: SafeArea(
          child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: IconButton(
              icon: Icon(null),
              onPressed: () => Navigator.of(context).pop(),
            ),
            expandedHeight: 200.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              collapseMode: CollapseMode.none,
              background: Container(
                color: Colors.lightGreenAccent[300],
              ),
              title: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                //margin: EdgeInsets.only(top: 40, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_left),
                      color: Colors.white,
                      tooltip: "mês anterior",
                      iconSize: 64.0,
                      onPressed: () => {
                        Navigator.of(context).popAndPushNamed('/resumo',
                            arguments: new Competencia(
                                mes: mes == 1 ? 12 : mes - 1,
                                ano: mes == 1 ? ano - 1 : ano))
                      },
                    ),
                    Text(
                      "$mes/$ano",
                      style: TextStyle(
                          fontSize: 24.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_right),
                      color: Colors.white,
                      tooltip: "próximo mês",
                      iconSize: 64.0,
                      onPressed: () => {
                        Navigator.of(context).popAndPushNamed('/resumo',
                            arguments: new Competencia(
                                mes: mes == 12 ? 1 : mes + 1,
                                ano: mes == 12 ? ano + 1 : ano))
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          StreamBuilder(
              stream: blocResumo.resumos,
              builder: (BuildContext context,
                  AsyncSnapshot<List<ResumoDia>> snapshot) {
                if (snapshot.hasData && snapshot.data.length > 0) {
                  return SliverList(
                    key: key1,
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        ResumoDia resumoDia = snapshot.data[index];
                        return Card(
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(
                                      resumoDia.dia.toString(),
                                      style: TextStyle(
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    Text(
                                      resumoDia.diaSemana,
                                      style: TextStyle(
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Text(
                                      "Saldo",
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      resumoDia.saldo.toString(),
                                      style: TextStyle(
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  icon: Icon(Icons.info_outline),
                                  onPressed: () => {},
                                  iconSize: 30.0,
                                  tooltip: "Visualizar Registros do Dia",
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: snapshot.hasData ? snapshot.data.length : 0,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return SliverToBoxAdapter(
                    child:
                        Text("Erro ao carregar os resumos dos dias para o mês"),
                  );
                }
                return SliverToBoxAdapter(
                    child: Text("Nenhum registro para a competência"));
              }),
        ],
      )),
    );
  }
}
