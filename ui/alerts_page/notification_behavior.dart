import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../global_members.dart';

mixin NotificationPageBehavior {
  bool isErrorUi = false;

  /*Future<List<dynamic>> getNotificationList(BuildContext context) async{

    try {
      Response<Map<String, dynamic>> response = await dio.get('', queryParameters: token);
      return await response.data!['data']['notifications'];
    } on Exception {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('server not responding, please try again', style: TextStyle(fontFamily: 'Roboto'),)));
      return const [];
    }
  }*/
}
