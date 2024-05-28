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

  @override
  void initState() {
    super.initState();
    getWaitersData();
  }

  Future<void> getWaitersData() async {
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
  }

  // Method to fetch orders by waiter
  Future<void> fetchOrdersByWaiter() async {
    if (selectedWaiter != null) {
      List<Map<String, dynamic>> result = await getOrdersByWaiter(selectedWaiter!);
      setState(() {
        orders = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emp Work'),
        backgroundColor: Colors.green,
      ),
      body: Center(
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
              items: waiters.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text(
              'Selected Waiter: ${selectedWaiter ?? "None"}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Table: ${orders[index]["table_no"].toString().split(" ")[1]}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Food Items:'),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: (orders[index]["food_items"] as Map<String, dynamic>)
                              .entries
                              .map<Widget>((entry) {
                            return Text('• ${entry.key}: ${entry.value}');
                          }).toList(),
                        ),
                        Text('Is Paid: ${orders[index]["is_paid"]}'),
                        // Add more fields as needed
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      drawer: const MyDrawer(),
      // bottomNavigationBar: const Footer(),
    );
  }
}
