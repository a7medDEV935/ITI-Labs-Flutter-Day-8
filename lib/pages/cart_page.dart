import 'package:flutter/material.dart';
import '../models/product_model.dart';

class CartPage extends StatefulWidget {
  final List<ProductModel> cartItems;
  final void Function(ProductModel product) onRemove;
  final VoidCallback onClear;

  const CartPage({
    super.key,
    required this.cartItems,
    required this.onRemove,
    required this.onClear,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late List<Map<String, dynamic>> cartItemsWithQty;

  @override
  void initState() {
    super.initState();
    cartItemsWithQty = widget.cartItems.map((item) {
      return {'product': item, 'quantity': 1};
    }).toList();
  }

  void removeItem(ProductModel product) {
    setState(() {
      cartItemsWithQty.removeWhere((item) => item['product'] == product);
    });
    widget.onRemove(product);
  }

  void updateQuantity(int index, int change) {
    setState(() {
      int currentQty = cartItemsWithQty[index]['quantity'];
      int newQty = currentQty + change;

      if (newQty <= 0) {
        removeItem(cartItemsWithQty[index]['product']);
      } else {
        cartItemsWithQty[index]['quantity'] = newQty;
      }
    });
  }

  double get total {
    return cartItemsWithQty.fold(0.0, (sum, item) {
      final price = item['product'].price;
      final qty = item['quantity'] as int;
      return sum + price * qty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Cart')),
      body: cartItemsWithQty.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_cart, size: 55, color: Colors.grey),
                  const SizedBox(height: 10),
                  const Text("Your Cart is empty"),
                  const Text("Add some products to get started"),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Continue Shopping'),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: cartItemsWithQty.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final item = cartItemsWithQty[index];
                      final product = item['product'] as ProductModel;
                      final quantity = item['quantity'] as int;

                      return ListTile(
                        leading: Image.network(
                          product.image,
                          width: 50,
                          height: 50,
                        ),
                        title: Text(product.title),
                        subtitle: Text(
                          "\$${(product.price * quantity).toStringAsFixed(2)}",
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () => updateQuantity(index, -1),
                            ),
                            Text(
                              quantity.toString(),
                              style: TextStyle(fontSize: 15),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () => updateQuantity(index, 1),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                removeItem(product);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text(
                                      "${product.title} was deleted",
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    border: const Border(top: BorderSide(color: Colors.grey)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$${total.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              final shouldCheckout = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Confirm Checkout"),
                                  content: const Text(
                                    "Are you sure you want to checkout? Your cart will be emptied.",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text("Cancel"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text("Yes, Checkout"),
                                    ),
                                  ],
                                ),
                              );

                              if (shouldCheckout == true) {
                                setState(() {
                                  widget.cartItems.clear(); // clear local copy
                                });
                                widget.onClear();
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: Colors.green,
                                      content: Text(
                                        "Checkout completed successfully. Cart cleared.",
                                      ),
                                    ),
                                  );
                                }
                              }
                            },

                            child: const Text('Proceed to checkout'),
                          ),
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
