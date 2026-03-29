import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pizoodia_customer/Pages/adminpage/Account/adresss.dart';
import 'package:pizoodia_customer/Pages/decortion/decortion.dart';
import 'package:pizoodia_customer/Pages/navigators/checkstatus.dart';

class cartpage extends StatefulWidget {
  final Map<String, int> cart;
  const cartpage({super.key, required this.cart});

  @override
  State<cartpage> createState() => _cartpageState();
}

class _cartpageState extends State<cartpage> {
  StreamSubscription? shopListener;
  @override
  void initState() {
    super.initState();
    ShopGuard.check(context);
    shopListener = ShopGuard.start(context);
    loadSettings();
  }

  double totalAmount = 0;
  double deliverycharge = 0;

  Future<void> loadSettings() async {
    var doc = await FirebaseFirestore.instance
        .collection("app_config")
        .doc("settings")
        .get();

    setState(() {
      setState(() {
        deliverycharge = (doc["delivery_charge"] as num).toDouble();
      });
    });
  }

  @override
  void dispose() {
    shopListener?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = widget.cart;
    final h = fontSize.height(context);
    final w = fontSize.width(context);

    if (cart.isEmpty) {
      return Scaffold(
        appBar: appname(context),
        body: Container(
          decoration: pagecolor(),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(h * 0.018),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            size: h * 0.10,
                            color: Colors.white,
                          ),
                          SizedBox(height: h * 0.012),
                          Text(
                            "Your Cart is Empty",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: h * 0.022,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  bottom(context, cart),
                ],
              ),
            ),
          ),
        ),
      );
    }

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
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("products")
                  .where(FieldPath.documentId, whereIn: cart.keys.toList())
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }

                var docs = snapshot.data!.docs;

                double newTotal = 0;

                for (var doc in docs) {
                  String id = doc.id;
                  int qty = cart[id]!;
                  int price = doc["price"];
                  newTotal += price * qty;
                }

                totalAmount = newTotal;

                return Column(
                  children: [
                    SizedBox(height: h * 0.10),

                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.only(bottom: 80),
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          var data = docs[index];
                          String id = data.id;
                          int qty = cart[id]!;
                          int price = data["price"];

                          return Card(
                            margin: EdgeInsets.symmetric(
                              horizontal: h * 0.015,
                              vertical: h * 0.004,
                            ),
                            child: ListTile(
                              title: Text(
                                data["name"],
                                style: TextStyle(fontSize: h * 0.020),
                              ),
                              subtitle: Text(
                                "₹ $price",
                                style: TextStyle(fontSize: h * 0.015),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove, size: h * 0.030),
                                    onPressed: () {
                                      setState(() {
                                        if (cart[id]! > 1) {
                                          cart[id] = cart[id]! - 1;
                                        } else {
                                          cart.remove(id);
                                        }
                                      });
                                    },
                                  ),

                                  Text(
                                    qty.toString(),
                                    style: TextStyle(fontSize: h * 0.018),
                                  ),

                                  IconButton(
                                    icon: Icon(Icons.add, size: h * 0.030),
                                    onPressed: () {
                                      setState(() {
                                        cart[id] = cart[id]! + 1;
                                      });
                                    },
                                  ),
                                  SizedBox(width: h * 0.05),

                                  Text(
                                    "₹ ${price * qty}",
                                    style: TextStyle(fontSize: h * 0.018),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // TOTAL BAR
                    Container(
                      padding: EdgeInsets.all(h * 0.018),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(h * 0.025),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                "Delivery Charge: $deliverycharge",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: h * 0.018,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              deliverycharge == 0
                                  ? Row(
                                      children: [
                                        SizedBox(
                                          height: h * 0.02,
                                          width: w * 0.04,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Text(
                                      "Total: ₹ ${totalAmount + deliverycharge}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: h * 0.025,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ],
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                251,
                                17,
                                0,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => address(
                                    cart: cart,
                                    total: totalAmount + deliverycharge,
                                    deliverycharge: deliverycharge,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              "Buy Now",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: h * 0.018,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    bottom(context, {}),
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
