import '../models/product.dart';

class ProductData {
  static List<Product> products = [
    // ☕ COFFEE
    Product(id: 1, name: "Americano", price: 50, category: "Coffee"),
    Product(id: 2, name: "Americano w/ Vanilla", price: 55, category: "Coffee"),
    Product(id: 3, name: "Cappuccino", price: 80, category: "Coffee"),
    Product(id: 4, name: "Latte", price: 80, category: "Coffee"),
    Product(id: 5, name: "Vanilla Latte", price: 100, category: "Coffee"),
    Product(id: 6, name: "Caramel Latte", price: 100, category: "Coffee"),
    Product(id: 7, name: "Hazelnut Latte", price: 100, category: "Coffee"),
    Product(id: 8, name: "Spanish Latte", price: 100, category: "Coffee"),
    Product(id: 9, name: "Matcha Latte", price: 70, category: "Coffee"),
    Product(id: 10, name: "Caramel Macchiato", price: 110, category: "Coffee"),
    Product(
      id: 11,
      name: "White Chocolate Mocha",
      price: 130,
      category: "Coffee",
    ),
    Product(
      id: 12,
      name: "Dark Chocolate Mocha",
      price: 130,
      category: "Coffee",
    ),

    // 🍵 MATCHA & CHOCOLATE
    Product(id: 13, name: "Strawberry Matcha", price: 60, category: "Matcha"),
    Product(id: 14, name: "Matcha", price: 60, category: "Matcha"),
    Product(id: 15, name: "Chocolate", price: 65, category: "Matcha"),
    Product(id: 16, name: "White Chocolate", price: 70, category: "Matcha"),

    // 🧋 ICED TEA
    Product(id: 17, name: "Strawberry Iced Tea", price: 50, category: "Tea"),
    Product(id: 18, name: "Blueberry Iced Tea", price: 50, category: "Tea"),
    Product(id: 19, name: "Lychee Iced Tea", price: 50, category: "Tea"),
    Product(id: 20, name: "Passion Fruit Iced Tea", price: 50, category: "Tea"),

    // 🥤 MILKSHAKES
    Product(
      id: 21,
      name: "Strawberry Milkshake",
      price: 60,
      category: "Milkshake",
    ),
    Product(
      id: 22,
      name: "Blueberry Milkshake",
      price: 60,
      category: "Milkshake",
    ),

    // 🍫 CRASHED MOCHA
    Product(
      id: 23,
      name: "Crashed Caramel Mocha",
      price: 160,
      category: "Special",
    ),
    Product(
      id: 24,
      name: "Crashed Chocolate Mocha",
      price: 160,
      category: "Special",
    ),
    Product(
      id: 25,
      name: "Crashed White Chocolate Mocha",
      price: 160,
      category: "Special",
    ),
  ];
}
