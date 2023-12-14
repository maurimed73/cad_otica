import 'package:cad_otica/models/inadimplente.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CadastroInadimplente extends StatefulWidget {
  const CadastroInadimplente({super.key});

  @override
  State<CadastroInadimplente> createState() => _CadastroInadimplenteState();
}

class _CadastroInadimplenteState extends State<CadastroInadimplente> {
 

  TextEditingController controllerDataCadastro = TextEditingController();
  TextEditingController controllerNome = TextEditingController();
  TextEditingController controllerCpf = TextEditingController();
  TextEditingController controllerDataDebito = TextEditingController();
  TextEditingController controllerLoja = TextEditingController();
  TextEditingController controllerValor = TextEditingController();
  bool situacao = false;

  List validators = [
    (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter the number';
      }
      return null;
    },
    (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter the email';
      }
      return null;
    },
    (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter the password';
      }
      return null;
    },
  ];
  List formatters = [
    FilteringTextInputFormatter.digitsOnly,
    FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
    FilteringTextInputFormatter.deny(RegExp(r'[/\\]'))
  ];
  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(title: Text('Definir CPF'),actions: [Padding(
        padding: const EdgeInsets.only(right: 20),
        child: IconButton(onPressed: () { 
        final inadimplente = Inadimplente(
          id: '', 
          nome: controllerNome.text, 
          cpf: controllerCpf.text, 
          dataCadastro: controllerDataCadastro.text, 
          dataDebito: controllerDataDebito.text, 
          loja: controllerLoja.text, 
          valor: double.parse(controllerValor.text),
          situacao: true
          );
          
          createInadimplente(inadimplente);

         }, icon: Icon(Icons.done,size: 40,color: Colors.greenAccent)
          
          ),
      )],),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Form(
            
            child: ListView(
              children: [
                TextFormField(
                  
                  controller: controllerDataCadastro,
                  decoration: InputDecoration(
                    labelText: 'Data Cadastro',
                    border: OutlineInputBorder(),
                  ),
                )
              ],
            )
            
          ),
        ),
        
      ),
     
    );
  }
  
  Future createInadimplente(Inadimplente inadimplente)async {
    final docInadimplente = FirebaseFirestore.instance.collection('cad_cred').doc();
    inadimplente.id = docInadimplente.id;

    final json = inadimplente.toJson();
    await docInadimplente.set(json);
  }
}

