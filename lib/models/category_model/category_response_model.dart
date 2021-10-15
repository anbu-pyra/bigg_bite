import 'data.dart';

class CategoryResponseModel {
  CategoryResponseModel({
    bool error = false,
    String message = '',
    List<Data>? data,
  }) {
    _error = error;
    _message = message;
    _data = data;
  }

  CategoryResponseModel.fromJson(dynamic json) {
    _error = json['error'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      int count = 0;
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v, count));
        count += 1;
      });
    }
  }
  bool? _error;
  String? _message;
  List<Data>? _data;

  bool? get error => _error;
  String? get message => _message;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = _error;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
