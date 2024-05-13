// models/food_menu.dart
class FoodMenu {
  final int foodId;
  final String foodName;
  final String foodDescription;

  FoodMenu({
    required this.foodId,
    required this.foodName,
    required this.foodDescription,
  });

  Map<String, dynamic> toMap() {
    return {
      'food_id': foodId,
      'food_nm': foodName,
      'food_des': foodDescription,
    };
  }

  factory FoodMenu.fromMap(Map<String, dynamic> map) {
    return FoodMenu(
      foodId: map['food_id'],
      foodName: map['food_nm'],
      foodDescription: map['food_des'],
    );
  }
}
