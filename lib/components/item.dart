import 'package:flutter/material.dart';
import 'package:made_by_nanu/bloc/cart.dart';
import 'package:made_by_nanu/bloc/item.dart';
import 'package:made_by_nanu/models/item.dart';
import 'package:made_by_nanu/models/shoe.dart';

class Item extends StatefulWidget {

  ItemModel item;
  bool showRemoveIcon;
  Item(this.item, {this.showRemoveIcon = false});

  @override
  State<StatefulWidget> createState() => _Item(item, showRemoveIcon);
}

class _Item extends State<Item> {

  bool showRemoveIcon;
  ItemModel item;
  ItemBloc itemBloc = ItemBloc();
  CartBloc cartBloc = CartBloc();
  _Item(this.item, this.showRemoveIcon);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(item.image),
      ),
      title: Text(item.description),
      subtitle: _subtitle(item),
      trailing: showRemoveIcon ? IconButton(icon: Icon(Icons.delete), onPressed: () {
        cartBloc.elementEventSink.add(RemoveById(item.id));
      }) : null,
    );
  }

  _subtitle(ItemModel item) {
    if (item is ShoeModel) {
      return Row(
        children: <Widget>[
          Text("size: ${item.size}"),
          Container(
            margin: EdgeInsets.only(left: 10),
          ),
          Text("color: ${item.color}")
        ],
      );
    }
  }
}