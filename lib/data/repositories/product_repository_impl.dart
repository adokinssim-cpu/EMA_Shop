import '../../domain/models/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDataSource dataSource;

  ProductRepositoryImpl({ProductLocalDataSource? dataSource})
    : dataSource = dataSource ?? ProductLocalDataSource();

  @override
  Future<List<Product>> getProducts() {
    return dataSource.getProducts();
  }
}
