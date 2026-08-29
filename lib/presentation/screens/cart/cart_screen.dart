import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/models/cart_item.dart';
import '../../../providers/cart_providers.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final total = ref.watch(cartTotalProvider);
    final itemCount = ref.watch(cartItemCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mon panier',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          if (cart.isNotEmpty)
            IconButton(
              onPressed: () => _showClearCartDialog(context, ref),
              icon: const Icon(Icons.delete_sweep_outlined),
              tooltip: 'Vider le panier',
            ),
        ],
      ),
      body: cart.isEmpty
          ? const _EmptyCart()
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '$itemCount article${itemCount > 1 ? 's' : ''}',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final item = cart[index];

                      return _CartItemCard(
                        item: item,
                        onIncrease: () {
                          ref
                              .read(cartProvider.notifier)
                              .increaseQuantity(item.product);
                        },
                        onDecrease: () {
                          ref
                              .read(cartProvider.notifier)
                              .decreaseQuantity(item.product);
                        },
                        onRemove: () {
                          ref
                              .read(cartProvider.notifier)
                              .removeProduct(item.product);
                        },
                      );
                    },
                  ),
                ),

                _CartSummary(
                  total: total,
                  itemCount: itemCount,
                  onCheckout: () {
                    _showCheckoutMessage(context);
                  },
                ),
              ],
            ),
    );
  }

  void _showClearCartDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Vider le panier ?'),
          content: const Text('Tous les produits du panier seront supprimés.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(cartProvider.notifier).clearCart();
                Navigator.pop(dialogContext);
              },
              child: const Text('Vider'),
            ),
          ],
        );
      },
    );
  }

  void _showCheckoutMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Le paiement sera disponible prochainement.'),
      ),
    );
  }
}

// ═══════════════════════════════════════
// ARTICLE DU PANIER
// ═══════════════════════════════════════

class _CartItemCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;

  const _CartItemCard({
    required this.item,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
  });

  String _formatPrice(double price) {
    return '${price.toStringAsFixed(0)} FCFA';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            // IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                item.product.imageUrl,
                width: 85,
                height: 85,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 85,
                    height: 85,
                    alignment: Alignment.center,
                    child: const Icon(Icons.image_not_supported),
                  );
                },
              ),
            ),

            const SizedBox(width: 12),

            // INFORMATIONS
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    _formatPrice(item.product.price),
                    style: TextStyle(color: Colors.grey.shade400),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      _QuantityButton(
                        icon: Icons.remove,
                        onPressed: onDecrease,
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          '${item.quantity}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),

                      _QuantityButton(icon: Icons.add, onPressed: onIncrease),
                    ],
                  ),
                ],
              ),
            ),

            // TOTAL ET SUPPRESSION
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Supprimer',
                ),

                Text(
                  _formatPrice(item.totalPrice),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════
// BOUTON QUANTITÉ
// ═══════════════════════════════════════

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _QuantityButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
      ),
    );
  }
}

// ═══════════════════════════════════════
// RÉSUMÉ DU PANIER
// ═══════════════════════════════════════

class _CartSummary extends StatelessWidget {
  final double total;
  final int itemCount;
  final VoidCallback onCheckout;

  const _CartSummary({
    required this.total,
    required this.itemCount,
    required this.onCheckout,
  });

  String _formatPrice(double price) {
    return '${price.toStringAsFixed(0)} FCFA';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade800)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                Text(
                  _formatPrice(total),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: onCheckout,
                icon: const Icon(Icons.payment),
                label: Text(
                  'Passer la commande ($itemCount)',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════
// PANIER VIDE
// ═══════════════════════════════════════

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 90,
              color: Colors.grey.shade500,
            ),

            const SizedBox(height: 24),

            const Text(
              'Votre panier est vide',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(
              'Ajoutez des produits depuis la boutique '
              'pour les retrouver ici.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade400, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
