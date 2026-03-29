import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:pizoodia_customer/Pages/decortion/decortion.dart';
import 'package:pizoodia_customer/Pages/navigators/checkstatus.dart';

class Historys extends StatefulWidget {
  @override
  State<Historys> createState() => _HistorysState();
}

class _HistorysState extends State<Historys> {
  StreamSubscription? shopListener;

  @override
  void initState() {
    super.initState();

    ShopGuard.check(context);
    shopListener = ShopGuard.start(context);
  }

  Widget buildStatus(String status) {
    final h = fontSize.height(context);
    final w = fontSize.width(context);
    if (status == "pending") {
      return Row(
        children: [
          Text(
            "Status: Pending",
            style: TextStyle(
              color: Colors.red,
              fontSize: h * 0.020,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: w * 0.006),
          Icon(Icons.access_time, color: Colors.red),
        ],
      );
    } else if (status == "confirmed") {
      return Row(
        children: [
          Text(
            "Status: Confirmed",
            style: TextStyle(
              color: Colors.orange,
              fontSize: h * 0.020,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: w * 0.006),
          Icon(Icons.assignment_turned_in, color: Colors.orange),
        ],
      );
    } else if (status == "delivered") {
      return Row(
        children: [
          Text(
            "Status: Delivered",
            style: TextStyle(
              color: Colors.green,
              fontSize: h * 0.020,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: w * 0.006),
          Icon(Icons.check_circle, color: Colors.green),
        ],
      );
    } else if (status == "cancelled") {
      return Row(
        children: [
          Text(
            "Status: Cancelled",
            style: TextStyle(
              color: Colors.red,
              fontSize: h * 0.020,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: w * 0.006),
          Icon(Icons.cancel, color: Colors.red),
        ],
      );
    } else if (status == "on_the_way") {
      return Row(
        children: [
          Text(
            "Status: On The Way ",
            style: TextStyle(
              color: Colors.orange,
              fontSize: h * 0.020,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: w * 0.006),
          Icon(Icons.local_shipping, color: Colors.orange),
        ],
      );
    } else {
      return Text(status);
    }
  }

  @override
  void dispose() {
    shopListener?.cancel();

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

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: h * 0.01),

                // pizzalist(context),
                Expanded(
                  child: Container(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("orders")
                          .where(
                            "userId",
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid,
                          )
                          .orderBy("time", descending: true)
                          .snapshots(),
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

                        var orders = snapshot.data!.docs;

                        return ListView.builder(
                          padding: EdgeInsets.only(bottom: 80),
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            var data =
                                orders[index].data() as Map<String, dynamic>;
                            Map<String, dynamic> items =
                                Map<String, dynamic>.from(data["items"] ?? {});

                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                              child: Container(
                                padding: EdgeInsets.all(h * 0.012),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        buildStatus(data["status"] ?? ""),
                                      ],
                                    ),
                                    SizedBox(height: h * 0.010),
                                    Text(
                                      "Total: ₹ ${data["total"]}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: h * 0.025,
                                        color: Color.fromARGB(255, 3, 112, 34),
                                      ),
                                    ),
                                    Text(
                                      "Mobile: ${data["mobile"]}",
                                      style: TextStyle(fontSize: h * 0.016),
                                    ),
                                    Text(
                                      "Address: ${data["address"]}",
                                      style: TextStyle(fontSize: h * 0.016),
                                    ),

                                    SizedBox(height: h * 0.006),
                                    Divider(
                                      color: const Color.fromARGB(
                                        255,
                                        215,
                                        215,
                                        215,
                                      ),
                                      thickness: 1,
                                      height: h * 0.025,
                                    ),

                                    Text(
                                      "Items:",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: h * 0.016,
                                      ),
                                    ),

                                    ...items.entries.map((e) {
                                      if (e.value is Map) {
                                        var item = Map<String, dynamic>.from(
                                          e.value,
                                        );

                                        return Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  item["name"] ?? "",
                                                  style: TextStyle(
                                                    fontSize: h * 0.016,
                                                  ),
                                                ),
                                                Expanded(child: SizedBox()),
                                                Text(
                                                  "Qty ${item["quantity"]}",
                                                  style: TextStyle(
                                                    fontSize: h * 0.016,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                      } else {
                                        return Text(
                                          "${e.key}  x${e.value}",
                                          style: TextStyle(fontSize: h * 0.016),
                                        );
                                      }
                                    }).toList(),
                                    SizedBox(height: h * 0.012),
                                    data["status"] == "cancelled" ||
                                            data["status"] == "delivered" ||
                                            data["status"] == "on_the_way"
                                        ? Center(
                                            child: Text(
                                              "Thanku for Order 😊",
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                                fontSize: h * 0.018,
                                              ),
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,

                                            children: [
                                              Container(
                                                width: w * 0.2,
                                                height: h * 0.05,
                                                child: TextButton(
                                                  style: TextButton.styleFrom(),
                                                  onPressed: () async {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection("orders")
                                                        .doc(orders[index].id)
                                                        .update({
                                                          "status": "cancelled",
                                                        });

                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                          "Order Cancelled ❌",
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: h * 0.015,
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              Text(
                                                "Thanku for Order 😊",
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                    255,
                                                    255,
                                                    119,
                                                    7,
                                                  ),

                                                  fontSize: h * 0.016,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),

                SizedBox(height: h * 0.01),
                bottom(context, {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:pizoodia_customer/Pages/decortion/decortion.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class Historys extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final h = size.height;

//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: appname(),
//       body: Container(
//         height: double.infinity,
//         width: double.infinity,
//         decoration: pagecolor(),
//         child: Padding(
//           padding: const EdgeInsets.all(15.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SizedBox(height: h * 0.10),
//               Expanded(
//                 child: Container(
//                   child: StreamBuilder<QuerySnapshot>(
//                     stream: FirebaseFirestore.instance
//                         .collection("orders")
//                         .where(
//                           "userId",
//                           isEqualTo: FirebaseAuth.instance.currentUser!.uid,
//                         )
//                         .orderBy("time", descending: true)
//                         .snapshots(),
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return const Center(child: CircularProgressIndicator());
//                       }

//                       if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                         return const Center(child: Text("No Orders Found"));
//                       }

//                       var orders = snapshot.data!.docs;

//                       return ListView.builder(
//                         itemCount: orders.length,
//                         itemBuilder: (context, index) {
//                           var data =
//                               orders[index].data() as Map<String, dynamic>;

//                           Map items = data["items"];

//                           return Card(
//                             margin: const EdgeInsets.symmetric(vertical: 8),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(12),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     "Total: ₹ ${data["total"]}",
//                                     style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),

//                                   Text("Status: ${data["status"]}"),
//                                   Text("Mobile: ${data["mobile"]}"),
//                                   Text("Address: ${data["address"]}"),

//                                   const SizedBox(height: 8),

//                                   const Text(
//                                     "Items:",
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),

//                                   ...items.entries.map<Widget>((item) {
//                                     return Text("${item.key}  x ${item.value}");
//                                   }).toList(),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               ),

//               bottom(context, {}),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
