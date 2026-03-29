import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pizoodia_customer/Pages/adminpage/Account/signin.dart';
import 'package:pizoodia_customer/Pages/adminpage/ProdectAdd/vegpizzalist.dart';
import 'package:pizoodia_customer/Pages/decortion/decortion.dart';

class login extends StatefulWidget {
  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isHidden = true;

  bool isLoading = false;

  Future<void> loginUser() async {
    FocusScope.of(context).unfocus();

    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Email aur Password dono bharo")));
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      await Future.delayed(Duration(milliseconds: 300));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => vegpizza()),
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login successful")));
    } on FirebaseAuthException catch (e) {
      String message = "";

      switch (e.code) {
        case 'invalid-email':
          message = "Email format galat hai";
          break;

        case 'invalid-credential':
          message = "Email ya Password galat hai";
          break;

        case 'user-not-found':
          message = "User exist nahi karta";
          break;
        case 'wrong-password':
          message = "Password galat hai";
          break;
        case 'user-disabled':
          message = "Account disabled hai";
          break;
        default:
          message = e.message ?? "Login failed";
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
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> resetPassword(String email) async {
    if (email.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please enter your email")));
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password reset link sent to $email")),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Failed to send reset link")),
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
        height: double.infinity,
        width: double.infinity,
        decoration: pagecolor(),
        child: Padding(
          padding: EdgeInsets.all(w * 0.06),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: w * 0.8,
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

                    SizedBox(height: h * 0.06),

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
                              color: Colors.white.withOpacity(0.5),
                              fontSize: h * 0.020,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: h * 0.025),

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
                          obscureText: isHidden,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: h * 0.020,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,

                            hintText: "Enter your Password",
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: h * 0.020,
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

                    SizedBox(height: h * 0.03),

                    /// LOGIN BUTTON
                    SizedBox(
                      width: w * 0.35,
                      height: h * 0.055,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 153, 2, 2),
                        ),
                        onPressed: isLoading ? null : loginUser,

                        child: isLoading
                            ? SizedBox(
                                height: h * 0.025,
                                width: h * 0.025,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: h * 0.018,
                                ),
                              ),
                      ),
                    ),

                    SizedBox(height: h * 0.015),

                    /// FORGET PASSWORD
                    TextButton(
                      onPressed: () {
                        resetPassword(emailController.text);
                      },
                      child: Text(
                        "Forget Password",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: h * 0.017,
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

                    SizedBox(height: h * 0.01),

                    /// REGISTER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an Account?",
                          style: TextStyle(
                            fontSize: h * 0.017,
                            color: Colors.white,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Signup()),
                            );
                          },
                          child: Text(
                            "Register Now",
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
                    SizedBox(height: h * 0.050),
                    Container(
                      width: w * 0.7,
                      child: Text(
                        '''⚠️ पहली बार उपयोग कर रहे हैं? पहले रजिस्टर करें, फिर उसी अकाउंट से लॉगिन करें।
                    ''',
                        style: TextStyle(
                          fontSize: h * 0.018,
                          color: Colors.white,
                        ),
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
