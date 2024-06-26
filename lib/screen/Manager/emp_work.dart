import 'package:flutter/material.dart';
import 'package:restaurant_management_system/database/firestore_services.dart';
import 'package:restaurant_management_system/widgets/drawer.dart';
import 'package:restaurant_management_system/widgets/footer.dart';

class EmpWork extends StatefulWidget {
  const EmpWork({super.key});

  @override
  State<EmpWork> createState() => _EmpWorkState();
}

class _EmpWorkState extends State<EmpWork> {
  List<String> waiters = [];
  String? selectedWaiter;
  List<Map<String, dynamic>> orders = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getWaitersData();
  }

  Future<void> getWaitersData() async {
    setState(() {
      isLoading = true;
    });
    List<dynamic> fetchedUsers = await getAllUsers();
    if (fetchedUsers.isNotEmpty) {
      for (var user in fetchedUsers) {
        String? username = user['name'] ?? user['emp_name'];
        String? role = user['role']?['role_des'];

        if (username != null && role == 'waiter') {
          setState(() {
            waiters.add(username);
          });
        }
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  // Method to fetch orders by waiter
  Future<void> fetchOrdersByWaiter() async {
    if (selectedWaiter != null) {
      setState(() {
        isLoading = true;
      });
      List<Map<String, dynamic>> result = await getOrdersByWaiter(selectedWaiter!);
      setState(() {
        orders = result;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emp Work'),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButton<String>(
                      value: selectedWaiter,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedWaiter = newValue;
                          // Fetch orders when a new waiter is selected
                          fetchOrdersByWaiter();
                        });
                      },
                      hint: Text('Select a waiter'),
                      icon: Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      items: waiters.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    // SizedBox(height: 20),
                    // Text(
                    //   'Selected Waiter: ${selectedWaiter ?? "None"}',
                    //   style: TextStyle(fontSize: 16),
                    // ),
                    SizedBox(height: 20),
                    Expanded(
                      child: orders.isEmpty
                          ? Center(
                              child: Text(
                                'No Order Placed Yet',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: orders.length,
                              itemBuilder: (context, index) {
                                bool isPaid = orders[index]["is_paid"];
                                return Card(
                                  elevation: 4.0,
                                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Table: ${orders[index]["table_no"].toString().split(" ")[1]}',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          'Food Items:',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: (orders[index]["food_items"] as Map<String, dynamic>)
                                              .entries
                                              .map<Widget>((entry) {
                                            return Text('• ${entry.key}: ${entry.value}');
                                          }).toList(),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          isPaid ? 'Paid' : 'Not Paid',
                                          style: TextStyle(
                                            color: isPaid ? Colors.green : Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        // Add more fields as needed
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
      drawer: const MyDrawer(),
      // bottomNavigationBar: const Footer(),
    );
  }
}
