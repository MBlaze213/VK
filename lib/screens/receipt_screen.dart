import 'package:flutter/material.dart';
import '../providers/cart_provider.dart';
import 'package:provider/provider.dart';

class ReceiptScreen extends StatelessWidget {
  final Map<int, dynamic> items;
  final double total;

  const ReceiptScreen({super.key, required this.items, required this.total});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("🧾 Receipt")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Vest Kape",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Divider(),

            Expanded(
              child: ListView(
                children: items.values.map((item) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${item.product.name} x${item.qty}"),
                      Text("₱${item.total.toStringAsFixed(2)}"),
                    ],
                  );
                }).toList(),
              ),
            ),

            const Divider(),
            Text(
              "TOTAL: ₱${total.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),
            const Text("Thank you! ☕"),
          ],
        ),
      ),
    );
  }
}
