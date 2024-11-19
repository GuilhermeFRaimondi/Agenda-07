import 'package:flutter/material.dart';
import '../screens/login_screen.dart';

class DrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blueAccent,
            ),
            child: Text('Menu', style: TextStyle(fontSize: 24)),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Homepage da Empresa'),
            onTap: () {
              // Encaminhar p/ página da empresa
            },
          ),
          ListTile(
            leading: Icon(Icons.contact_mail),
            title: Text('Contato'),
            onTap: () {
              // Adicionar lógica para mostrar o contato da empresa qd clica
            },
          ),
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text('Endereço da Empresa'),
            onTap: () {
              // Adicionar endereço da empresa
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Sair'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
