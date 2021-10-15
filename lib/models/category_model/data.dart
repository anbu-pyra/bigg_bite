class Data {
  Data({int id = 0, String categoryName = '', bool isSelected = false}) {
    _id = id;
    _categoryName = categoryName;
    _isSelected = isSelected;
  }

  Data.fromJson(dynamic json, int count) {
    _id = json['id'];
    _categoryName = json['category_name'];
    if (count == 0) {
      _isSelected = true;
    } else {
      _isSelected = false;
    }
  }
  int? _id;
  String? _categoryName;
  bool _isSelected = false;

  int? get id => _id;
  String? get categoryName => _categoryName;
  bool? get isSelected => _isSelected;

  setSelected(bool selected) {
    _isSelected = selected;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['category_name'] = _categoryName;
    return map;
  }
}
