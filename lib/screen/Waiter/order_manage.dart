import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/services/SharedPref_Helper.dart';
import 'package:restaurant_management_system/widgets/drawer.dart';
import 'package:restaurant_management_system/widgets/footer.dart';
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

    initiatePreference();

    _fetchFoodItems();
    getTablesInfo();
  }

  Future<void> getTablesInfo() async {
    _isReservedList = fetchTableData();

    _isReservedList.then((reservedList) {
      print(reservedList);
      for (int i=0; i<reservedList.length; ++i) {
        if (reservedList[i]) {
          continue;
        }
        tableList.add("Table ${i+1}");
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

    print('Number of documents retrieved: ${foodSnapshot.docs.length}');

    final List<String> imageUrls = [];

    for (var doc in foodSnapshot.docs) {
      foodList.add(doc['food_nm']);
      foodPriceList.add(doc['price'].toString()); // Convert price to string
      foodUnit.add('1 per'); // Assuming 'foodUnit' is constant for all items

      try {
        final String imagePath = doc['img'];
        if (imagePath.isNotEmpty && !imagePath.endsWith('/')) {
          final Reference ref = FirebaseStorage.instance.ref().child(imagePath);
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
        imageUrls.add(''); // Add an empty string or a placeholder URL in case of error
      }
    }

    print('Length of foodList: ${foodList.length}');
    print('Length of foodPriceList: ${foodPriceList.length}');
    print('Length of foodUnit: ${foodUnit.length}');
    print('Length of imageUrls: ${imageUrls.length}');

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
    displayCartValues();
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
    displayCartValues();
  }

  void displayCartValues () {
    print(cartItems);
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
        // String tableToRemove = "Table ${}"; // Extracting table number
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
    bool isDataLoaded = 
      foodList.length == foodPriceList.length && 
      foodPriceList.length == foodUnit.length && 
      foodUnit.length == foodImages.length;

    if (!isDataLoaded) {
      print('Data is not fully loaded yet');
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
      crossAxisAlignment: CrossAxisAlignment.stretch, // Expand children horizontally
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
                          print(selectedTable);
                        },
                      ),
                      const SizedBox(height: 8.0),
                      Text(selectedTable),
                    ],
                  ),
                ),
              ),
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
                        bill.toString(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 8.0), // Add space between bill text and button
                    ElevatedButton(
                      onPressed: () => _placeOrder(), 
                      child: const Text("Place Order")
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
              if (index >= foodImages.length) {
                print('Index $index out of range for foodImages with length ${foodImages.length}');
                return const SizedBox(); // Skip rendering if index is invalid
              }
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                                        child: Icon(Icons.error),
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
                                    child: Text(
                                      'Image not available',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ),
                                ),
                          ),
                          const SizedBox(width: 10),
                          // Details and buttons
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  foodList[index],
                                  style: const TextStyle(
                                    fontSize: 14, // Smaller font size
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '${foodUnit[index]} Rs${foodPriceList[index]}',
                                  style: const TextStyle(
                                    fontSize: 14, // Smaller font size
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () => _incrementCartCounter(foodList[index]),
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(32, 32), // Smaller button size
                                        shape: const CircleBorder(), // Circular shape
                                      ),
                                      child: const Text('+'),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      cartItems[foodList[index]]?.toString() ?? '0',
                                      style: const TextStyle(
                                        fontSize: 14, // Smaller font size
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    ElevatedButton(
                                      onPressed: () => _decrementCartCounter(foodList[index]),
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(32, 32), // Smaller button size
                                        shape: const CircleBorder(), // Circular shape
                                      ),
                                      child: const Text('-'),
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
      // bottomNavigationBar: const Footer(),
    );
  }
}
