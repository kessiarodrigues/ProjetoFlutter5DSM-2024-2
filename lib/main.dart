import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() => runApp(const Banco());

class Banco extends StatelessWidget {
  const Banco({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.pink,
          appBarTheme: AppBarTheme(
              backgroundColor: Colors.pinkAccent,
              titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          buttonTheme: ButtonThemeData(buttonColor: Colors.pink),
          floatingActionButtonTheme:
              FloatingActionButtonThemeData(backgroundColor: Colors.pink[700])),
      home: Dashboard(),
    );
  }
}

class FormularioTransferencia extends StatelessWidget {
  final TextEditingController _controllerCampoNumeroConta =
      TextEditingController();
  final TextEditingController _controllerCampoValor = TextEditingController();

  FormularioTransferencia({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //cololocar cor no texto Transferência
        title: const Text(
          "Nova Transferência",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Editor(
              controlador: _controllerCampoNumeroConta,
              rotulo: 'Numero da conta',
              dica: '0000'),
          Editor(
              controlador: _controllerCampoValor,
              rotulo: 'Valor',
              dica: '0.00',
              icone: Icons.monetization_on),
          ElevatedButton(
            onPressed: () {
              _criarTransferencia(
                context,
                _controllerCampoNumeroConta,
                _controllerCampoValor,
              );
            },
            child: const Text(
              'Confirmar',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          )
        ],
      ),
    );
  }

  void _criarTransferencia(
      BuildContext context, controllerCampoNumeroConta, controllerCampoValor) {
    debugPrint("Clicou em confirmar");
    final int? numeroConta = int.tryParse(controllerCampoNumeroConta.text);
    final double? valor = double.tryParse(controllerCampoValor.text);
    if (numeroConta != null && valor != null) {
      final transferenciaCriada = Transferencia(valor, numeroConta);
      debugPrint('Criando transferência');
      debugPrint('$transferenciaCriada');
      Navigator.pop(context, transferenciaCriada);
    }
  }
}

class Editor extends StatelessWidget {
  final TextEditingController? controlador;
  final String? rotulo;
  final String? dica;
  final IconData? icone;

  const Editor(
      {super.key, this.controlador, this.rotulo, this.dica, this.icone});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controlador,
        style: const TextStyle(fontSize: 24.0),
        decoration: InputDecoration(
          icon: icone != null
              ? Icon(
                  icone,
                  color: Colors.green,
                )
              : null,
          labelText: rotulo,
          hintText: dica,
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }
}

class ListaTransferencia extends StatefulWidget {
  final List<Transferencia> _transferencias = [];

  ListaTransferencia({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ListaTransferenciasState();
  }
}

class ListaTransferenciasState extends State<ListaTransferencia> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //cololocar cor no texto Transferência
        title: const Text(
          "Transferência",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
          itemCount: widget._transferencias.length,
          itemBuilder: (context, indice) {
            final transferencia = widget._transferencias[indice];
            return ItemTransferencia(transferencia);
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final Future<Transferencia?> future =
              Navigator.push(context, MaterialPageRoute(builder: (context) {
            return FormularioTransferencia();
          }));
          future.then((transferenciaRecebida) {
            debugPrint('chegou no then do future');
            debugPrint('$transferenciaRecebida');
            setState(() {
              widget._transferencias.add(transferenciaRecebida!);
            });
          });
        },
        child: const Icon(
          Icons.add_circle_rounded,
          size: 35,
          color: Colors.white,
        ),
      ),
    );
  }
}

class ItemTransferencia extends StatelessWidget {
  final Transferencia _transferencia;

  const ItemTransferencia(this._transferencia, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.monetization_on, color: Colors.green),
        title: Text(
          NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$')
              .format(_transferencia.valor),
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(_transferencia.numeroConta.toString()),
      ),
    );
  }
}

class Transferencia {
  final double valor; //
  final int numeroConta;

  Transferencia(this.valor, this.numeroConta);

  @override
  String toString() {
    return 'Transferência{valor: $valor, numeroConta: $numeroConta}';
  }
}

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                _FeatureItem(
                  'Transferência',
                  Icons.monetization_on,
                  onClick: () => _showTransferenciasList(context),
                ),
                _FeatureItem(
                  'Contatos',
                  Icons.people,
                  onClick: () => _showContatosList(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showTransferenciasList(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ListaTransferencia(),
      ),
    );
  }

  void _showContatosList(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ListaContatos(),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final String name;
  final IconData icon;
  final Function onClick;

  _FeatureItem(this.name, this.icon, {required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Theme.of(context).primaryColor,
        child: InkWell(
          onTap: () => onClick(),
          child: Container(
            padding: EdgeInsets.all(8.0),
            width: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(
                  icon,
                  color: Colors.white,
                  size: 24.0,
                ),
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ListaContatos extends StatefulWidget {
  @override
  _ListaContatosState createState() => _ListaContatosState();
}

class _ListaContatosState extends State<ListaContatos> {
  final List _contatos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contatos'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          final contato = _contatos[index];
          return _ContatoItem(contato);
        },
        itemCount: _contatos.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (context) => FormularioContato(),
            ),
          )
              .then((novoContato) {
            if (novoContato != null) {
              setState(() {
                _contatos.add(novoContato);
              });
            }
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class _ContatoItem extends StatelessWidget {
  final contato;

  _ContatoItem(this.contato);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(
            Icons.person,
            color: Colors.white,
          ),
        ),
        title: Text(
          contato.nome,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          contato.telefone,
          style: TextStyle(
            fontSize: 14.0,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Endereço', contato.endereco),
                _buildInfoRow('E-mail', contato.email),
                _buildInfoRow('CPF', contato.cpf),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 14.0),
            ),
          ),
        ],
      ),
    );
  }
}

class FormularioContato extends StatefulWidget {
  @override
  _FormularioContatoState createState() => _FormularioContatoState();
}

class _FormularioContatoState extends State<FormularioContato> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Novo contato'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(
                labelText: 'Nome completo',
              ),
              style: TextStyle(
                fontSize: 24.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextField(
                controller: _enderecoController,
                decoration: InputDecoration(
                  labelText: 'Endereço',
                ),
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextField(
                controller: _telefoneController,
                decoration: InputDecoration(
                  labelText: 'Telefone',
                ),
                style: TextStyle(
                  fontSize: 24.0,
                ),
                keyboardType: TextInputType.phone,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                ),
                style: TextStyle(
                  fontSize: 24.0,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextField(
                controller: _cpfController,
                decoration: InputDecoration(
                  labelText: 'CPF',
                ),
                style: TextStyle(
                  fontSize: 24.0,
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  child: Text('Criar'),
                  onPressed: () {
                    final String nome = _nomeController.text;
                    final String endereco = _enderecoController.text;
                    final String telefone = _telefoneController.text;
                    final String email = _emailController.text;
                    final String cpf = _cpfController.text;

                    final novoContato = (
                      nome: nome,
                      endereco: endereco,
                      telefone: telefone,
                      email: email,
                      cpf: cpf,
                    );
                    Navigator.pop(context, novoContato);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
