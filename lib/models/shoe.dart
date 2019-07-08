import 'item.dart';

class ShoeModel extends ItemModel {
  String size;
  String color;
  ShoeModel(int id, String image, String description, {this.size, this.color}) : super(id, image, description);

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'image': image,
    'description': description,
    'shoe_size': size,
    'shoe_color': color
  };

  @override
  Map<String, dynamic> toCartJson() => {
    'item_id': id,
    'shoe_size': size,
    'shoe_color': color
  };
}