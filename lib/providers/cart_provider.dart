import 'package:flutter/material.dart';
import '../models/product.dart';

class CartItem {
  final Product product;
  int qty;

  CartItem({required this.product, this.qty = 1});

  double get total => product.price * qty;
}

class CartProvider with ChangeNotifier {
  final Map<int, CartItem> _items = {};

  Map<int, CartItem> get items => _items;

  void add(Product product) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.qty++;
    } else {
      _items[product.id] = CartItem(product: product);
    }
    notifyListeners();
  }

  // The "-" logic
  void decrement(int id) {
    if (!_items.containsKey(id)) return;

    if (_items[id]!.qty > 1) {
      _items[id]!.qty--;
    } else {
      _items.remove(id);
    }
    notifyListeners();
  }

  void remove(int id) {
    _items.remove(id);
    notifyListeners();
  }

  double get total {
    double sum = 0;
    _items.forEach((key, item) => sum += item.total);
    return sum;
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
