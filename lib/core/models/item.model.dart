// 🎯 Dart imports:
import 'dart:convert';

// 📦 Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'item.model.g.dart';

@HiveType(typeId: 0)
class Item extends HiveObject with EquatableMixin implements Comparable<Item> {
  Item({
    required this.identifier,
    required this.createdTime,
    required this.updatedTime,
    required this.name,
    this.iconUrl = '',
    required this.secret,
    this.issuer = '',
    this.deleted = false,
  });

  factory Item.initial({String? identifier}) => Item(
        identifier: identifier ?? const Uuid().v4(),
        createdTime: DateTime.now(),
        updatedTime: DateTime.now(),
        name: '',
        secret: '',
        issuer: '',
      );

  factory Item.fromUri(String name, String secret, String? issuer) => Item(
        identifier: const Uuid().v4(),
        createdTime: DateTime.now(),
        updatedTime: DateTime.now(),
        name: name,
        secret: secret,
        issuer: issuer ?? '',
      );

  factory Item.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return Item.fromMap(data!);
  }

  factory Item.fromMap(Map<String, dynamic> map) => Item(
        identifier: map['identifier'] as String,
        createdTime:
            DateTime.fromMillisecondsSinceEpoch(map['createdTime'] as int),
        updatedTime:
            DateTime.fromMillisecondsSinceEpoch(map['updatedTime'] as int),
        name: map['name'] as String,
        iconUrl: map['iconUrl'] as String,
        secret: map['secret'] as String,
        issuer: map['issuer'] as String,
        deleted: map['deleted'] as bool,
      );

  factory Item.fromJson(String source) =>
      Item.fromMap(json.decode(source) as Map<String, dynamic>);

  @HiveField(0)
  String identifier;
  @HiveField(1)
  DateTime createdTime;
  @HiveField(2)
  DateTime updatedTime;
  @HiveField(3)
  String name;
  @HiveField(4)
  String iconUrl;
  @HiveField(5)
  String secret;
  @HiveField(6)
  String issuer;
  @HiveField(7)
  bool deleted;

  @override
  List<Object> get props => [
        identifier,
        createdTime,
        updatedTime,
        name,
        iconUrl,
        secret,
        issuer,
        deleted,
      ];

  Item copyWith({
    String? identifier,
    DateTime? createdTime,
    DateTime? updatedTime,
    String? name,
    String? iconUrl,
    String? secret,
    String? issuer,
    bool? deleted,
  }) {
    return Item(
      identifier: identifier ?? this.identifier,
      createdTime: createdTime ?? this.createdTime,
      updatedTime: updatedTime ?? this.updatedTime,
      name: name ?? this.name,
      iconUrl: iconUrl ?? this.iconUrl,
      secret: secret ?? this.secret,
      issuer: issuer ?? this.issuer,
      deleted: deleted ?? this.deleted,
    );
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        'identifier': identifier,
        'createdTime': createdTime.millisecondsSinceEpoch,
        'updatedTime': updatedTime.millisecondsSinceEpoch,
        'name': name,
        'iconUrl': iconUrl,
        'secret': secret,
        'issuer': issuer,
        'deleted': deleted,
      };

  String toJson() => json.encode(toMap());

  @override
  bool get stringify => true;

  @override
  int compareTo(Item other) => createdTime.millisecondsSinceEpoch
      .compareTo(other.createdTime.millisecondsSinceEpoch);
}
