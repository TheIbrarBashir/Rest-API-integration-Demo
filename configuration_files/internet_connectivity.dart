import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NetworkConnection extends ChangeNotifier {
  NetworkConnection() {
    Connectivity().onConnectivityChanged.listen((event) {
      _checkConnection(event);
    });
  }

  bool _isMobileData = false;
  bool _isWifi = false;
  bool _isNoInternet = false;

  bool get isMobileData => _isMobileData;

  bool get isWifi => _isWifi;

  bool get isNoInternet => _isNoInternet;

  void _checkConnection(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      _isNoInternet = true;
      _isMobileData = false;
      _isWifi = false;
    } else if (result == ConnectivityResult.mobile) {
      _isNoInternet = false;
      _isMobileData = true;
      _isWifi = false;
    } else if (result == ConnectivityResult.wifi) {
      _isNoInternet = false;
      _isMobileData = false;
      _isWifi = true;
    }
    notifyListeners();
  }

  Future<void> initialState() async {
    ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());
    _checkConnection(connectivityResult);
  }
}
