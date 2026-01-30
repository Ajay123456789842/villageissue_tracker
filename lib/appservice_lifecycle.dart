import 'package:flutter/widgets.dart';
import 'package:itemtracker/cloud_sync/check_connectivity.dart';
import '../providers/item_provider.dart';

class AppLifecycleService with WidgetsBindingObserver {
  AppLifecycleService();

  void start() {
    WidgetsBinding.instance.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      CheckConnectivityService().checkConnectivity;
    }
  }
}
