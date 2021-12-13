
import 'dart:convert';

class Cover {
  Cover({
    this.id,
    this.coverableId,
    this.image,
    this.imgUrl,
  });

  final int? id;
  final int? coverableId;
  final String? image;
  final String? imgUrl;

  Cover copyWith({
    int? id,
    int? coverableId,
    String? image,
    String? imgUrl,
  }) {
    return Cover(
      id: id ?? this.id,
      coverableId: coverableId ?? this.coverableId,
      image: image ?? this.image,
      imgUrl: imgUrl ?? this.imgUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'coverableId': coverableId,
      'image': image,
      'imgUrl': imgUrl,
    };
  }

  factory Cover.fromMap(Map<String, dynamic> map) {
    return Cover(
      id: map['id'] != null ? map['id'] as int : null,
      coverableId:
          map['coverable_id'] != null ? map['coverable_id'] as int : null,
      image: map['image'] != null ? map['image'] as String : null,
      imgUrl: map['img_url'] != null ? map['img_url'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Cover.fromJson(String source) =>
      Cover.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Cover(id: $id, coverableId: $coverableId, image: $image, imgUrl: $imgUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Cover &&
        other.id == id &&
        other.coverableId == coverableId &&
        other.image == image &&
        other.imgUrl == imgUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        coverableId.hashCode ^
        image.hashCode ^
        imgUrl.hashCode;
  }
}
