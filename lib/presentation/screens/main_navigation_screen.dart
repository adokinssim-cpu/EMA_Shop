import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/cart_providers.dart';
import 'home/home_screen.dart';
import 'favorites/favorites_screen.dart';
import 'cart/cart_screen.dart';
import 'profile/profile_screen.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  ConsumerState<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final itemCount = ref.watch(cartItemCountProvider);

    final screens = <Widget>[
      const HomeScreen(),
      const FavoritesScreen(),
      const CartScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,

        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },

        type: BottomNavigationBarType.fixed,

        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Accueil',
          ),

          const BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: 'Favoris',
          ),

          BottomNavigationBarItem(
            icon: _CartIcon(itemCount: itemCount),
            activeIcon: _CartIcon(itemCount: itemCount, active: true),
            label: 'Panier',
          ),

          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════
// ICÔNE PANIER + BADGE
// ═══════════════════════════════════════

class _CartIcon extends StatelessWidget {
  final int itemCount;
  final bool active;

  const _CartIcon({required this.itemCount, this.active = false});

  @override
  Widget build(BuildContext context) {
    return Badge(
      isLabelVisible: itemCount > 0,
      label: Text('$itemCount'),
      child: Icon(active ? Icons.shopping_cart : Icons.shopping_cart_outlined),
    );
  }
}
