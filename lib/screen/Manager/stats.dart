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

  @override
  void initState() {
    super.initState();
    getFoodCounter();
  }

  Future<void> getFoodCounter() async {
    foodItemCount = await fetchFoodItemsCount();
    print(foodItemCount);
    setState(() {}); // Trigger a rebuild to display the fetched data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: const Text('Stats'),
      backgroundColor: Colors.green,
    ),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Food Item Counts:",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            if (foodItemCount.isNotEmpty)
              Column(
                children: foodItemCount.entries
                  .map((entry) => Text(
                    "${entry.key}: ${entry.value}",
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ))
                  .toList(),
              )
            else
              const Text(
                "No data available",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.red,
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
