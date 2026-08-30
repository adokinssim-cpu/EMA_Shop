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
    if (quantity <= 1) {
      return;
    }

    setState(() {
      quantity--;
    });
  }

  void addToCart() {
    final cartNotifier = ref.read(cartProvider.notifier);

    cartNotifier.addProduct(widget.product);

    for (int i = 1; i < quantity; i++) {
      cartNotifier.increaseQuantity(widget.product);
    }

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$quantity × ${widget.product.name} ajouté au panier'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(label: 'OK', onPressed: () {}),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isFavorite = ref.watch(
      favoritesProvider.select(
        (favorites) => favorites.contains(widget.product.id),
      ),
    );

    final totalPrice = widget.product.price * quantity;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Détails du produit',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: isFavorite ? 'Retirer des favoris' : 'Ajouter aux favoris',
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
            // IMAGE DU PRODUIT
            SizedBox(
              width: double.infinity,
              height: 320,
              child: Image.network(
                widget.product.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }

                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.image_not_supported_outlined, size: 80),
                  );
                },
              ),
            ),

            // INFORMATIONS DU PRODUIT
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // CATÉGORIE
                  Text(
                    widget.product.category.toUpperCase(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // NOM
                  Text(
                    widget.product.name,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // NOTE
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 22),
                      const SizedBox(width: 6),
                      Text(
                        widget.product.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // PRIX
                  Text(
                    formatPrice(widget.product.price),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // DESCRIPTION
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    widget.product.description,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // QUANTITÉ
                  const Text(
                    'Quantité',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: 'Diminuer',
                          onPressed: quantity > 1 ? decreaseQuantity : null,
                          icon: const Icon(Icons.remove),
                        ),

                        Container(
                          constraints: const BoxConstraints(minWidth: 45),
                          alignment: Alignment.center,
                          child: Text(
                            quantity.toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        IconButton(
                          tooltip: 'Augmenter',
                          onPressed: increaseQuantity,
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // TOTAL
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 18,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
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
                  ),

                  const SizedBox(height: 20),

                  // AJOUT AU PANIER
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: addToCart,
                      icon: const Icon(Icons.shopping_cart_outlined),
                      label: Text(
                        'Ajouter $quantity au panier',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
