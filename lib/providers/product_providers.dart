import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/product_repository_impl.dart';
import '../domain/models/product.dart';
import '../domain/repositories/product_repository.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepositoryImpl();
});

final productsProvider = FutureProvider<List<Product>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);

  return repository.getProducts();
});
