import 'item.dart';

class OrderModel {
  int id;
  DateTime added;

  OrderModel(this.added, {this.id});

  Map<String, dynamic> toJson() => {
    'added': added.toIso8601String()
  };

  factory OrderModel.fromJson(Map<String, dynamic> map) => new OrderModel(
    DateTime.parse(map['added']),
    id: map['id']
  );
}