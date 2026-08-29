import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/favorite_providers.dart';
import '../../../providers/product_providers.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/product_card.dart';
import '../product/product_detail_screen.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Récupère les IDs des produits favoris
    final favoriteIds = ref.watch(favoritesProvider);

    // Récupère tous les produits
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mes favoris',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        actions: [
          // Le bouton supprimer apparaît seulement
          // lorsqu'il existe au moins un favori
          if (favoriteIds.isNotEmpty)
            IconButton(
              onPressed: () {
                _showClearFavoritesDialog(context, ref);
              },
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Supprimer tous les favoris',
            ),
        ],
      ),

      body: productsAsync.when(
        // ─────────────────────────
        // CHARGEMENT
        // ─────────────────────────
        loading: () {
          return const LoadingWidget();
        },

        // ─────────────────────────
        // ERREUR
        // ─────────────────────────
        error: (error, stackTrace) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60),

                  const SizedBox(height: 16),

                  const Text(
                    'Impossible de charger les produits.',
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  ElevatedButton.icon(
                    onPressed: () {
                      ref.invalidate(productsProvider);
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Réessayer'),
                  ),
                ],
              ),
            ),
          );
        },

        // ─────────────────────────
        // DONNÉES
        // ─────────────────────────
        data: (products) {
          // On sélectionne uniquement les produits
          // dont l'ID est présent dans favoritesProvider
          final favoriteProducts = products
              .where((product) => favoriteIds.contains(product.id))
              .toList();

          // ─────────────────────────
          // AUCUN FAVORI
          // ─────────────────────────
          if (favoriteProducts.isEmpty) {
            return const _EmptyFavorites();
          }

          // ─────────────────────────
          // LISTE DES FAVORIS
          // ─────────────────────────
          return GridView.builder(
            padding: const EdgeInsets.all(16),

            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.68,
            ),

            itemCount: favoriteProducts.length,

            itemBuilder: (context, index) {
              final product = favoriteProducts[index];

              return ProductCard(
                product: product,

                // Tous les produits affichés ici
                // sont des favoris
                isFavorite: true,

                // Ouvrir le détail
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailScreen(product: product),
                    ),
                  );
                },

                // Retirer des favoris
                onFavorite: () {
                  ref
                      .read(favoritesProvider.notifier)
                      .toggleFavorite(product.id);
                },
              );
            },
          );
        },
      ),
    );
  }

  // ─────────────────────────
  // DIALOGUE DE SUPPRESSION
  // ─────────────────────────

  void _showClearFavoritesDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Supprimer les favoris ?'),

          content: const Text(
            'Tous vos produits favoris '
            'seront supprimés.',
          ),

          actions: [
            // ANNULER
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Annuler'),
            ),

            // SUPPRIMER
            ElevatedButton(
              onPressed: () {
                ref.read(favoritesProvider.notifier).clearFavorites();

                Navigator.pop(dialogContext);
              },
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }
}

// ═══════════════════════════════════
// ÉCRAN AUCUN FAVORI
// ═══════════════════════════════════

class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 90, color: Colors.grey.shade500),

            const SizedBox(height: 24),

            const Text(
              'Aucun favori',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(
              'Ajoutez des produits à vos favoris '
              'pour les retrouver facilement ici.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade400, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
