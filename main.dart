import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:ugc_esports/configuration_files/internet_connectivity.dart';
import 'package:ugc_esports/repository/domain/notifications_api_client.dart';
import 'package:ugc_esports/repository/model_classes/login.dart';
import 'package:ugc_esports/repository/providers/ui_providers.dart';
import 'package:ugc_esports/ui/chat_page/chat_detail_page/chat_detail_behavior.dart';

import 'package:ugc_esports/ui/login_page/login_page.dart';

import 'configuration_files/app_configuration.dart';

NetworkConnection networkConnection = NetworkConnection();

void main() {
  runApp(MultiProvider(providers: <SingleChildWidget>[
    ChangeNotifierProvider<PasswordVisibilityNotifier>(
      create: (context) => PasswordVisibilityNotifier(),
    ),
    ChangeNotifierProvider<LoginApiClient>(
      create: (context) => LoginApiClient(),
    ),
    ChangeNotifierProvider<NotificationApiClient>(
      create: (context) => NotificationApiClient(),
    ),
    ChangeNotifierProvider<NotifyOnChatRefresh>(
        create: (context) => NotifyOnChatRefresh(),)
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API Integration',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: appTextTheme(),
        primarySwatch: Colors.blue,
      ),
      initialRoute: LoginPage.routeName,
      routes: appRoutes(),
    );
  }
}
