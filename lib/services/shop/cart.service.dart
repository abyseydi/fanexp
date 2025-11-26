import 'package:fanexp/entity/product.entity.dart';

class CartItem {
  final ProductInterface product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  int get totalPrice => (product.newPrix ?? product.prix) * quantity;
}

class CartService {
  CartService._internal();
  static final CartService instance = CartService._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  void addItem(ProductInterface product, {int quantity = 1}) {
    try {
      final index = _items.indexWhere((item) => item.product.id == product.id);
      if (index >= 0) {
        _items[index].quantity += quantity;
      } else {
        _items.add(CartItem(product: product, quantity: quantity));
      }
    } catch (_) {}
  }

  void removeItem(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
  }

  void clear() {
    _items.clear();
  }

  int get totalAmount {
    return _items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  bool get isEmpty => _items.isEmpty;
}
