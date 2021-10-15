import 'dart:convert';

import 'package:bigg_bite/core/SharedPreference/Prefs.dart';
import 'package:bigg_bite/core/api.dart';
import 'package:bigg_bite/models/category_model/category_response_model.dart';
import 'package:bigg_bite/models/product_model/product_response_model.dart';
import 'package:bigg_bite/view_cart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'core/SharedPreference/Prefs.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: MyHomePage(title: 'Bigg Bite'),
      // home: ViewCart(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String categoryId = '1';
  late Future<CategoryResponseModel> categoryFuture;
  late Future<ProductResponseModel> productFuture;
  late ProductResponseModel response;
  late CategoryResponseModel categoryResponse;
  String prefData = '';
  int count = 0;
  @override
  void initState() {
    categoryFuture = getCategory(context);
    productFuture = getProduct(context, categoryId);
    getSharedPref();
    super.initState();
  }

  getSharedPref() async {
    prefData = await Prefs.cartData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [Text('Orders')],
        title:
            Align(alignment: Alignment.centerLeft, child: Text(widget.title)),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Center(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 200.0,
                    child: PageView.builder(
                      itemCount: 10,
                      controller: PageController(viewportFraction: 0.8),
                      itemBuilder: (BuildContext context, int itemIndex) {
                        return _buildCarouselItem(context, 0, itemIndex);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text(
                        'Categories',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  FutureBuilder<CategoryResponseModel>(
                    future: categoryFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          categoryResponse = snapshot.data!;
                          return Container(
                            height: 50,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: categoryResponse.data?.length,
                              itemBuilder: (BuildContext context, int index) {
                                String? categoryName =
                                    categoryResponse.data?[index].categoryName;
                                int? categoryIdValue =
                                    categoryResponse.data?[index].id;
                                bool? selected =
                                    categoryResponse.data?[index].isSelected;
                                print(selected);
                                return InkWell(
                                  onTap: () {
                                    int length =
                                        categoryResponse.data?.length ?? 0;
                                    for (int i = 0; i < length; i++) {
                                      if (index == i) {
                                        categoryResponse.data?[i]
                                            .setSelected(true);
                                      } else {
                                        categoryResponse.data?[i]
                                            .setSelected(false);
                                      }
                                    }
                                    setState(() {
                                      categoryId = categoryIdValue.toString();
                                      productFuture =
                                          getProduct(context, categoryId);
                                    });
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Container(
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: selected ?? false
                                            ? Colors.yellow
                                            : Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            blurRadius: 3,
                                            offset: Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Text(
                                            categoryName ?? 'none',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          return Container();
                        }
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text(
                        'Grab Your Favourite Dishes',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  FutureBuilder<ProductResponseModel>(
                    future: productFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          ProductResponseModel? productResponse = snapshot.data;
                          response = snapshot.data!;

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: productResponse?.data?.length,
                            itemBuilder: (BuildContext context, int index) {
                              String? productName =
                                  snapshot.data?.data?[index].productName;
                              String? productDescri =
                                  response.data?[index].productName;
                              int? id = response.data?[index].id;
                              try {
                                List<dynamic> jsonData = jsonDecode(prefData);
                                jsonData.forEach((element) {
                                  if (element["product_id"] == id.toString()) {
                                    response.data?[index]
                                        .setCount(element["quantity"]);
                                  }
                                });
                              } catch (e) {}
                              return Padding(
                                padding: EdgeInsets.all(8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        blurRadius: 3,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          color: Colors.grey,
                                          width: 100,
                                          height: 100,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              productName ?? '',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              productDescri ?? '',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              '18',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                int maxCount = response
                                                        .data?[index]
                                                        .maxQuantity ??
                                                    0;
                                                int count = response
                                                        .data?[index].count ??
                                                    0;
                                                int id =
                                                    response.data?[index].id ??
                                                        0;

                                                if (maxCount > count) {
                                                  count = count + 1;
                                                  String data =
                                                      await Prefs.cartData;
                                                  try {
                                                    List<dynamic> jsonData =
                                                        jsonDecode(data);
                                                    bool notchanged = false;
                                                    jsonData.forEach((element) {
                                                      if (element[
                                                              "product_id"] ==
                                                          id.toString()) {
                                                        notchanged = true;
                                                        element["quantity"] =
                                                            count;
                                                      }
                                                    });
                                                    if (!notchanged) {
                                                      jsonData.add({
                                                        "product_id":
                                                            id.toString(),
                                                        "quantity": 1
                                                      });
                                                    }
                                                    String tostore =
                                                        json.encode(jsonData);
                                                    Prefs.setCartData(tostore);
                                                  } catch (e) {
                                                    String data = json.encode([
                                                      {
                                                        "product_id":
                                                            id.toString(),
                                                        "quantity": 1
                                                      }
                                                    ]);
                                                    Prefs.setCartData(data);
                                                  }
                                                  response.data?[index]
                                                      .setCount(count);
                                                  String pr =
                                                      await Prefs.cartData;
                                                  print(pr);
                                                  productFuture = getProduct(
                                                      context, categoryId);
                                                }
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.yellow,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.2),
                                                      blurRadius: 3,
                                                      offset: Offset(0,
                                                          3), // changes position of shadow
                                                    ),
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(5),
                                                  ),
                                                ),
                                                height: 20,
                                                width: 20,
                                                child: Center(
                                                  child: Text('+'),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 20,
                                              width: 20,
                                              child: Center(
                                                child: Text(response
                                                        .data?[index].count
                                                        .toString() ??
                                                    ''),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                int count = response
                                                        .data?[index].count ??
                                                    0;
                                                if (0 < count) {
                                                  count = count - 1;
                                                  String data =
                                                      await Prefs.cartData;
                                                  List<dynamic> jsonData =
                                                      jsonDecode(data);
                                                  bool notchanged = false;
                                                  jsonData.forEach((element) {
                                                    if (element["product_id"] ==
                                                        id.toString()) {
                                                      notchanged = true;
                                                      element["quantity"] =
                                                          count;
                                                    }
                                                  });
                                                  response.data?[index]
                                                      .setCount(count);
                                                  String tostore =
                                                      json.encode(jsonData);
                                                  Prefs.setCartData(tostore);
                                                  productFuture = getProduct(
                                                      context, categoryId);
                                                }
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.yellow,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.2),
                                                      blurRadius: 3,
                                                      offset: Offset(0,
                                                          3), // changes position of shadow
                                                    ),
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(5),
                                                  ),
                                                ),
                                                height: 20,
                                                width: 20,
                                                child: Center(child: Text('-')),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return Container();
                        }
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
          ),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: Container(
          //     decoration: BoxDecoration(
          //       color: Colors.black,
          //       boxShadow: [
          //         BoxShadow(
          //           color: Colors.grey.withOpacity(0.2),
          //           blurRadius: 3,
          //           offset: Offset(1, 3), // changes position of shadow
          //         ),
          //       ],
          //     ),
          //     height: 50,
          //     child: Row(
          //       children: [
          //         // Padding(
          //         //   padding: const EdgeInsets.all(8.0),
          //         //   child: Text(
          //         //     'Total : 2000',
          //         //     style: TextStyle(
          //         //         color: Colors.white,
          //         //         fontWeight: FontWeight.bold,
          //         //         fontSize: 16),
          //         //   ),
          //         // ),
          //         // Container(
          //         //   height: 5,
          //         //   width: 5,
          //         //   decoration: BoxDecoration(
          //         //     color: Colors.white,
          //         //     boxShadow: [
          //         //       BoxShadow(
          //         //         color: Colors.grey.withOpacity(0.2),
          //         //         blurRadius: 3,
          //         //         offset: Offset(0, 3), // changes position of shadow
          //         //       ),
          //         //     ],
          //         //     borderRadius: BorderRadius.all(
          //         //       Radius.circular(15),
          //         //     ),
          //         //   ),
          //         // ),
          //         // Padding(
          //         //   padding: const EdgeInsets.all(8.0),
          //         //   child: Text(
          //         //     count.toString(),
          //         //     style: TextStyle(
          //         //         color: Colors.white, fontWeight: FontWeight.bold),
          //         //   ),
          //         // ),
          //         // Spacer(),
          //         InkWell(
          //           onTap: () {
          //             // Navigator.push(context, )
          //           },
          //           child: Container(
          //             height: 60,
          //             color: Colors.yellow,
          //             child: Padding(
          //               padding: const EdgeInsets.all(10.0),
          //               child: Center(
          //                   child: Text(
          //                 'View Cart',
          //                 style: TextStyle(fontWeight: FontWeight.bold),
          //               )),
          //             ),
          //           ),
          //         )
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ViewCart()),
          );
        },
        child: const Icon(
          Icons.shopping_cart,
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
      ),
    );
  }

  Widget _buildCarouselItem(
      BuildContext context, int carouselIndex, int itemIndex) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
      ),
    );
  }
}
