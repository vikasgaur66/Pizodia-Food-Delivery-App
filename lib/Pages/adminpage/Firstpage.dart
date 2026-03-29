import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pizoodia_customer/Pages/decortion/decortion.dart';
import 'package:pizoodia_customer/Pages/navigators/navigators.dart';
import 'package:url_launcher/url_launcher.dart';

class FirstPages extends StatefulWidget {
  @override
  State<FirstPages> createState() => _FirstPagesState();
}

class _FirstPagesState extends State<FirstPages> {
  bool shopOpen = true;

  StreamSubscription? shopListener;

  @override
  void initState() {
    super.initState();
    checkShopStatus();

    updates();
  }

  String updatelink = "";
  String updateversion = "";

  Future<void> updates() async {
    var doc = await FirebaseFirestore.instance
        .collection("app_config")
        .doc("settings")
        .get();

    if (!doc.exists) return;

    var data = doc.data();

    if (!mounted) return;

    updatelink = data?["update_link"] ?? "";
    updateversion = data?["update_version"] ?? "";

    if (updatelink.isNotEmpty && updateversion == "1.1.1") {
      showUpdateDialog();
    }
  }

  Future<void> checkShopStatus() async {
    shopListener = FirebaseFirestore.instance
        .collection("app_config")
        .doc("settings")
        .snapshots()
        .listen((doc) {
          if (!doc.exists) return;

          var data = doc.data();

          if (!mounted) return;

          setState(() {
            shopOpen = data?["shop_open"] ?? true;
          });
        });
  }

  void showUpdateDialog() {
    final h = fontSize.height(context);
    final w = fontSize.width(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: w * 0.85,
            padding: EdgeInsets.all(h * 0.025),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "New Update Available 🚀",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: h * 0.025,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: h * 0.02),

                Text(
                  "Version: $updateversion",
                  style: TextStyle(fontSize: h * 0.020),
                ),

                SizedBox(height: h * 0.015),

                Text(
                  "Update Link:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: h * 0.018,
                  ),
                ),

                SizedBox(height: h * 0.005),

                SelectableText(
                  updatelink,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: h * 0.017),
                ),

                SizedBox(height: h * 0.025),

                SizedBox(
                  height: h * 0.05,
                  width: w * 0.35,
                  child: ElevatedButton(
                    onPressed: () async {
                      final Uri url = Uri.parse(updatelink);

                      if (await canLaunchUrl(url)) {
                        await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                      } else {
                        print("Could not open link");
                      }
                    },
                    child: Text(
                      "Update Now",
                      style: TextStyle(fontSize: h * 0.018),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Text(
                "Hey Buddy 👋 ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: h * 0.030,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: h * 0.020),

              shopOpen
                  ? Container(
                      width: w * 0.6,
                      child: TextButton(
                        onPressed: () {
                          dashNav(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Let's Eat! 🍕",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: h * 0.030,
                              ),
                            ),
                            SizedBox(width: w * 0.02), // 👈 spacing important
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: h * 0.030, // 👈 small = premium feel
                            ),
                          ],
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        Text(
                          "Kitchen is Closed 🍽️",
                          style: TextStyle(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontSize: h * 0.032,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: h * 0.020),
                        Text(
                          "अभी दुकान बंद है ",
                          style: TextStyle(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontSize: fontSize.height(context) * 0.032,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
