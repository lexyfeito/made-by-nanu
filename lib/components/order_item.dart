import 'package:flutter/material.dart';
import 'package:made_by_nanu/models/order.dart';
import 'package:made_by_nanu/models/order_item.dart';
import 'package:made_by_nanu/pages/order_items.dart';

import '../db_helper.dart';

class OrderItem extends StatefulWidget {

  OrderModel order;
  OrderItem(this.order);

  @override
  State<StatefulWidget> createState() => _OrderItem(order);
}

class _OrderItem extends State<OrderItem> {

  OrderModel order;
  List<OrderItemModel> orderItems = [];
  _OrderItem(this.order);

  @override
  void initState() {
    super.initState();
    _getItem();
  }

  @override
  Widget build(BuildContext context) {
    var added = order.added;
    var year = added.year;
    var month = added.month;
    var day = added.day;
    return ListTile(
      title: Text('Created: $year-$month-$day'),
      subtitle: Text('Items: ${orderItems.length}'),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => OrderItemsPage(orderItems))),
    );
  }

  _getItem() async {
    var dbHelper = DbHelper.instance;
    var db = await dbHelper.database;
    var map = await db.query('Order_Item', where: 'order_id = ?', whereArgs: [order.id]);
    if (map.isNotEmpty) {
      setState(() {
        orderItems = map.map((i) => OrderItemModel.fromJson(i)).toList();
      });
    }
  }
}