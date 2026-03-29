import 'package:flutter/material.dart';
import 'package:pizoodia_customer/Pages/adminpage/Account/accounnt.dart';
import 'package:pizoodia_customer/Pages/adminpage/Cart/oders.dart';
import 'package:pizoodia_customer/Pages/adminpage/ProdectAdd/vegpizzalist.dart';
import 'package:pizoodia_customer/Pages/adminpage/history/historys.dart';

PreferredSizeWidget appname(BuildContext context) {
  final h = fontSize.height(context);
  return AppBar(
    leading: Navigator.canPop(context)
        ? IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: h * 0.027,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        : null,
    title: Center(
      child: Text(
        "Pizodia 🍕",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: h * 0.030,
        ),
      ),
    ),

    elevation: 0,
    flexibleSpace: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Colors.red, Color.fromARGB(255, 254, 184, 21)],
        ),
      ),
    ),
  );
}

BoxDecoration pagecolor() {
  return BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Colors.red, const Color.fromARGB(255, 254, 184, 21)],
    ),
  );
}

class fontSize {
  static double width(BuildContext context) =>
      MediaQuery.of(context).size.width;
  static double height(BuildContext context) =>
      MediaQuery.of(context).size.height;
}

Widget bottom(BuildContext context, Map<String, int> cart) {
  final size = MediaQuery.of(context).size;
  final h = size.height;
  final w = size.width;
  return Container(
    height: h * 0.08,
    child: Row(
      children: [
        Expanded(
          child: Container(
            color: Colors.white.withOpacity(0.15),
            child: IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => vegpizza()),
                  (Route<dynamic> route) => false,
                );
              },
              icon: Icon(Icons.home, color: Colors.white, size: h * 0.038),
            ),
          ),
        ),
        SizedBox(width: w * 0.01),
        Expanded(
          child: Container(
            color: Colors.white.withOpacity(0.15),
            child: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => cartpage(cart: cart)),
                );
              },
              icon: Icon(
                Icons.my_library_add,
                color: Colors.white,
                size: h * 0.038,
              ),
            ),
          ),
        ),
        SizedBox(width: w * 0.01),
        Expanded(
          child: Container(
            color: Colors.white.withOpacity(0.15),
            child: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Historys()),
                );
              },
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.white,
                size: h * 0.038,
              ),
            ),
          ),
        ),
        SizedBox(width: w * 0.01),
        Expanded(
          child: Container(
            color: Colors.white.withOpacity(0.15),
            child: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Account()),
                );
              },
              icon: Icon(Icons.person, color: Colors.white, size: h * 0.038),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget pizzalist(context) {
  final size = MediaQuery.of(context).size;
  final h = size.height;
  final w = size.width;
  return Container(
    height: h * 0.15,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => vegpizza()),
              );
            },

            child: Container(
              alignment: Alignment.center,

              height: h * 0.11,
              child: Image.asset("assets/images/veg.png", fit: BoxFit.cover),
            ),
          ),
        ),
        SizedBox(width: w * 0.01),
        // Expanded(
        //   child: GestureDetector(
        //     onTap: () {
        //       Navigator.pushReplacement(
        //         context,
        //         MaterialPageRoute(builder: (context) => nonvegpizza()),
        //       );
        //     },
        //     child: Container(
        //       alignment: Alignment.center,

        //       height: h * 0.11,
        //       child: Image.asset("assets/images/nonv.png", fit: BoxFit.cover),
        //     ),
        //   ),
        // ),
        // SizedBox(width: w * 0.01),
        // Expanded(
        //   child: GestureDetector(
        //     onTap: () {
        //       Navigator.pushReplacement(
        //         context,
        //         MaterialPageRoute(builder: (context) => otheritems()),
        //       );
        //     },

        //     child: Container(
        //       alignment: Alignment.center,

        //       height: h * 0.11,
        //       child: Image.asset("assets/images/other.png", fit: BoxFit.cover),
        //     ),
        //   ),
        // ),
      ],
    ),
  );
}
