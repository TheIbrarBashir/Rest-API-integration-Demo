import 'package:flutter/cupertino.dart';

mixin MatchesBehavior{
  bool isErrorUI = false;
  ScrollController upcomingMatchesScrollController = ScrollController();
  ScrollController pastMatchesScrollController = ScrollController();
}