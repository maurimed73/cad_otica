import 'package:cad_otica/models/inadimplente.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ProcurarCpf extends StatefulWidget {
  const ProcurarCpf({super.key});

  @override
  State<ProcurarCpf> createState() => _ProcurarCpfState();
}

class _ProcurarCpfState extends State<ProcurarCpf> {
  TextEditingController controllerCpf = TextEditingController();
  FirebaseFirestore db = FirebaseFirestore.instance;

  List<Inadimplente> listaDevedores = [];

  final maskCpf = MaskTextInputFormatter(
      mask: "###.###.###-##", filter: {"#": RegExp(r'[0-9]')});

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Row(
                children: [
                  Text(
                    'CPF',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: TextField(
                        textInputAction: TextInputAction.go,
                        onSubmitted: (value) async {
                          bool result = await buscaCpf(value);
                        },
                        inputFormatters: [maskCpf],
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.top,
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                        controller: controllerCpf,
                        decoration: InputDecoration(
                          fillColor: Colors.blueGrey.withOpacity(0.1),
                          filled: true,
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.teal)),
                          suffixIconColor: Colors.redAccent,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                listaDevedores = [];
                              });
                              controllerCpf.text = "";
                            },
                            icon: Icon(Icons.clear),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              loading
                  ? Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                          child: CircularProgressIndicator(
                        strokeAlign: BorderSide.strokeAlignCenter,
                      )),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        child: ListView(
                          children: List.generate(
                            listaDevedores.length,
                            (index) {
                              Inadimplente model = listaDevedores[index];
                              return Dismissible(
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  alignment: Alignment.centerRight,
                                  color: Colors.red,
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                                onDismissed: (direction) {
                                  //remove(model);
                                },
                                key: ValueKey<Inadimplente>(model),
                                child: Card(
                                  color: Colors.blueGrey[100],
                                  child: ListTile(
                                    onTap: () {
                                      print('clicou');
                                    },
                                    onLongPress: () {
                                      // showFormModal(model: model);
                                    },
                                    leading: const Icon(Icons.list_alt_rounded),
                                    title: Text(
                                      model.nome,
                                      style: TextStyle(fontSize: 14),
                                      textAlign: TextAlign.start,
                                    ),
                                    subtitle: Row(
                                      children: [
                                        Container(
                                            width: 100,
                                            child: Text(model.valor.toString(),
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                ))),
                                        Container(
                                          width: 100,
                                          child: Text(
                                            model.dataDebito,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> buscaCpf(String text) async {
    print('chamou o método');
    setState(() {
      loading = true;
    });

    List<Inadimplente> temp = [];
    QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection('cad_cred')
        .where('cpf', isEqualTo: text)
        .get();

    for (var doc in snapshot.docs) {
      temp.add(Inadimplente.fromJson(doc.data()));
    }

    setState(() {
      listaDevedores = temp;
      loading = false;
    });
    print('passou do método');

    if (temp.length > 0) {
      return true;
    } else {
      const snackBar = SnackBar(
        content: Text('Não há registro cadastrado'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      return false;
    }
  }
}

Widget buildUser(Inadimplente inadimplente) => ListTile(
      title: Text(inadimplente.nome),
      subtitle: Text(inadimplente.valor.toString()),
    );
