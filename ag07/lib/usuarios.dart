import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'editar_usuario.dart';
import 'login_screen.dart';

class UsuariosScreen extends StatefulWidget {
  @override
  _UsuariosScreenState createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  final CollectionReference usuariosCollection =
  FirebaseFirestore.instance.collection('usuarios');

  void _excluirUsuario(String usuarioId) async {
    try {
      await usuariosCollection.doc(usuarioId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuário excluído com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir usuário: ${e.toString()}')),
      );
    }
  }

  void _editarUsuario(String usuarioId, Map<String, dynamic> usuarioData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditarUsuarioScreen(
          usuarioId: usuarioId,
          usuarioData: usuarioData,
        ),
      ),
    ).then((value) {
      if (value == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuário editado com sucesso!')),
        );
        setState(() {});
      }
    });
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Lista de Usuários')),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: usuariosCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Nenhum usuário encontrado.'));
          }

          final usuarios = snapshot.data!.docs;

          return ListView.builder(
            itemCount: usuarios.length,
            itemBuilder: (context, index) {
              final usuario = usuarios[index];
              final usuarioId = usuario.id;
              final usuarioData = usuario.data() as Map<String, dynamic>;

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(usuarioData['nome'] ?? 'Sem nome'),
                  subtitle: Text(usuarioData['email'] ?? 'Sem e-mail'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _editarUsuario(usuarioId, usuarioData),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmarExclusao(usuarioId),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _confirmarExclusao(String usuarioId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Excluir Usuário'),
        content: Text('Você tem certeza que deseja excluir este usuário?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _excluirUsuario(usuarioId);
            },
            child: Text('Excluir'),
          ),
        ],
      ),
    );
  }
}
