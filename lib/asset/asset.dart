// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';

class Asset {
  int id;
  String name;
  String path;
  String category;
  List<String> tags;
  Asset({
    required this.id,
    required this.name,
    required this.path,
    required this.category,
    required this.tags,
  });

  Asset copyWith({
    int? id,
    String? name,
    String? path,
    String? category,
    List<String>? tags,
  }) {
    return Asset(
      id: id ?? this.id,
      name: name ?? this.name,
      path: path ?? this.path,
      category: category ?? this.category,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'path': path,
      'category': category,
      'tags': tags,
    };
  }

  factory Asset.fromMap(Map<String, dynamic> map) {
    return Asset(
      id: map['id'] as int,
      name: map['name'] as String,
      path: map['path'] as String,
      category: map['category'] as String,
      tags: List<String>.from(map['tags'] as List),
    );
  }

  String toJson() => json.encode(toMap());

  factory Asset.fromJson(String source) =>
      Asset.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Asset(id: $id, name: $name, path: $path, category: $category, tags: $tags)';
  }

  @override
  bool operator ==(covariant Asset other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.id == id &&
        other.name == name &&
        other.path == path &&
        other.category == category &&
        listEquals(other.tags, tags);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        path.hashCode ^
        category.hashCode ^
        tags.hashCode;
  }
}
