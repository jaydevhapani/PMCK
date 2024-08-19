import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pmck/commonWidgets/button.dart';
import 'package:pmck/network/api.dart';
import 'package:pmck/routes.dart';
import 'package:pmck/ui/enter_code.dart';
import 'package:pmck/util/SizeConfig.dart';
import 'package:pmck/util/common_methods.dart';
import 'package:pmck/util/main_app_bar.dart';

// ignore: must_be_immutable
class ForgotPassword extends StatefulWidget {
  bool isForgot = false;
  String? emailID;
  var navId;
  @override
  Key? key;
  ForgotPassword({Key? key, data}) : super(key: key) {
    isForgot = data["isForget"];
    emailID = data["emailID"];
    if (!isForgot) {
      navId = data['navId'];
    }
  }
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailPhone = TextEditingController();
  bool loading = false;
  ScrollController scollBarController = ScrollController();
  @override
  void initState() {
    emailPhone.text = widget.emailID!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MainAppBar(
            widget.isForgot ? "Forgot Password" : "Change Password",
            false,
            widget.isForgot
                ? null
                : () => widget.navId == null
                    ? Get.back()
                    : Get.back(id: widget.navId)),
        body: SafeArea(
          bottom: false,
          child: Container(
            height: SizeConfig.screenHeight * 0.85,
            padding: const EdgeInsets.only(right: 20, left: 20),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Text(
                      "Enter your Phone Number below & we’ll send you a verification code to change your password",
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: const Color(0xff0E0B20),
                        height: SizeConfig.blockSizeVertical * 0.29,
                        fontFamily: 'Muli-SemiBold',
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 1,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal * 5),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Username*",
                          style: TextStyle(
                              color: const Color(0xff0E0B20),
                              fontWeight: FontWeight.bold,
                              fontSize: 20.sp,
                              fontFamily: 'Muli-SemiBold'),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 1,
                    ),
                    SingleChildScrollView(
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: emailPhone,
                        style: const TextStyle(
                            fontFamily: 'Muli-SemiBold',
                            color: Color(0xff0E0B20)),
                        decoration: InputDecoration(
                            hintText: "Phone Number",
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            //border: InputBorder.none,
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide:
                                    const BorderSide(color: Colors.white)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                            hintStyle: TextStyle(
                                fontFamily: 'Muli-Light',
                                fontSize: SizeConfig.blockSizeVertical * 2.5,
                                color: const Color(0xff0E0B20))),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 3,
                    ),
                    Center(
                      child: loading
                          ? CommonMethods().loader()
                          : CustomButton(
                              width: 200,
                              text: "SEND",
                              onTap: () async {
                                setState(() {
                                  loading = true;
                                });
                                if (emailPhone.text == "") {
                                  setState(() {
                                    loading = false;
                                  });
                                  CommonMethods().showFlushBar(
                                      "Please fill the required fields",
                                      context);
                                } else {
                                  try {
                                    var res = await Api.forgotPassword(
                                        emailPhone.text);

                                    print(res);
                                    print(res.runtimeType);
                                    Map valueMap = jsonDecode(res);

                                    switch (valueMap['status']) {
                                      case "success":
                                        setState(() {
                                          loading = false;
                                        });
                                        Get.to(() => EnterCode(
                                            code: valueMap['code'],
                                            uuid: valueMap['uuid'],
                                            isForgot: widget.isForgot));

                                        break;
                                      case "failed":
                                        setState(() {
                                          loading = false;
                                        });
                                        CommonMethods().showFlushBar(
                                            "Your email doesn't exist",
                                            context);
                                        break;
                                      default:
                                        print("Something went wrong");
                                    }
                                  } catch (e) {
                                    print("error: $e");
                                  }
                                }
                              }),
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 3,
                    ),
                    widget.isForgot
                        ? Align(
                            alignment: Alignment.bottomCenter,
                            child: GestureDetector(
                              onTap: () {
                                Get.toNamed(Routes.LOGIN);
                              },
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                      fontSize:
                                          SizeConfig.blockSizeVertical * 3.3,
                                      color: const Color(0xff0E0B20),
                                      height:
                                          SizeConfig.blockSizeVertical * 0.18,
                                      fontFamily: 'Muli-Bold'),
                                  children: const <TextSpan>[
                                    TextSpan(text: 'Already have an account? '),
                                    TextSpan(
                                        text: 'Login',
                                        style: TextStyle(
                                          color: Color(0xffFF6C0E),
                                          decoration: TextDecoration.underline,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 20,
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 3,
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 3,
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 3,
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 3,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
