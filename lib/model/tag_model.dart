import 'dart:convert';
import 'dart:developer';

class Tag {
  Tag({
    this.id,
    this.name,
    this.pivot,
  });

  final int? id;
  final String? name;
  final Pivot? pivot;

  Tag copyWith({
    int? id,
    String? name,
    Pivot? pivot,
  }) {
    return Tag(
      id: id ?? this.id,
      name: name ?? this.name,
      pivot: pivot ?? this.pivot,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'pivot': pivot?.toMap(),
    };
  }

  factory Tag.fromMap(Map<String, dynamic> map) {
    try {
      return Tag(
        id: map['id'] != null ? map['id'] as int : null,
        name: map['name'] != null ? map['name'] as String : null,
        pivot: map['pivot'] != null ? Pivot.fromMap(map['pivot'] as Map<String, dynamic>) as Pivot : null,
      );
    } catch (e) {
      log('Error in 5  : $e');
    }

    return Tag(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      pivot: map['pivot'] != null ? Pivot.fromMap(map['pivot'] as Map<String, dynamic>) as Pivot : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Tag.fromJson(String source) => Tag.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Tag(id: $id, name: $name, pivot: $pivot)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Tag && other.id == id && other.name == name && other.pivot == pivot;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ pivot.hashCode;
}

class Pivot {
  Pivot({
    this.taggableId,
    this.tagId,
    this.taggerId,
    this.taggableType,
    this.taggerType,
    this.context,
    this.order,
  });

  final int? taggableId;
  final int? tagId;
  final int? taggerId;
  final String? taggableType;
  final String? taggerType;
  final String? context;
  final String? order;

  Pivot copyWith({
    int? taggableId,
    int? tagId,
    int? taggerId,
    String? taggableType,
    String? taggerType,
    String? context,
    String? order,
  }) {
    return Pivot(
      taggableId: taggableId ?? this.taggableId,
      tagId: tagId ?? this.tagId,
      taggerId: taggerId ?? this.taggerId,
      taggableType: taggableType ?? this.taggableType,
      taggerType: taggerType ?? this.taggerType,
      context: context ?? this.context,
      order: order ?? this.order,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'taggableId': taggableId,
      'tagId': tagId,
      'taggerId': taggerId,
      'taggableType': taggableType,
      'taggerType': taggerType,
      'context': context,
      'order': order,
    };
  }

  factory Pivot.fromMap(Map<String, dynamic> map) {
    return Pivot(
      taggableId: map['taggable_id'] != null ? map['taggable_id'] as int : null,
      tagId: map['tag_id'] != null ? map['tag_id'] as int : null,
      taggerId: map['tagger_id'] != null ? map['tagger_id'] as int : null,
      taggableType: map['taggable_type'] != null ? map['taggable_type'] as String : null,
      taggerType: map['tagger_type'] != null ? map['tagger_type'] as String : null,
      context: map['context'] != null ? map['context'] as String : null,
      order: map['order'] != null ? map['order'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Pivot.fromJson(String source) => Pivot.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Pivot(taggableId: $taggableId, tagId: $tagId, taggerId: $taggerId, taggableType: $taggableType, taggerType: $taggerType, context: $context, order: $order)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Pivot &&
        other.taggableId == taggableId &&
        other.tagId == tagId &&
        other.taggerId == taggerId &&
        other.taggableType == taggableType &&
        other.taggerType == taggerType &&
        other.context == context &&
        other.order == order;
  }

  @override
  int get hashCode {
    return taggableId.hashCode ^ tagId.hashCode ^ taggerId.hashCode ^ taggableType.hashCode ^ taggerType.hashCode ^ context.hashCode ^ order.hashCode;
  }
}
