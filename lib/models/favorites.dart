import 'package:flutter/material.dart';

/// A single favorite item with an id and a display label.
class FavoriteItem {
  final int id;
  final String label;

  FavoriteItem({
    required this.id,
    required this.label,
  });
}

/// The [Favorites] class holds a list of favorite items saved by the user.
class Favorites extends ChangeNotifier {
  final List<FavoriteItem> _favoriteItems = [];

  List<FavoriteItem> get items => _favoriteItems;

  bool contains(int itemNo) {
    return _favoriteItems.any((item) => item.id == itemNo);
  }

  void add(int itemNo, String label) {
    _favoriteItems.add(
      FavoriteItem(
        id: itemNo,
        label: label,
      ),
    );
    notifyListeners();
  }

  void remove(int itemNo) {
    _favoriteItems.removeWhere((item) => item.id == itemNo);
    notifyListeners();
  }
}