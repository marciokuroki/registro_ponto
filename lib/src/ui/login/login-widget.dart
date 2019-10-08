import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:registro_ponto/src/ui/login/login-controller.dart';

class LoginWidget extends StatefulWidget {
  LoginWidget({Key key}) : super(key: key);

  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  @override
  Widget build(BuildContext context) {
    final LoginController bloc = BlocProvider.getBloc<LoginController>();

    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            cpfField(bloc),
            SizedBox(
              height: 10.0,
            ),
            passwordField(bloc),
            SizedBox(
              height: 40.0,
            ),
            loginButton(bloc),
          ],
        ),
      ),
    );
  }

  Widget cpfField(bloc) {
    return StreamBuilder(
      stream: bloc.cpfStream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return TextField(
          onChanged: bloc.updateCpf,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: '12345678900',
            labelText: 'CPF',
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget passwordField(bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return TextField(
          onChanged: bloc.updatePassword,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Sua senha',
            labelText: 'Senha',
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget loginButton(LoginController stateMgmtBloc) {
    return StreamBuilder(
      stream: stateMgmtBloc.submitValid,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return RaisedButton(
          child: Text('Entrar'),
          color: Colors.blue,
          onPressed: snapshot.hasData
              ? snapshot.data == true
                  ? () => Navigator.pushNamed(context, "/registro")
                  : () => Navigator.popAndPushNamed(context, "/").whenComplete(
                      () => Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text("Login e Senha inválido(s)!"),
                          )))
              : null,
        );
      },
    );
  }
}
