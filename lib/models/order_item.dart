class OrderItemModel {
  int orderId;
  int itemId;
  String shoeSize;
  String shoeColor;

  OrderItemModel(this.orderId, this.itemId, this.shoeSize, this.shoeColor);

  factory OrderItemModel.fromJson(Map<String, dynamic> map) => new OrderItemModel(
    map['order_id'],
    map['item_id'],
    map['shoe_size'],
    map['shoe_color'],
  );

  Map<String, dynamic> toJson() => {
    "order_id": orderId,
    "item_id": itemId,
    "shoe_size": shoeSize,
    "shoe_color": shoeColor
  };
}