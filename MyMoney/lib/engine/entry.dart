import 'dart:convert';

Entry clientFromJson(String str) {
  final jsonData = json.decode(str);
  return Entry.fromJson(jsonData);
}

String clientToJson(Entry entry) {
  final dyn = entry.toJson();
  return json.encode(dyn);
}

class Entry {
  int id;
  String type;
  String name;
  String tagString;
  DateTime date;
  double amount;

  Entry(
      {this.id, this.name, this.tagString, this.amount, this.date, this.type});

  List<String> get tags {
    return (tagString != null) ? tagString.split(" ") : null;
  }

  factory Entry.fromJson(Map<String, dynamic> json) => new Entry(
        id: json["id"],
        name: json["name"],
        amount: json["amount"],
        date: DateTime.fromMillisecondsSinceEpoch(json["date"]),
        tagString: json["tagString"],
        type: json["type"],
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "amount": amount,
        "type": type,
        "date": date.millisecondsSinceEpoch,
        "tagString": tagString,
      };
}
