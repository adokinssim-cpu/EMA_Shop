# EMA Shop 🛍️

Application e-commerce mobile développée avec Flutter et Riverpod dans le cadre du projet de certification.

## 🎯 Objectif

EMA Shop est une application e-commerce permettant à un utilisateur de consulter un catalogue de produits, rechercher et filtrer des produits, consulter leurs détails, gérer un panier, enregistrer des favoris et consulter son profil.

L'objectif principal du projet est de mettre en pratique la gestion d'état avec Riverpod ainsi qu'une architecture en couches.

---

## ✨ Fonctionnalités

### Catalogue

- Affichage des produits
- Affichage sous forme de grille
- Recherche de produits
- Filtrage par catégorie
- Tri par :
  - Prix croissant
  - Prix décroissant
  - Meilleures notes
  - Nom A-Z
  - Ordre par défaut

### Détails produit

- Image du produit
- Nom
- Catégorie
- Description
- Note
- Prix
- Sélection de la quantité
- Ajout au panier
- Ajout/retrait des favoris

### Panier

- Ajout d'un produit
- Suppression d'un produit
- Augmentation de la quantité
- Diminution de la quantité
- Suppression complète du panier
- Calcul automatique du total
- Nombre total d'articles

### Favoris

- Ajout et retrait des favoris
- Persistance locale des favoris

### Profil

- Écran de profil utilisateur mock
- Informations utilisateur fictives

---

# 🏗️ Architecture

Le projet utilise une architecture en couches afin de séparer clairement les responsabilités entre les données, la logique métier, la gestion d'état et l'interface utilisateur.

```text
lib/
│
├── core/
│   └── utils/
│
├── data/
│   ├── datasources/
│   │   ├── product_mock_datasource.dart
│   │   └── favorites_mock_datasource.dart
│   │
│   └── repositories/
│       ├── product_repository_impl.dart
│       └── favorites_repository_impl.dart
│
├── domain/
│   ├── models/
│   │   ├── product.dart
│   │   ├── cart_item.dart
│   │   ├── product_filter.dart
│   │   └── user.dart
│   │
│   └── repositories/
│       ├── product_repository.dart
│       └── favorites_repository.dart
│
├── presentation/
│   ├── screens/
│   │   ├── home/
│   │   ├── product/
│   │   ├── cart/
│   │   ├── favorites/
│   │   └── profile/
│   │
│   └── widgets/
│
└── providers/
    ├── product_providers.dart
    ├── filter_providers.dart
    ├── favorite_providers.dart
    └── cart_providers.dart
```

---

# 🔄 Gestion d'état avec Riverpod

Riverpod est utilisé comme solution de gestion d'état principale du projet.

## Providers principaux

### `productRepositoryProvider`

Fournit l'implémentation du repository des produits.

### `productsProvider`

Charge les produits de manière asynchrone avec `FutureProvider`.

### `productByIdProvider`

Permet de récupérer un produit à partir de son identifiant.

### `filterProvider`

Gère l'état des filtres, de la recherche et du tri.

### `filteredProductsProvider`

Combine les produits et les filtres pour produire la liste finale affichée dans l'interface.

### `favoritesRepositoryProvider`

Fournit le repository responsable de la persistance des favoris.

### `favoritesProvider`

Gère l'ensemble des favoris avec `StateNotifierProvider`.

### `cartProvider`

Gère l'état du panier avec `StateNotifierProvider`.

### `cartTotalProvider`

Calcule automatiquement le montant total du panier.

### `cartItemCountProvider`

Calcule automatiquement le nombre total d'articles du panier.

---

# ⚡ Gestion des états asynchrones

Les données produits sont chargées avec `FutureProvider`.

L'interface utilise `AsyncValue` afin de gérer les différents états :

```text
Loading
   ↓
Success
   ↓
Error
```

L'interface affiche notamment :

- un écran de chargement ;
- un message d'erreur ;
- un bouton pour réessayer ;
- un message lorsqu'aucun produit n'est trouvé.

---

# 🧪 Tests

Les tests du projet sont exécutés avec :

```bash
flutter test
```

Résultat attendu :

```text
All tests passed!
```

L'analyse statique du projet peut être vérifiée avec :

```bash
flutter analyze
```

---

# 📱 Technologies utilisées

- Flutter
- Dart
- Riverpod
- StateNotifierProvider
- FutureProvider
- AsyncValue
- Données mockées
- Architecture en couches

---

# 🚀 Installation

## Prérequis

Avant de lancer le projet, il est nécessaire d'avoir installé :

- Flutter
- Dart
- Android Studio ou Visual Studio Code
- Un émulateur Android ou un appareil physique

## Installation

Cloner le repository :

```bash
git clone URL_DU_REPOSITORY
```

Entrer dans le dossier du projet :

```bash
cd projet3_flutter
```

Installer les dépendances :

```bash
flutter pub get
```

Lancer l'application :

```bash
flutter run
```

---

# 📌 État du projet

Projet de certification Flutter — **EMA Shop**

Les fonctionnalités obligatoires sont implémentées :

- ✅ Catalogue de produits
- ✅ Liste des produits
- ✅ Détail d'un produit
- ✅ Panier d'achat
- ✅ Ajout et suppression des produits
- ✅ Gestion des quantités
- ✅ Calcul automatique du total
- ✅ Système de favoris
- ✅ Persistance locale des favoris
- ✅ Recherche de produits
- ✅ Filtrage par catégorie
- ✅ Tri des produits
- ✅ Écran de profil utilisateur mock
- ✅ Gestion d'état avec Riverpod
- ✅ Plus de 5 providers distincts
- ✅ Architecture en couches
- ✅ Séparation de la logique métier et de l'interface
- ✅ Gestion des états de chargement
- ✅ Gestion des erreurs
- ✅ Utilisation de `AsyncValue`
- ✅ Données produits mockées

---

# 🎁 Bonus

Une amélioration possible du projet est l'ajout d'animations lors de l'ajout d'un produit au panier.

Cette fonctionnalité est considérée comme optionnelle et n'est pas nécessaire pour satisfaire les exigences obligatoires.

---

# 👨‍💻 Projet

**EMA Shop**

Application e-commerce mobile développée avec **Flutter** et **Riverpod** dans le cadre d'un projet de certification.