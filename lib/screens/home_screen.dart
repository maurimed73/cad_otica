import 'package:cad_otica/models/inadimplente.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Inadimplente> listaDevedores = [
    // Listin(id: "L001", name: "Feira de Outubro"),
    // Listin(id: "L002", name: "Feira de Novembro"),
  ];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController dataCadastroController = TextEditingController();
  TextEditingController dataDebitoController = TextEditingController();
  TextEditingController cpfController = TextEditingController();
  TextEditingController lojaController = TextEditingController();
  TextEditingController situacaoController = TextEditingController();
  TextEditingController valorController = TextEditingController();

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CadCred Aurora"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showFormModal();
        },
        child: const Icon(Icons.add),
      ),
      body: (listaDevedores.isEmpty)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () {
                return refresh();
              },
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
                        remove(model);
                      },
                      key: ValueKey<Inadimplente>(model),
                      child: ListTile(
                        onTap: () {
                          print('clicou');
                        },
                        onLongPress: () {
                          showFormModal(model: model);
                        },
                        leading: const Icon(Icons.list_alt_rounded),
                        title: Text(model.nome),
                        subtitle: Text(
                          model.id,
                          style: const TextStyle(fontSize: 10),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }

  showFormModal({Inadimplente? model}) {
    // Labels à serem mostradas no Modal
    String title = "Adicionar Devedor";
    String confirmationButton = "Salvar";
    String skipButton = "Cancelar";

    // Controlador do campo que receberá o nome do Listin
    TextEditingController nameController = TextEditingController();

    // Caso esteja editando
    if (model != null) {
      title = "Editando ${model.nome}";
      nameController.text = model.nome;
    }

    // Função do Flutter que mostra o modal na tela
    showModalBottomSheet(
      context: context,

      // Define que as bordas verticais serão arredondadas
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(32.0),

          // Formulário com Título, Campo e Botões
          child: ListView(
            children: [
              Text(title, style: Theme.of(context).textTheme.headline5),
              TextFormField(
                controller: nameController,
                decoration:
                    const InputDecoration(label: Text("Nome do Devedor")),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(skipButton),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        //criar um objeto Listin com as infos
                        Inadimplente listin = Inadimplente(
                            id: const Uuid().v1(),
                            nome: nameController.text,
                            dataCadastro: dataCadastroController.text,
                            dataDebito: dataDebitoController.text,
                            cpf: cpfController.text,
                            loja: lojaController.text,
                            situacao: bool.parse(situacaoController.text),
                            valor: double.parse(valorController.text));

                        // usar id do model
                        if (model != null) {
                          listin.id = model.id;
                        }

                        // salvar no firestore
                        firestore
                            .collection('cad_cred')
                            .doc(listin.id)
                            .set(listin.toJson());

                        // Atualizar a lista
                        refresh();

                        // fechar o modal
                        Navigator.pop(context);
                      },
                      child: Text(confirmationButton)),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  refresh() async {
    List<Inadimplente> temp = [];
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection('cad_cred').get();

    for (var doc in snapshot.docs) {
      temp.add(Inadimplente.fromJson(doc.data()));
    }

    setState(() {
      listaDevedores = temp;
    });
  }

  void remove(Inadimplente model) {
    firestore.collection('cad_cred').doc(model.id).delete();
    refresh();
  }
}
