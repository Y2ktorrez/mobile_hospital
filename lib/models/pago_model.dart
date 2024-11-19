class PagoDto {
  final int? id;
  final int idConsulta;
  final int costoTotal;
  final bool cancelado;
  final String tipoPago;

  PagoDto({
    this.id,
    required this.idConsulta,
    required this.costoTotal,
    required this.cancelado,
    required this.tipoPago,
  });

  factory PagoDto.fromJson(Map<String, dynamic> json) {
    return PagoDto(
      id: json['id'],
      idConsulta: json['idConsulta'],
      costoTotal: json['costoTotal'],
      cancelado: json['cancelado'],
      tipoPago: json['tipoPago'],
    );
  }
}
