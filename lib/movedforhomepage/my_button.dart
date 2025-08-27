// import 'dart:ffi';

// import 'package:ansvel/loginapp/src/features/core/screens/dashboard/util/agentcolors.dart';
import 'package:ansvel/movedforhomepage/agentcolors.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';

class MyButton extends StatefulWidget {
  final IconData iconButton;
  final String buttonText;
  final bool isMerchantService;
  final bool isMerchantSpecific;
  final bool isAgentSpecific;
  final Color color;
  final double borderradius;
  final void Function() onTap;
  final double height;
  final double width;

  const MyButton({
    required this.iconButton,
    required this.buttonText,
    required this.color,
    required this.borderradius,
    required this.onTap,
    required this.height,
    required this.width,
    super.key,
    this.isMerchantService = false,
    this.isMerchantSpecific = false,
    this.isAgentSpecific = false,
  });

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  String _customerType = '';
  bool isVisible = false;

  @override
  void initState() {
    super.initState();
    _loadCustomerType();
  }

  // Load customerType from SharedPreferences
  Future<void> _loadCustomerType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _customerType = (prefs.getString('customerType') ?? 'Merchant');
    });
  }

  @override
  Widget build(BuildContext context) {
    // var height = SizeConfig.getHeight(context);
    // var width = SizeConfig.getWidth(context);
    Offset distance = const Offset(4, 4);

    if (_customerType == 'Customer' && widget.isMerchantService == false) {
      isVisible = true;
    } else if (_customerType == 'Merchant' &&
        widget.isMerchantService == true) {
      if (widget.isMerchantSpecific == true) {
        isVisible = false;
      } else if (widget.isAgentSpecific == true) {
        isVisible = false;
      } else {
        isVisible = true;
      }
    } else if (_customerType == 'Merchant' &&
        widget.isMerchantService == false) {
      isVisible = true;
    } else if (_customerType == 'Agent' && widget.isMerchantService == false) {
      isVisible = true;
    } else if (_customerType == 'Agent' && widget.isMerchantService == true) {
      if (widget.isMerchantSpecific == true) {
        isVisible = false;
      } else if (widget.isAgentSpecific == true) {
        isVisible = true;
      } else {
        isVisible = true;
      }
    } else if (_customerType == 'Admin') {
      isVisible = true;
    } else if (_customerType == 'Submerchant' &&
        widget.isMerchantService == true) {
      if (widget.isMerchantSpecific == true) {
        isVisible = false;
      } else if (widget.isAgentSpecific == true) {
        isVisible = false;
      } else {
        isVisible = true;
      }
    }

    double blur = 10.0;
    return Visibility(
      visible: isVisible,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          height: widget.height,
          width: widget.width,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            // color: Colors.blueGrey[200],
            color: Colors.white,
            borderRadius: BorderRadius.circular(widget.borderradius),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade800,
                blurRadius: blur,
                offset: distance,
                spreadRadius: 1,
              ),
              BoxShadow(
                color: Colors.white,
                blurRadius: blur,
                offset: -distance,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            children: [
              SizedBox(
                height: 70,
                child: Stack(
                  children: <Widget>[
                    // Center(
                    //   child: Container(
                    //     margin: const EdgeInsets.all(1),
                    //     decoration: const BoxDecoration(
                    //         color: Colors.purpleAccent, shape: BoxShape.circle),
                    //   ),
                    // ),
                    Center(
                      child: Container(
                        height: 60,
                        margin: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            color: widget.color,
                            boxShadow: AppColors.neumorpShadow,
                            shape: BoxShape.circle),
                      ),
                    ),
                    Center(
                      child: Icon(
                        widget.iconButton,
                        size: 40,
                        color: Colors.white,
                      ),
                      // child: Icon(
                      //   icon: iconButton,

                      //   //onTap: onPressed,
                      //   color: Colors.white,
                      // ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              //text
              Text(
                widget.buttonText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    // : GestureDetector(
    //     onTap: () {},
    //     child: Container(
    //       height: widget.height,
    //       width: widget.width,
    //       padding: const EdgeInsets.all(2),
    //       decoration: BoxDecoration(
    //         // color: Colors.blueGrey[200],
    //         color: Colors.white,
    //         borderRadius: BorderRadius.circular(widget.borderradius),
    //         boxShadow: [
    //           BoxShadow(
    //             color: Colors.grey.shade800,
    //             blurRadius: blur,
    //             offset: distance,
    //             spreadRadius: 1,
    //           ),
    //           BoxShadow(
    //             color: Colors.white,
    //             blurRadius: blur,
    //             offset: -distance,
    //             spreadRadius: 1,
    //           ),
    //         ],
    //       ),
    //       child: Column(
    //         children: [
    //           SizedBox(
    //             height: 70,
    //             child: Stack(
    //               children: <Widget>[
    //                 // Center(
    //                 //   child: Container(
    //                 //     margin: const EdgeInsets.all(1),
    //                 //     decoration: const BoxDecoration(
    //                 //         color: Colors.purpleAccent, shape: BoxShape.circle),
    //                 //   ),
    //                 // ),
    //                 Center(
    //                   child: Container(
    //                     height: 60,
    //                     margin: const EdgeInsets.all(6),
    //                     decoration: BoxDecoration(
    //                         color: Colors.grey[500],
    //                         boxShadow: AppColors.neumorpShadow,
    //                         shape: BoxShape.circle),
    //                   ),
    //                 ),
    //                 Center(
    //                   child: Icon(
    //                     widget.iconButton,
    //                     size: 40,
    //                     color: Colors.white,
    //                   ),
    //                   // child: Icon(
    //                   //   icon: iconButton,

    //                   //   //onTap: onPressed,
    //                   //   color: Colors.white,
    //                   // ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //           const SizedBox(
    //             height: 5,
    //           ),
    //           //text
    //           Text(
    //             widget.buttonText,
    //             style: TextStyle(
    //               fontSize: 14,
    //               fontWeight: FontWeight.bold,
    //               color: Colors.grey[500],
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   );
  }
}
