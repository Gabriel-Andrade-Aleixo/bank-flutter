class Transferencia {
  final int? id;
  final double valor;
  final int numeroConta;

  Transferencia({
    this.id,
    required this.valor,
    required this.numeroConta,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'valor': valor,
      'numero_conta': numeroConta,
    };
  }

  factory Transferencia.fromMap(Map<String, dynamic> map) {
    return Transferencia(
      id: map['id'] as int?,
      valor: (map['valor'] as num).toDouble(),
      numeroConta: map['numero_conta'] as int,
    );
  }

  @override
  String toString() {
    return 'Transferencia{id: $id, valor: $valor, numeroConta: $numeroConta}';
  }
}