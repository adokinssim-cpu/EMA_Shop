import '../models/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();

  Future<Product?> getProductById(String id);
}
