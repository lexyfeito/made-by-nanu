import 'item.dart';

class CartModel {
  int id;
  ItemModel item;

  CartModel(this.id, this.item);

  Map<String, dynamic> toJson() => {
    'id': id,
    'item': item.toCartJson()
  };
}