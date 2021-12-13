
import 'dart:convert';

import 'cover_model.dart';

class Profile {
  Profile({
    this.id,
    this.name,
    this.cover,
  });

  final int? id;
  final String? name;
  final Cover? cover;

  Profile copyWith({
    int? id,
    String? name,
    Cover? cover,
  }) {
    return Profile(
      id: id ?? this.id,
      name: name ?? this.name,
      cover: cover ?? this.cover,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'cover': cover?.toMap(),
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      cover: map['cover'] != null
          ? Cover.fromMap(map['cover'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Profile.fromJson(String source) =>
      Profile.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Profile(id: $id, name: $name, cover: $cover)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Profile &&
        other.id == id &&
        other.name == name &&
        other.cover == cover;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ cover.hashCode;
}