abstract class ItemInterface {
  int id;
  String image;
  String description;

  Map<String, dynamic> toJson();
  Map<String, dynamic> toCartJson();
}

class ItemModel implements ItemInterface {
  int id;
  String image;
  String description;

  ItemModel(this.id, this.image, this.description);

  Map<String, dynamic> toJson() => {
    'id': id,
    'image': image,
    'description': description
  };

  Map<String, dynamic> toCartJson() => {
    'item_id': id,
  };
}