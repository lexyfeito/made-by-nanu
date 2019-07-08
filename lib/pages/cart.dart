import 'package:flutter/material.dart';
import 'package:made_by_nanu/bloc/cart.dart';
import 'package:made_by_nanu/components/item.dart';
import 'package:made_by_nanu/models/item.dart';
import 'package:made_by_nanu/models/order.dart';
import 'package:made_by_nanu/models/order_item.dart';
import 'package:made_by_nanu/models/shoe.dart';

import '../db_helper.dart';

class CartPage extends StatefulWidget {
  final CartBloc cartBloc;
  CartPage(this.cartBloc);

  @override
  State<StatefulWidget> createState() => _CartPage(cartBloc);
}

class _CartPage extends State<CartPage> {
  
  final CartBloc cartBloc;
  _CartPage(this.cartBloc);
  
  @override
  void initState() {
    super.initState();
    cartBloc.elementEventSink.add(GetItems());
  }
  
  @override
  void dispose() {
    super.dispose();
  }

  Map<int, List<ItemModel>> reduceCartList(List<ItemModel> cart) {
    Map<int, List<ItemModel>> cartReduced = Map();
    cart.fold(0, (t, ItemModel b) {
      if (cartReduced.containsKey(b.id)) cartReduced[b.id].add(b);
      else cartReduced[b.id] = [b];
    });

    return cartReduced;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
        stream: cartBloc.stream,
        builder: (context, AsyncSnapshot<List<ItemModel>> snapshot) {
          if (snapshot.data == null) return Center(child: CircularProgressIndicator(),);
          var items = snapshot.data;
          if (items == null || items.length == 0) return Center(child: Icon(Icons.remove_shopping_cart));
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Item(items[index], showRemoveIcon: true,);
            },
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: FlatButton(
          child: Text('Submit Order'),
          textTheme: ButtonTextTheme.primary,
          onPressed: () {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Ready to submit'),
                  content: Text('We will process your order an email you as soon as it is ready. Submit?'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('No'),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    FlatButton(
                      child: Text('Yes'),
                      onPressed: () async {
                        var dbHelper = DbHelper.instance;
                        var db = await dbHelper.database;
                        var order = OrderModel(DateTime.now());
                        int id = await db.insert('Orders', order.toJson());
                        cartBloc.cart.forEach((ItemModel i) async {
                          if (i is ShoeModel) {
                            var orderItem = OrderItemModel(id, i.id, i.size, i.color);
                            var orderItemId = await db.insert('Order_Item', orderItem.toJson());
                            print(orderItemId);
                          }
                        });
                        Navigator.of(context).pop(true);
                      },
                    )
                  ],
                );
              }
            );
          },
        ),
      ),
    );
  }

  _showOrderItem() {

  }

  _subtitle(ItemModel item) {
    if (item is ShoeModel) {
      ShoeModel shoe = item as ShoeModel;
      return Row(
        children: <Widget>[
//          Text("x${items.length}"),
          Text("size: ${shoe.size}"),
          Container(
            margin: EdgeInsets.only(left: 10),
          ),
          Text("color: ${shoe.color}")
        ],
      );
    }
  }
}