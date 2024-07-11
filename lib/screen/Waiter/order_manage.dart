import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/services/SharedPref_Helper.dart';
import 'package:restaurant_management_system/widgets/drawer.dart';
import 'package:restaurant_management_system/database/firestore_services.dart';

class OrderManage extends StatefulWidget {
  const OrderManage({super.key});

  @override
  State<OrderManage> createState() => _OrderManageState();
}

class _OrderManageState extends State<OrderManage> {
  Map<String, int> cartItems = {};

  List<String> foodList = [];
  List<String> foodPriceList = [];
  List<String> foodUnit = [];
  List<String> foodImages = [];

  List<String> tableList = [];
  String selectedTable = "Table #";

  late Future<List<bool>> _isReservedList;

  late SharedPref pref;
  late Future<void> _initFuture;

  late String user;
  int bill = 0;

  @override
  void initState() {
    super.initState();
    _initFuture = initiatePreference();
    _initFuture.then((_) {
      _fetchFoodItems();
      getTablesInfo();
    });
  }

  Future<void> getTablesInfo() async {
    _isReservedList = fetchTableData();

    _isReservedList.then((reservedList) {
      for (int i = 0; i < reservedList.length; ++i) {
        if (!reservedList[i]) {
          tableList.add("Table ${i + 1}");
        }
      }
    }).catchError((error) {
      print('Error fetching table data: $error');
    });
  }

  Future<void> initiatePreference() async {
    pref = SharedPref();
    await pref.init();
    user = pref.getValue("USER")!;
  }

  Future<void> _fetchFoodItems() async {
    final QuerySnapshot foodSnapshot = await FirebaseFirestore.instance.collection('food_menu').get();

    final List<String> imageUrls = [];

    for (var doc in foodSnapshot.docs) {
      foodList.add(doc['food_nm']);
      foodPriceList.add(doc['price'].toString());
      foodUnit.add('1 per');

      try {
        final String imagePath = doc['img'];
        if (imagePath.isNotEmpty && !imagePath.endsWith('/')) {
          final Reference ref = FirebaseStorage.instance.refFromURL(imagePath);
          final String imageUrl = await ref.getDownloadURL();
          imageUrls.add(imageUrl);
        } else {
          throw FirebaseException(
            plugin: 'firebase_storage',
            code: 'invalid-url',
            message: 'Invalid URL: $imagePath'
          );
        }
      } catch (e) {
        print('Error fetching image for ${doc['food_nm']}: $e');
        imageUrls.add('');
      }
    }

    setState(() {
      foodImages.addAll(imageUrls);
    });
  }

  void _incrementCartCounter(String item) {
    int index = foodList.indexOf(item);
    bill += int.parse(foodPriceList[index]);
    setState(() {
      if (cartItems.containsKey(item)) {
        cartItems[item] = cartItems[item]! + 1;
      } else {
        cartItems[item] = 1; 
      }
    });
  }

  void _decrementCartCounter(String item) {
    int index = foodList.indexOf(item);
    bill -= int.parse(foodPriceList[index]);
    setState(() {
      if (cartItems.containsKey(item) && cartItems[item]! > 0) {
        cartItems[item] = cartItems[item]! - 1;
        if (cartItems[item] == 0) {
          cartItems.remove(item);
        }
      }
    });
  }

  void _placeOrder() async {
    dynamic newObject = {
      "food_items": cartItems,
      "waiter": user,
      "table_no": selectedTable,
      "is_paid": false,
      "bill": bill
    };

    if (selectedTable == "Table #" || cartItems.isEmpty || bill == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('NO ACTIVITY NOTICED'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    Future<bool> response = placeOrder(newObject);
    if (await response) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('DATA SAVED TO SERVER'),
          duration: Duration(seconds: 3),
        ),
      );
      setState(() {
        cartItems = {};
        tableList.remove(selectedTable);
        selectedTable = "Table #";
        bill = 0;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('SERVER ERROR OCCURRED'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
            ),
          );
        }
        bool isDataLoaded =
            foodList.length == foodPriceList.length &&
            foodPriceList.length == foodUnit.length &&
            foodUnit.length == foodImages.length;

        if (!isDataLoaded) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Order Place'),
            backgroundColor: Colors.green,
            centerTitle: true,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DropdownButton<String>(
                              isExpanded: true,
                              hint: const Text("Select Table"),
                              value: selectedTable == "Table #" ? null : selectedTable,
                              items: tableList.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedTable = newValue!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Text(
                              'Total Bill: \$${bill.toString()}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          ElevatedButton(
                            onPressed: _placeOrder,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                            ),
                            child: const Text("Place Order", style: TextStyle(fontSize: 16)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: foodList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Image
                                SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: foodImages[index].isNotEmpty
                                      ? Image.network(
                                          foodImages[index],
                                          fit: BoxFit.cover,
                                          loadingBuilder: (context, child, loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return const Center(
                                              child: CircularProgressIndicator(),
                                            );
                                          },
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.red,
                                                  width: 2,
                                                ),
                                              ),
                                              child: const Center(
                                                child: Icon(Icons.fastfood, size: 50, color: Colors.red),
                                              ),
                                            );
                                          },
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.red,
                                              width: 2,
                                            ),
                                          ),
                                          child: const Center(
                                            child: Icon(Icons.fastfood, size: 50, color: Colors.red),
                                          ),
                                        ),
                                ),
                                const SizedBox(width: 16),
                                // Details and buttons
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        foodList[index],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '${foodUnit[index]} Rs${foodPriceList[index]}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          ElevatedButton(
                                            onPressed: () => _incrementCartCounter(foodList[index]),
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: Colors.white, backgroundColor: Colors.green, minimumSize: const Size(32, 32), // Smaller button size
                                              shape: const CircleBorder(),
                                            ),
                                            child: const Icon(Icons.add),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            cartItems[foodList[index]]?.toString() ?? '0',
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          ElevatedButton(
                                            onPressed: () => _decrementCartCounter(foodList[index]),
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: Colors.white, backgroundColor: Colors.red, minimumSize: const Size(32, 32), // Smaller button size
                                              shape: const CircleBorder(),
                                            ),
                                            child: const Icon(Icons.remove),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          drawer: const MyDrawer(),
        );
      },
    );
  }
}
