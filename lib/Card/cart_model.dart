class CartModel {
  final String id;
  final String userId;
  final String status; // 'active' or 'completed'

  CartModel({
    required this.id,
    required this.userId,
    required this.status,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'],
      userId: json['user'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
    'user': userId,
    'status': status,
  };
}