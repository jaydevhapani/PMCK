import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pmck/commonWidgets/button.dart';
import 'package:pmck/network/api.dart';
import 'package:pmck/routes.dart';
import 'package:pmck/ui/newsController.dart';
import 'package:pmck/util/NavConst.dart';
import 'package:pmck/util/SizeConfig.dart';
import 'package:pmck/util/common_methods.dart';
import 'package:pmck/util/main_app_bar.dart';

class NewsPage extends StatelessWidget {
  var _navID = NavConst.notifyNav;
  String? res;

  get navID => _navID;

  set navID(navID) {
    _navID = navID;
  }

  NewsPage({Key? key, data}) : super(key: key) {
    _navID = NavConst.notifyNav;
    if (data != null) {
      _navID = data['navId'] ?? NavConst.notifyNav;
      res = data['res'];
      cont.setRestId(res);
    }
  }
  var newsList;
  bool isLoading = false;
  NewsController cont = Get.put(NewsController());

  Widget newsWidget(String title, String heading, String image, String id,
      Image? icon, var navID) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Container(
                height: SizeConfig.screenHeight * 0.22,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  // color: Colors.red[300],
                ),
                child: SizedBox(
                  width: SizeConfig.screenWidth / 2,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: icon ??
                          Image.network(
                            image,
                            fit: BoxFit.contain,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return Center(child: CommonMethods().loader());
                              }
                            },
                          )),
                ),
                // child: Center(child: Text('Image', style: TextStyle(color: Colors.white),),),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, bottom: 8.0, left: 5.0, right: 5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      heading,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical),
          child: CustomButton(
            text: 'Details',
            onTap: () {
              Get.toNamed(Routes.NEWSDETAIL,
                  arguments: {"id": id, "navId": navID}, id: navID);

              // Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var one = Get.arguments ?? "";

    var bar =
        MainAppBar('News & Promotions', false, () => Get.back(id: _navID));
    if (one != "") {
      bar = MainAppBar("News & Promotions", false, () => Get.back());
    }
    return GetBuilder<NewsController>(
        init: cont,
        builder: (index) => SafeArea(
              child: Scaffold(
                appBar: bar,
                body: cont.isLoading.value
                    ? Center(child: CommonMethods().loader())
                    : ListView(
                        shrinkWrap: true,
                        children: [
                          SafeArea(
                            bottom: false,
                            child: SingleChildScrollView(
                              child: Center(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0, right: 20.0),
                                      child: Container(
                                        height: SizeConfig.screenHeight * 0.90,
                                        width: SizeConfig.screenWidth,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: ListView.builder(
                                          itemCount:
                                              cont.newsList.newsData.length,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 20.0),
                                                child: newsWidget(
                                                    cont.newsList
                                                        .newsData[index].title,
                                                    cont
                                                        .newsList
                                                        .newsData[index]
                                                        .heading,
                                                    cont.newsList
                                                        .newsData[index].image,
                                                    cont.newsList
                                                        .newsData[index].id,
                                                    cont.newsList
                                                        .newsData[index].icon,
                                                    _navID));
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ));
  }
}

class NewsDetails extends StatefulWidget {
  String? id;
  var navId;
  NewsDetails({Key? key, data}) : super(key: key) {
    if (data != null && data != "") {
      id = data['id'] ?? "";
      navId = data['navId'] ?? NavConst.notifyNav;
    } else {
      navId = NavConst.notifyNav;
    }
  }
  @override
  _NewsDetailsState createState() => _NewsDetailsState();
}

class _NewsDetailsState extends State<NewsDetails> {
  late bool isLoading;
  var newsList;
  String? image, title, heading, expiryDate, restaurantID, details;
  @override
  void initState() {
    isLoading = true;
    newsData();
    super.initState();
  }

  newsData() async {
    newsList = await Api.newsPromotion();
    for (int i = 0; i < newsList.newsData.length; i++) {
      if (newsList.newsData[i].id == widget.id) {
        setState(() {
          image = newsList.newsData[i].image;
          title = newsList.newsData[i].title;
          heading = newsList.newsData[i].heading;
          expiryDate = newsList.newsData[i].expiryDate;
          restaurantID = newsList.newsData[i].restaurant;
          details = newsList.newsData[i].details;
        });
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
          'Promotions Details', false, () => Get.back(id: widget.navId)),
      backgroundColor: const Color(0xfff1f2f4),
      body: isLoading == true
          ? Center(child: CommonMethods().loader())
          : SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.white,
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: SizeConfig.screenHeight * 0.22,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      // color: Colors.red[300],
                                    ),
                                    child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10.0),
                                          child: image != null
                                              ? Image.network(
                                                  image!,
                                                  fit: BoxFit.contain,
                                                  loadingBuilder:
                                                      (BuildContext context,
                                                          Widget child,
                                                          ImageChunkEvent?
                                                              loadingProgress) {
                                                    if (loadingProgress ==
                                                        null) {
                                                      return child;
                                                    } else {
                                                      return Center(
                                                          child: CommonMethods()
                                                              .loader());
                                                    }
                                                  },
                                                )
                                              : Center(
                                                  child:
                                                      CommonMethods().loader()),
                                        )),
                                    // child: Center(child: Text('Image', style: TextStyle(color: Colors.white),),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15.0, bottom: 15.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          title!,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(heading!,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 20.0,
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: Text(expiryDate!,
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.5),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, bottom: 10.0),
                              child: Container(
                                height: SizeConfig.screenHeight * 0.25,
                                width: SizeConfig.screenWidth,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      details!,
                                      textAlign: TextAlign.justify,
                                      style: const TextStyle(
                                          fontFamily: 'Muli-Bold',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            CustomButton(
                              text: 'View Restaurant',
                              onTap: () {
                                Get.toNamed(Routes.RESTAURANTDETAILS,
                                    arguments: {
                                      'id': restaurantID,
                                      "navId": widget.navId
                                    },
                                    id: widget.navId);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
