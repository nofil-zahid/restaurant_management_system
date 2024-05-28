import 'package:flutter/material.dart';
import 'package:restaurant_management_system/widgets/drawer.dart';
import 'package:restaurant_management_system/database/firestore_services.dart';
import 'package:restaurant_management_system/widgets/footer.dart';

class Bill extends StatefulWidget {
  const Bill({super.key});

  @override
  State<Bill> createState() => _BillState();
}

class _BillState extends State<Bill> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bill'),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchUnpaidOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No unpaid orders found'));
          } else {
            List<Map<String, dynamic>> orders = snapshot.data!;
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> order = orders[index];
                List<String> foodItems = (order['food_items'] as Map<String, dynamic>).keys.toList();
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Table: ${order['table_no'].toString().split(" ")[1]}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8.0),
                        Text('Waiter: ${order['waiter'].toString()}', style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 8.0),
                        Text('Total Bill: ${order['bill'].toString()}', style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 8.0),
                        const Text('Items:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8.0),
                        ...foodItems.map((item) => Text('• $item x ${order['food_items'][item]}', style: const TextStyle(fontSize: 14))),
                        const SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              await updateOrderIsPaid(order['id']);
                              await updateTableReservation(int.parse(order['table_no'].toString().split(" ")[1])-1, false);
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order marked as paid')));
                              setState(() {}); // Refresh the state to reflect the changes
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error updating order')));
                            }
                          },
                          child: const Text('Paid'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      drawer: const MyDrawer(),
      // bottomNavigationBar: const Footer(),
    );
  }
}
