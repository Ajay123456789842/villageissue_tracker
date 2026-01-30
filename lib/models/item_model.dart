import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
part 'item_model.g.dart';

@HiveType(typeId: 1)
class ItemModel {
  @HiveField(0)
  String? name;
  @HiveField(1)
  String? description;
  @HiveField(2)
  String? imgurl;
  @HiveField(3)
  DateTime? createdAt;
  @HiveField(4)
  bool? isSynced;
  @HiveField(5)
  String? id;

  ItemModel({
    required this.name,
    required this.description,
    this.createdAt,
    this.isSynced = false,
    this.imgurl,
    required this.id,
  });

  ItemModel fromMap(Map<String, dynamic> map) {
    return ItemModel(
      name: map['name'],
      description: map['description'],
      createdAt: map['createdAt'],
      isSynced: map['isSynced'],
      imgurl: map['imgurl'],
      id: map['id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'createdAt': createdAt,
      'isSynced': isSynced,
      'imgurl': imgurl,
      'id': id,
    };
  }
}
