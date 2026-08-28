import 'dart:convert';

import 'package:flutter/services.dart';

import '../../domain/models/product.dart';

class ProductLocalDataSource {
  Future<List<Product>> getProducts() async {
    await Future.delayed(const Duration(milliseconds: 800));

    final jsonString = await rootBundle.loadString('assets/data/products.json');

    final List<dynamic> jsonData = json.decode(jsonString);

    return jsonData
        .map((json) => Product.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
