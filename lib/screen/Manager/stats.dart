import 'package:flutter/material.dart';
import 'package:restaurant_management_system/widgets/drawer.dart';
import 'package:restaurant_management_system/widgets/footer.dart';
import 'package:restaurant_management_system/database/firestore_services.dart';

class Stats extends StatefulWidget {
  const Stats({Key? key}) : super(key: key);

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  Map<String, int> foodItemCount = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getFoodCounter();
  }

  Future<void> getFoodCounter() async {
    foodItemCount = await fetchFoodItemsCount();
    print(foodItemCount);
    setState(() {
      isLoading = false; // Data fetching complete, stop loading
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stats'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: isLoading
              ? const CircularProgressIndicator() // Show loader while loading
              : foodItemCount.isNotEmpty
                  ? DataTable(
                      columns: const <DataColumn>[
                        DataColumn(
                          label: Text(
                            'Food Item',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Count',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                      rows: foodItemCount.entries
                          .map(
                            (entry) => DataRow(
                              cells: <DataCell>[
                                DataCell(Text(entry.key)),
                                DataCell(Text(entry.value.toString())),
                              ],
                            ),
                          )
                          .toList(),
                    )
                  : const Text(
                      "No data available",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                      ),
                    ),
        ),
      ),
      drawer: const MyDrawer(),
      // bottomNavigationBar: const Footer(),
    );
  }
}
