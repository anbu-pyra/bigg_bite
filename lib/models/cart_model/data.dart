import 'cart_items.dart';

class Data {
  Data({
    int? total,
    List<CartItems>? cartItems,
  }) {
    _total = total;
    _cartItems = cartItems;
  }

  Data.fromJson(dynamic json) {
    _total = json['total'];
    if (json['cartItems'] != null) {
      _cartItems = [];
      json['cartItems'].forEach((v) {
        _cartItems?.add(CartItems.fromJson(v));
      });
    }
  }
  int? _total;
  List<CartItems>? _cartItems;

  int? get total => _total;
  List<CartItems>? get cartItems => _cartItems;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total'] = _total;
    if (_cartItems != null) {
      map['cartItems'] = _cartItems?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
