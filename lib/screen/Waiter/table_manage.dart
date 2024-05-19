import 'package:flutter/material.dart';
import 'package:restaurant_management_system/widgets/drawer.dart';
import 'package:restaurant_management_system/widgets/footer.dart';
import 'package:restaurant_management_system/widgets/table_grid.dart';
import 'package:restaurant_management_system/database/firestore_services.dart';

class TableManage extends StatefulWidget {
  const TableManage({super.key});

  @override
  State<TableManage> createState() => _TableManageState();
}

class _TableManageState extends State<TableManage> {
  late Future<List<bool>> _isReservedList;

  @override
  void initState() {
    super.initState();
    _refreshTableData();
  }

  void _refreshTableData() {
    setState(() {
      _isReservedList = fetchTableData();
    });
  }

  Future<void> _addTable() async {
    await addTable();
    _refreshTableData();
  }

  Future<void> _removeTable() async {
    bool response = await removeTable();
    _refreshTableData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Table Manage"),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<bool>>(
              future: _isReservedList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No table data found"));
                } else {
                  return TableGrid(isReservedList: snapshot.data!);
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _addTable,
                  child: const Text('Add Table'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _removeTable,
                  child: const Text('Remove Table'),
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: const MyDrawer(),
      // Assuming Footer is a widget to display at the bottom of the screen
      // bottomNavigationBar: const Footer(),
    );
  }
}
