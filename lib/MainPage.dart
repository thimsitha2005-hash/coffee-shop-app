import 'package:flutter/material.dart';
import 'package:coffeeapp/CategoryPage.dart';
import 'package:coffeeapp/FavoritePage.dart';
import 'package:coffeeapp/HomePage.dart';
import 'package:coffeeapp/ProfilePage.dart';
import 'package:coffeeapp/CartPage.dart';

import 'Login_Page.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  int index = 0;

  // Shared state for favorite items
  List<Map<String, dynamic>> favoriteItems = [];

  // Shared state for cart items
  List<Map<String, dynamic>> cartItems = [];

  // Toggle favorite item
  void toggleFavorite(Map<String, dynamic> product) {
    setState(() {
      int existingIndex = favoriteItems.indexWhere((item) => item['title'] == product['title']);
      if (existingIndex != -1) {
        favoriteItems.removeAt(existingIndex);
      } else {
        favoriteItems.add(product);
      }
    });
  }

  // 1. Update addToCart to accept size
  void addToCart(Map<String, dynamic> product, {int quantity = 1, String size = 'Medium'}) {
    setState(() {
      // Finds item with both matching title AND matching size
      int existingIndex = cartItems.indexWhere(
            (item) => item['title'] == product['title'] && item['size'] == size,
      );

      if (existingIndex != -1) {
        cartItems[existingIndex]['quantity'] =
            (cartItems[existingIndex]['quantity'] as int) + quantity;
      } else {
        cartItems.add({
          'title': product['title'],
          'category': product['category'],
          'price': (product['price'] as num).toDouble(),
          'quantity': quantity,
          'size': size, // <--- Saves selected size ('Small', 'Medium', 'Large')
          'imagePath': product['image'] ?? product['imagePath'],
        });
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product["title"]} ($size) added to cart!'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // Update cart item quantity or remove item
  void updateQuantity(int itemIndex, int delta) {
    setState(() {
      int currentQty = cartItems[itemIndex]['quantity'] as int;
      if (currentQty + delta > 0) {
        cartItems[itemIndex]['quantity'] = currentQty + delta;
      } else {
        cartItems.removeAt(itemIndex);
      }
    });
  }

  // Delete cart item directly
  void removeCartItem(int itemIndex) {
    setState(() {
      cartItems.removeAt(itemIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    var bodyPage = [
      Homepage(
        favoriteItems: favoriteItems,
        onToggleFavorite: toggleFavorite,
        onAddToCart: (product, {int quantity = 1, String size = 'Medium'}) {
          addToCart(product, quantity: quantity, size: size);
        },
      ),
      const Categorypage(),
      Cartpage(
        cartItems: cartItems,
        onUpdateQuantity: updateQuantity,
        onRemoveItem: removeCartItem, onCheckout: (Map<String, dynamic> p1) {  },
      ),
      Favoritepage(
        favoriteItems: favoriteItems,
        onToggleFavorite: toggleFavorite,
        onAddToCart: addToCart, // Add this line!
      ),
      Profilepage(
        userRole: 'customer', // or your dynamic user role variable
        onLogout: () {
          // 1. (Optional) Clear session or user preferences here if needed
          // await prefs.clear();

          // 2. Navigate to Login Page and clear all previous routes
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const LoginPage(), // Replace with your actual Login Page widget class name
            ),
                (route) => false, // Removes all previous routes from the stack
          );
        },
      )
    ];

    return Scaffold(
      body: bodyPage[index],
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.red,
        showUnselectedLabels: true,
        currentIndex: index,
        type: BottomNavigationBarType.fixed,
        onTap: (int currentIndex) {
          setState(() {
            index = currentIndex;
          });
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Category',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              label: Text('${cartItems.length}'),
              isLabelVisible: cartItems.isNotEmpty,
              child: const Icon(Icons.shopping_cart),
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              label: Text('${favoriteItems.length}'),
              isLabelVisible: favoriteItems.isNotEmpty,
              child: const Icon(Icons.favorite),
            ),
            label: 'Favorite',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}