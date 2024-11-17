import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'editar_usuario.dart';

class UsuariosScreen extends StatelessWidget {
  const UsuariosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Lista de Usuários')),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('usuarios').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Nenhum usuário encontrado.'));
          }

          final usuarios = snapshot.data!.docs;

          return ListView.builder(
            itemCount: usuarios.length,
            itemBuilder: (context, index) {
              final usuario = usuarios[index];
              final dados = usuario.data() as Map<String, dynamic>;

              return ListTile(
                title: Text(dados['nome'] ?? 'Sem Nome'),
                subtitle: Text(dados['email'] ?? 'Sem Email'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditarUsuarioScreen(usuario: {
                              'id': usuario.id,
                              ...dados,
                            }),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('usuarios')
                            .doc(usuario.id)
                            .delete();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Usuário excluído com sucesso!'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
