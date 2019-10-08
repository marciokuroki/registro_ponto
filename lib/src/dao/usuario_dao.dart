import 'package:registro_ponto/src/model/usuario.dart';
import 'package:registro_ponto/src/util/database_helper.dart';

class UsuarioDao {
  final dbHelper = DatabaseHelper.instance;

  Future<Usuario> getUsuario(Usuario user) async {
    final dbClient = await dbHelper.db;
    List<Map<String, dynamic>> result = await dbClient.query(tableUsuario,
        columns: [
          columnCpf,
          columnPassword,
        ],
        where: '$columnCpf = ? and $columnPassword = ?',
        whereArgs: [user.cpf, user.password]);

    if (result.length > 0) {
      Usuario userResult = new Usuario.fromJson(result.first);
      return userResult;
    }

    return null;
  }
}
