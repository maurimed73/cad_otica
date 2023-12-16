import 'package:cad_otica/dbFirestore.dart';
import 'package:cad_otica/models/inadimplente.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class resultFirestore extends ChangeNotifier {
  List<Inadimplente> _lista = [];
  FirebaseFirestore db = DBFirestore.get();
  Inadimplente devedor = Inadimplente(
      id: '',
      nome: 'Fernando',
      cpf: '555.555.555-55',
      dataCadastro: '01/01/2021',
      dataDebito: '01/01/2020',
      loja: 'Aurora Costa e Silva',
      valor: 456,
      situacao: true);

  _startRepository() async {
    await _startFirestore();
  }

  _startFirestore() {}

  saveAll(Inadimplente inadimplente) async {
    FirebaseFirestore db = DBFirestore.get();
    final docInadimplente =
        FirebaseFirestore.instance.collection('cad_cred').doc();
    inadimplente.id = docInadimplente.id;

    final json = inadimplente.toJson();
    await docInadimplente.set(json);
  }

  readAll() async {
    final snapshot = await db.collection('cad_cred').get();
    snapshot.docs.forEach((document) {
      print(document);
    });
  }
}
