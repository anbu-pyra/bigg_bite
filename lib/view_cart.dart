import 'dart:convert';

import 'package:bigg_bite/models/cart_model/cart_response_model.dart';
import 'package:flutter/material.dart';

import 'core/SharedPreference/Prefs.dart';
import 'core/api.dart';

class ViewCart extends StatefulWidget {
  const ViewCart({Key? key}) : super(key: key);

  @override
  _ViewCartState createState() => _ViewCartState();
}

class _ViewCartState extends State<ViewCart> {
  List<dynamic> jsonData = [];
  late Future<CartResponseModel> cartFuture;

  @override
  void initState() {
    getSharedPref();
    super.initState();
  }

  getSharedPref() async {
    String prefData = await Prefs.cartData;
    try {
      jsonData = jsonDecode(prefData);
    } catch (e) {
      jsonData = [];
    }
    if (jsonData.length > 0) {
      cartFuture = viewCart(context, jsonData);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(alignment: Alignment.centerLeft, child: Text('Cart')),
      ),
      body: jsonData.length > 0
          ? SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder<CartResponseModel>(
                    future: cartFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          String? total = snapshot.data?.data?.total.toString();

                          return Column(
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Text(
                                    'Dishes',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount:
                                      snapshot.data?.data?.cartItems?.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    String? quantity = snapshot
                                        .data?.data?.cartItems?[index].quantity
                                        .toString();
                                    String? productName = snapshot.data?.data
                                        ?.cartItems?[index].productName;
                                    return Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.2),
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
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    'Description',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    '18',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                      int maxCount = snapshot
                                                              .data
                                                              ?.data
                                                              ?.cartItems?[
                                                                  index]
                                                              .maxQuantity ??
                                                          0;
                                                      int? count = snapshot
                                                              .data
                                                              ?.data
                                                              ?.cartItems?[
                                                                  index]
                                                              .quantity ??
                                                          0;
                                                      int id = snapshot
                                                              .data
                                                              ?.data
                                                              ?.cartItems?[
                                                                  index]
                                                              .id ??
                                                          0;
                                                      if (maxCount > count) {
                                                        count = count + 1;
                                                        String data =
                                                            await Prefs
                                                                .cartData;
                                                        try {
                                                          List<dynamic>
                                                              jsonData =
                                                              jsonDecode(data);
                                                          bool notchanged =
                                                              false;
                                                          jsonData.forEach(
                                                              (element) {
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
                                                          String tostore = json
                                                              .encode(jsonData);
                                                          Prefs.setCartData(
                                                              tostore);
                                                        } catch (e) {
                                                          String data =
                                                              json.encode([
                                                            {
                                                              "product_id":
                                                                  id.toString(),
                                                              "quantity": 1
                                                            }
                                                          ]);
                                                          Prefs.setCartData(
                                                              data);
                                                        }
                                                        String pr = await Prefs
                                                            .cartData;
                                                        cartFuture = viewCart(
                                                            context,
                                                            json.decode(pr));
                                                        setState(() {});
                                                      }
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.yellow,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.2),
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
                                                          child: Text('+')),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 20,
                                                    width: 20,
                                                    child: Center(
                                                        child: Text(
                                                            quantity ?? '0')),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      int? count = snapshot
                                                              .data
                                                              ?.data
                                                              ?.cartItems?[
                                                                  index]
                                                              .quantity ??
                                                          0;
                                                      if (0 < count) {
                                                        count = count - 1;
                                                        setState(() {});
                                                      }
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.yellow,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.2),
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
                                                          child: Text('-')),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                              SizedBox(
                                height: 15,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Text(
                                    'Delivery Instructions',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Instructions',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              Divider(),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0,
                                      right: 20,
                                      top: 10,
                                      bottom: 10),
                                  child: Text(
                                    'To Pay : ' + total.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22),
                                  ),
                                ),
                              ),
                              Divider(),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Enter Your Name',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Enter Your Mobile Number',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Enter Your House Number',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 200,
                              ),
                            ],
                          );
                        } else {
                          return Container();
                        }
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ],
              ),
            )
          : Container(),
    );
  }
}
