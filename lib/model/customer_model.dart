// models/customer.dart
class Customer {
  final int customerId;
  final String customerHash;

  Customer({
    required this.customerId,
    required this.customerHash,
  });

  Map<String, dynamic> toMap() {
    return {
      'cus_id': customerId,
      'cus_hash': customerHash,
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      customerId: map['cus_id'],
      customerHash: map['cus_hash'],
    );
  }
}
