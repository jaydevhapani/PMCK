import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pmck/commonWidgets/button.dart';
import 'package:pmck/commonWidgets/textField.dart';
import 'package:pmck/network/api.dart';
import 'package:pmck/routes.dart';
import 'package:pmck/ui/create_account.dart';
import 'package:pmck/ui/forgot_password.dart';
import 'package:pmck/util/SizeConfig.dart';
import 'package:pmck/util/common_methods.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/services.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailPhone = TextEditingController();
  TextEditingController password = TextEditingController();
  final _session = Get.put(SessionService());
  String? deviceToken = null;
  bool loading = false;
  @override
  void initState() {
    super.initState();
    FirebaseService().getMessageToken().then((value) {
      if (value != null) {
        print('DeviceToken ::' + value);
        deviceToken = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xffF1F2F4),
        body: Container(
          margin: const EdgeInsets.only(left: 20.0, right: 20.0),
          width: SizeConfig.screenWidth,
          child: ListView(
            children: [
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
                "Login",
                style: TextStyle(
                    color: const Color(0xff0E0B20),
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.blockSizeVertical * 6.5,
                    fontFamily: 'Muli-Bold'),
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                      fontSize: SizeConfig.blockSizeVertical * 2.8,
                      color: const Color(0xff0E0B20),
                      height: SizeConfig.blockSizeVertical * 0.30,
                      fontFamily: 'Muli-SemiBold'),
                  children: const <TextSpan>[
                    TextSpan(
                        text: 'Please Login to your account to continue with '),
                    TextSpan(
                        text: 'HowZaT ',
                        style: TextStyle(
                          color: Color(0xffFF6C0E),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical * 3,
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Phone Number*",
                    style: TextStyle(
                        color: const Color(0xff0E0B20),
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.blockSizeVertical * 2.9,
                        fontFamily: 'Muli-SemiBold'),
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical * 1,
              ),
              CommonTextField(
                hintText: "Phone Number",
                controller: emailPhone,
                obscureText: false,
                fontSize: 2.5,
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical * 3,
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "PASSWORD*",
                    style: TextStyle(
                        color: const Color(0xff0E0B20),
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.blockSizeVertical * 2.9,
                        fontFamily: 'Muli-SemiBold'),
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical * 1,
              ),
              CommonTextField(
                hintText: "Password",
                controller: password,
                obscureText: true,
                fontSize: 2.5,
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical * 3,
              ),
              GestureDetector(
                onTap: () {
                  Get.to(() => ForgotPassword(
                        data: {"isForget": true, "emailID": emailPhone.text},
                      ));
                },
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                        color: const Color(0xff0E0B20),
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.blockSizeVertical * 2.9,
                        fontFamily: 'Muli-SemiBold'),
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical * 3,
              ),
              loading
                  ? CommonMethods().loader()
                  : CustomButton(
                      width: 150,
                      text: "LOGIN",
                      onTap: () async {
                        setState(() {
                          loading = true;
                        });

                        SharedPreferences preferences =
                            await SharedPreferences.getInstance();
                        if (emailPhone.text == "" || password.text == "") {
                          setState(() {
                            loading = false;
                          });
                          await CommonMethods().showFlushBar(
                              "Please fill the required fields", context);
                        } else {
                          try {
                            var res = await Api.login(emailPhone.text.trim(),
                                password.text.trim(), deviceToken);

                            Map valueMap = jsonDecode(res);
                            print(valueMap['status']);

                            switch (valueMap['status']) {
                              case "success":
                                setState(() {
                                  loading = false;
                                });
                                preferences.setBool("isLogin", true);
                                print('Usermap --> $valueMap');
                                preferences.setString("uuid", valueMap['uuid']);
                                await _session.init();
                                Get.offAndToNamed(Routes.ROOT);
                                break;
                              case "failed":
                                setState(() {
                                  loading = false;
                                });
                                // ignore: use_build_context_synchronously
                                CommonMethods().showFlushBar(
                                    "Phone number and Password doesn't matched",
                                    context);
                                break;
                              default:
                                print("Something went wrong");
                            }
                          } catch (e) {
                            print("error: $e");
                          }
                        }
                      },
                    ),
              SizedBox(
                height: SizeConfig.blockSizeVertical * 2,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Get.to(() => CreateAccount());
                  },
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                          fontSize: SizeConfig.blockSizeVertical * 2.9,
                          color: const Color(0xff0E0B20),
                          height: SizeConfig.blockSizeVertical * 0.18,
                          fontFamily: 'Muli-Bold'),
                      children: const <TextSpan>[
                        TextSpan(text: 'Don’t have an account? '),
                        TextSpan(
                            text: 'Register Now',
                            style: TextStyle(
                              color: Color(0xffFF6C0E),
                              decoration: TextDecoration.underline,
                            )),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
