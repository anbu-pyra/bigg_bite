import 'dart:convert';
import 'dart:io';

import 'package:bigg_bite/core/urlhelper.dart';
import 'package:bigg_bite/models/cart_model/cart_response_model.dart';
import 'package:bigg_bite/models/category_model/category_response_model.dart';
import 'package:bigg_bite/models/product_model/product_response_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<CategoryResponseModel> getCategory(context) async {
  CategoryResponseModel result = CategoryResponseModel();
  try {
    final response = await http.post(
      Uri.parse(GET_CATEGORIES),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      },
    );
    if (response.statusCode == 200) {
      final item = json.decode(response.body);
      result = CategoryResponseModel.fromJson(item);
    } else {
      Fluttertoast.showToast(
          msg: "Oops Something Went Wrong",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  } catch (e) {
    Fluttertoast.showToast(
        msg: "Oops Something Went Wrong",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
  return result;
}

Future<CartResponseModel> viewCart(context, List<dynamic> body) async {
  print('working');
  CartResponseModel result = CartResponseModel();
  var array = [];
  body.forEach((element) {
    Map<String, dynamic> ele = {};
    ele["product_id"] = element["product_id"];
    ele["quantity"] = element["quantity"];
    array.add(ele);
  });
  print(jsonEncode({'data': array.toString()}));

  try {
    final response = await http.post(
      Uri.parse(VIEW_CART),
      body: jsonEncode({'data': array}),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      },
    );
    print('result: ' +
        response.statusCode.toString() +
        ' response: ' +
        response.body);
    if (response.statusCode == 200) {
      final item = json.decode(response.body);
      result = CartResponseModel.fromJson(item);
    } else {
      Fluttertoast.showToast(
          msg: "Oops Something Went Wrong",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  } catch (e) {
    print(e);
    Fluttertoast.showToast(
        msg: "Oops Something Went Wrong",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
  return result;
}

Future<ProductResponseModel> getProduct(context, String categoryId) async {
  print('working');
  ProductResponseModel result = ProductResponseModel();
  try {
    var body = jsonEncode({'category_id': categoryId});
    final response = await http.post(
      Uri.parse(GET_PRODUCTS),
      body: body,
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      },
    );
    print('result: ' +
        response.statusCode.toString() +
        ' response: ' +
        response.body);
    if (response.statusCode == 200) {
      final item = json.decode(response.body);
      result = ProductResponseModel.fromJson(item);
    } else {
      Fluttertoast.showToast(
          msg: "Oops Something Went Wrong",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  } catch (e) {
    print(e);
    Fluttertoast.showToast(
        msg: "Oops Something Went Wrong",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
  return result;
}
