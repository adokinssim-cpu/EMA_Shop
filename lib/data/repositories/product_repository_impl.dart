import '../../domain/models/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_mock_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  @override
  Future<List<Product>> getProducts() async {
    // Simulation d'un appel réseau.
    await Future.delayed(const Duration(milliseconds: 700));

    return mockProducts.map((json) => Product.fromJson(json)).toList();
  }

  @override
  Future<Product?> getProductById(String id) async {
    // Simulation d'un appel réseau.
    await Future.delayed(const Duration(milliseconds: 300));

    final productJson = mockProducts.cast<Map<String, dynamic>>().firstWhere(
      (product) => product['id'] == id,
      orElse: () => {},
    );

    if (productJson.isEmpty) {
      return null;
    }

    return Product.fromJson(productJson);
  }
}
