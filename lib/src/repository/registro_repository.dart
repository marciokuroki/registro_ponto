import 'package:registro_ponto/src/dao/registro_dao.dart';
import 'package:registro_ponto/src/model/registro.dart';

class RegistroRepository {
  final registroDao = RegistroDao();

  Future getRegistrosByAnoAndMesAndDia(int ano, int mes, int dia) => registroDao.getRegistrosByAnoAndMesAndDia(ano, mes, dia);
  Future insertRegistro(Registro registro) => registroDao.createRegistro(registro);
  Future updateRegistro(Registro registro) => registroDao.updateRegistro(registro);
  Future countRegistroByAnoAndMesAndDia(int ano, int mes, int dia) => registroDao.getCountByAnoAndMesAndDia(ano, mes, dia);
  Future getRegistro(int id) => registroDao.getRegistro(id);
  Future nextIsEntrada(int ano, int mes, int dia) => registroDao.nextIsEntrada(ano, mes, dia);
  
  Future getResumoDia(int ano, int mes, int dia) => registroDao.getResumoDia(ano, mes, dia);
  Future getResumoDiaByMesAndAno(int ano, int mes) => registroDao.getResumoDiaByMesAndAno(ano, mes);

  Future getRegistrosByMes(int ano, int mes) => registroDao.getRegistrosByMes(ano, mes);
}