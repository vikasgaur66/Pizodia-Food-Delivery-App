import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pizoodia_customer/Pages/adminpage/Cart/odderconfirm.dart';
import 'package:pizoodia_customer/Pages/decortion/decortion.dart';
import 'package:pizoodia_customer/Pages/navigators/checkstatus.dart';

class address extends StatefulWidget {
  final Map<String, int> cart;
  final double total;
  final double deliverycharge;

  const address({
    super.key,
    required this.cart,
    required this.total,
    required this.deliverycharge,
  });
  @override
  State<address> createState() => _addressState();
}

class _addressState extends State<address> {
  TextEditingController AddressController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  StreamSubscription? shopListener;

  @override
  void initState() {
    super.initState();

    ShopGuard.check(context);
    shopListener = ShopGuard.start(context);
  }

  @override
  void dispose() {
    shopListener?.cancel();
    AddressController.dispose();
    mobileController.dispose();
    super.dispose();
  }

  Future<void> addaddress(String address, String mobile) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
      "address": address,
      "mobile": mobile,
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    final h = fontSize.height(context);
    final w = fontSize.width(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appname(context),

      body: Container(
        width: w,
        decoration: pagecolor(),

        child: Padding(
          padding: EdgeInsets.all(h * 0.031),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              Expanded(child: SizedBox()),
              Container(
                width: w,
                color: Colors.transparent,
                child: Column(
                  children: [
                    Text(
                      "Confirm Your Address ",
                      style: TextStyle(
                        shadows: [
                          Shadow(
                            blurRadius: 15,
                            color: const Color.fromARGB(255, 255, 0, 0),
                            offset: Offset(1, 1),
                          ),
                        ],
                        color: Colors.white,
                        fontSize: h * 0.025,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: h * 0.04),

                    Container(
                      height: h * 0.6,
                      width: w * 0.7,
                      child: Column(
                        children: [
                          Container(
                            width: w * 1,
                            height: h * 0.06,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: h * 0.002,
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                              borderRadius: BorderRadius.circular(h * 0.031),
                            ),

                            child: Padding(
                              padding: EdgeInsets.only(left: h * 0.030),
                              child: TextField(
                                controller: AddressController,
                                textAlignVertical: TextAlignVertical.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: h * 0.020,
                                ),

                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  border: InputBorder.none,

                                  hintText: "Enter your Address ",
                                  hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: h * 0.022,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: h * 0.018),

                          Container(
                            width: w * 1,
                            height: h * 0.06,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: h * 0.002,
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                              borderRadius: BorderRadius.circular(h * 0.031),
                            ),

                            child: Padding(
                              padding: EdgeInsets.only(left: h * 0.030),
                              child: TextField(
                                controller: mobileController,
                                textAlignVertical: TextAlignVertical.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: h * 0.020,
                                ),

                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  border: InputBorder.none,

                                  hintText: "Enter your Mobile Number",
                                  hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: h * 0.022,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: h * 0.018),

                          SizedBox(height: h * 0.03),

                          Container(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  255,
                                  17,
                                  0,
                                ), // button color
                                foregroundColor: Colors.white,
                                shadowColor: Colors.black, // text color
                              ),
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                await Future.delayed(
                                  Duration(milliseconds: 300),
                                );
                                if (AddressController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Please enter Address"),
                                    ),
                                  );
                                  return;
                                }

                                if (mobileController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Please enter Mobile No."),
                                    ),
                                  );
                                  return;
                                }
                                if (mobileController.text.length != 10) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Mobile number must be 10 digits",
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                String address = AddressController.text;
                                String mobile = mobileController.text;
                                await addaddress(address, mobile);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Saved Successfully ✅"),
                                  ),
                                );
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OrderSummaryPage(
                                      cart: widget.cart,
                                      total: widget.total,
                                      address: address,
                                      mobile: mobile,
                                      deliverycharge: widget.deliverycharge,
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                "Confirm",
                                style: TextStyle(fontSize: h * 0.020),
                              ),
                            ),
                          ),
                          SizedBox(height: h * 0.025),

                          Text(
                            "⚠️ यह सेवा केवल जैतपुर क्षेत्र के अंदर ही उपलब्ध है।\nकृपया ऑर्डर करने से पहले अपना पता जांच लें।",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.yellow,
                              fontSize: h * 0.019,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
