import 'package:registro_ponto/src/dao/usuario_dao.dart';
import 'package:registro_ponto/src/model/usuario.dart';

class UsuarioRepository {
  final usuarioDao = UsuarioDao();

  Future getUsuario(Usuario user) => usuarioDao.getUsuario(user);
}
