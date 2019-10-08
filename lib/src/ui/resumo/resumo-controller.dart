import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:registro_ponto/src/repository/registro_repository.dart';
import 'package:rxdart/subjects.dart';

class ResumoController extends BlocBase {
  final _registroRepository = RegistroRepository();
  final _resumoController = BehaviorSubject<List<ResumoDia>>();
  final _registroController = BehaviorSubject<Map<int, List<String>>>();

  get resumos => _resumoController.stream;

  get registrosByMes => _registroController.stream;

  ResumoController() {
    print('#### Resumo Controller');
    //final DateTime now = DateTime.now();
    //final int mes = now.month; 
    //final int ano = now.year; 
    //getDadosCompetencia(ano, mes);
  }

  getRegistroByCompetencia(int ano, int mes) async {
    Map<int, List<String>> registros = await _registroRepository.getRegistrosByMes(ano, mes);
    _registroController.sink.add(registros);
  }

  getDadosCompetencia(int ano, int mes) async {
    //final DateTime now = DateTime.now();
    //final int dia = now.day;
    //final int mes = now.month; 
    //final int ano = now.year; 

    //ResumoDia resumoDia = await _registroRepository.getResumoDia(ano, mes, dia);

    List<ResumoDia> resumosDia = await _registroRepository.getResumoDiaByMesAndAno(ano, mes);
    //resumosDia.add(resumoDia);

    _resumoController.sink.add(resumosDia);
  }

  @override
  void dispose() {
    print('&&& Dispose do Resumo Controller');
    _resumoController.close();
    _registroController.close();
    super.dispose();
  }
}

class ResumoDia {
  int dia;
  String diaSemana;
  int saldo;
  String descricao;

  ResumoDia({this.dia, this.diaSemana, this.saldo, this.descricao});

  ResumoDia.fimDeSemana({this.dia, this.diaSemana}){
    this.saldo = 0;
    this.descricao = "DSR";
  }

  ResumoDia.feriado({this.dia, this.diaSemana}){
    this.saldo = 0;
    this.descricao = "FERIADO";
  }
}