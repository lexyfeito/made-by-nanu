import 'dart:async';

import 'package:made_by_nanu/models/cart.dart';
import 'package:made_by_nanu/models/shoe.dart';

import '../db_helper.dart';
import 'item.dart';

abstract class CartEvent {}

class GetItems extends CartEvent {

}
class AddItem extends CartEvent {
  CartModel cart;
  AddItem(this.cart);
}
class RemoveItem extends CartEvent {
  int index;
  RemoveItem(this.index);
}
class RemoveById extends CartEvent {
  int id;
  RemoveById(this.id);
}

class CartBloc {
  DbHelper dbHelper;
  ItemBloc itemBloc = ItemBloc();
  List<CartModel> _cart = [];

  List<CartModel> get cart => _cart;

  final StreamController _ctrl = StreamController<List<CartModel>>.broadcast();
  Stream<List<CartModel>> get stream => _ctrl.stream;

  final _eventController = StreamController<CartEvent>.broadcast();
  Sink<CartEvent> get elementEventSink => _eventController.sink;

  CartBloc() {
    _eventController.stream.listen(_handleCtrlEvent);
    dbHelper = DbHelper.instance;
  }

  _handleCtrlEvent(CartEvent event) async {
    if (event is GetItems) {
      var db = await dbHelper.database;
      var items = await db.query('Cart');
      if (items.isNotEmpty) {
        _cart = items.map((i) {
          var item = itemBloc.items.firstWhere((x) => x.id == i['item_id']);
          if (item != null) {
            if (item is ShoeModel) {
              item.size = i['shoe_size'];
              item.color = i['shoe_color'];
            }
          }

          return CartModel(i['id'], item);
        }).toList();
      }
    } else if (event is AddItem) {
      var db = await dbHelper.database;
      var itemJson = event.cart.toJson();
      db.insert('Cart', itemJson);
      _cart.add(event.cart);
    } else if (event is RemoveItem) {
      _cart.removeAt(event.index);
    } else if (event is RemoveById) {
      var db = await dbHelper.database;
      try {
        await db.delete('Cart', where: 'id = ?', whereArgs: [event.id]);
        int index = _cart.indexWhere((i) => i.id == event.id);
        _cart.removeAt(index);
      } catch (e) {
        print(e);
      }
    }

    _ctrl.sink.add(_cart);
  }

  dispose() {
    _ctrl.close();
  }
}