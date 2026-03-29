import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:pizoodia_customer/Pages/adminpage/Firstpage.dart';

class ShopGuard {
  static StreamSubscription start(BuildContext context) {
    return FirebaseFirestore.instance
        .collection("app_config")
        .doc("settings")
        .snapshots()
        .listen((doc) async {
          if (!doc.exists) return;

          bool isOpen = doc.data()?["shop_open"] ?? true;

          if (!isOpen) {
            if (!context.mounted) return;

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => FirstPages()),
              (route) => false,
            );
          }
        });
  }

  static Future<void> check(BuildContext context) async {
    var doc = await FirebaseFirestore.instance
        .collection("app_config")
        .doc("settings")
        .get();

    if (!doc.exists) return;

    bool isOpen = doc.data()?["shop_open"] ?? true;

    if (!isOpen) {
      if (!context.mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => FirstPages()),
        (route) => false,
      );
    }
  }
}
