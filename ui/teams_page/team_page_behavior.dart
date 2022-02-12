import 'package:flutter/material.dart';
import 'package:ugc_esports/repository/domain/teams_api_client.dart';

mixin TeamPageBehaviorMixin {
  ScrollController pageNumberListViewScrollController = ScrollController();
  ScrollController teamListViewScrollController = ScrollController();
  int currentPageNumber = 1;
  bool isErrorUi = false;
  // TeamApiResponse? teamApiResponse;
  TeamsApiClient teamsApiClient = TeamsApiClient();

  /*Future<List<dynamic>> getTeamsList(BuildContext context) async{
    // teamApiResponse = await teamsApiClient.getTeamsData(token: token);
    // teamList = await teamApiResponse!.data!['teams'];
    // teamList = await response.data!['data']['teams'];

    try {
      Response<Map<String, dynamic>> response = await dio.get('https://www.ugcesports.gg/api/teams', queryParameters: token);
      return await response.data!['data']['teams'];
    } on Exception {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('server not responding, please try again', style: TextStyle(fontFamily: 'Roboto'),)));
      return const [] as Future<List<dynamic>>;
    }
  }*/

  List<int> manageItemPerPage({required int pageNumber, required int listLength}) {
    int startRange = 1, endRange = 1;

    if(listLength <= 10) {
      startRange = 0;
      endRange = listLength - 1;
    }
    else {
      endRange = (pageNumber * 10) - 1;
      startRange = endRange - 9;

      if(listLength - 1 >= endRange) {
        startRange = endRange - 9;
      }
      else {
        endRange = startRange + (listLength - 1) - startRange;
      }
    }
    return [startRange, endRange];
  }

}