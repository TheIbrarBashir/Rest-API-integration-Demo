import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ugc_esports/network_connectivity_handler.dart';
import 'package:ugc_esports/ui/colors.dart';
import 'package:ugc_esports/ui/teams_page/team_detail_page/team_details_page.dart';
import 'package:ugc_esports/ui/teams_page/team_page_behavior.dart';
import '../../global_members.dart';

class TeamsPage extends StatelessWidget {
  static const String routeName = '/teams';
  const TeamsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
        child: Scaffold(
      backgroundColor: UGCColors.black,
      body: TeamsList(),
    ));
  }
}

class TeamsList extends StatefulWidget {
  const TeamsList({Key? key}) : super(key: key);

  @override
  _TeamsListState createState() => _TeamsListState();
}

class _TeamsListState extends State<TeamsList>
    with TeamPageBehaviorMixin, ConnectivityHandler {
  Future<List<dynamic>> getTeamsList() async {
    try {
      setState(() {
        isErrorUi = false;
      });
      if (await checkForInternetServiceAvailability(context,
          allowSnackBar: false)) {
        setState(() {
          isErrorUi = false;
        });
        Response<Map<String, dynamic>> response = await dio
            .get('https://www.example.com/api/teams', queryParameters: token);
        return response.data is Map<String, dynamic>
            ? await response.data!['data'] is Map<String, dynamic>
                ? await response.data!['data']['teams'] is List<dynamic>
                    ? await response.data!['data']['teams']
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
    if (!isTeamListLoaded) {
      teamList = getTeamsList();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isErrorUi
          ? Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(
                      image: AssetImage('assets/images/no_internet.png')),
                  OutlinedButton(
                    onPressed: () {
                      teamList = getTeamsList();
                    },
                    child: const Text(
                      'try again',
                    ),
                  ),
                ],
              ),
            )
          : FutureBuilder<List<dynamic>>(
              initialData: const [],
              future: teamList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(
                        color: UGCColors.green,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          'loading teams...',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasData) {
                  isTeamListLoaded = true;
                  if (snapshot.data!.isNotEmpty) {
                    perPageTeamList.clear();
                    List<int> rangeList = [];
                    rangeList = manageItemPerPage(
                        pageNumber: currentPageNumber,
                        listLength: snapshot.data!.length);
                    perPageTeamList.addAll(snapshot.data!
                        .sublist(rangeList[0], (rangeList[1] + 1)));
                    return Column(
                      children: [
                        Expanded(
                          child: RawScrollbar(
                            controller: teamListViewScrollController,
                            isAlwaysShown: false,
                            thumbColor: UGCColors.green,
                            interactive: true,
                            thickness: 3,
                            radius: const Radius.circular(20.0),
                            child: ListView.builder(
                              controller: teamListViewScrollController,
                              itemBuilder: (context, index) => GestureDetector(
                                onTap: () {
                                  currentTeamIndex = index;
                                  isTeamMemberListLoaded = false;
                                  isTeamUpComingMatchListLoaded = false;
                                  isTeamPastMatchListLoaded = false;
                                  teamMemberId = perPageTeamList[index]
                                          is Map<String, dynamic>
                                      ? perPageTeamList[index]['pivot']
                                              is Map<String, dynamic>
                                          ? perPageTeamList[index]['pivot']
                                                  ['team_id'] is int
                                              ? perPageTeamList[index]['pivot']
                                                  ['team_id']
                                              : -1
                                          : -1
                                      : -1;
                                  Navigator.pushNamed(
                                      context, TeamDetailsPage.routeName);
                                },
                                child: Team(
                                  teamName: perPageTeamList[index]
                                          is Map<String, dynamic>
                                      ? perPageTeamList[index]['name'] is String
                                          ? perPageTeamList[index]['name']
                                          : 'not available'
                                      : 'not available',
                                  gameName: perPageTeamList[index]
                                          is Map<String, dynamic>
                                      ? perPageTeamList[index]['captain']
                                              is Map<String, dynamic>
                                          ? perPageTeamList[index]['captain']
                                                  ['currentMatch'] is Map
                                              ? perPageTeamList[index]
                                                      ['captain']
                                                  ['currentMatch']['game_name']
                                              : 'not available'
                                          : 'not available'
                                      : 'not available',
                                  imageURL: perPageTeamList[index]
                                          is Map<String, dynamic>
                                      ? perPageTeamList[index]['coverUrl']
                                              is String
                                          ? perPageTeamList[index]['coverUrl']
                                          : 'https://www.classify24.com/wp-content/uploads/2016/05/no-image.png'
                                      : 'https://www.classify24.com/wp-content/uploads/2016/05/no-image.png',
                                ),
                              ),
                              itemCount: perPageTeamList.length,
                              physics: const BouncingScrollPhysics(),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 70,
                          child: RawScrollbar(
                            controller: pageNumberListViewScrollController,
                            isAlwaysShown: false,
                            interactive: true,
                            thumbColor: UGCColors.green,
                            thickness: 1.5,
                            radius: const Radius.circular(20.0),
                            child: ListView.builder(
                              controller: pageNumberListViewScrollController,
                              physics: const BouncingScrollPhysics(),
                              itemCount: ((snapshot.data!.length % 10) != 0)
                                  ? ((snapshot.data!.length ~/ 10) + 1)
                                  : (snapshot.data!.length ~/ 10),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      currentPageNumber = index + 1;
                                    });
                                  },
                                  child: Center(
                                      child: Text(
                                    '   ${index + 1}    ',
                                    style: TextStyle(
                                        color: currentPageNumber == (index + 1)
                                            ? UGCColors.green
                                            : Colors.white,
                                        fontSize:
                                            currentPageNumber == (index + 1)
                                                ? 22
                                                : 18),
                                  )),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
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
                                image: AssetImage('assets/images/no_teams.png'),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            fit: FlexFit.tight,
                            child: Text(
                              'no teams found',
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
            ),
    );
  }
}

//team list one whole container to show in a listView builder.
//above shown ListView builder
//below the one container

class Team extends StatelessWidget {
  final String? imageURL;
  final String? teamName;
  final String? gameName;

  const Team({
    Key? key,
    this.imageURL,
    this.teamName = 'Team Name ',
    this.gameName = 'Game Name',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 18.0, right: 18.0),
      child: Container(
        height: 170,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: UGCColors.darkGrey,
            borderRadius: BorderRadius.circular(5.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
                flex: 6,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          topRight: Radius.circular(5.0)),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                          image: CachedNetworkImageProvider(imageURL ??
                              'https://w7.pngwing.com/pngs/38/708/png-transparent-car-mercedes-car-love-compact-car-vehicle-thumbnail.png'))),
                )),
            Expanded(
                flex: 4,
                child: Container(
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5.0),
                        topRight: Radius.circular(5.0)),
                  ),
                  child: ListTile(
                    title: Text(
                      '$teamName',
                      style: const TextStyle(
                          color: UGCColors.green,
                          fontFamily: "eurostile",
                          fontWeight: FontWeight.w500,
                          fontSize: 18.0),
                    ),
                    subtitle: Text(
                      '$gameName',
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'eurostile',
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
