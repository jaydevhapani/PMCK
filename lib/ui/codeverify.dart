import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:pmck/util/SizeConfig.dart';
import 'package:pmck/util/common_methods.dart';

import '../commonWidgets/button.dart';
import '../commonWidgets/textField.dart';
import '../network/api.dart';
import '../routes.dart';

class CodeVerificationScreen extends StatefulWidget {
  @override
  CodeVerificationScreen({Key? key, required this.eotp, required this.uid});
  final String eotp, uid;
  State<CodeVerificationScreen> createState() => _CodeVerificationScreenState();
}

class _CodeVerificationScreenState extends State<CodeVerificationScreen> {
  @override
  String? otp;
  bool loader = false;
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
            backgroundColor: const Color(0xffF1F2F4),
            body: Container(
                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                width: SizeConfig.screenWidth,
                child: ListView(children: [
                  Center(
                    child: SizedBox(
                      height: SizeConfig.blockSizeVertical * 40,
                      width: SizeConfig.blockSizeHorizontal * 70,
                      child: Image.asset('assets/images/pmck_logo.png'),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 2,
                  ),
                  Text(
                    "Enter OTP",
                    style: TextStyle(
                        color: const Color(0xff0E0B20),
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.blockSizeVertical * 6.5,
                        fontFamily: 'Muli-Bold'),
                  ),
                  SizedBox(
                    height: 31,
                  ),
                  PinCodeTextField(
                    appContext: context,
                    length: 6,
                    obscureText: false,
                    obscuringCharacter: '*',
                    keyboardType: TextInputType.number,
                    autoDismissKeyboard: true,
                    enableActiveFill: true,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (value) {
                      setState(() {
                        otp = value;
                      });
                    },
                    pinTheme: PinTheme(
                      fieldHeight: 57.00,
                      fieldWidth: 45.00,
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(
                        28.00,
                      ),
                      selectedFillColor: Colors.white,
                      activeFillColor: Colors.white,
                      inactiveFillColor: Colors.white,
                      inactiveColor: Colors.white,
                      selectedColor: Colors.white,
                      activeColor: Colors.white,
                    ),
                  ),
                  loader
                      ? CommonMethods().loader()
                      : CustomButton(
                          text: "VERIFY CODE",
                          onTap: () async {
                            setState(() {
                              loader = true;
                            });
                            if (otp!.isEmpty) {
                              await CommonMethods()
                                  .showFlushBar("Please enter OTP.", context);
                            } else if (otp!.length < 6) {
                              await CommonMethods()
                                  .showFlushBar("Please 6 digit OTP.", context);
                            } else if (otp != widget.eotp) {
                              await CommonMethods()
                                  .showFlushBar("OTP is incorrect.", context);
                            } else {
                              Map<String, dynamic> body = {
                                "action": 'VERIFY_USER',
                                "user_id": int.parse(widget.uid),

                                // "spur_family_card_number" : spurCard == true ? cardNumber.text.trim() : null,
                              };

                              print(body);
                              var res = await Api.verifyOTP(body);

                              Map valueMap = jsonDecode(res);

                              if (valueMap['status'] == "success") {
                                setState(() {
                                  loader = false;
                                });
                                TextEditingController t =
                                    TextEditingController();

                                CommonMethods().enterReferal(context, t);
                              } else if (valueMap['status'] == "failed") {
                                setState(() {
                                  loader = false;
                                });
                                CommonMethods().showFlushBar(
                                    valueMap['message'][0], context);
                              }
                            }
                            setState(() {
                              loader = false;
                            });
                            // Navigator.pushNamed(context,
                            //     AppRoutes.resetPasswordScreen);
                          },
                        ),
                ]))));
  }

  onTapClose1(BuildContext context) {
    Navigator.pop(context);
  }
}
