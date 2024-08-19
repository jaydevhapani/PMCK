import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pmck/model/advertisement_model.dart';
import 'package:pmck/model/restaurants_model.dart';
import 'package:pmck/model/specials_model.dart';
import 'package:pmck/routes.dart';
import 'package:pmck/services/storage/storage_service.dart';
import 'package:pmck/util/NavConst.dart';
import 'package:url_launcher/url_launcher.dart';

import '../network/api.dart';
import '../util/common_methods.dart';

class HomeController extends GetxController {
  var specialSelected = true.obs;
  var specialsLoading = true.obs;
  var restuarantLoading = true.obs;
  Restaurants? res = Restaurants([]).obs();
  var selectedIndex = 0.obs;
  var swiperIndex = 0.obs;
  var viewAllClicked = false.obs;
  late DateTime currentBackPressTime;
  var advertsLoading = true.obs;
  Adverts? adverts = Adverts([]).obs();
  Specials? specials = Specials([]).obs();
  int totalAd = 0;
  bool isLoading = false;
  final pagecontroller = PageController(viewportFraction: 1.0);
  StorageService _storage = Get.put(StorageService());
  late ScrollController restaurantScroll = ScrollController();

  bool onload = true;

  @override
  void onInit() async {
    specials?.specials = [];
    adverts?.adverts = [];
    res?.res = [];
    super.onInit();
    onload = false;
    await getRestaurant();
    await getSpecails();
    await advertisementData();
    currentBackPressTime = DateTime.now();

    update();
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (now.difference(currentBackPressTime) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      return Future.value(false);
    } else {
      SystemNavigator.pop();
      return Future.value(true);
    }
  }

  void launchURL(url, context) async {
    try {
      await launch(url);
    } catch (e) {
      CommonMethods().showFlushBar("Invalid URL request", context);
    }
  }

  getRestaurant() async {
    if (onload) {
      res = await _storage.getRestuarant();
      await Future.delayed(const Duration(seconds: 3), () async {
        res = await Api.getRestautantlist(newLocation: false);
      });
      update();
    } else {
      res = await Api.getRestautantlist(newLocation: true);
    }

    restuarantLoading.value = false;
    update();
  }

  getSpecails() async {
    if (onload) {
      specials = await _storage.getSpecials();
      await Future.delayed(const Duration(seconds: 3), () async {
        specials = await Api.getSpecials(newLocation: true);
      });
      update();
    } else {
      specials = await Api.getSpecials(newLocation: true);
      update();
    }
    specialsLoading.value = false;
    update();
  }

  advertisementData() async {
    if (onload) {
      adverts = await _storage.getAdverts();
      await Future.delayed(const Duration(seconds: 3), () async {
        adverts = await Api.advertisement(newLocation: false);
      });
      advertsLoading.value = false;
      update();
    } else {
      adverts = await Api.advertisement(newLocation: true);
      advertsLoading.value = false;
      update();
    }
  }

  Future gotTOProudPartners() async {
    await Get.toNamed(Routes.STOREPAGE,
        arguments: {"navId": NavConst.homeNav}, id: NavConst.homeNav);
  }
}
