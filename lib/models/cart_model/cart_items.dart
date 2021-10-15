class CartItems {
  CartItems({
    int? id,
    int? categoryId,
    String? productName,
    int? maxQuantity,
    String? description,
    int? slashedPrice,
    String? photo,
    int? isVeg,
    int? status,
    int? price,
    dynamic gst,
    String? specifications,
    String? updatedAt,
    String? createdAt,
    int? totalPrice,
    int quantity = 0,
  }) {
    _id = id;
    _categoryId = categoryId;
    _productName = productName;
    _maxQuantity = maxQuantity;
    _description = description;
    _slashedPrice = slashedPrice;
    _photo = photo;
    _isVeg = isVeg;
    _status = status;
    _price = price;
    _gst = gst;
    _specifications = specifications;
    _updatedAt = updatedAt;
    _createdAt = createdAt;
    _totalPrice = totalPrice;
    _quantity = quantity;
  }

  CartItems.fromJson(dynamic json) {
    _id = json['id'];
    _categoryId = json['category_id'];
    _productName = json['product_name'];
    _maxQuantity = json['max_quantity'];
    _description = json['description'];
    _slashedPrice = json['slashed_price'];
    _photo = json['photo'];
    _isVeg = json['is_veg'];
    _status = json['status'];
    _price = json['price'];
    _gst = json['gst'];
    _specifications = json['specifications'];
    _updatedAt = json['updated_at'];
    _createdAt = json['created_at'];
    _totalPrice = json['total_price'];
    _quantity = json['quantity'] ?? 0;
  }
  int? _id;
  int? _categoryId;
  String? _productName;
  int? _maxQuantity;
  String? _description;
  int? _slashedPrice;
  String? _photo;
  int? _isVeg;
  int? _status;
  int? _price;
  dynamic _gst;
  String? _specifications;
  String? _updatedAt;
  String? _createdAt;
  int? _totalPrice;
  int _quantity = 0;

  int? get id => _id;
  int? get categoryId => _categoryId;
  String? get productName => _productName;
  int? get maxQuantity => _maxQuantity;
  String? get description => _description;
  int? get slashedPrice => _slashedPrice;
  String? get photo => _photo;
  int? get isVeg => _isVeg;
  int? get status => _status;
  int? get price => _price;
  dynamic get gst => _gst;
  String? get specifications => _specifications;
  String? get updatedAt => _updatedAt;
  String? get createdAt => _createdAt;
  int? get totalPrice => _totalPrice;
  int? get quantity => _quantity;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['category_id'] = _categoryId;
    map['product_name'] = _productName;
    map['max_quantity'] = _maxQuantity;
    map['description'] = _description;
    map['slashed_price'] = _slashedPrice;
    map['photo'] = _photo;
    map['is_veg'] = _isVeg;
    map['status'] = _status;
    map['price'] = _price;
    map['gst'] = _gst;
    map['specifications'] = _specifications;
    map['updated_at'] = _updatedAt;
    map['created_at'] = _createdAt;
    map['total_price'] = _totalPrice;
    map['quantity'] = _quantity;
    return map;
  }
}
