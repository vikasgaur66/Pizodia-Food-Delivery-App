import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pizoodia_customer/Pages/adminpage/Account/login.dart';
import 'package:pizoodia_customer/Pages/adminpage/ProdectAdd/vegpizzalist.dart';

void dashNav(BuildContext context) {
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => vegpizza()), // Jahan jaana hai
    ); // user already login
  } else {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => login()), //
    ); // login page flow
  }
}
