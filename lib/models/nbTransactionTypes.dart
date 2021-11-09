class NbTransactionTypes {
  String? id;
  String? type;
  int? factor;

  NbTransactionTypes({this.id, this.type,this.factor});

  factory NbTransactionTypes.fromJson(Map<String, dynamic> json) {
    NbTransactionTypes nbTransactionTypes = NbTransactionTypes(
      id: json['id'],
      type: json['type'],
      factor: int.parse(json['factor']),
    );
    return nbTransactionTypes;
  }
}
