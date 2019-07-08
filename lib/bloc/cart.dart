import 'dart:async';

import 'package:made_by_nanu/models/item.dart';
import 'package:made_by_nanu/models/shoe.dart';

import '../db_helper.dart';
import 'item.dart';

abstract class CartEvent {}

class GetItems extends CartEvent {

}
class AddItem extends CartEvent {
  ItemModel item;
  AddItem(this.item);
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
  List<ItemModel> _cart = [];

  List<ItemModel> get cart => _cart;

  final StreamController _ctrl = StreamController<List<ItemModel>>.broadcast();
  Stream<List<ItemModel>> get stream => _ctrl.stream;

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

          return item;
        }).toList();
        print(_cart);
      }
    } else if (event is AddItem) {
      var db = await dbHelper.database;
      var itemJson = event.item.toCartJson();
      db.insert('Cart', itemJson);
      _cart.add(event.item);
    } else if (event is RemoveItem) {
      _cart.removeAt(event.index);
    } else if (event is RemoveById) {
      int index = _cart.indexWhere((i) => i.id == event.id);
      _cart.removeAt(index);
    }

    _ctrl.sink.add(_cart);
  }

  dispose() {
    _ctrl.close();
  }
}