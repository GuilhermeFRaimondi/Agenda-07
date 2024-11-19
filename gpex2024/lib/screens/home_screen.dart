import 'package:flutter/material.dart';
import '../widgets/drawer_menu.dart';
import 'criar_orcamento_screen.dart';
import '../models/orcamento.dart';
import '../widgets/orcamento_item.dart';
import 'confirmacao_screen.dart';
import 'cliente_orcamento_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Orcamento> _orcamentos = [];

  void _adicionarOrcamento(Orcamento orcamento) {
    setState(() {
      int index = _orcamentos.indexWhere((o) => o.id == orcamento.id);
      if (index != -1) {
        _orcamentos[index] = orcamento;
      } else {
        _orcamentos.add(orcamento);
      }
    });
  }

  void _abrirCriarOrcamento() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CriarOrcamentoScreen(
          onSalvarOrcamento: _adicionarOrcamento,
        ),
      ),
    );
  }

  void _abrirConfirmacao(Orcamento orcamento) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmacaoScreen(orcamento: orcamento),
      ),
    );
    setState(() {}); // Atualiza a tela após retornar
  }

  void _editarOrcamento(Orcamento orcamento) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CriarOrcamentoScreen(
          onSalvarOrcamento: _adicionarOrcamento,
          orcamentoExistente: orcamento,
        ),
      ),
    );
  }

  void _excluirOrcamento(Orcamento orcamento) {
    setState(() {
      _orcamentos.removeWhere((o) => o.id == orcamento.id);
    });
  }

  void _finalizarOrcamento(Orcamento orcamento) {
    setState(() {
      orcamento.status = 'Serviço Concluído';
    });
  }

  void _gerarLinkOrcamento(Orcamento orcamento) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClienteOrcamentoScreen(
          orcamento: orcamento,
        ),
      ),
    );

    if (resultado != null && resultado is Orcamento) {
      _adicionarOrcamento(resultado);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Painel do Mecânico'),
      ),
      drawer: DrawerMenu(),


      /*primeiros textos do orçamento formatado*/
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Orçamentos',
              style: TextStyle(color: Colors.green, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Ativos',
              style: TextStyle(color: Colors.green, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            /*Fim dos textos e início do container onde ficarão anexados os orçamentos*/

            Container(
              width: double.infinity,
              height: 400,
              margin: EdgeInsets.only(top: 16),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: _orcamentos.isEmpty
                  ? Center(
                child: Text(
                  'Nenhum orçamento em andamento.',
                  style: TextStyle(color: Colors.black54, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              )
                  : ListView.builder(
                itemCount: _orcamentos.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: OrcamentoItem(
                      orcamento: _orcamentos[index],
                      onTap: () => _abrirConfirmacao(_orcamentos[index]),
                      onEditar: () => _editarOrcamento(_orcamentos[index]),
                      onExcluir: () => _excluirOrcamento(_orcamentos[index]),
                      onFinalizar: () => _finalizarOrcamento(_orcamentos[index]),
                      onGerarLink: () => _gerarLinkOrcamento(_orcamentos[index]),
                    ),
                  );
                },
              ),
            ),
            /*Fim do container e lógica de adição de orçamentos*/

            /**/
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 16),
              child: ElevatedButton(
                onPressed: _abrirCriarOrcamento,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Novo Orçamento',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
