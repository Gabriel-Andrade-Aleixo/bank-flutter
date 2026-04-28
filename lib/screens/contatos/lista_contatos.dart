import 'package:flutter/material.dart';

import '../../database/app_database.dart';
import '../../models/contato.dart';
import 'formulario_contato.dart';

class ListaContatos extends StatefulWidget {
  const ListaContatos({super.key});

  @override
  State<ListaContatos> createState() => _ListaContatosState();
}

class _ListaContatosState extends State<ListaContatos> {
  late Future<List<Contato>> _futureContatos;

  @override
  void initState() {
    super.initState();
    _futureContatos = buscarContatos();
  }

  Future<void> _abrirFormulario() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FormularioContato()),
    );

    setState(() {
      _futureContatos = buscarContatos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contatos')),
      body: FutureBuilder<List<Contato>>(
        future: _futureContatos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar contatos'));
          }

          final contatos = snapshot.data ?? [];

          if (contatos.isEmpty) {
            return const Center(child: Text('Nenhum contato encontrado'));
          }

          return ListView.builder(
            itemCount: contatos.length,
            itemBuilder: (context, index) {
              final contato = contatos[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(contato.nome),
                  subtitle: Text('Conta: ${contato.numeroConta}'),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirFormulario,
        child: const Icon(Icons.add),
      ),
    );
  }
}
