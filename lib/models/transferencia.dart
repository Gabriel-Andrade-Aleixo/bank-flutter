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
      'numeroConta': numeroConta,
    };
  }

  factory Transferencia.fromMap(Map<String, dynamic> map) {
    return Transferencia(
      id: map['id'],
      valor: map['valor'],
      numeroConta: map['numeroConta'],
    );
  }

  @override
  String toString() {
    return 'Transferencia{id: $id, valor: $valor, numeroConta: $numeroConta}';
  }
}