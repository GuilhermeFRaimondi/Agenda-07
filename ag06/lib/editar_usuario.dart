import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditarUsuarioScreen extends StatefulWidget {
  final Map<String, dynamic> usuario;
  const EditarUsuarioScreen({Key? key, required this.usuario}) : super(key: key);

  @override
  State<EditarUsuarioScreen> createState() => _EditarUsuarioScreenState();
}

class _EditarUsuarioScreenState extends State<EditarUsuarioScreen> {
  late TextEditingController nomeController;
  late TextEditingController emailController;
  late TextEditingController enderecoController;
  late TextEditingController dataNascController;

  @override
  void initState() {
    super.initState();
    nomeController = TextEditingController(text: widget.usuario['nome']);
    emailController = TextEditingController(text: widget.usuario['email']);
    enderecoController = TextEditingController(text: widget.usuario['endereco']);
    dataNascController = TextEditingController(text: widget.usuario['data_nascimento']);
  }

  Future<void> salvarAlteracoes() async {
    try {
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(widget.usuario['id'])
          .update({
        'nome': nomeController.text,
        'email': emailController.text,
        'endereco': enderecoController.text,
        'data_nascimento': dataNascController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alterações salvas com sucesso!')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Usuário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: enderecoController,
              decoration: const InputDecoration(labelText: 'Endereço'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: dataNascController,
              decoration: const InputDecoration(labelText: 'Data de Nascimento'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: salvarAlteracoes,
              child: const Text('Salvar Alterações'),
            ),
          ],
        ),
      ),
    );
  }
}
