class CashFlow {
  int? id;
  int? type;
  int? amount;
  String? description;
  String? date;
  
  CashFlow({this.id, this.type, this.amount, this.description, this.date, required String inputTime});

  CashFlow.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    amount = json['amount'];
    description = json['description'];
    date = json['date'];
  }

  String? get inputTime => null;

  String? get transactionType => null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['amount'] = amount;
    data['description'] = description;
    data['date'] = date;
    return data;
  }
  
}
