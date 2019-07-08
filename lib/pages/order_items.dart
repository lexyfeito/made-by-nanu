import 'package:flutter/material.dart';
import 'package:made_by_nanu/bloc/item.dart';
import 'package:made_by_nanu/components/item.dart';
import 'package:made_by_nanu/models/order_item.dart';
import 'package:made_by_nanu/models/shoe.dart';

class OrderItemsPage extends StatelessWidget {

  List<OrderItemModel> items;
  OrderItemsPage(this.items);
  ItemBloc itemBloc = ItemBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: items.map((i) {
          return Item(_getItem(i));
        }).toList(),
      ),
    );
  }

  _getItem(item) {
    var i = itemBloc.items.firstWhere((i) => i.id == item.itemId);
    if (i is ShoeModel) {
      return ShoeModel(i.id, i.image, i.description, size: item.shoeSize, color: item.shoeColor);
    }
  }
}