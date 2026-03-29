import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pizoodia_customer/Pages/decortion/decortion.dart';

class Signup extends StatefulWidget {
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isHidden = true;

  Future<void> createAccount() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      User? user = userCredential.user;

      if (user != null) {
        await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
          "uid": user.uid,
          "name": nameController.text.trim(),
          "email": emailController.text.trim(),
          "address": 0.toString(),
          "mobile": 0.toString(),
          "createdAt": Timestamp.now(),
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Account created successfully")));

        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      String message = "";

      switch (e.code) {
        case 'invalid-email':
          message = "Email ka format galat hai";
          break;
        case 'email-already-in-use':
          message = "Ye email already registered hai";
          break;
        case 'weak-password':
          message = "Password bahut weak hai, kam se kam 6 characters rakho";
          break;
        default:
          message = e.message ?? "Signup failed";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Kuch galat ho gaya: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
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
          padding: EdgeInsets.all(w * 0.06),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: SizedBox()),

              Container(
                width: w,
                color: Colors.transparent,
                child: Column(
                  children: [
                    Text(
                      "Welcome to Pizodia 🍕",
                      style: TextStyle(
                        shadows: [
                          Shadow(
                            blurRadius: 15,
                            color: Color.fromARGB(255, 255, 0, 0),
                            offset: Offset(1, 1),
                          ),
                        ],
                        color: Colors.white,
                        fontSize: h * 0.030,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: h * 0.04),

                    Container(
                      width: w * 0.8,
                      child: Column(
                        children: [
                          /// NAME
                          Container(
                            width: double.infinity,

                            height: h * 0.06,

                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: h * 0.030),
                              child: TextField(
                                controller: nameController,

                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: h * 0.020,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Enter your Name",
                                  hintStyle: TextStyle(
                                    fontSize: h * 0.020,
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: h * 0.02),

                          /// EMAIL
                          Container(
                            width: double.infinity,
                            height: h * 0.06,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: h * 0.030),
                              child: TextField(
                                controller: emailController,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: h * 0.020,
                                ),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Enter your Email",
                                  hintStyle: TextStyle(
                                    fontSize: h * 0.020,
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: h * 0.02),

                          /// PASSWORD
                          Container(
                            width: double.infinity,
                            height: h * 0.06,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: h * 0.030),
                              child: TextField(
                                controller: passwordController,
                                obscureText: true,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: h * 0.020,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Create Your Own Password",
                                  hintStyle: TextStyle(
                                    fontSize: h * 0.020,
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      isHidden
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: Colors.white,
                                      size: h * 0.020,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isHidden = !isHidden;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: h * 0.035),

                          /// CREATE ACCOUNT
                          SizedBox(
                            height: h * 0.06,
                            width: w * 0.45,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 153, 2, 2),
                              ),
                              onPressed: createAccount,
                              child: Text(
                                "Create Account",
                                style: TextStyle(
                                  fontSize: h * 0.018,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 15,
                                      color: Color.fromARGB(255, 255, 0, 0),
                                      offset: Offset(1, 1),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: h * 0.02),

                          /// LOGIN OPTION
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an Account?",
                                style: TextStyle(
                                  fontSize: h * 0.017,
                                  color: Colors.white,
                                ),
                              ),

                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    fontSize: h * 0.017,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 15,
                                        color: Color.fromARGB(255, 255, 0, 0),
                                        offset: Offset(1, 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: SizedBox()),
            ],
          ),
        ),
      ),
    );
  }
}
