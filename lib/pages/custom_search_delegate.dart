import 'package:flutter/material.dart';
import '../models/product_model.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<ProductModel> products;

  CustomSearchDelegate(this.products);

  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, null),
  );

  @override
  Widget buildResults(BuildContext context) {
    final results = products
        .where((p) => p.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return _buildGrid(results);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = products
        .where((p) => p.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return _buildGrid(suggestions);
  }

  Widget _buildGrid(List<ProductModel> items) {
    return GridView.extent(
      maxCrossAxisExtent: 200,
      padding: const EdgeInsets.all(10),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 0.7,
      children: items.map((product) {
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Image.network(product.image, fit: BoxFit.cover),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "\$${product.price}",
                      style: const TextStyle(fontSize: 14, color: Colors.green),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.shopping_cart),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
