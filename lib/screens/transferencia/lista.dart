import 'package:flutter/material.dart';
import '../../database/transferencia_dao.dart';
import '../../models/transferencia.dart';
import 'formulario.dart';

class ListaTransferencias extends StatefulWidget {
  const ListaTransferencias({super.key});

  @override
  State<ListaTransferencias> createState() => _ListaTransferenciasState();
}

class _ListaTransferenciasState extends State<ListaTransferencias> {
  final TransferenciaDao _dao = TransferenciaDao();
  late Future<List<Transferencia>> _futureTransferencias;

  @override
  void initState() {
    super.initState();
    _futureTransferencias = _dao.buscarTodas();
  }

  void _atualizaLista() {
    setState(() {
      _futureTransferencias = _dao.buscarTodas();
    });
  }

  Future<void> _abrirFormulario() async {
    final transferencia = await Navigator.push<Transferencia>(
      context,
      MaterialPageRoute(builder: (context) => const FormularioTransferencia()),
    );

    if (transferencia != null) {
      await _dao.inserir(transferencia);
      _atualizaLista();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Transferências',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<List<Transferencia>>(
        future: _futureTransferencias,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar dados: ${snapshot.error}'),
            );
          }

          final transferencias = snapshot.data ?? [];

          if (transferencias.isEmpty) {
            return const Center(
              child: Text('Nenhuma transferência cadastrada.'),
            );
          }

          return ListView.builder(
            itemCount: transferencias.length,
            itemBuilder: (context, indice) {
              final transferencia = transferencias[indice];
              return ItemTransferencia(transferencia);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirFormulario,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class ItemTransferencia extends StatelessWidget {
  final Transferencia transferencia;

  const ItemTransferencia(this.transferencia, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.monetization_on),
        title: Text('R\$ ${transferencia.valor.toStringAsFixed(2)}'),
        subtitle: Text('Conta: ${transferencia.numeroConta}'),
      ),
    );
  }
}
