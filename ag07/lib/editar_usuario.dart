import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditarUsuarioScreen extends StatefulWidget {
  final String usuarioId;
  final Map<String, dynamic> usuarioData;

  EditarUsuarioScreen({required this.usuarioId, required this.usuarioData});

  @override
  _EditarUsuarioScreenState createState() => _EditarUsuarioScreenState();
}

class _EditarUsuarioScreenState extends State<EditarUsuarioScreen> {
  late TextEditingController nomeController;
  late TextEditingController emailController;
  late TextEditingController enderecoController;
  late TextEditingController dataNascimentoController;

  @override
  void initState() {
    super.initState();
    nomeController = TextEditingController(text: widget.usuarioData['nome']);
    emailController = TextEditingController(text: widget.usuarioData['email']);
    enderecoController =
        TextEditingController(text: widget.usuarioData['endereco']);
    dataNascimentoController =
        TextEditingController(text: widget.usuarioData['data_nascimento']);
  }

  void _salvarAlteracoes() async {
    try {
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(widget.usuarioId)
          .update({
        'nome': nomeController.text,
        'email': emailController.text,
        'endereco': enderecoController.text,
        'data_nascimento': dataNascimentoController.text,
      });

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar alterações: ${e.toString()}')),
      );
    }
  }

  Future<void> _selecionarData(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        dataNascimentoController.text =
        "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Usuário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nomeController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'E-mail'),
            ),
            TextField(
              controller: enderecoController,
              decoration: InputDecoration(labelText: 'Endereço'),
            ),
            TextField(
              controller: dataNascimentoController,
              readOnly: true,
              onTap: () => _selecionarData(context),
              decoration: InputDecoration(labelText: 'Data de Nascimento'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _salvarAlteracoes,
              child: Text('Salvar Alterações'),
            ),
          ],
        ),
      ),
    );
  }
}
