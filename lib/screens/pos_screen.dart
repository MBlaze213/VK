import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../data/products.dart';
import '../data/database_helper.dart';

// NEW IMPORTS
import 'sales_screen.dart';
import 'receipt_screen.dart';
import '../data/export_service.dart'; // or services/

class POSScreen extends StatelessWidget {
  const POSScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],

      appBar: AppBar(
        title: const Text("☕ Vest Kape"),
        centerTitle: true,
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        actions: [
          // 📊 Sales Report
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: "Sales Report",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SalesScreen()),
              );
            },
          ),

          // 🧾 Receipt Preview (FIXED ✅)
          IconButton(
            icon: const Icon(Icons.receipt_long),
            tooltip: "Receipt",
            onPressed: () {
              final cart = Provider.of<CartProvider>(context, listen: false);

              if (cart.items.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("🛒 Cart is empty")),
                );
                return;
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ReceiptScreen(
                    items: Map<int, dynamic>.from(cart.items),
                    total: cart.total,
                  ),
                ),
              );
            },
          ),

          // 📤 Export Excel
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: "Export Excel",
            onPressed: () async {
              final path = await ExportService.exportSales();

              if (path == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("❌ Permission denied")),
                );
                return;
              }

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("✅ Saved to: $path"),
                  backgroundColor: Colors.brown, // ☕ KEEP THEME
                ),
              );
            },
          ),
        ],
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          return constraints.maxWidth < 600
              ? _buildMobileLayout(context)
              : _buildDesktopLayout(context);
        },
      ),
    );
  }

  // 📱 MOBILE
  Widget _buildMobileLayout(BuildContext context) {
    final products = ProductData.products;
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) =>
                _productCard(context, products[index]),
          ),
        ),
        SizedBox(height: 250, child: _cartPanel(context)),
      ],
    );
  }

  // 💻 DESKTOP
  Widget _buildDesktopLayout(BuildContext context) {
    final products = ProductData.products;
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.2,
            ),
            itemBuilder: (context, index) =>
                _productCard(context, products[index]),
          ),
        ),
        Expanded(child: _cartPanel(context)),
      ],
    );
  }

  // ☕ PRODUCT CARD
  Widget _productCard(BuildContext context, Product p) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return GestureDetector(
      onTap: () => cart.add(p),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.local_cafe, color: Colors.brown, size: 30),
            const SizedBox(height: 8),
            Text(
              p.name,
              style: const TextStyle(fontSize: 13),
              textAlign: TextAlign.center,
            ),
            Text(
              "₱${p.price}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🛒 CART PANEL
  Widget _cartPanel(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "🛒 Cart",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Divider(),

          // 🧾 CART ITEMS
          Expanded(
            child: cart.items.isEmpty
                ? const Center(child: Text("No items yet"))
                : ListView(
                    children: cart.items.values.map((item) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          title: Text(
                            item.product.name,
                            style: const TextStyle(fontSize: 14),
                          ),
                          subtitle: Row(
                            children: [
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                icon: const Icon(
                                  Icons.remove_circle,
                                  color: Colors.red,
                                  size: 22,
                                ),
                                onPressed: () =>
                                    cart.decrement(item.product.id),
                              ),
                              Text(
                                "${item.qty}",
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                icon: const Icon(
                                  Icons.add_circle,
                                  color: Colors.green,
                                  size: 22,
                                ),
                                onPressed: () => cart.add(item.product),
                              ),
                            ],
                          ),
                          trailing: Text(
                            "₱${item.total.toStringAsFixed(2)}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ),

          const Divider(),

          // 💰 TOTAL
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total:"),
              Text(
                "₱${cart.total.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ✅ CHECKOUT BUTTON (WITH DATABASE + RECEIPT)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
              ),
              onPressed: cart.items.isEmpty
                  ? null
                  : () async {
                      final db = DatabaseHelper.instance;

                      // 🔹 Save order
                      final orderId = await db.insertOrder(
                        cart.total,
                        DateTime.now().toString(),
                      );

                      // 🔹 Save items
                      for (var item in cart.items.values) {
                        await db.insertOrderItem(
                          orderId,
                          item.product.name,
                          item.product.price,
                          item.qty,
                        );
                      }

                      // 🔹 Navigate to receipt BEFORE clearing
                      // 🔹 CREATE SNAPSHOT BEFORE CLEARING
                      final receiptItems = Map<int, dynamic>.from(cart.items);
                      final receiptTotal = cart.total;

                      // 🔹 Navigate with data
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ReceiptScreen(
                            items: receiptItems,
                            total: receiptTotal,
                          ),
                        ),
                      );

                      // 🔹 NOW clear safely
                      cart.clear();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("✅ Order Saved")),
                      );
                    },
              child: const Text("Checkout"),
            ),
          ),
        ],
      ),
    );
  }
}
