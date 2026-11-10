import 'package:flutter/material.dart';

class Cartpage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final Function(int, int) onUpdateQuantity;
  final Function(int) onRemoveItem;
  final Function(Map<String, dynamic>) onCheckout;

  const Cartpage({
    super.key,
    required this.cartItems,
    required this.onUpdateQuantity,
    required this.onRemoveItem,
    required this.onCheckout,
  });

  @override
  State<Cartpage> createState() => _CartpageState();
}

class _CartpageState extends State<Cartpage> {
  double get _subtotal {
    return widget.cartItems.fold(0.0, (sum, item) {
      final price = (item['price'] as num?)?.toDouble() ?? 0.0;
      final quantity = (item['quantity'] as num?)?.toInt() ?? 1;
      return sum + (price * quantity);
    });
  }

  void _processCheckout() {
    if (widget.cartItems.isEmpty) return;

    final now = DateTime.now();
    final formattedDate = "${now.day}/${now.month}/${now.year}";
    final orderId = "ORD-${now.millisecondsSinceEpoch.toString().substring(7)}";

    // Extract all items selected in cart
    final List<String> itemSummaries = widget.cartItems.map((item) {
      final title = item['title'] ?? 'Product';
      final qty = item['quantity'] ?? 1;
      final size = item['size'] != null ? " (${item['size']})" : "";
      return "$title x$qty$size";
    }).toList();

    final newOrder = {
      'id': orderId,
      'date': formattedDate,
      'total': _subtotal,
      'status': 'Processing',
      'items': itemSummaries,
    };

    // Send order back to MainPage
    widget.onCheckout(newOrder);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Order placed successfully!'),
        backgroundColor: Colors.brown,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.brown,
        centerTitle: true,
      ),
      body: widget.cartItems.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 70, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text('Your cart is empty', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
          ],
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                final item = widget.cartItems[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(item['title'] ?? 'Product', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('\$${item['price']} x ${item['quantity']} (${item['size'] ?? 'M'})'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () => widget.onUpdateQuantity(index, -1),
                        ),
                        Text('${item['quantity']}'),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () => widget.onUpdateQuantity(index, 1),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => widget.onRemoveItem(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('\$${_subtotal.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown)),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: _processCheckout,
                    child: const Text('Checkout', style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}