import 'package:flutter/material.dart';
import 'package:made_by_nanu/components/order_item.dart';
import 'package:made_by_nanu/models/order.dart';
import '../db_helper.dart';

class OrdersPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OrdersPage();
}

class _OrdersPage extends State<OrdersPage> {

  List<OrderModel> _orders = [];

  @override
  void initState() {
    super.initState();
    _getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      body: ListView.builder(
        itemCount: _orders.length,
        itemBuilder: (context, index) {
          return OrderItem(_orders[index]);
        },
      ),
    );
  }

  _getOrders() async {
    var dbHelper = DbHelper.instance;
    var db = await dbHelper.database;
    var orders = await db.rawQuery('SELECT * FROM Orders');
    if (orders.isNotEmpty) {
      _orders = orders.map((i) => OrderModel.fromJson(i)).toList();
    }

    setState(() {
      _orders;
    });
  }
}