// ignore_for_file: use_build_context_synchronously

import 'package:ansvel/homeandregistratiodesign/util/appthemedata.dart';
import 'package:ansvel/referralsystem/screens/refhomepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_text_form_field/flutter_text_form_field.dart';
// import 'package:ansvel/ridewithme/themes/app_them_data.dart';
import 'package:provider/provider.dart';
import 'package:ansvel/referralsystem/enums/state.dart';
import 'package:ansvel/referralsystem/provider/ref_provider.dart';
import 'package:ansvel/referralsystem/screens/authentication/login.dart';
// import 'package:ansvel/referralsystem/screens/home_page.dart';
import 'package:ansvel/referralsystem/utils/message.dart';

class RefCodePage extends StatefulWidget {
  @override
  _RefCodePageState createState() => _RefCodePageState();
}

class _RefCodePageState extends State<RefCodePage> {
  final TextEditingController _refController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppThemeData.primary50,
        body: Consumer<RefProvider>(builder: (context, model, child) {
          return model.state == ViewState.Busy
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 143, 58, 213),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 150,
                        ),
                        Text(
                          "Enter referral code",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                        Expanded(
                          child: Container(
                              padding: const EdgeInsets.all(30.0),
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20)),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      CustomTextField(
                                        _refController,
                                        hint: 'Referal code',
                                        password: false,
                                        border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 143, 58, 213),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      //Validate User Inputs
                                      if (_refController.text.isEmpty) {
                                        showMessage(
                                            context, "All field are required");
                                      } else {
                                        await model.setReferral(
                                            _refController.text.trim());

                                        if (model.state == ViewState.Success) {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              CupertinoPageRoute(
                                                  builder: (context) =>
                                                      const RefHomePage()),
                                              (route) => false);
                                        } else {
                                          showMessage(context, model.message);
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              CupertinoPageRoute(
                                                  builder: (context) =>
                                                      const RefHomePage()),
                                              (route) => false);
                                        }
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(15.0),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 143, 58, 213),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        "Continue",
                                        style: TextStyle(color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      //Navigate to Register Page

                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  RefHomePage()),
                                          (route) => false);
                                    },
                                    child: Text(
                                      "No referral? continue instead",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),
                );
        }));
  }
}
