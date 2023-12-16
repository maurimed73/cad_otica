class Inadimplente {
  String id;
  String nome;
  String cpf;
  String dataCadastro;
  String dataDebito;
  String loja;
  double valor;
  bool situacao;

  Inadimplente({
    required this.id,
    required this.nome,
    required this.cpf,
    required this.dataCadastro,
    required this.dataDebito,
    required this.loja,
    required this.valor,
    required this.situacao,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': nome,
        'cpf': cpf,
        'dataCadastro': dataCadastro,
        'dataDebito': dataDebito,
        'loja': loja,
        'valor': valor,
        'situacao': situacao
      };

  static Inadimplente fromJson(Map<String, dynamic> json) => Inadimplente(
      id: json['id'],
      nome: json['name'],
      cpf: json['cpf'],
      dataCadastro: json['dataCadastro'],
      dataDebito: json['dataDebito'],
      loja: json['loja'],
      valor: json['valor'],
      situacao: json['situacao']);
}
