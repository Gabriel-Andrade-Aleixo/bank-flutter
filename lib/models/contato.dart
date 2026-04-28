class Contato {
  final int? id;
  final String nome;
  final int numeroConta;

  Contato({this.id, required this.nome, required this.numeroConta});

  Map<String, dynamic> toMap() {
    return {'id': id, 'nome': nome, 'numero_conta': numeroConta};
  }

  factory Contato.fromMap(Map<String, dynamic> map) {
    return Contato(
      id: map['id'] as int?,
      nome: map['nome'] as String,
      numeroConta: map['numero_conta'] as int,
    );
  }

  @override
  String toString() {
    return 'Contato{id: $id, nome: $nome, numeroConta: $numeroConta}';
  }
}
