import 'package:flutter/material.dart';
//import 'package:registro_ponto/src/ui/registro/registro-controller.dart';
//import 'package:registro_ponto/src/ui/registro/registro-widget.dart';
//import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:registro_ponto/src/util/route_generator.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    initializeDateFormatting("pt_BR");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.lightBlue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
    );
  }
}
