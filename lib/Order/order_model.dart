class OrderModel {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final double totalPrice;
  final String status;
  final DateTime created;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalPrice,
    required this.status,
    required this.created,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    id: json['id'],
    userId: json['user'] ?? '',
    items: (json['items'] as List).map((i) => OrderItem.fromJson(i)).toList(),
    totalPrice: (json['total_price'] as num).toDouble(),
    status: json['status'],
    created: DateTime.parse(json['created']),
  );

  Map<String, dynamic> toJson() => {
    "user": userId, // فیلد ریلیشن به کاربر
    "items": items.map((i) => i.toJson()).toList(), // لیست محصولات به صورت JSON
    "total_price": totalPrice,
    "status": status,
  };
}

class OrderItem {
  final String name;
  final double price;
  final int qty;

  OrderItem({required this.name, required this.price, required this.qty});

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    name: json['name'],
    price: (json['price'] as num).toDouble(),
    qty: json['qty'],
  );

  Map<String, dynamic> toJson() => {"name": name, "price": price, "qty": qty};
}