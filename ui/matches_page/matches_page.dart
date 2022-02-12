import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ugc_esports/global_members.dart';
import 'package:ugc_esports/network_connectivity_handler.dart';
import 'package:ugc_esports/ui/colors.dart';
import 'package:ugc_esports/ui/matches_page/matches_behavior.dart';

class MatchesPage extends StatelessWidget {
  const MatchesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UGCColors.black,
      body: DefaultTabController(
        length: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [MatchesTab(), Expanded(child: MatchesTabViews())],
        ),
      ),
    );
  }
}

class MatchesTab extends StatelessWidget {
  const MatchesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const TabBar(
      labelColor: UGCColors.green,
      indicatorColor: Colors.transparent,
      unselectedLabelColor: Colors.white,
      tabs: <Tab>[
        Tab(
          child: Text(
            'UPCOMING',
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: 'eurostile'),
          ),
        ),
        Tab(
          child: Text(
            'PAST',
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: 'eurostile'),
          ),
        ),
      ],
    );
  }
}

class MatchesTabViews extends StatelessWidget {
  const MatchesTabViews({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const TabBarView(children: [
      UpComingMatches(),
      PastMatches(),
    ]);
  }
}

class UpComingMatches extends StatefulWidget {
  const UpComingMatches({Key? key}) : super(key: key);

  @override
  _UpComingMatchesState createState() => _UpComingMatchesState();
}

class _UpComingMatchesState extends State<UpComingMatches>
    with MatchesBehavior, ConnectivityHandler {
  Future<List<dynamic>> getUpcomingMatchesList() async {
    try {
      setState(() {
        isErrorUI = false;
      });
      if (await checkForInternetServiceAvailability(context,
          allowSnackBar: false)) {
        setState(() {
          isErrorUI = false;
        });
        Response<Map<String, dynamic>> response = await dio.get(
            'https://www.example/api/matches?where=[{"status": 3, "op": "<"}]&',
            queryParameters: token);
        return response.data is Map<String, dynamic>
            ? await response.data!['data'] is Map<String, dynamic>
                ? await response.data!['data']['matches'] is List<dynamic>
                    ? await response.data!['data']['matches']
                    : const []
                : const []
            : const [];
      } else {
        setState(() {
          isErrorUI = true;
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
    if (!isUpComingMatchListLoaded) {
      upComingMatchList = getUpcomingMatchesList();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isErrorUI
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
                        image: AssetImage('assets/images/no_internet.png'),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: Center(
                      child: OutlinedButton(
                        onPressed: () {
                          upComingMatchList = getUpcomingMatchesList();
                        },
                        child: const Text('try again'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Center(
            child: FutureBuilder<List<dynamic>>(
                initialData: const [],
                future: upComingMatchList,
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
                            'loading upcoming matches...',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ],
                    );
                  } else if (snapshot.hasData) {
                    isUpComingMatchListLoaded = true;
                    if (snapshot.data!.isNotEmpty) {
                      return RawScrollbar(
                        controller: upcomingMatchesScrollController,
                        isAlwaysShown: false,
                        thumbColor: UGCColors.green,
                        interactive: true,
                        thickness: 3,
                        radius: const Radius.circular(20.0),
                        child: ListView.builder(
                          controller: upcomingMatchesScrollController,
                          physics: const BouncingScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.all(8.0),
                              height: 100,
                              decoration: BoxDecoration(
                                  color: UGCColors.darkGrey,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  //team_a_name
                                  Flexible(
                                      flex: 23,
                                      child: Center(
                                          child: SingleChildScrollView(
                                              child: Text(
                                        snapshot.data![index]
                                                is Map<String, dynamic>
                                            ? snapshot.data![index]
                                                    ['team_a_name'] is String
                                                ? snapshot.data![index]
                                                    ['team_a_name']
                                                : 'null'
                                            : 'null',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.bold),
                                      )))),

                                  //team_a_logo
                                  Flexible(
                                      flex: 15,
                                      child: Center(
                                        child: LayoutBuilder(
                                          builder: (context, constraints) =>
                                              Container(
                                            height: constraints.maxWidth * 0.90,
                                            width: constraints.maxWidth * 0.90,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: CachedNetworkImageProvider(snapshot
                                                                .data![index]
                                                            is Map<String,
                                                                dynamic>
                                                        ? snapshot.data![index][
                                                                    'team_a_logo']
                                                                is String
                                                            ? snapshot.data![
                                                                    index]
                                                                ['team_a_logo']
                                                            : 'https://www.oakleyrealestate.com.au/wp-content/uploads/2018/10/no-img.jpg'
                                                        : 'https://www.oakleyrealestate.com.au/wp-content/uploads/2018/10/no-img.jpg'))),
                                          ),
                                        ),
                                      )),

                                  //VS Box
                                  Flexible(
                                    flex: 24,
                                    child: Center(
                                      child: Container(
                                        height: 100,
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                child: const Center(
                                                  child: Text(
                                                    'VS',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontFamily: 'Roboto',
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                height: 60,
                                                width: 60,
                                                decoration: BoxDecoration(
                                                  color: UGCColors.green,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              Text(
                                                'Round ${snapshot.data![index] is Map<String, dynamic> ? snapshot.data![index]['round'] is int ? snapshot.data![index]['round'] : '-' : '-'}',
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Roboto'),
                                              ),
                                            ],
                                          ),
                                        ),
                                        color: UGCColors.grey,
                                      ),
                                    ),
                                  ),

                                  //team_b_logo
                                  Flexible(
                                      flex: 15,
                                      child: Center(
                                        child: LayoutBuilder(
                                          builder: (context, constraints) =>
                                              Container(
                                            height: constraints.maxWidth * 0.90,
                                            width: constraints.maxWidth * 0.90,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: CachedNetworkImageProvider(snapshot
                                                              .data![index]
                                                          is Map<String,
                                                              dynamic>
                                                      ? snapshot.data![index][
                                                                  'team_b_logo']
                                                              is String
                                                          ? snapshot
                                                                  .data![index]
                                                              ['team_b_logo']
                                                          : 'https://www.oakleyrealestate.com.au/wp-content/uploads/2018/10/no-img.jpg'
                                                      : 'https://www.oakleyrealestate.com.au/wp-content/uploads/2018/10/no-img.jpg'),
                                                )),
                                          ),
                                        ),
                                      )),

                                  //team_b_name
                                  Flexible(
                                      flex: 23,
                                      child: Center(
                                          child: SingleChildScrollView(
                                              child: Text(
                                        snapshot.data![index]
                                                is Map<String, dynamic>
                                            ? snapshot.data![index]
                                                    ['team_b_name'] is String
                                                ? snapshot.data![index]
                                                    ['team_b_name']
                                                : 'null'
                                            : 'null',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.bold),
                                      )))),
                                ],
                              ),
                            );
                          },
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
                                      'assets/images/no_matches.png'),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              fit: FlexFit.tight,
                              child: Text(
                                'no upcoming matches',
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
                }),
          );
  }
}

class PastMatches extends StatefulWidget {
  const PastMatches({Key? key}) : super(key: key);

  @override
  _PastMatchesState createState() => _PastMatchesState();
}

class _PastMatchesState extends State<PastMatches>
    with MatchesBehavior, ConnectivityHandler {
  Future<List<dynamic>> getPastMatchesList() async {
    try {
      setState(() {
        isErrorUI = false;
      });
      if (await checkForInternetServiceAvailability(context,
          allowSnackBar: false)) {
        setState(() {
          isErrorUI = false;
        });
        Response<Map<String, dynamic>> response = await dio.get(
            'https://www.example.com/api/matches?where=[{"status": 6, "op": "="}]&',
            queryParameters: token);
        return response.data is Map<String, dynamic>
            ? await response.data!['data'] is Map<String, dynamic>
                ? await response.data!['data']['matches'] is List<dynamic>
                    ? await response.data!['data']['matches']
                    : const []
                : const []
            : const [];
      } else {
        setState(() {
          isErrorUI = true;
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
    if (!isPastMatchListLoaded) {
      pastMatchList = getPastMatchesList();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isErrorUI
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
                        image: AssetImage('assets/images/no_internet.png'),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: Center(
                      child: OutlinedButton(
                        onPressed: () {
                          pastMatchList = getPastMatchesList();
                        },
                        child: const Text('try again'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Center(
            child: FutureBuilder<List<dynamic>>(
                initialData: const [],
                future: pastMatchList,
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
                            'loading past matches...',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        )
                      ],
                    );
                  } else if (snapshot.hasData) {
                    isPastMatchListLoaded = true;
                    if (snapshot.data!.isNotEmpty) {
                      return RawScrollbar(
                        controller: pastMatchesScrollController,
                        isAlwaysShown: false,
                        thumbColor: UGCColors.green,
                        interactive: true,
                        thickness: 3.0,
                        radius: const Radius.circular(20.0),
                        child: ListView.builder(
                          controller: pastMatchesScrollController,
                          physics: const BouncingScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            String teamAScore =
                                snapshot.data![index] is Map<String, dynamic>
                                    ? snapshot.data![index]['score_a'] is int
                                        ? snapshot.data![index]['score_a']
                                            .toString()
                                        : '-'
                                    : '-';

                            String teamBScore =
                                snapshot.data![index] is Map<String, dynamic>
                                    ? snapshot.data![index]['score_b'] is int
                                        ? snapshot.data![index]['score_b']
                                            .toString()
                                        : '-'
                                    : '-';

                            return Container(
                              margin: const EdgeInsets.all(8.0),
                              height: 100,
                              decoration: BoxDecoration(
                                  color: UGCColors.darkGrey,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Flexible(
                                      flex: 23,
                                      child: Center(
                                          child: SingleChildScrollView(
                                              child: Text(
                                        snapshot.data![index]
                                                is Map<String, dynamic>
                                            ? snapshot.data![index]
                                                    ['team_a_name'] is String
                                                ? snapshot.data![index]
                                                    ['team_a_name']
                                                : 'null'
                                            : 'null',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.bold),
                                      )))),

                                  Flexible(
                                      flex: 15,
                                      child: Center(
                                        child: LayoutBuilder(
                                          builder: (context, constraints) =>
                                              Container(
                                            height: constraints.maxWidth * 0.90,
                                            width: constraints.maxWidth * 0.90,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: CachedNetworkImageProvider(snapshot
                                                                .data![index]
                                                            is Map<String,
                                                                dynamic>
                                                        ? snapshot.data![index][
                                                                    'team_a_logo']
                                                                is String
                                                            ? snapshot.data![
                                                                    index]
                                                                ['team_a_logo']
                                                            : 'https://www.oakleyrealestate.com.au/wp-content/uploads/2018/10/no-img.jpg'
                                                        : 'https://www.oakleyrealestate.com.au/wp-content/uploads/2018/10/no-img.jpg'))),
                                          ),
                                        ),
                                      )),

                                  //center container
                                  Flexible(
                                    flex: 24,
                                    child: Center(
                                      child: Container(
                                        height: 100,
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                child: Center(
                                                  child: SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Text(
                                                      '${snapshot.data![index] is Map<String, dynamic> ? snapshot.data![index]['score_a'] is int ? snapshot.data![index]['score_a'] : '-' : '-'} - ${snapshot.data![index] is Map<String, dynamic> ? snapshot.data![index]['score_b'] is int ? snapshot.data![index]['score_b'] : '-' : '-'}',
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                          color: (teamAScore !=
                                                                      '-' &&
                                                                  teamBScore !=
                                                                      '-')
                                                              ? (int.parse(
                                                                          teamAScore) <
                                                                      int.parse(
                                                                          teamBScore))
                                                                  ? Colors.red
                                                                  : Colors.white
                                                              : Colors.blue,
                                                          fontSize: 18,
                                                          fontFamily: 'Roboto',
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                                height: 60,
                                                width: 60,
                                                decoration: BoxDecoration(
                                                    color: (teamAScore != '-' &&
                                                            teamBScore != '-')
                                                        ? (int.parse(
                                                                    teamAScore) <
                                                                int.parse(
                                                                    teamBScore))
                                                            ? UGCColors
                                                                .lightBrown
                                                            : UGCColors.green
                                                        : Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                        color: (teamAScore !=
                                                                    '-' &&
                                                                teamBScore !=
                                                                    '-')
                                                            ? (int.parse(
                                                                        teamAScore) <
                                                                    int.parse(
                                                                        teamBScore))
                                                                ? Colors.red
                                                                : Colors.white
                                                            : Colors.white,
                                                        width: 2)),
                                              ),
                                              Text(
                                                'Round ${snapshot.data![index] is Map<String, dynamic> ? snapshot.data![index]['round'] is int ? snapshot.data![index]['round'] : '-' : '-'}',
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Roboto'),
                                              ),
                                            ],
                                          ),
                                        ),
                                        color: UGCColors.grey,
                                      ),
                                    ),
                                  ),

                                  Flexible(
                                      flex: 15,
                                      child: Center(
                                        child: LayoutBuilder(
                                          builder: (context, constraints) =>
                                              Container(
                                            height: constraints.maxWidth * 0.90,
                                            width: constraints.maxWidth * 0.90,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: CachedNetworkImageProvider(snapshot
                                                              .data![index]
                                                          is Map<String,
                                                              dynamic>
                                                      ? snapshot.data![index][
                                                                  'team_b_logo']
                                                              is String
                                                          ? snapshot
                                                                  .data![index]
                                                              ['team_b_logo']
                                                          : 'https://www.oakleyrealestate.com.au/wp-content/uploads/2018/10/no-img.jpg'
                                                      : 'https://www.oakleyrealestate.com.au/wp-content/uploads/2018/10/no-img.jpg'),
                                                )),
                                          ),
                                        ),
                                      )),

                                  Flexible(
                                      flex: 23,
                                      child: Center(
                                          child: SingleChildScrollView(
                                              child: Text(
                                        snapshot.data![index]
                                                is Map<String, dynamic>
                                            ? snapshot.data![index]
                                                    ['team_b_name'] is String
                                                ? snapshot.data![index]
                                                    ['team_b_name']
                                                : 'null'
                                            : 'null',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.bold),
                                      )))),
                                ],
                              ),
                            );
                          },
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
                                      'assets/images/no_matches.png'),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              fit: FlexFit.tight,
                              child: Text(
                                'no past matches',
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
                }),
          );
  }
}
