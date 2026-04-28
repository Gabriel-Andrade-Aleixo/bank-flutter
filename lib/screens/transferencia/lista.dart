import 'package:flutter/material.dart';

import '../../database/app_database.dart';
import '../../models/transferencia.dart';
import 'formulario.dart';

class ListaTransferencias extends StatefulWidget {
  const ListaTransferencias({super.key});

  @override
  State<ListaTransferencias> createState() => _ListaTransferenciasState();
}

class _ListaTransferenciasState extends State<ListaTransferencias> {
  late Future<List<Transferencia>> _futureTransferencias;

  @override
  void initState() {
    super.initState();
    _futureTransferencias = buscarTransferencias();
  }

  Future<void> _abrirFormulario() async {
    final Transferencia? transferenciaRecebida = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FormularioTransferencia()),
    );

    if (transferenciaRecebida != null) {
      await salvarTransferencia(transferenciaRecebida);

      setState(() {
        _futureTransferencias = buscarTransferencias();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transferências')),
      body: FutureBuilder<List<Transferencia>>(
        future: _futureTransferencias,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar transferências'));
          }

          final transferencias = snapshot.data ?? [];

          if (transferencias.isEmpty) {
            return const Center(
              child: Text('Nenhuma transferência encontrada'),
            );
          }

          return ListView.builder(
            itemCount: transferencias.length,
            itemBuilder: (context, index) {
              final transferencia = transferencias[index];
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
