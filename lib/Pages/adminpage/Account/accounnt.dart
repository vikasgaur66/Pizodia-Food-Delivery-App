import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:pizoodia_customer/Pages/adminpage/history/historys.dart';
import 'package:pizoodia_customer/Pages/adminpage/Account/login.dart';
import 'package:pizoodia_customer/Pages/decortion/decortion.dart';
import 'package:pizoodia_customer/Pages/navigators/checkstatus.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  String name = "";
  String email = "";
  String deliveryPhone = "";
  StreamSubscription? shopListener;

  @override
  void initState() {
    super.initState();
    ShopGuard.check(context);
    shopListener = ShopGuard.start(context);
    loadUser();
    loadSettings();
  }

  Future<void> loadSettings() async {
    var doc = await FirebaseFirestore.instance
        .collection("app_config")
        .doc("settings")
        .get();

    setState(() {
      deliveryPhone = doc["phone"];
    });
  }

  /// LOAD USER DATA FROM FIREBASE
  Future<void> loadUser() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      setState(() {
        name = doc["name"] ?? "";
        email = doc["email"] ?? "";
      });
    }
  }

  /// EDIT NAME / EMAIL
  void showEditDialog() {
    TextEditingController nameController = TextEditingController(text: name);

    TextEditingController emailController = TextEditingController(text: email);

    showDialog(
      context: context,
      builder: (context) {
        final h = fontSize.height(context);

        return AlertDialog(
          title: const Text("Update Profile"),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Name"),
                ),

                SizedBox(height: 20),

                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text("Cancel", style: TextStyle(fontSize: h * 0.02)),
              onPressed: () {
                FocusScope.of(context).unfocus();
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text("Save", style: TextStyle(fontSize: h * 0.02)),
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;

                await FirebaseFirestore.instance
                    .collection("users")
                    .doc(user!.uid)
                    .update({
                      "name": nameController.text,
                      "email": emailController.text,
                    });

                setState(() {
                  name = nameController.text;
                  email = emailController.text;
                });

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  /// SEND FEEDBACK
  void sendFeedback() {
    TextEditingController feedback = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        final h = fontSize.height(context);

        return AlertDialog(
          title: const Text("Send Feedback"),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            child: TextField(
              controller: feedback,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: "Write your feedback",
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text("Cancel", style: TextStyle(fontSize: h * 0.02)),
              onPressed: () {
                FocusScope.of(context).unfocus();
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text("Send", style: TextStyle(fontSize: h * 0.02)),
              onPressed: () async {
                FocusScope.of(context).unfocus();
                await FirebaseFirestore.instance.collection("feedback").add({
                  "message": feedback.text,
                  "email": FirebaseAuth.instance.currentUser?.email,
                  "uid": FirebaseAuth.instance.currentUser?.uid,
                  "time": Timestamp.now(),
                });

                Navigator.pop(context);

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text("Feedback Sent")));
              },
            ),
          ],
        );
      },
    );
  }

  void About() {
    showDialog(
      context: context,
      builder: (context) {
        final h = fontSize.height(context);

        return AlertDialog(
          title: const Text("About Pizodia 🍕"),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            child: SingleChildScrollView(
              child: Text(
                '''
Pizodia is a simple local delivery service that helps
people order products easily from nearby shops.
          
Instead of going to the shop, you can order through
the app and get your items delivered to your home.
          
🚴 How it works
          
• You select items from the app
• Order is placed to the shop
• Delivery partner picks the items
• Items are delivered to your home
          
💰 Delivery Charge
A small delivery charge is added to support
the delivery service.
          
Our goal is to make local shopping faster,
easier and more convenient for everyone.
          
Thank you for supporting local businesses ❤️
              ''',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: h * 0.017),
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void Contect() {
    showDialog(
      context: context,
      builder: (context) {
        final h = fontSize.height(context);
        return AlertDialog(
          title: const Text("Contact Details"),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            child: SingleChildScrollView(
              child: Text(
                '''
📞 Delivery Support
          
If you have any issue with your order or delivery,
you can contact with our delivery partner.
          
🚴 Delivery Boy
Phone: $deliveryPhone
          
⏰ Delivery Time
Usually 20–30 minutes depends on distance.
          
────────────────────
          
🛠 App Support
          
For app related problems, feedback, or suggestions
you can contact the developer.
          
👨‍💻 App Developer
Vikas Gaur
Email: vk872117@gmail.com
Contact: 9793464866
          
Thank you for using our service ❤️
              ''',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: h * 0.017),
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
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
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(h * 0.018),
            child: Column(
              children: [
                /// USER INFO
                Container(
                  padding: EdgeInsets.all(h * 0.018),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(h * 0.018),
                    color: Colors.white.withOpacity(0.1),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: Colors.white,
                            size: h * 0.03,
                          ),
                          SizedBox(width: w * 0.012),
                          Expanded(
                            child: Text(
                              name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: h * 0.018,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: h * 0.012),
                      Row(
                        children: [
                          Icon(
                            Icons.email,
                            color: Colors.white,
                            size: h * 0.03,
                          ),
                          SizedBox(width: w * 0.012),
                          Expanded(
                            child: Text(
                              email,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: h * 0.018,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: h * 0.025),

                /// EDIT PROFILE
                ListTile(
                  leading: Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: h * 0.03,
                  ),
                  title: Text(
                    "Edit Name / Email",
                    style: TextStyle(color: Colors.white, fontSize: h * 0.018),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: h * 0.03,
                  ),
                  onTap: showEditDialog,
                ),

                /// ORDER HISTORY
                ListTile(
                  leading: Icon(
                    Icons.history,
                    color: Colors.white,
                    size: h * 0.03,
                  ),
                  title: Text(
                    "My Orders",
                    style: TextStyle(color: Colors.white, fontSize: h * 0.018),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: h * 0.03,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Historys()),
                    );
                  },
                ),

                /// CONTACT SHOP
                ListTile(
                  leading: Icon(
                    Icons.phone,
                    color: Colors.white,
                    size: h * 0.03,
                  ),
                  title: Text(
                    "Contact Details",
                    style: TextStyle(color: Colors.white, fontSize: h * 0.018),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: h * 0.03,
                  ),
                  onTap: Contect,
                ),

                /// ABOUT SHOP
                ListTile(
                  leading: Icon(
                    Icons.info,
                    color: Colors.white,
                    size: h * 0.03,
                  ),
                  title: Text(
                    "About App",
                    style: TextStyle(color: Colors.white, fontSize: h * 0.018),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: h * 0.03,
                  ),
                  onTap: About,
                ),

                /// FEEDBACK
                ListTile(
                  leading: Icon(
                    Icons.feedback,
                    color: Colors.white,
                    size: h * 0.03,
                  ),
                  title: Text(
                    "Send Feedback",
                    style: TextStyle(color: Colors.white, fontSize: h * 0.018),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: h * 0.03,
                  ),
                  onTap: sendFeedback,
                ),

                const Spacer(),

                /// LOGOUT
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  icon: Icon(Icons.logout, size: h * 0.025),
                  label: Text("Logout", style: TextStyle(fontSize: h * 0.02)),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => login()),
                    );
                  },
                ),

                SizedBox(height: h * 0.012),

                bottom(context, {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
