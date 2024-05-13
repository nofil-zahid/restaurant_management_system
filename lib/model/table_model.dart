// models/table.dart
class TableModel {
  final int id;
  final int tableNumber;
  final int isReserved;

  TableModel({
    required this.id,
    required this.tableNumber,
    required this.isReserved,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      't_no': tableNumber,
      'is_reserved': isReserved,
    };
  }

  factory TableModel.fromMap(Map<String, dynamic> map) {
    return TableModel(
      id: map['id'],
      tableNumber: map['t_no'],
      isReserved: map['is_reserved'],
    );
  }
}
