import 'package:flutter/material.dart';

class TableGrid extends StatelessWidget {
  final List<bool> isReservedList;

  const TableGrid({required this.isReservedList, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Two tables per row
        childAspectRatio: 1.5, // Adjust the aspect ratio as needed
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: isReservedList.length,
      itemBuilder: (context, index) {
        final tableNumber = index + 1;
        final isReserved = isReservedList[index];
        return Container(
          decoration: BoxDecoration(
            color: isReserved ? Colors.red : Colors.green,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.table_bar, // Table icon
                  color: Colors.white,
                  size: 48,
                ),
                const SizedBox(height: 8),
                Text(
                  'Table $tableNumber',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
