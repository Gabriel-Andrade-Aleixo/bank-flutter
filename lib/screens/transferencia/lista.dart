import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    _carregarTransferencias();
  }

  void _carregarTransferencias() {
    _futureTransferencias = buscarTransferencias();
  }

  Future<void> _abrirFormulario() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const FormularioTransferencia()),
    );

    setState(() {
      _carregarTransferencias();
    });
  }

  @override
  Widget build(BuildContext context) {
    final formatador = NumberFormat.simpleCurrency(locale: 'pt_BR');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transferências'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _carregarTransferencias();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Transferencia>>(
        future: _futureTransferencias,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());

            case ConnectionState.done:
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Erro ao carregar transferências.'),
                );
              }

              final transferencias = snapshot.data ?? [];

              if (transferencias.isEmpty) {
                return const Center(
                  child: Text('Nenhuma transferência encontrada.'),
                );
              }

              return ListView.builder(
                itemCount: transferencias.length,
                itemBuilder: (context, index) {
                  final transferencia = transferencias[index];

                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      leading: const Icon(
                        Icons.monetization_on,
                        color: Colors.green,
                      ),
                      title: Text(formatador.format(transferencia.valor)),
                      subtitle: Text('Conta: ${transferencia.numeroConta}'),
                    ),
                  );
                },
              );

            default:
              return const SizedBox.shrink();
          }
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
