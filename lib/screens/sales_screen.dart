import 'package:flutter/material.dart';
import '../data/database_helper.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  List daily = [];
  List monthly = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    final db = DatabaseHelper.instance;

    daily = await db.getDailySales();
    monthly = await db.getMonthlySales();

    setState(() {});
  }

  Widget buildList(String title, List data) {
    return Expanded(
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (_, i) {
                final item = data[i];
                return ListTile(
                  title: Text(item.values.first.toString()),
                  trailing: Text("₱${item['total']}"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("📊 Sales Report")),
      body: Row(
        children: [buildList("Daily", daily), buildList("Monthly", monthly)],
      ),
    );
  }
}
