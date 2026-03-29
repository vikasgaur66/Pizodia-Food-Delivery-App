import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pizoodia_customer/Pages/adminpage/history/historys.dart';
import 'package:pizoodia_customer/Pages/decortion/decortion.dart';
import 'package:pizoodia_customer/Pages/navigators/checkstatus.dart';

class OrderSummaryPage extends StatefulWidget {
  final Map<String, int> cart;

  final double total;
  final String address;
  final String mobile;
  final double deliverycharge;

  const OrderSummaryPage({
    super.key,
    required this.cart,
    required this.total,
    required this.address,
    required this.mobile,
    required this.deliverycharge,
  });

  @override
  State<OrderSummaryPage> createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  StreamSubscription? shopListener;

  @override
  void initState() {
    super.initState();

    ShopGuard.check(context);
    shopListener = ShopGuard.start(context);
  }

  Future<void> placeOrder() async {
    User user = FirebaseAuth.instance.currentUser!;

    Map<String, dynamic> detailedItems = {};

    for (var entry in widget.cart.entries) {
      String productId = entry.key;
      int quantity = entry.value;

      DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
          .collection("products")
          .doc(productId)
          .get();

      var productData = productSnapshot.data() as Map<String, dynamic>;

      detailedItems[productId] = {
        "name": productData["name"],
        "price": productData["price"],
        "image": productData["image"],
        "quantity": quantity,
      };
    }

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();

    var userData = userDoc.data() as Map<String, dynamic>;
    String name = userData["name"];

    await FirebaseFirestore.instance.collection("orders").add({
      "userId": user.uid,
      "userName": name,
      "items": detailedItems,
      "total": widget.total,
      "address": widget.address,
      "mobile": widget.mobile,
      "status": "pending",
      "time": FieldValue.serverTimestamp(),
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = fontSize.height(context);
    final w = fontSize.width(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appname(context),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: pagecolor(),

        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(h * 0.018),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: pagecolor(), // 👈 same background
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Colors.white, // 👈 visible on dark bg
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Loading...",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  );
                }

                var data = snapshot.data!;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: h * 0.58,

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(h * 0.015),
                        ),
                      ),

                      child: Column(
                        children: [
                          Container(
                            height: h * 0.087,
                            margin: EdgeInsets.all(h * 0.006),
                            child: Row(
                              children: [
                                Container(
                                  child: Image.asset(
                                    "assets/images/boy.jpg",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Text(
                                  "${data['name'] ?? 'User'}",
                                  style: TextStyle(fontSize: h * 0.022),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: h * 0.002,
                            color: const Color.fromARGB(255, 204, 203, 203),
                            margin: EdgeInsets.only(
                              left: h * 0.022,
                              right: h * 0.022,
                            ),
                          ),
                          SizedBox(height: h * 0.020),

                          Container(
                            alignment: Alignment.topLeft,
                            height: h * 0.05,
                            margin: EdgeInsets.only(left: h * 0.022),
                            child: Text(
                              "🏠 Address: ${data['address']}",
                              style: TextStyle(fontSize: h * 0.020),
                            ),
                          ),
                          SizedBox(),

                          Container(
                            alignment: Alignment.topLeft,
                            height: h * 0.05,
                            margin: EdgeInsets.only(left: h * 0.022),
                            child: Text(
                              "📱 Moblie: +91${data['mobile']}",
                              style: TextStyle(fontSize: h * 0.020),
                            ),
                          ),
                          SizedBox(height: h * 0.010),
                          Container(
                            alignment: Alignment.topLeft,
                            height: h * 0.06,
                            margin: EdgeInsets.only(
                              left: h * 0.022,
                              right: h * 0.022,
                            ),
                            color: const Color.fromARGB(255, 249, 239, 189),
                            child: Column(
                              children: [
                                Text(
                                  "  💵Cash On Delivery",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: h * 0.020,
                                  ),
                                ),
                                Text(
                                  "  (Pay ₹ ${widget.total} in cash) ",
                                  style: TextStyle(fontSize: h * 0.020),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: h * 0.020),

                          Container(
                            alignment: Alignment.topLeft,
                            height: h * 0.037,
                            margin: EdgeInsets.only(left: h * 0.022),
                            child: Text(
                              "Order Summary",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: h * 0.020,
                              ),
                            ),
                          ),
                          SizedBox(height: h * 0.010),
                          Container(
                            alignment: Alignment.topLeft,
                            height: h * 0.12,
                            margin: EdgeInsets.only(
                              left: h * 0.022,
                              right: h * 0.022,
                            ),
                            decoration: BoxDecoration(),
                            child: Column(
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "iteam Rate ",
                                          style: TextStyle(fontSize: h * 0.020),
                                        ),

                                        Text(
                                          "₹ ${widget.total - widget.deliverycharge}",
                                          style: TextStyle(fontSize: h * 0.018),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Delivery Charge",
                                          style: TextStyle(fontSize: h * 0.020),
                                        ),

                                        Text(
                                          "₹ ${widget.deliverycharge}",
                                          style: TextStyle(fontSize: h * 0.018),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: h * 0.010),
                                Container(
                                  height: h * 0.037,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Total",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: h * 0.020,
                                        ),
                                      ),
                                      Text(
                                        "₹ ${widget.total}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: h * 0.020,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: h * 0.015),

                          Container(
                            width: w * 0.5,
                            height: h * 0.05,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              onPressed: () async {
                                await placeOrder();
                                widget.cart.clear();

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Order Placed Successfully ✅",
                                    ),
                                  ),
                                );

                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Historys(),
                                  ),
                                  (Route<dynamic> route) => false,
                                );
                              },
                              child: Text(
                                "Confirm & Buy",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: h * 0.018,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

//   children: [
        //     /// ADDRESS
        //     Align(
        //       alignment: Alignment.centerLeft,
        //       child: Text(
        //         "Address:",
        //         style: TextStyle(fontWeight: FontWeight.bold),
        //       ),
        //     ),
        //     Text(address),
        //     SizedBox(height: 10),

        //     /// MOBILE
        //     Align(
        //       alignment: Alignment.centerLeft,
        //       child: Text(
        //         "Mobile:",
        //         style: TextStyle(fontWeight: FontWeight.bold),
        //       ),
        //     ),
        //     Text(mobile),
        //     SizedBox(height: 20),

        //     /// ITEMS LIST
        //     Expanded(
        //       child: ListView(
        //         children: cart.entries.map((item) {
        //           return ListTile(
        //             title: Text(item.key),
        //             trailing: Text("x${item.value}"),
        //           );
        //         }).toList(),
        //       ),
        //     ),

        //     /// TOTAL
        //     Text(
        //       "Total:  $total",
        //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        //     ),

        //     SizedBox(height: 20),

        //     /// DONE BUTTON
        //     SizedBox(
        //       width: double.infinity,
        //       child: ElevatedButton(
        //         onPressed: () async {
        //           await placeOrder();

        //           ScaffoldMessenger.of(
        //             context,
        //           ).showSnackBar(SnackBar(content: Text("Order Placed ✅")));

        //           Navigator.popUntil(context, (route) => route.isFirst);
        //         },
        //         child: Text("DONE"),
        //       ),
        //     ),