import 'dart:async';
import 'package:cpf_cnpj_validator/cpf_validator.dart';

class LoginValidator {
  final performcpfValidation =
      StreamTransformer<String, String>.fromHandlers(handleData: (cpf, sink) {
    if (CPFValidator.isValid(cpf)) {
      sink.add(cpf);
    } else {
      sink.addError('Favor, entrar com um cpf válido');
    }
  });

  final performPasswordValidation =
      StreamTransformer<String, String>.fromHandlers(
          handleData: (password, sink) {
    if (password.length >= 4) {
      sink.add(password);
    } else {
      sink.addError('A senha tem que ter no mínimo 4 dígitos');
    }
    //String passwordValidationRule = '((?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@#%]).{6,10})';
    //RegExp regExp = new RegExp(passwordValidationRule);

    //if (regExp.hasMatch(password)) {
    //  sink.add(password);
    //} else {
    //  sink.addError(
    //      'A senha tem que ter um número, uma letra minúscula, uma maiúscula, um caracter especial "@#%" e no min. 6 a max. 10 caracteres');
    //}
  });
}
