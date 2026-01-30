import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:itemtracker/models/item_model.dart';

class ItemProvider extends ChangeNotifier {
  List<ItemModel> _items = [];
  ThemeMode _themeMode = ThemeMode.dark;
  late Box<ItemModel> _itemsbox;

  List<ItemModel> get items => _items;
  ThemeMode get thememode => _themeMode;

  void toggletheme() {
    if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }
    notifyListeners();
  }

  ItemProvider() {
    init();
  }

  Future<void> init() async {
    _itemsbox = Hive.box<ItemModel>('itembox');
    _getItems();
  }

// ignore: non_constant_identifier_names
  void _getItems() async {
    _items = _itemsbox.values.toList();
    print(_items.length);
    notifyListeners();
  }

  void addItem(ItemModel m) {
    _itemsbox.put(m.id, m);
    _getItems();
  }

  void removeitem(String id) {
    _itemsbox.delete(id);
    _getItems();
  }

  void deleteallitems() {
    _itemsbox.clear();
    _getItems();
  }

  void updateitem(ItemModel m) {
    _itemsbox.put(m.id, m);
    _getItems();
  }

  List<ItemModel> get unsynceditems =>
      _items.where((e) => e.isSynced == false).toList();

  Future<void> markassynced(ItemModel item) async {
    item.isSynced = true;
    updateitem(item);
    _getItems();
  }
}
