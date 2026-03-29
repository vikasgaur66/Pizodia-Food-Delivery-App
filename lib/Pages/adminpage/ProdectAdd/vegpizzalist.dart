import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pizoodia_customer/Pages/adminpage/Cart/oders.dart';

import 'package:pizoodia_customer/Pages/decortion/decortion.dart';
import 'package:pizoodia_customer/Pages/navigators/checkstatus.dart';

class vegpizza extends StatefulWidget {
  @override
  State<vegpizza> createState() => _vegpizzaState();
}

class _vegpizzaState extends State<vegpizza> {
  ScrollController _scrollController = ScrollController();
  Map<String, int> cart = {};
  late Stream<QuerySnapshot> productStream;

  StreamSubscription? shopListener;

  @override
  void initState() {
    super.initState();
    productStream = FirebaseFirestore.instance
        .collection("products")
        .where("category", isEqualTo: "Veg")
        .orderBy("createdAt", descending: true)
        .snapshots();
    ShopGuard.check(context);
    shopListener = ShopGuard.start(context);
  }

  @override
  void dispose() {
    shopListener?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final h = fontSize.height(context);
    final w = fontSize.width(context);

    int totalItems = cart.values.fold(0, (sum, qty) => sum + qty);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: totalItems == 0
          ? null
          : Container(
              margin: EdgeInsets.only(bottom: h * 0.060),
              child: FloatingActionButton.extended(
                backgroundColor: const Color.fromARGB(255, 250, 39, 39),

                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => cartpage(cart: cart)),
                  );
                  setState(() {});
                },
                label: Text(
                  "View Cart ($totalItems) ",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    fontSize: h * 0.022,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                icon: Icon(
                  Icons.shopping_cart,
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontWeight: FontWeight.bold,
                  size: h * 0.025,
                ),
              ),
            ),
      extendBodyBehindAppBar: true,
      appBar: appname(context),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: pagecolor(),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(h * 0.018),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: h * 0.01),

                // pizzalist(context),
                Expanded(
                  child: Container(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: productStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(child: Text("No Products Found"));
                        }

                        var products = snapshot.data!.docs;

                        return ListView.builder(
                          key: PageStorageKey("vegpizzaList"),
                          controller: _scrollController,
                          padding: EdgeInsets.only(bottom: 80),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            var data = products[index];
                            String productId = data.id;

                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(h * 0.015),
                              ),
                              elevation: 0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 🍕 TOP IMAGE
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                    child: Image.asset(
                                      "assets/images/${data["image"] ?? ""}",
                                      height: h * 0.25,
                                      width: double.infinity,
                                      fit: BoxFit.cover,

                                      errorBuilder: (context, error, stackTrace) {
                                        return Image.asset(
                                          "assets/images/noimage.jpg", // 👈 fallback image
                                          height: h * 0.25,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),

                                    child: Container(
                                      height: h * 0.079,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // LEFT TEXT SECTION
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  data["name"],
                                                  style: TextStyle(
                                                    fontSize: h * 0.019,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),

                                                Text(
                                                  data["description"],
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: h * 0.014,
                                                  ),
                                                ),
                                                SizedBox(height: h * 0.004),

                                                Text(
                                                  "₹ ${data["price"]}",
                                                  style: TextStyle(
                                                    fontSize: h * 0.020,
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          SizedBox(width: w * 0.012),

                                          // 🛒 ADD BUTTON
                                          Container(
                                            margin: EdgeInsets.only(
                                              right: h * 0.012,
                                            ),
                                            alignment: Alignment.center,
                                            child: cart.containsKey(productId)
                                                ? Row(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            if (cart[productId]! >
                                                                1) {
                                                              cart[productId] =
                                                                  cart[productId]! -
                                                                  1;
                                                            } else {
                                                              cart.remove(
                                                                productId,
                                                              );
                                                            }
                                                          });
                                                        },
                                                        child: Icon(
                                                          Icons.remove,
                                                          size: h * 0.022,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal:
                                                                  h * 0.010,
                                                            ),
                                                        child: Text(
                                                          cart[productId]
                                                              .toString(),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            cart[productId] =
                                                                cart[productId]! +
                                                                1;
                                                          });
                                                        },
                                                        child: Icon(
                                                          Icons.add,
                                                          size: h * 0.022,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: Colors
                                                          .red, // button ka background color
                                                    ),
                                                    onPressed: () {
                                                      if (!cart.containsKey(
                                                            productId,
                                                          ) &&
                                                          cart.length >= 10) {
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          const SnackBar(
                                                            content: Text(
                                                              "Only 10 different items allowed in cart",
                                                            ),
                                                          ),
                                                        );
                                                        return;
                                                      }
                                                      setState(() {
                                                        cart[productId] = 1;
                                                      });
                                                    },
                                                    child: Text(
                                                      "ADD",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: h * 0.020,
                                                      ),
                                                    ),
                                                  ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),

                SizedBox(height: h * 0.01),
                bottom(context, cart),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
