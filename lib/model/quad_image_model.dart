
import 'dart:convert';

class QuadImage {
  QuadImage({
    this.imageUrl,
    this.image,
  });

  final String? imageUrl;
  final String? image;

  QuadImage copyWith({
    String? imageUrl,
    String? image,
  }) {
    return QuadImage(
      imageUrl: imageUrl ?? this.imageUrl,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'image': image,
    };
  }

  factory QuadImage.fromMap(Map<String, dynamic> map) {
    return QuadImage(
      imageUrl: map['image_url'] != null ? map['image_url'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory QuadImage.fromJson(String source) =>
      QuadImage.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'QuadImage(imageUrl: $imageUrl, image: $image)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is QuadImage &&
        other.imageUrl == imageUrl &&
        other.image == image;
  }

  @override
  int get hashCode => imageUrl.hashCode ^ image.hashCode;
}