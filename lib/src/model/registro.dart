class Registro {
  int id;
  int empregadoId;
  int empregadorId;
  int hora;
  bool isEntrada;
  int dia;
  int mes;
  int ano;

  Registro({this.id, this.empregadoId, this.empregadorId, this.dia, this.mes, this.hora, this.isEntrada, this.ano});

  Registro.cadastroPadrao({this.id, this.dia, this.mes, this.hora, this.isEntrada, this.ano}) {
    this.empregadoId = 1;
    this.empregadorId = 1;
  }

  factory Registro.fromDatabaseJson(Map<String, dynamic> data) => Registro(
      id: data['id'],
      empregadoId: data['empregado_id'],
      empregadorId: data['empregador_id'],
      hora: data['hora'],
      isEntrada: data['is_entrada'] == 0 ? false : true,
      dia: data['dia'],
      mes: data['mes'],
      ano: data['ano'],
  );

  Map<String, dynamic> toDatabaseJson() => {
    "id": this.id,
    "empregado_id": this.empregadoId,
    "empregador_id": this.empregadorId,
    "hora": this.hora,
    "is_entrada": this.isEntrada == false ? 0 : 1,
    "dia": this.dia,
    "mes": this.mes,
    "ano": this.ano,
  };
}