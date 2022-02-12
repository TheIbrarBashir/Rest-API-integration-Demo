import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ugc_esports/network_connectivity_handler.dart';
import 'package:ugc_esports/ui/chat_page/chat_room_page.dart';
import 'package:ugc_esports/ui/colors.dart';
import 'package:ugc_esports/ui/alerts_page/notifications_page.dart';
import 'package:ugc_esports/ui/matches_page/matches_page.dart';
import 'package:ugc_esports/ui/teams_page/teams_page.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with ConnectivityHandler {
  int _selectedIndex = 1;

  static const List<Widget> _widgetOptions = <Widget>[MatchesPage(), TeamsPage(), ChatRoomPage(), Text('Account Page',),];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void showExitDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: UGCColors.darkGrey,
            title: const Text('Confirm Exit?', style: TextStyle(color: Colors.white, fontFamily: 'Roboto',),),
            content: const Text('Are you sure you want to exit?', style: TextStyle(color: Colors.white, fontFamily: 'Roboto'),),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  }, child: const Text('NO', style: TextStyle(color: UGCColors.green, fontFamily: 'Roboto'),)),
              TextButton(
                  onPressed: () {
                    if (Platform.isAndroid) {
                      SystemNavigator.pop(animated: true);
                    }
                    else if(Platform.isIOS) {
                      exit(0);
                    }
                  }, child: const Text('YES', style: TextStyle(color: UGCColors.green, fontFamily: 'Roboto'),))
            ],
          );
        },);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        showExitDialog();
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leadingWidth: 0,
            backgroundColor: UGCColors.black,
            title: const Center(
              child: Padding(
                padding: EdgeInsets.only(left: 54.0),
                child: Image(
                  height: 25,
                  image: AssetImage('assets/images/ugc_navigation_logo.png'),
                ),
              ),
            ),
            actions: [
              IconButton(onPressed: () {
                Navigator.pushNamed(context, NotificationsPage.routeName);
              }, icon: const Icon(Icons.notifications_active_outlined))
            ],
          ),
          body: Center(
            child:  _widgetOptions.elementAt(_selectedIndex),),

          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
              backgroundColor: UGCColors.black,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.sports_outlined),
                  label: 'MATCHES',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.groups_outlined),
                  label: 'TEAMS',
                ),

                BottomNavigationBarItem(
                  icon: Icon(Icons.chat_outlined),
                  label: 'CHATS',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  label: 'PROFILE',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: UGCColors.green,
              unselectedItemColor: Colors.white,
              onTap: _onItemTapped),
        ),
      ),
    );
  }
}
