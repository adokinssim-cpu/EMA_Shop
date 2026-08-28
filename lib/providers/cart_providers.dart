import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/cart_item.dart';
import '../domain/models/product.dart';

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addProduct(Product product) {
    final index = state.indexWhere((item) => item.product.id == product.id);

    if (index == -1) {
      state = [...state, CartItem(product: product, quantity: 1)];
    } else {
      final updatedCart = [...state];

      final item = updatedCart[index];

      updatedCart[index] = item.copyWith(quantity: item.quantity + 1);

      state = updatedCart;
    }
  }

  void removeProduct(Product product) {
    state = state.where((item) => item.product.id != product.id).toList();
  }

  void increaseQuantity(Product product) {
    final index = state.indexWhere((item) => item.product.id == product.id);

    if (index == -1) return;

    final updatedCart = [...state];

    final item = updatedCart[index];

    updatedCart[index] = item.copyWith(quantity: item.quantity + 1);

    state = updatedCart;
  }

  void decreaseQuantity(Product product) {
    final index = state.indexWhere((item) => item.product.id == product.id);

    if (index == -1) return;

    final item = state[index];

    if (item.quantity <= 1) {
      removeProduct(product);
      return;
    }

    final updatedCart = [...state];

    updatedCart[index] = item.copyWith(quantity: item.quantity - 1);

    state = updatedCart;
  }

  void clearCart() {
    state = [];
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

final cartTotalProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);

  return cart.fold(0, (total, item) => total + item.totalPrice);
});

final cartItemCountProvider = Provider<int>((ref) {
  final cart = ref.watch(cartProvider);

  return cart.fold(0, (total, item) => total + item.quantity);
});
