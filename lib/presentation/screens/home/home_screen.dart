import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/models/product_filter.dart';
import '../../../providers/filter_providers.dart';
import '../../../providers/favorite_providers.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/product_card.dart';
import '../product/product_detail_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(filteredProductsProvider);
    final filter = ref.watch(filterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'EMA Shop',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),

      body: Column(
        children: [
          // RECHERCHE
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) {
                ref.read(filterProvider.notifier).setSearchQuery(value);
              },
              decoration: InputDecoration(
                hintText: 'Rechercher un produit...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: filter.searchQuery.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          ref.read(filterProvider.notifier).setSearchQuery('');
                        },
                        icon: const Icon(Icons.clear),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),

          // FILTRES
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _CategoryChip(
                  label: 'Tous',
                  selected: filter.category == null,
                  onSelected: () {
                    ref.read(filterProvider.notifier).setCategory(null);
                  },
                ),

                _CategoryChip(
                  label: 'Téléphones',
                  selected: filter.category == 'Téléphones',
                  onSelected: () {
                    ref.read(filterProvider.notifier).setCategory('Téléphones');
                  },
                ),

                _CategoryChip(
                  label: 'Ordinateurs',
                  selected: filter.category == 'Ordinateurs',
                  onSelected: () {
                    ref
                        .read(filterProvider.notifier)
                        .setCategory('Ordinateurs');
                  },
                ),

                _CategoryChip(
                  label: 'Audio',
                  selected: filter.category == 'Audio',
                  onSelected: () {
                    ref.read(filterProvider.notifier).setCategory('Audio');
                  },
                ),

                _CategoryChip(
                  label: 'Accessoires',
                  selected: filter.category == 'Accessoires',
                  onSelected: () {
                    ref
                        .read(filterProvider.notifier)
                        .setCategory('Accessoires');
                  },
                ),
              ],
            ),
          ),

          // TRI
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Produits',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                PopupMenuButton<SortOption>(
                  initialValue: filter.sortOption,
                  onSelected: (option) {
                    ref.read(filterProvider.notifier).setSortOption(option);
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: SortOption.none,
                      child: Text('Par défaut'),
                    ),
                    PopupMenuItem(
                      value: SortOption.priceLowToHigh,
                      child: Text('Prix croissant'),
                    ),
                    PopupMenuItem(
                      value: SortOption.priceHighToLow,
                      child: Text('Prix décroissant'),
                    ),
                    PopupMenuItem(
                      value: SortOption.ratingHighToLow,
                      child: Text('Meilleures notes'),
                    ),
                    PopupMenuItem(
                      value: SortOption.nameAZ,
                      child: Text('Nom A-Z'),
                    ),
                  ],
                  child: const Row(
                    children: [
                      Icon(Icons.sort),
                      SizedBox(width: 5),
                      Text('Trier'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // LISTE DES PRODUITS
          Expanded(
            child: productsAsync.when(
              loading: () => const LoadingWidget(),

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
                            ref.invalidate(filteredProductsProvider);
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Réessayer'),
                        ),
                      ],
                    ),
                  ),
                );
              },

              data: (products) {
                if (products.isEmpty) {
                  return const Center(child: Text('Aucun produit trouvé.'));
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.68,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];

                    final isFavorite = ref.watch(
                      favoritesProvider.select(
                        (favorites) => favorites.contains(product.id),
                      ),
                    );

                    return ProductCard(
                      product: product,
                      isFavorite: isFavorite, // <--- Paramètre ajouté ici
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ProductDetailScreen(product: product),
                          ),
                        );
                      },
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
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onSelected(),
      ),
    );
  }
}
