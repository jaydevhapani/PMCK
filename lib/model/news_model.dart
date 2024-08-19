import 'package:flutter/material.dart';

import '../util/common_methods.dart';

class News {
  late List<NewsList> newsData = [];
  News(data) {
    newsData = [];
  }

  News.fromJson(Map<String, dynamic> json) {
    List newsList = json['data'] as List;

    newsData = newsList.map((item) => NewsList.fromJson(item)).toList();

    print("Notifications List");
    print(newsList);
    // print(notifications);
  }
}

class NewsList {
  late String id;
  late String title;
  late String heading;
  late String image;
  late String expiryDate;
  late String restaurant;
  late String details;
  Image? icon;

  NewsList(
      {required this.id,
      required this.title,
      required this.heading,
      required this.expiryDate,
      required this.restaurant,
      required this.image,
      required this.details});

  NewsList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    heading = json['heading'];
    expiryDate = json['expiry_date'];
    restaurant = json['restaurant'];
    image = json['image'] ?? "";
    details = json['details'];
    icon = Image.network(image, fit: BoxFit.contain, loadingBuilder:
        (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
      if (loadingProgress == null) {
        return child;
      } else {
        return Center(child: CommonMethods().loader());
      }
    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['title'] = title;
    data['heading'] = heading;
    data['expiry_date'] = expiryDate;
    data['restaurant'] = restaurant;
    data['image'] = image;
    data['details'] = details;

    return data;
  }
}
