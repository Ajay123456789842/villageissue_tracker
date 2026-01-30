import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:itemtracker/cloud_sync/Firebase_sync.dart';

class CheckConnectivityService {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription? _connection;
  void checkConnectivity(BuildContext ct) {
    _connectivity.onConnectivityChanged.listen((result) {
      // ignore: unrelated_type_equality_checks
      if (result != ConnectivityResult.none) {
        if (!ct.mounted) return;
        FirebaseSync.syncUnsynceditems(ct);
      }
    });
  }

  void stopSyncListener() {
    _connection?.cancel();
  }
}
