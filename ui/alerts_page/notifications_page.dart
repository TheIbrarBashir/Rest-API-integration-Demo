import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:ugc_esports/global_members.dart';
import 'package:ugc_esports/network_connectivity_handler.dart';
import 'package:ugc_esports/ui/alerts_page/notification_behavior.dart';
import 'package:ugc_esports/ui/colors.dart';

class NotificationsToken {
  Map<String, dynamic> data;

  NotificationsToken({required this.data});
}

class NotificationsPage extends StatefulWidget {
  static const String routeName = '/notifications';

  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with NotificationPageBehavior, ConnectivityHandler {
  Future<List<dynamic>> getNotificationList(BuildContext context) async {
    try {
      setState(() {
        isErrorUi = false;
      });
      if (await checkForInternetServiceAvailability(context,
          allowSnackBar: false)) {
        setState(() {
          isErrorUi = false;
        });
        Response<Map<String, dynamic>> response = await dio.get(
            'https://www.example.com/api/notifications',
            queryParameters: token);
        return response.data is Map<String, dynamic>
            ? await response.data!['data'] is Map<String, dynamic>
                ? await response.data!['data']['notifications'] is List<dynamic>
                    ? await response.data!['data']['notifications']
                    : const []
                : const []
            : const [];
      } else {
        setState(() {
          isErrorUi = true;
        });
        return const [];
      }
    } on Exception {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
        'server not responding, please try again',
        style: TextStyle(fontFamily: 'Roboto'),
      )));
      return const [];
    }
  }

  @override
  void initState() {
    // final args = ModalRoute.of(context)!.settings.arguments as LoginToken;
    // NotificationApiClient _apiClient = Provider.of<NotificationApiClient>(context);

    if (!isNotificationListLoaded) {
      notificationList = getNotificationList(context);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: UGCColors.darkGrey,
          appBar: AppBar(
            backgroundColor: UGCColors.black,
            title: const Center(
              child: Padding(
                padding: EdgeInsets.only(right: 54.0),
                child: Image(
                  height: 25,
                  image: AssetImage('assets/images/ugc_navigation_logo.png'),
                ),
              ),
            ),
          ),
          body: isErrorUi
              ? Center(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Flexible(
                          flex: 8,
                          fit: FlexFit.tight,
                          child: Center(
                            child: Image(
                              image:
                                  AssetImage('assets/images/no_internet.png'),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          fit: FlexFit.tight,
                          child: Center(
                            child: OutlinedButton(
                              onPressed: () {
                                notificationList = getNotificationList(context);
                              },
                              child: const Text('try again'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : FutureBuilder<List<dynamic>>(
                  future: notificationList,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(
                        color: UGCColors.green,
                      ));
                    } else if (snapshot.hasData) {
                      isNotificationListLoaded = true;
                      if (snapshot.data!.isNotEmpty) {
                        List<dynamic> _notifications =
                            snapshot.data!.reversed.toList();
                        return RawScrollbar(
                          isAlwaysShown: false,
                          thumbColor: UGCColors.green,
                          interactive: true,
                          thickness: 3,
                          radius: const Radius.circular(20.0),
                          child: Container(
                            color: UGCColors.darkGrey,
                            child: ListView.separated(
                              dragStartBehavior: DragStartBehavior.down,
                              physics: const BouncingScrollPhysics(),
                              itemCount: _notifications.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: Material(
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    color: UGCColors.green,
                                    borderOnForeground: true,
                                    child: Container(
                                      width: 50.0,
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.blue,
                                            width: 0.1,
                                            style: BorderStyle.solid),
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.gamepad,
                                          color: UGCColors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    '${_notifications[index]['message']}',
                                    style: const TextStyle(
                                        fontFamily: 'eurostile',
                                        color: Color(0xffbababa),
                                        letterSpacing: 0.5,
                                        fontSize: 13.0),
                                  ),
                                  subtitle: Text(
                                    GetTimeAgo.parse(
                                        DateTime.parse(_notifications[index]
                                            ['created_at']),
                                        pattern: "dd-MM-yyyy hh:mm:aa"),
                                    style: const TextStyle(
                                        fontFamily: 'eurostile',
                                        color: Color(0xff474e58),
                                        letterSpacing: .5,
                                        fontSize: 15.0),
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const Divider(
                                  color: Color(0xff424242),
                                  endIndent: 15.0,
                                  indent: 15.0,
                                );
                              },
                            ),
                          ),
                        );
                      } else {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Flexible(
                                flex: 8,
                                fit: FlexFit.tight,
                                child: Center(
                                  child: Image(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                        'assets/images/no_notifications.png'),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 2,
                                fit: FlexFit.tight,
                                child: Text(
                                  'no notifications found',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16.0),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    } else {
                      return const Text(
                        'something went wrong',
                        style: TextStyle(color: Colors.white),
                      );
                    }
                  },
                )),
    );
  }
}
