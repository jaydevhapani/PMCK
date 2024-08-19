import 'package:get/get.dart';

import '../model/news_model.dart';
import '../network/api.dart';

class NewsController extends GetxController {
  late News newsList = News([]);
  RxBool isLoading = true.obs;
  String? resId;

  @override
  Future<void> onInit() async {
    await newsData();
    super.onInit();
  }

  Future<void> newsData() async {
    newsList = await Api.newsPromotion();
    print("jo");
    print(newsList);
    filter();
    isLoading.value = false;
    update();
  }

  void filter() {
    if (resId != null) {
      var list = newsList.newsData
          .where((element) => element.restaurant == resId)
          .toList();
      newsList.newsData = list;
    }
  }

  void setRestId(String? id) {
    resId = id;
  }
}
