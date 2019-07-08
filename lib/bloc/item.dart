import 'package:made_by_nanu/models/item.dart';
import 'package:made_by_nanu/models/shoe.dart';

class ItemBloc {
  final List<ItemModel> _items = [
    new ShoeModel(
        1,
        'images/shoes_1.jpeg',
        'Beautiful decoration on any shoe of your choosing.'
    )
  ];

  List<ItemModel> get items => _items;
}