import 'package:flutter/material.dart';
import 'package:made_by_nanu/bloc/item.dart';
import 'package:made_by_nanu/models/cart.dart';
import 'package:made_by_nanu/models/item.dart';
import 'package:badges/badges.dart';
import 'package:made_by_nanu/bloc/cart.dart';
import 'package:made_by_nanu/models/shoe.dart';
import 'package:made_by_nanu/pages/settings.dart';

import 'about.dart';
import 'cart.dart';
import 'orders.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {

  final cartBloc = CartBloc();
  final itemBloc = ItemBloc();
  List<ItemModel> items;

  _HomePage() {
    items = itemBloc.items;
  }

  @override
  void initState() {
    super.initState();
    cartBloc.elementEventSink.add(GetItems());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Made By Nanu"),
        actions: [
          StreamBuilder(
            stream: cartBloc.stream,
            builder: (BuildContext context, AsyncSnapshot<List<CartModel>> snapshot) {
              return IconButton(
                icon: Badge(
                  child: Icon(Icons.shopping_cart),
                  badgeContent: snapshot.data == null ? Text("0") : Text("${snapshot.data.length}"),
                  animationType: BadgeAnimationType.scale,
                ),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage(cartBloc))),
              );
            },
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey[200]
              ),
              child: Text('Made By Nanu', style: TextStyle(fontSize: 22, color: Colors.red),),
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text("Orders"),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => OrdersPage())),
              trailing: Icon(Icons.chevron_right, color: Colors.red,),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("About"),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AboutPage())),
              trailing: Icon(Icons.chevron_right, color: Colors.red,),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage())),
              trailing: Icon(Icons.chevron_right, color: Colors.red,),
            )
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image.asset(items[index].image),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Text(items[index].description, textAlign: TextAlign.left,)
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    FlatButton(
                      child: Text("ADD TO CART"),
                      onPressed: () async {
                        var sizeController = TextEditingController();
                        var colorController = TextEditingController();
                        if (items[index] is ShoeModel) {
                          var shoeItem = items[index] as ShoeModel;
                          var newItem = ShoeModel(shoeItem.id, shoeItem.image, shoeItem.description, size: shoeItem.size, color: shoeItem.color);
                          await showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Options"),
                                  content: Container(
                                    width: 100,
                                    height: 200,
                                    child: Column(
                                      children: <Widget>[
                                        TextField(
                                          decoration: InputDecoration(
                                              labelText: "Size"
                                          ),
                                          controller: sizeController,
                                        ),
                                        TextField(
                                          decoration: InputDecoration(
                                            labelText: "Color"
                                          ),
                                          controller: colorController,
                                        )
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text("Save"),
                                      onPressed: () {
                                        if (sizeController.text.isEmpty || colorController.text.isEmpty) return;
                                        newItem.size = sizeController.text;
                                        newItem.color = colorController.text;
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                );
                              }
                          );
                          cartBloc.elementEventSink.add(AddItem(CartModel(0, newItem)));
                        }
                      },
                      textTheme: ButtonTextTheme.primary,
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}