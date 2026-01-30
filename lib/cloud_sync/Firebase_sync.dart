import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:itemtracker/providers/item_provider.dart';
import 'package:provider/provider.dart';

class FirebaseSync {
  static Future<void> syncUnsynceditems(BuildContext context) async {
    final provider = Provider.of<ItemProvider>(context, listen: false);
    final unsynceditems = provider.unsynceditems;

    if (unsynceditems.isEmpty) {
      print("No items to sync");
      return;
    }

    print("🔄Syncing ${unsynceditems.length} items...");
    try {
      for (var item in unsynceditems) {
        FirebaseFirestore.instance
            .collection('items')
            .doc(item.id)
            .set(item.toMap());

        await provider.markassynced(item);
        print("item synced...${item.id}");
      }
    } catch (e) {
      print("Failed to sync: $e");
    }
  }
}
