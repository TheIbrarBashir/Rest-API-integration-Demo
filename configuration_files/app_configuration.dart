import 'package:flutter/material.dart';
import 'package:ugc_esports/ui/chat_page/chat_detail_page/chat_detail_page.dart';
import 'package:ugc_esports/ui/home_page/home_page.dart';
import 'package:ugc_esports/ui/login_page/login_page.dart';
import 'package:ugc_esports/ui/alerts_page/notifications_page.dart';
import 'package:ugc_esports/ui/teams_page/team_detail_page/team_details_page.dart';
import 'package:ugc_esports/ui/teams_page/teams_page.dart';

TextTheme appTextTheme() => const TextTheme(
    headline1: TextStyle(
        fontSize: 72.0,
        fontWeight: FontWeight.bold,
        fontFamily: 'eurostile',
        color: Colors.black),
    headline6: TextStyle(
        // fontSize: 36.0,
        fontStyle: FontStyle.italic,
        fontFamily: 'eurostile',
        color: Colors.black),
    bodyText2:
        TextStyle(fontSize: 14.0, fontFamily: 'eurostile', color: Colors.black),
    bodyText1: TextStyle(
        fontSize: 12.0, fontFamily: 'eurostile', color: Colors.black));
// App TextTheme

Map<String, WidgetBuilder> appRoutes() => <String, WidgetBuilder>{
      LoginPage.routeName: (context) => const LoginPage(),
      NotificationsPage.routeName: (context) => const NotificationsPage(),
      HomePage.routeName: (context) => const HomePage(),
      TeamsPage.routeName: (context) => const TeamsPage(),
      TeamDetailsPage.routeName: (context) => const TeamDetailsPage(),
      ChatDetailPage.routeName:  (context) => const ChatDetailPage(),
    };
