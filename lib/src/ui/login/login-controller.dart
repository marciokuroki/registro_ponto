import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:registro_ponto/src/ui/login/login-validator.dart';
import 'package:rxdart/rxdart.dart';

class LoginController extends BlocBase with LoginValidator implements Object {
  final _cpfController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  //Recebe dados do fluxo
  Stream<String> get cpfStream =>
      _cpfController.stream.transform(performcpfValidation);
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(performPasswordValidation);

  //Combinando os fluxos de cpf e senha
  Stream<bool> get submitValid =>
      Observable.combineLatest2(cpfStream, passwordStream, (c, p) {
        if (c == '80498051234' && p == '1234') return true;
        return false;
      });

  //Add dados ao fluxo
  Function(String) get updateCpf => _cpfController.sink.add;
  Function(String) get updatePassword => _passwordController.sink.add;

  @override
  void dispose() {
    _cpfController.close();
    _passwordController.close();

    super.dispose();
  }
}
