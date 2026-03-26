import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../data/products.dart';

class POSScreen extends StatelessWidget {
  POSScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(title: const Text("☕ Vest Kape"), centerTitle: true),

      // 🔥 RESPONSIVE BODY
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return _buildMobileLayout(context);
          } else {
            return _buildDesktopLayout(context);
          }
        },
      ),
    );
  }

  // 📱 MOBILE VIEW
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
            itemBuilder: (context, index) {
              return _productCard(context, products[index]);
            },
          ),
        ),

        SizedBox(height: 200, child: _cartPanel(context)),
      ],
    );
  }

  // 💻 DESKTOP / LANDSCAPE VIEW
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
            itemBuilder: (context, index) {
              return _productCard(context, products[index]);
            },
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
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.local_cafe, color: Colors.brown, size: 30),

              const SizedBox(height: 8),

              Text(
                p.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13),
              ),

              const SizedBox(height: 5),

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

          Expanded(
            child: cart.items.isEmpty
                ? const Center(child: Text("No items yet"))
                : ListView(
                    children: cart.items.values.map((item) {
                      return Card(
                        child: ListTile(
                          title: Text(item.product.name),
                          subtitle: Text("Qty: ${item.qty}"),
                          trailing: Text("₱${item.total.toStringAsFixed(2)}"),
                        ),
                      );
                    }).toList(),
                  ),
          ),

          const Divider(),

          Text("Total", style: TextStyle(color: Colors.grey[600])),

          Text(
            "₱${cart.total.toStringAsFixed(2)}",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
          ),

          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                padding: const EdgeInsets.all(12),
              ),
              onPressed: () {
                if (cart.items.isEmpty) return;

                cart.clear();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("✅ Order Completed")),
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
