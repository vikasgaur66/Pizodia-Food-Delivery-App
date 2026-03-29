// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:pizoodia_customer/Pages/adminpage/Cart/oders.dart';

// import 'package:pizoodia_customer/Pages/decortion/decortion.dart';

// class otheritems extends StatelessWidget {
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
//               pizzalist(context),

//               Expanded(
//                 child: Stack(
//                   children: [
//                     Container(
//                       child: StreamBuilder<QuerySnapshot>(
//                         stream: FirebaseFirestore.instance
//                             .collection("products")
//                             .where("category", isEqualTo: "Other")
//                             .orderBy("createdAt", descending: true)
//                             .snapshots(),
//                         builder: (context, snapshot) {
//                           if (snapshot.connectionState ==
//                               ConnectionState.waiting) {
//                             return const Center(
//                               child: CircularProgressIndicator(),
//                             );
//                           }

//                           if (!snapshot.hasData ||
//                               snapshot.data!.docs.isEmpty) {
//                             return const Center(
//                               child: Text("No Products Found"),
//                             );
//                           }

//                           var products = snapshot.data!.docs;

//                           return ListView.builder(
//                             itemCount: products.length,
//                             itemBuilder: (context, index) {
//                               var data = products[index];
//                               String id = data.id;

//                               return Card(
//                                 margin: const EdgeInsets.all(0),
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Row(
//                                     children: [
//                                       // 🍕 LEFT IMAGE
//                                       ClipRRect(
//                                         borderRadius: BorderRadius.circular(10),
//                                         child: Image.asset(
//                                           "assets/images/other.png", // image url from firebase
//                                           width: 90,
//                                           height: 90,
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),

//                                       const SizedBox(width: 10),

//                                       // RIGHT SIDE DETAILS
//                                       Expanded(
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             // Pizza Name
//                                             Text(
//                                               data["name"],
//                                               style: const TextStyle(
//                                                 fontSize: 16,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),

//                                             const SizedBox(height: 4),

//                                             // Price
//                                             Text(
//                                               "₹ ${data["price"]}",
//                                               style: const TextStyle(
//                                                 fontSize: 15,
//                                                 color: Colors.green,
//                                                 fontWeight: FontWeight.w600,
//                                               ),
//                                             ),

//                                             const SizedBox(height: 4),

//                                             // Description
//                                             Text(
//                                               data["description"],
//                                               maxLines: 2,
//                                               overflow: TextOverflow.ellipsis,
//                                               style: const TextStyle(
//                                                 fontSize: 13,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),

//                                       // 🛒 ADD TO CART BUTTON
//                                       Container(
//                                         width: 112,
//                                         child: Column(
//                                           children: [
//                                             IconButton(
//                                               icon: const Icon(
//                                                 Icons.favorite_border,
//                                               ),
//                                               color: Colors.red,
//                                               onPressed: () {
//                                                 // add to cart logic
//                                               },
//                                             ),
//                                             Row(
//                                               children: [
//                                                 IconButton(
//                                                   icon: const Icon(
//                                                     Icons.add_shopping_cart,
//                                                   ),

//                                                   color: Colors.orange,
//                                                   onPressed: () {
//                                                     // add to cart logic
//                                                   },
//                                                 ),
//                                                 TextButton(
//                                                   onPressed: () {
//                                                     Navigator.pushReplacement(
//                                                       context,
//                                                       MaterialPageRoute(
//                                                         builder: (context) =>
//                                                             cart(),
//                                                       ),
//                                                     );
//                                                   },
//                                                   child: Text("Buy"),
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             },
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               SizedBox(height: h * 0.01),
//               bottom(context),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
