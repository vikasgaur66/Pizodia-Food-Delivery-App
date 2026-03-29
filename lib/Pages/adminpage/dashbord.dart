import 'package:flutter/material.dart';

import 'package:pizoodia_customer/Pages/decortion/decortion.dart';

class dashbord extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final h = size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appname(context),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: pagecolor(),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: h * 0.10),
              Container(),
              Expanded(child: SizedBox(height: h * 0.10)),

              bottom(context, {}),
            ],
          ),
        ),
      ),
    );
  }
}
