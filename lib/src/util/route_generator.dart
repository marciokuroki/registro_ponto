import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:registro_ponto/src/ui/login/login-controller.dart';
import 'package:registro_ponto/src/ui/login/login-widget.dart';
import 'package:registro_ponto/src/ui/registro/registro-controller.dart';
import 'package:registro_ponto/src/ui/registro/registro-widget.dart';
import 'package:registro_ponto/src/ui/resumo/resumo-controller.dart';
import 'package:registro_ponto/src/ui/resumo/resumo-widget.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      //case '/login':
      //  return MaterialPageRoute(
      //      builder: (_) => BlocProvider(
      //            child: LoginWidget(),
      //            blocs: [
      //              Bloc((i) => LoginController()),
      //            ],
      //          ));
      case '/':
        return MaterialPageRoute(
          //builder: (_) => BlocProvider(child: RegistroWidget(), blocs: [
          builder: (_) => BlocProvider(child: LoginWidget(), blocs: [
            Bloc((i) => RegistroController()),
            Bloc((i) => ResumoController()),
            Bloc((i) => LoginController()),
          ]),
        );
      case '/registro':
        return MaterialPageRoute(
          builder: (_) => RegistroWidget(),
        );
      case '/resumo':
        if (args is Competencia) {
          return MaterialPageRoute(
              builder: (_) => ResumoWidget(mes: args.mes, ano: args.ano));
        }
        return _errorRoute();

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}

class Competencia {
  int mes;
  int ano;

  Competencia({this.mes, this.ano});
}
