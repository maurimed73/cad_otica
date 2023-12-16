import 'package:cad_otica/dbFirestore.dart';
import 'package:cad_otica/models/inadimplente.dart';
import 'package:cad_otica/result.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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
  final _formKey = GlobalKey<FormState>();
  final maskCpf = MaskTextInputFormatter(
      mask: "###.###.###-##", filter: {"#": RegExp(r'[0-9]')});
  final maskData = MaskTextInputFormatter(
      mask: "##/##/####", filter: {"#": RegExp(r'[0-9]')});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar CPF'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    final inadimplente = Inadimplente(
                        id: '',
                        nome: controllerNome.text,
                        cpf: controllerCpf.text,
                        dataCadastro: controllerDataCadastro.text,
                        dataDebito: controllerDataDebito.text,
                        loja: controllerLoja.text,
                        valor: double.parse(controllerValor.text),
                        situacao: true);
                    createInadimplente(inadimplente);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                    //limpaForm();
                  }
                },
                icon: const Icon(Icons.done,
                    size: 40, color: Colors.greenAccent)),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  insertText(
                    maskFormat: maskData,
                    controller: controllerDataCadastro,
                    label: 'Data Cadastro',
                  ),
                  insertText(
                    maskFormat: null,
                    controller: controllerNome,
                    label: 'Nome Cliente',
                  ),
                  insertText(
                    maskFormat: maskCpf,
                    controller: controllerCpf,
                    label: 'cpf Cliente',
                  ),
                  insertText(
                    maskFormat: maskData,
                    controller: controllerDataDebito,
                    label: 'Data Débito',
                  ),
                  insertText(
                    maskFormat: null,
                    controller: controllerLoja,
                    label: 'Loja',
                  ),
                  insertText(
                    maskFormat: null,
                    controller: controllerValor,
                    label: 'Valor',
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Future createInadimplente(Inadimplente inadimplente) async {
    final docInadimplente =
        FirebaseFirestore.instance.collection('cad_cred').doc();
    inadimplente.id = docInadimplente.id;

    final json = inadimplente.toJson();
    await docInadimplente.set(json);
    //await readAll();
  }

  void limpaForm() {
    controllerDataCadastro.text = '';
    controllerNome.text = '';
    controllerCpf.text = '';
    controllerDataDebito.text = '';
    controllerLoja.text = '';
    controllerValor.text = '';
  }
}

class insertText extends StatelessWidget {
  insertText({
    super.key,
    required this.label,
    required this.controller,
    required this.maskFormat,
  });
  final TextInputFormatter? maskFormat;
  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        height: 55,
        child: TextFormField(
          textAlignVertical: TextAlignVertical.center,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          },
          inputFormatters: maskFormat == null ? [] : [maskFormat!],
          controller: controller,
          decoration: InputDecoration(
            errorStyle: TextStyle(fontSize: 10),
            fillColor: Colors.blueGrey.withOpacity(0.1),
            filled: true,
            labelText: label,
            labelStyle: TextStyle(fontSize: 12),
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
