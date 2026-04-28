import 'package:flutter/material.dart';

import '../../components/editor.dart';
import '../../database/app_database.dart';
import '../../models/contato.dart';

class FormularioContato extends StatefulWidget {
  const FormularioContato({super.key});

  @override
  State<FormularioContato> createState() => _FormularioContatoState();
}

class _FormularioContatoState extends State<FormularioContato> {
  final TextEditingController _controladorNome = TextEditingController();
  final TextEditingController _controladorConta = TextEditingController();

  @override
  void dispose() {
    _controladorNome.dispose();
    _controladorConta.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    final String nome = _controladorNome.text.trim();
    final int? conta = int.tryParse(_controladorConta.text.trim());

    if (nome.isEmpty || conta == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos corretamente.')),
      );
      return;
    }

    final contato = Contato(nome: nome, numeroConta: conta);

    final idGerado = await salvarContato(contato);
    debugPrint('Contato salvo com id: $idGerado');

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Contato')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Editor(
              controlador: _controladorNome,
              rotulo: 'Nome',
              dica: 'Ex: Maria Oliveira',
              icone: Icons.person,
              tipoTeclado: TextInputType.text, // teclado padrão
            ),

            Editor(
              controlador: _controladorConta,
              rotulo: 'Número da conta',
              dica: '0000',
              icone: Icons.numbers,
              tipoTeclado: TextInputType.number, // teclado numérico
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _salvar,
                child: const Text('Salvar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
