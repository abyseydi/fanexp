import 'package:flutter/material.dart';

// import '../screens/services/community.service.dart';

String formatDate(String date) {
  String formattedDate = date.substring(0, 10).split('-').reversed.join('/');
  return formattedDate;
}

String getFormatedDateTime(String date) {
  String time = date.split('T')[1];
  time = time.substring(0, 5);
  return time;
}

String formatTime(TimeOfDay time) {
  String formattedTime = "${time.hour}h:${time.minute}min";
  return formattedTime;
}

String? getExactTimeString(TimeOfDay? time) {
  if (time != null) {
    String timeString = "${time.hour}:${time.minute}";
    return timeString;
  }
  return null;
}

// PostService favPostService = PostService();
// List userFavPosts = [];
// dynamic getUserFavPosts() async {
//   try {
//     userFavPosts = await favPostService.getAllFavPosts();
//   } catch (e) {
//     print("USER_FAV $userFavPosts");
//     await getUserFavPosts();
//   }
// }
