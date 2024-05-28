import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> addUser(String username, String password, DocumentReference roleRef) async {
  try {
    await FirebaseFirestore.instance.collection('users').add({
      'name': username,
      'password': password,
      'role': roleRef
    });
    print("User Added");
    return true;
  } catch (error) {
    print("Failed to add user: $error");
    return false;
  }
}

Future<String?> getRoleId(String roleDescription) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('roles')
        .where('role_des', isEqualTo: roleDescription)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id;
    } else {
      print("No matching role found");
      return null;
    }
  } catch (error) {
    print("Failed to get role ID: $error");
    return null;
  }
}

Future<List<Map<String, dynamic>>> fetchRoles() async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('roles').get();
  return querySnapshot.docs.map((doc) {
    return {'id': doc.id, 'description': doc['role_des']};
  }).toList();
}

Future<List<Map<String, dynamic>>> getAllUsers() async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').get();
  List<Map<String, dynamic>> users = [];

  for (var doc in querySnapshot.docs) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    if (data['role'] is DocumentReference) {
      DocumentReference roleRef = data['role'] as DocumentReference;
      DocumentSnapshot roleSnapshot = await roleRef.get();
      data['role'] = roleSnapshot.data();
    }

    users.add(data);
  }

  return users;
}

Future<List<DocumentSnapshot>> getAllFood() async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('food_menu').get();
  return querySnapshot.docs;
}

Future<void> addFood(String foodName, String foodDescription, String price) async {
  await FirebaseFirestore.instance.collection('food_menu').add({
    'food_nm': foodName,
    'food_des': foodDescription,
    'price': price
  }).then((value) {
    print("Food Added");
  }).catchError((error) {
    print("Failed to add food: $error");
  });
}

Future<List<DocumentSnapshot>> getTableInfo() async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('tables').get();
  return querySnapshot.docs;
}

Future<List<Map<String, dynamic>>> fetchTables() async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('tables').get();
    List<Map<String, dynamic>> tablesData = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    return tablesData;
  } catch (e) {
    print('Error fetching tables: $e');
    return [];
  }
}

Future<void> addTableToDatabase(Map<String, dynamic> tableData) async {
  try {
    await FirebaseFirestore.instance.collection('tables').add(tableData);
  } catch (e) {
    print('Error adding table to database: $e');
  }
}

Future<void> removeTableFromDatabase(String? tableId) async {
  if (tableId == null) {
    print('Error: tableId is null');
    return;
  }

  try {
    await FirebaseFirestore.instance.collection('tables').doc(tableId).delete();
  } catch (e) {
    print('Error removing table from database: $e');
  }
}

Future<List<bool>> fetchTableData() async {
  try {
    final document = await FirebaseFirestore.instance.collection('tables').doc('XdeQvmToFLARsorJhHcI').get();
    final data = document.data();
    if (data != null && data.containsKey('is_reseved')) {
      return List<bool>.from(data['is_reseved']);
    } else {
      return [];
    }
  } catch (e) {
    print('Error fetching table data: $e');
    return [];
  }
}

Future<bool> addTable() async {
  try {
    DocumentReference docRef = FirebaseFirestore.instance.collection('tables').doc('XdeQvmToFLARsorJhHcI');
    DocumentSnapshot snapshot = await docRef.get();
    List<bool> isReservedList = List<bool>.from(snapshot['is_reseved']);
    isReservedList.add(false);
    await docRef.update({'is_reseved': isReservedList});
    return true;
  } catch (e) {
    print('Error adding table: $e');
    return false;
  }
}

Future<bool> removeTable() async {
  try {
    DocumentReference docRef = FirebaseFirestore.instance.collection('tables').doc('XdeQvmToFLARsorJhHcI');
    DocumentSnapshot snapshot = await docRef.get();
    List<bool> isReservedList = List<bool>.from(snapshot['is_reseved']);
    if (isReservedList.isNotEmpty) {
      if (isReservedList.last == false) {
        isReservedList.removeLast();
        await docRef.update({'is_reseved': isReservedList});
        return true;
      } else {
        print('Cannot remove table as it is reserved');
        return false;
      }
    }
    return false;
  } catch (e) {
    print('Error removing table: $e');
    return false;
  }
}

// Order Placement
Future<bool> placeOrder(Map<String, dynamic> orderData) async {
  try {
    // Add the order data to the "order_placement" collection
    await FirebaseFirestore.instance.collection('order_placement').add(orderData);
    int index = int.parse(orderData['table_no'].toString().split(" ")[1]) - 1;
    updateTableReservation(index, true);
    return true;
  } catch (e) {
    print('Error placing order: $e');
    return false;
  }
}

Future<void> updateTableReservation(int index, bool reservation) async {
  try {
    final DocumentReference docRef = FirebaseFirestore.instance.collection('tables').doc("XdeQvmToFLARsorJhHcI");

    // Update the is_reserved array within a transaction
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(docRef);
      List<bool> isReservedList = List<bool>.from(snapshot['is_reseved']);

      // Update the specified index in the array to true
      if (index >= 0 && index < isReservedList.length) {
        isReservedList[index] = reservation;
        await transaction.update(docRef, {'is_reseved': isReservedList});
      }
    });
  } catch (e) {
    print('Error updating table reservation: $e');
  }
}

// Bill
Future<List<Map<String, dynamic>>> fetchUnpaidOrders() async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('order_placement')
      .where('is_paid', isEqualTo: false)
      .get();
    List<Map<String, dynamic>> orders = querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id; // Add the document ID to the data
      return data;
    }).toList();

    print(orders);

    return orders;
  } catch (e) {
    print('Error fetching unpaid orders: $e');
    return [];
  }
}

Future<void> updateOrderIsPaid(String orderId) async {
  try {
    await FirebaseFirestore.instance.collection('order_placement').doc(orderId).update({'is_paid': true});
  } catch (e) {
    print('Error updating order: $e');
    throw e;
  }
}

// Emp - Work
Future<List<Map<String, dynamic>>> getOrdersByWaiter(String waiterName) async {
  QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
    .collection('order_placement')
    .where('waiter', isEqualTo: waiterName)
    .get();

  List<Map<String, dynamic>> orders = [];

  querySnapshot.docs.forEach((doc) {
    orders.add(doc.data());
  });

  print(orders);

  return orders;
}

Future<Map<String, int>> fetchFoodItemsCount() async {
  Map<String, int> foodItemCount = {};

  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('order_placement').get();

    snapshot.docs.forEach((doc) {
      dynamic foodItems = doc['food_items'];

      if (foodItems is Map) {
        dynamic food_item = foodItems.keys.toList();
        food_item.forEach((item) {
          if (foodItemCount.containsKey(item)) {
            foodItemCount[item] = (foodItemCount[item] ?? 0) + 1;
          }
          else {
            foodItemCount[item] = 1;
          }
        });
      } else {
        print("Invalid food_items format in document: ${doc.id}");
      }
    });
  } catch (e) {
    print("Error fetching food items count: $e");
  }

  return foodItemCount;
}