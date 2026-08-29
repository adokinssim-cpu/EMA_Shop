import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:projet3_flutter/domain/models/product.dart';
import 'package:projet3_flutter/providers/cart_providers.dart';
import 'package:projet3_flutter/providers/favorite_providers.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int quantity = 1;

  String formatPrice(double price) {
    return '${price.toStringAsFixed(0)} FCFA';
  }

  void increaseQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decreaseQuantity() {
    if (quantity <= 1) return;

    setState(() {
      quantity--;
    });
  }

  void addToCart() {
    final cartNotifier = ref.read(cartProvider.notifier);

    // Ajoute une première unité.
    cartNotifier.addProduct(widget.product);

    // Ajoute les unités supplémentaires.
    for (int i = 1; i < quantity; i++) {
      cartNotifier.increaseQuantity(widget.product);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$quantity × ${widget.product.name} ajouté au panier'),
        action: SnackBarAction(
          label: 'VOIR',
          onPressed: () {
            // Le panier pourra être ouvert depuis la navigation principale.
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favorites = ref.watch(favoritesProvider);
    final isFavorite = favorites.contains(widget.product.id);

    final totalPrice = widget.product.price * quantity;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Détails du produit',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ref
                  .read(favoritesProvider.notifier)
                  .toggleFavorite(widget.product.id);
            },
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ═══════════════════════════════
            // IMAGE DU PRODUIT
            // ═══════════════════════════════
            SizedBox(
              width: double.infinity,
              height: 300,
              child: Image.network(
                widget.product.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.image_not_supported_outlined, size: 80),
                  );
                },
              ),
            ),

            // ═══════════════════════════════
            // INFORMATIONS DU PRODUIT
            // ═══════════════════════════════
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Catégorie
                  Text(
                    widget.product.category,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),

                  const SizedBox(height: 8),

                  // Nom
                  Text(
                    widget.product.name,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Note
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 22),
                      const SizedBox(width: 6),
                      Text(
                        widget.product.rating.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Prix
                  Text(
                    formatPrice(widget.product.price),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ═══════════════════════════════
                  // DESCRIPTION
                  // ═══════════════════════════════
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    widget.product.description,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ═══════════════════════════════
                  // QUANTITÉ
                  // ═══════════════════════════════
                  const Text(
                    'Quantité',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: decreaseQuantity,
                              icon: const Icon(Icons.remove),
                            ),

                            Text(
                              quantity.toString(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            IconButton(
                              onPressed: increaseQuantity,
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // ═══════════════════════════════
                  // TOTAL
                  // ═══════════════════════════════
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        formatPrice(totalPrice),
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ═══════════════════════════════
                  // BOUTON PANIER
                  // ═══════════════════════════════
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: addToCart,
                      icon: const Icon(Icons.shopping_cart_outlined),
                      label: const Text(
                        'Ajouter au panier',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
