import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pmck/commonWidgets/button.dart';
import 'package:pmck/model/offer_model.dart';
import 'package:pmck/network/api.dart';
import 'package:pmck/routes.dart';
import 'package:pmck/util/NavConst.dart';
import 'package:pmck/util/SizeConfig.dart';
import 'package:pmck/util/common_methods.dart';
import 'package:pmck/util/main_app_bar.dart';
import 'package:pmck/util/top_part.dart';

String membershipNumber='';
class RewardsDashboard extends StatefulWidget {
  @override
  _RewardsDashboardState createState() => _RewardsDashboardState();
}

class _RewardsDashboardState extends State<RewardsDashboard> {
  // bool _isSelected1 = false, _isSelected2 = false, _isSelected = false;
  TextEditingController enterCode = TextEditingController();

  Api api = Api();
  var streamBuilder;
  late List<OffersList> allData;
  bool loading = false;
  late String firstName, lastName;

  late String uuid;
  getUSerData() async {
    var userData = await api.fetchUserDetails();
    setState(() {
      firstName = userData.data!.name;
      lastName = userData.data!.lastName!;
      uuid = userData.data!.uuid;
    });
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loading = true;
    getUSerData();
  }

  Future<bool> _onWillPop() async {
    Get.back(id: NavConst.rewardnav);
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    var one = Get.arguments ?? "";
    var bar = const MainAppBar("HowZaT", false, null);
    if (one != "") {
      bar = MainAppBar("HowZaT", false, () => Get.back());
    }
    double height = SizeConfig.screenHeight;
    double width = SizeConfig.screenWidth;
    return SafeArea(
      child: Scaffold(
        appBar: bar,
        body: ListView(
          padding: EdgeInsets.zero,
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          children: [
            loading == true
                ? Center(child: CommonMethods().loader())
                : SafeArea(
                    bottom: false,
                    child: FutureBuilder(
                      future: api.userPointInfo(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          Map valueMap = jsonDecode(snapshot.data as String);
                          
                          membershipNumber=valueMap['membership_number'];
                          print('get membership number===>>>>>$membershipNumber');
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                      width: SizeConfig.screenWidth,
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              SizeConfig.blockSizeHorizontal *
                                                  2),
                                      child: valueMap['membership_number'] !=
                                              null
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "You Have",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'Muli-SemiBold',
                                                      fontSize: SizeConfig
                                                              .blockSizeVertical *
                                                          2.2,
                                                      color: const Color(
                                                          0xffff6c0e)),
                                                ),
                                                SizedBox(
                                                  height: SizeConfig
                                                          .blockSizeVertical *
                                                      1,
                                                ),
                                                Container(
                                                  height: 3,
                                                  width: SizeConfig
                                                          .blockSizeHorizontal *
                                                      55,
                                                  color:
                                                      const Color(0xffff6c0e),
                                                ),
                                                Column(
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .baseline,
                                                      textBaseline: TextBaseline
                                                          .alphabetic,
                                                      children: [
                                                        Text(
                                                            valueMap[
                                                                'user_point'],
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Muli-Bold',
                                                              fontSize: SizeConfig
                                                                      .blockSizeVertical *
                                                                  5,
                                                            )),
                                                        SizedBox(
                                                          width: SizeConfig
                                                                  .blockSizeVertical *
                                                              1,
                                                        ),
                                                        Text(
                                                          "HowZaT POINTS",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Muli-SemiBold',
                                                              fontSize: SizeConfig
                                                                      .blockSizeVertical *
                                                                  2.2),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .baseline,
                                                      textBaseline: TextBaseline
                                                          .alphabetic,
                                                      children: [
                                                        Text(
                                                          "Membership Number -  ${valueMap['membership_number']}",
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  'Muli-SemiBold',
                                                              fontSize: 12,
                                                              color: Color(
                                                                  0xffff6c0e)),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: SizeConfig
                                                          .blockSizeVertical *
                                                      2.2,
                                                ),
                                                Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    SizedBox(
                                                      // height: height * 0.4,
                                                      width: width,
                                                      child: Image.asset(
                                                          'assets/images/LoyaltyCard.png'),
                                                    ),
                                                    Text(
                                                        "${valueMap['membership_number']}",
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'Muli-Bold')),
                                                    Positioned(
                                                      bottom: 30,
                                                      left: 32,
                                                      child: Text(
                                                          '$firstName $lastName',
                                                          style: const TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  'Muli-Bold')),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          : SizedBox(
                                              height: height * 0.5,
                                              child: Column(
                                                children: [
                                                  const Text(
                                                    'No Membership Number',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            Color(0xffFF6C0E)),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 3.0,
                                                        left: width / 6,
                                                        right: width / 6),
                                                    child: const Divider(
                                                      thickness: 3,
                                                      height: 0,
                                                      color: Color(0xffff6c0e),
                                                    ),
                                                  ),
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 20.0,
                                                        bottom: 20.0),
                                                    child: Text(
                                                      'Please create a Membership Number',
                                                      style: TextStyle(
                                                          fontSize: 18.0,
                                                          color: Color(
                                                              0xff222222)),
                                                    ),
                                                  ),
                                                  CustomButton(
                                                    width: 200.w,
                                                    text:
                                                        'Click Here to Create',
                                                    onTap: () {
                                                      Get.toNamed(
                                                          Routes.PROFILE,
                                                          arguments: {
                                                            "navId": NavConst
                                                                .rewardnav
                                                          },
                                                          id: NavConst
                                                              .rewardnav);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            )),
                                  valueMap['membership_number'] != null
                                      ? Container(
                                          padding: EdgeInsets.only(
                                              top:
                                                  SizeConfig.blockSizeVertical *
                                                      6),
                                          margin: EdgeInsets.symmetric(
                                              horizontal: SizeConfig
                                                      .blockSizeHorizontal *
                                                  4),
                                          child: CustomButton(
                                            width: 200.w,
                                            text: 'Available Vouchers',
                                            onTap: () {
                                              Get.toNamed(Routes.VOUCHERLIST,
                                                  arguments: {
                                                    "uuid": uuid,
                                                    "points":
                                                        valueMap['user_point'],
                                                    "navId": NavConst.rewardnav
                                                  },
                                                  id: NavConst.rewardnav);
                                            },
                                          ),
                                        )
                                      : Container(),
                                  valueMap['membership_number'] != null
                                      ? Container(
                                          padding: EdgeInsets.only(
                                              top:
                                                  SizeConfig.blockSizeVertical *
                                                      6),
                                          margin: EdgeInsets.symmetric(
                                              horizontal: SizeConfig
                                                      .blockSizeHorizontal *
                                                  4),
                                          child: CustomButton(
                                            width: 200.w,
                                            text: 'Transaction History',
                                            onTap: () {
                                              Get.toNamed(Routes.TRANSACTIONHISTORY,
                                                  arguments: {
                                                    "uuid": uuid,
                                                    "points":
                                                        valueMap['user_point'],
                                                    "navId": NavConst.rewardnav
                                                  },
                                                  id: NavConst.rewardnav);
                                            },
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          );
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xffFF6C0E)),
                            ),
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xffFF6C0E)),
                          ),
                        );
                      },
                    )),
          ],
        ),
      ),
    );
  }

//235656
  enterPoints() async {
    var res = await Api.getPoints(enterCode.text);
    Map valueMap = jsonDecode(res);
    print("response of points :  $valueMap");
    if (valueMap['status'] == "success") {
      setState(() {
        loading = false;
      });
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => EarnPoints()));
    } else if (valueMap['status'] == "failed") {
      setState(() {
        loading = false;
      });
      CommonMethods().showFlushBar(valueMap['message'], context);
    }
  }
}

class EarnPoints extends StatefulWidget {
  var navId = NavConst.rewardnav;
  EarnPoints({Key? key, data}) : super(key: key) {
    navId = data['navId'];
  }

  @override
  _EarnPointsState createState() => _EarnPointsState();
}

class _EarnPointsState extends State<EarnPoints> {
  Future<bool> _onWillPop() {
    Get.offAndToNamed(Routes.REWARDDASH);
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const TopPart(title: "Redeem"),
              SizedBox(
                height: height * 0.4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 30.0, right: 30.0),
                      child: Text(
                        "Thank you. You have successfully earned loyalty points",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15.0,
                            fontFamily: 'Muli-Bold',
                            fontWeight: FontWeight.bold,
                            color: Color(0xffff6c0e)),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          top: SizeConfig.blockSizeVertical * 3,
                          bottom: SizeConfig.blockSizeVertical * 1),
                      margin: EdgeInsets.symmetric(
                          horizontal: SizeConfig.blockSizeHorizontal * 4),
                      child: CustomButton(
                        text: 'Check Balance',
                        onTap: () {
                          Get.offAndToNamed(Routes.REWARDDASH);
                        },
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
