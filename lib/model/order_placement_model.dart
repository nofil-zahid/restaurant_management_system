// models/order_placement.dart
class OrderPlacement {
  final int orderId;
  final int customerId;
  final int userId;
  final int foodId;
  final int quantity;

  OrderPlacement({
    required this.orderId,
    required this.customerId,
    required this.userId,
    required this.foodId,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'op_id': orderId,
      'cus_id': customerId,
      'user_id': userId,
      'food_id': foodId,
      'qty': quantity,
    };
  }

  factory OrderPlacement.fromMap(Map<String, dynamic> map) {
    return OrderPlacement(
      orderId: map['op_id'],
      customerId: map['cus_id'],
      userId: map['user_id'],
      foodId: map['food_id'],
      quantity: map['qty'],
    );
  }
}
