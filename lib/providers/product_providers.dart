import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/product_repository_impl.dart';
import '../domain/models/product.dart';
import '../domain/repositories/product_repository.dart';

/// Fournit l'implémentation du repository des produits.
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepositoryImpl();
});

/// Charge la liste complète des produits.
final productsProvider = FutureProvider<List<Product>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);

  return repository.getProducts();
});

/// Charge un produit à partir de son identifiant.
final productByIdProvider = FutureProvider.family<Product?, String>((
  ref,
  id,
) async {
  final repository = ref.watch(productRepositoryProvider);

  return repository.getProductById(id);
});
