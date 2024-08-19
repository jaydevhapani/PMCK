import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pmck/commonWidgets/button.dart';
import 'package:pmck/commonWidgets/textField.dart';
import 'package:pmck/network/api.dart';
import 'package:pmck/routes.dart';
import 'package:pmck/services/firebase/firebase_service.dart';
import 'package:pmck/ui/codeverify.dart';
import 'package:pmck/ui/login.dart';
import 'package:pmck/ui/my_profile.dart';
import 'package:pmck/ui/preferred_Store.dart';
import 'package:pmck/util/NavConst.dart';
import 'package:pmck/util/SizeConfig.dart';
import 'package:pmck/util/color_gradient.dart';
import 'package:pmck/util/common_methods.dart';
import 'package:pmck/util/main_app_bar.dart';

// ignore: must_be_immutable
class CreateAccount extends StatefulWidget {
  String? uuid;
  var navId;
  CreateAccount({data}) {
    if (data != null) {
      uuid = data['uuid'];
      navId = data['navId'];
    } else {
      navId = NavConst.profile;
    }
  }

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController emailPhone = TextEditingController();
  TextEditingController dateOfBirth = TextEditingController();
  TextEditingController preferredStore = TextEditingController();
  TextEditingController createPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController cardNumber = TextEditingController();

  late bool yesNoBool = false,
      listView,
      childOptionSelect = false,
      loading = false;
  List childInfoWidget = [], childInfoList = [], childData = [], stores = [];
  bool spurCard = false;

  int totalCount = 1;
  String selectedStore = "";
  var selectedStoreId;
  List storeIdSelected = [];
  Api api = Api();

  @override
  void initState() {
    loading = true;
    super.initState();
    // getHiveData();
    print(widget.uuid);
    getUserData();
  }

  getUserData() async {
    if (widget.uuid != null) {
      await api.fetchUserDetails().then((userData) {
        if (mounted) {
          setState(() {
            firstName.text = userData.data!.name;
            lastName.text = userData.data!.lastName!;
            emailPhone.text = userData.data!.email!;
            dateOfBirth.text = userData.data!.dob;

            List prepData = userData.data!.prefStores!;
            List tempNameList = [];
            List tempIdList = [];
            for (var s in prepData) {
              tempNameList.add(s['name']);
              tempIdList.add(s['id']);
            }
            selectedStore = tempNameList.join(", ");
            selectedStoreId = tempIdList.join(", ");
            stores = tempIdList;
            preferredStore.text = selectedStore;
            List childData1 = userData.data!.childData!;
            if (childData1.isNotEmpty) {
              yesNoBool = true;
              childOptionSelect = true;
              childInfoWidget.clear();
              for (var c = 0; c < childData1.length; c++) {
                addMore();
                childData.insert(c, childInfoRow());
                childData[c].name.text = childData1[c]['name'];
                childData[c].date = childData1[c]['birth_date'];
                childData[c].dob.text = childData1[c]['birth_date'];
                childData[c].map['birth_date'] = childData1[c]['birth_date'];
                childData[c].map['name'] = childData1[c]['name'];
              }
            } else {
              yesNoBool = false;
              childOptionSelect = true;
            }

            loading = false;
          });
        }
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  getHiveData() {
    if (widget.uuid != null) {
      final userBox = Hive.box('userdata').get('data');
      final userData = userBox['data'];
      firstName.text = userData['first_name'];
      lastName.text = userData['last_name'];
      emailPhone.text = userData['email'];
      dateOfBirth.text = userData['birth_date'];

      List prepData = userData['preferred_store'];
      List tempNameList = [];
      List tempIdList = [];
      for (var s in prepData) {
        tempNameList.add(s['name']);
        tempIdList.add(s['id']);
      }

      selectedStore = tempNameList.join(", ");
      selectedStoreId = tempIdList.join(", ");
      stores = tempIdList;
      preferredStore.text = selectedStore;
      List childData1 = userData['childs'] as List;
      if (childData1.isNotEmpty) {
        yesNoBool = true;
        childOptionSelect = true;
        childInfoWidget.clear();
        for (var c = 0; c < childData1.length; c++) {
          addMore();
          childData.insert(c, childInfoRow());
          childData[c].name.text = childData1[c]['name'];
          childData[c].date = childData1[c]['birth_date'];
          childData[c].dob.text = childData1[c]['birth_date'];
          childData[c].map['birth_date'] = childData1[c]['birth_date'];
          childData[c].map['name'] = childData1[c]['name'];
        }
      } else {
        yesNoBool = false;
        childOptionSelect = true;
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MainAppBar(
            widget.uuid != null ? "Edit Information" : "Create Account",
            false,
            () => Navigator.pop(context)),
        backgroundColor: const Color(0xffF1F2F4),
        body: loading == true
            ? Center(child: CommonMethods().loader())
            : SizedBox(
                height: SizeConfig.screenHeight * 0.85,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 4,
                      ),

                      //First Name*
                      commonText("First Name*"),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 1,
                      ),
                      CommonTextField(
                        hintText: "Full Name",
                        controller: firstName,
                        obscureText: false,
                        fontSize: 2.3,
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 3,
                      ),

                      //Last Name*
                      commonText("Last Name*"),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 1,
                      ),
                      CommonTextField(
                        hintText: "Full Name",
                        controller: lastName,
                        obscureText: false,
                        fontSize: 2.3,
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 3,
                      ),

                      //Email / Phone Number*
                      widget.uuid != null
                          ? const SizedBox()
                          : commonText("Phone Number*"),
                      widget.uuid != null
                          ? const SizedBox()
                          : SizedBox(
                              height: SizeConfig.blockSizeVertical * 1,
                            ),
                      widget.uuid != null
                          ? const SizedBox()
                          : CommonTextField(
                              hintText: "Phone Number",
                              controller: emailPhone,
                              obscureText: false,
                              fontSize: 2.3,
                              keyboardType: TextInputType.number,
                              formatter: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^[0-9]+')),
                                LengthLimitingTextInputFormatter(10)
                              ],
                            ),
                      widget.uuid != null
                          ? const SizedBox()
                          : SizedBox(
                              height: SizeConfig.blockSizeVertical * 3,
                            ),

                      //Date Of Birth*
                      commonText("Date Of Birth(Optional)"),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 1,
                      ),
                      GestureDetector(
                        onTap: () {
                          CommonMethods().selectDate(context).then((value) {
                            dateOfBirth.text = value;
                          });
                        },
                        child: CommonTextField(
                          hintText: "Date Of Birth",
                          controller: dateOfBirth,
                          enabled: false,
                          obscureText: false,
                          fontSize: 2.3,
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 3,
                      ),

                      //Preferred Store*
                      commonText("Preferred Stores*"),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 1,
                      ),
                      GestureDetector(
                        onTap: () async {
                          final locList = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PreferredStore(
                                        uuid: widget.uuid,
                                      )));

                          if (locList != null) {
                            selectedStore = locList['name'].join(", ");
                            selectedStoreId = locList['id'].join(", ");

                            stores = locList['id'];
                            preferredStore.text = selectedStore;

                            setState(() {});
                          }
                        },
                        child: CommonTextField(
                          hintText: "Select your preferred store",
                          controller: preferredStore,
                          enabled: false,
                          obscureText: false,
                          fontSize: 2.3,
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 3,
                      ),

                      //Do you have a children?*
                      commonText("Do You Have Children?(Optional)"),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          yesNo(
                              text: "Yes",
                              color: yesNoBool == true && childOptionSelect
                                  ? const Color(0xffFF6C0E)
                                  : Colors.white,
                              onTab: () {
                                yesNoBool = true;
                                if (childData.isEmpty) {
                                  childData.add(
                                    childInfoRow(),
                                  );
                                }
                                childOptionSelect = true;
                              }),
                          yesNo(
                              text: "No",
                              color: yesNoBool == false && childOptionSelect
                                  ? const Color(0xffFF6C0E)
                                  : Colors.white,
                              onTab: () {
                                yesNoBool = false;
                                childOptionSelect = true;
                                childData = [];
                                setState(() {});
                              }),
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 3,
                      ),

                      //child info*
                      yesNoBool
                          ? Container(
                              child: Column(
                                children: [
                                  commonText("Child Info*"),
                                  SizedBox(
                                    height: SizeConfig.blockSizeVertical * 1,
                                  ),
                                  // childInfoRow(),
                                  SizedBox(
                                    height: 70 *
                                        (double.parse(
                                            childData.length.toString())),
                                    width: double.infinity,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: childData.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return childData[index];
                                      },
                                    ),
                                  ),

                                  InkWell(
                                    onTap: () {
                                      childData.add(
                                        childInfoRow(),
                                      );

                                      setState(() {});
                                    },
                                    child: Container(
                                      height: SizeConfig.blockSizeVertical *
                                          (SizeConfig.isDeviceLarge ? 5 : 10),
                                      width: 200,
                                      decoration: BoxDecoration(
                                          gradient: ColorGradient().gradient(),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(30))),
                                      child: Center(
                                        child: Text(
                                          "Add More",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize:
                                                  SizeConfig.blockSizeVertical *
                                                      2,
                                              fontFamily: 'Muli-Bold'),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.blockSizeVertical * 3,
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox(),
                      //

                      //Create Password*
                      widget.uuid != null
                          ? const SizedBox()
                          : commonText("Create Password*"),
                      widget.uuid != null
                          ? const SizedBox()
                          : SizedBox(
                              height: SizeConfig.blockSizeVertical * 1,
                            ),

                      widget.uuid != null
                          ? const SizedBox()
                          : CommonTextField(
                              hintText: "Password",
                              controller: createPassword,
                              obscureText: true,
                              fontSize: 2.3,
                            ),
                      widget.uuid != null
                          ? const SizedBox()
                          : SizedBox(
                              height: SizeConfig.blockSizeVertical * 3,
                            ),

                      //Confirm Password*
                      widget.uuid != null
                          ? const SizedBox()
                          : commonText("Confirm Password*"),
                      widget.uuid != null
                          ? const SizedBox()
                          : SizedBox(
                              height: SizeConfig.blockSizeVertical * 1,
                            ),
                      widget.uuid != null
                          ? const SizedBox()
                          : CommonTextField(
                              hintText: "Password",
                              controller: confirmPassword,
                              obscureText: true,
                              fontSize: 2.3,
                            ),
                      widget.uuid != null
                          ? const SizedBox()
                          : SizedBox(
                              height: SizeConfig.blockSizeVertical * 5,
                            ),

                      widget.uuid != null
                          ? loading
                              ? CommonMethods().loader()
                              : Container(
                                  margin: const EdgeInsets.all(25),
                                  child: CustomButton(
                                    width: 200,
                                    text: "SAVE",
                                    onTap: () {
                                      setState(() {
                                        loading = true;

                                        childInfoList = [];
                                        for (var item in childData) {
                                          if (item.map != null) {
                                            if (item.map['name'] == "" &&
                                                item.map['birth_date'] == "") {
                                              print("empty");
                                            } else {
                                              childInfoList.add(item.map);
                                            }
                                          }
                                        }
                                      });
                                      if (firstName.text == "" ||
                                          lastName.text == "" ||
                                          // dateOfBirth.text == "" ||
                                          stores.isEmpty) {
                                        setState(() {
                                          loading = false;
                                        });
                                        CommonMethods().showFlushBar(
                                            "Please fill all fields", context);
                                      } else {
                                        editInfoApi();
                                      }
                                    },
                                  ),
                                )
                          : loading
                              ? CommonMethods().loader()
                              : Container(
                                  margin: const EdgeInsets.all(25),
                                  child: CustomButton(
                                    width: 200,
                                    text: "REGISTER NOW",
                                    onTap: () {
                                      setState(() {
                                        loading = true;

                                        childInfoList = [];
                                        for (var item in childData) {
                                          if (item.map != null &&
                                              item.map.isNotEmpty) {
                                            if (item.map['name'] == "" &&
                                                item.map['birth_date'] == "") {
                                              print("empty");
                                            } else {
                                              childInfoList.add(item.map);
                                            }
                                          }
                                        }
                                      });

                                      if (firstName.text == "" ||
                                          lastName.text == "" ||
                                          stores.isEmpty ||
                                          emailPhone.text == "" ||
                                          createPassword.text == "") {
                                        setState(() {
                                          loading = false;
                                        });

                                        CommonMethods().showFlushBar(
                                            "Please fill all fields", context);
                                      } else {
                                        registrationApi();
                                      }
                                    },
                                  ),
                                ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 5,
                      ),
                      widget.uuid != null
                          ? Container()
                          : Container(
                              margin:
                                  const EdgeInsets.only(right: 10, left: 20),
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    Get.offAndToNamed(Routes.LOGIN);
                                  },
                                  child: RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                          fontSize:
                                              SizeConfig.blockSizeVertical *
                                                  2.9,
                                          color: const Color(0xff0E0B20),
                                          height: SizeConfig.blockSizeVertical *
                                              0.18,
                                          fontFamily: 'Muli-Bold'),
                                      children: const <TextSpan>[
                                        TextSpan(
                                            text: 'Already have an account? '),
                                        TextSpan(
                                            text: 'Login',
                                            style: TextStyle(
                                              color: Color(0xffFF6C0E),
                                              decoration:
                                                  TextDecoration.underline,
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      const SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget commonText(String text) {
    return Padding(
      padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          text,
          style: TextStyle(
              color: const Color(0xff0E0B20),
              fontWeight: FontWeight.bold,
              fontSize: SizeConfig.blockSizeVertical * 2.2,
              fontFamily: 'Muli-SemiBold'),
        ),
      ),
    );
  }

  Widget yesNo(
      {required String text, required Color color, required Function onTab}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          onTab();
        });
      },
      child: Container(
        height: SizeConfig.blockSizeVertical * 10,
        width: SizeConfig.blockSizeHorizontal * 15,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            border: Border.all(color: color, width: 5)),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
                fontFamily: 'Muli-Light', color: Color(0xff0E0B20)),
          ),
        ),
      ),
    );
  }

  void addMore() {
    setState(() {
      childInfoWidget.add(childInfoRow());
    });
  }

  registrationApi() async {
    String deviceToken = await FirebaseService().getMessageToken() ?? "";
    Map<String, dynamic> body = {
      "action": 'REGISTER_2FA',
      "first_name": firstName.text.trim(),
      "email": emailPhone.text.trim(),
      "password": createPassword.text,
      "birth_date": dateOfBirth.text.isNotEmpty ? dateOfBirth.text : "",
      "preferred_store": stores,
      "has_child": childInfoList.isEmpty ? "0" : childInfoList.length,
      "last_name": lastName.text.trim(),
      "deviceToken": deviceToken,
      // "spur_family_card_number" : spurCard == true ? cardNumber.text.trim() : null,
    };

    if (childInfoList.isNotEmpty) {
      body['child'] = childInfoList;
    } else {
      body['child'] = {};
    }
    print(body);
    var res = await Api.registration(body);

    Map valueMap = jsonDecode(res);

    if (valueMap['status'] == "success") {
      setState(() {
        loading = false;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CodeVerificationScreen(
                  eotp: valueMap["code"].toString(),
                  uid: valueMap["user_id"].toString())));
    } else if (valueMap['status'] == "failed") {
      setState(() {
        loading = false;
      });
      CommonMethods().showFlushBar(valueMap['message'][0], context);
    }
  }

  editInfoApi() async {
    Map<String, dynamic> body = {
      "action": "UPDATE_PROFILE",
      "uuid": widget.uuid,
      "first_name": firstName.text.trim(),
      "birth_date": dateOfBirth.text.isNotEmpty ? dateOfBirth.text : "",
      "preferred_store": stores,
      "has_child": childInfoList.isEmpty ? "0" : childInfoList.length,
      "last_name": lastName.text.trim(),
      // "spur_family_card_number" : spurCard == true ? cardNumber.text.trim() : null,
    };

    if (childInfoList.isNotEmpty) {
      body['child'] = childInfoList;
    } else {
      body['child'] = {};
    }

    var res = await Api.editProfile(body);
    Map valueMap = jsonDecode(res);
    if (valueMap['status'] == "success") {
      setState(() {
        loading = false;
      });
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyProfile()));
    } else if (valueMap['status'] == "failed") {
      setState(() {
        loading = false;
      });
      CommonMethods().showFlushBar(valueMap['message'][0], context);
    }
  }
}

class childInfoRow extends StatelessWidget {
  TextEditingController name = TextEditingController();
  TextEditingController dob = TextEditingController();
  String? date;
  Map<String, String> map = {};

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          width: 150.w,
          margin: const EdgeInsets.only(bottom: 10),
          child: CommonTextField(
              hintText: "Name",
              controller: name,
              enabled: true,
              obscureText: false,
              fontSize: 2,
              onChanged: () {
                map['name'] = name.text;
              }),
        ),
        Container(
          width: 150.w,
          margin: const EdgeInsets.only(bottom: 10),
          child: GestureDetector(
            onTap: () {
              CommonMethods().selectDate(context).then((value) {
                dob.text = value;
                map["birth_date"] = value;
              });
            },
            child: CommonTextField(
                hintText: "Date Of Birth",
                controller: dob,
                enabled: false,
                obscureText: false,
                fontSize: 2,
                onChanged: () {}),
          ),
        ),
      ],
    );
  }
}
