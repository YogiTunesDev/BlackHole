import 'dart:convert';

import 'package:flutter/foundation.dart';

class RadioStationsResponse {
    RadioStationsResponse({
        this.status,
        this.statusCode,
        this.data,
    });

    final bool? status;
    final int? statusCode;
    final RadioStationsResponseData? data;

  RadioStationsResponse copyWith({
    bool? status,
    int? statusCode,
    RadioStationsResponseData? data,
  }) {
    return RadioStationsResponse(
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'statusCode': statusCode,
      'data': data?.toMap(),
    };
  }

  factory RadioStationsResponse.fromMap(Map<String, dynamic> map) {
    return RadioStationsResponse(
      status: map['status'] != null ? map['status'] as bool : null,
      statusCode: map['status_code'] != null ? map['status_code'] as int : null,
      data: map['data'] != null ? RadioStationsResponseData.fromMap(map['data'] as Map<String, dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RadioStationsResponse.fromJson(String source) => RadioStationsResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'RadioStationsResponse(status: $status, statusCode: $statusCode, data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is RadioStationsResponse &&
      other.status == status &&
      other.statusCode == statusCode &&
      other.data == data;
  }

  @override
  int get hashCode => status.hashCode ^ statusCode.hashCode ^ data.hashCode;
}

class RadioStationsResponseData {
    RadioStationsResponseData({
        this.currentPage,
        this.data,
        this.firstPageUrl,
        this.from,
        this.lastPage,
        this.lastPageUrl,
        this.nextPageUrl,
        this.path,
        this.perPage,
        this.prevPageUrl,
        this.to,
        this.total,
    });

    final int? currentPage;
    final List<RadioStationsData>? data;
    final String? firstPageUrl;
    final int? from;
    final int? lastPage;
    final String? lastPageUrl;
    final String? nextPageUrl;
    final String? path;
    final int? perPage;
    final String? prevPageUrl;
    final int? to;
    final int? total;

  RadioStationsResponseData copyWith({
    int? currentPage,
    List<RadioStationsData>? data,
    String? firstPageUrl,
    int? from,
    int? lastPage,
    String? lastPageUrl,
    String? nextPageUrl,
    String? path,
    int? perPage,
    String? prevPageUrl,
    int? to,
    int? total,
  }) {
    return RadioStationsResponseData(
      currentPage: currentPage ?? this.currentPage,
      data: data ?? this.data,
      firstPageUrl: firstPageUrl ?? this.firstPageUrl,
      from: from ?? this.from,
      lastPage: lastPage ?? this.lastPage,
      lastPageUrl: lastPageUrl ?? this.lastPageUrl,
      nextPageUrl: nextPageUrl ?? this.nextPageUrl,
      path: path ?? this.path,
      perPage: perPage ?? this.perPage,
      prevPageUrl: prevPageUrl ?? this.prevPageUrl,
      to: to ?? this.to,
      total: total ?? this.total,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'currentPage': currentPage,
      'data': data?.map((x) => x.toMap()).toList(),
      'firstPageUrl': firstPageUrl,
      'from': from,
      'lastPage': lastPage,
      'lastPageUrl': lastPageUrl,
      'nextPageUrl': nextPageUrl,
      'path': path,
      'perPage': perPage,
      'prevPageUrl': prevPageUrl,
      'to': to,
      'total': total,
    };
  }

  factory RadioStationsResponseData.fromMap(Map<String, dynamic> map) {
    return RadioStationsResponseData(
      currentPage: map['current_page'] != null ? map['current_page'] as int : null,
      data: map['data'] != null ? List<RadioStationsData>.from(map['data']?.map((x) => RadioStationsData.fromMap(x as Map<String, dynamic>)) as Iterable<dynamic>) : null,
      firstPageUrl: map['first_page_url'] != null ? map['first_page_url']as String : null,
      from: map['from'] != null ? map['from'] as int : null,
      lastPage: map['last_page'] != null ? map['last_page'] as int : null,
      lastPageUrl: map['last_page_url'] != null ? map['last_page_url']as String : null,
      nextPageUrl: map['next_page_url'] != null ? map['next_page_url'] as String: null,
      path: map['path'] != null ? map['path'] as String : null,
      perPage: map['per_page'] != null ? map['per_page'] as int: null,
      prevPageUrl: map['prev_page_url'] != null ? map['prev_page_url'] as String : null,
      to: map['to'] != null ? map['to'] as int: null,
      total: map['total'] != null ? map['total'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RadioStationsResponseData.fromJson(String source) => RadioStationsResponseData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RadioStationsResponseData(currentPage: $currentPage, data: $data, firstPageUrl: $firstPageUrl, from: $from, lastPage: $lastPage, lastPageUrl: $lastPageUrl, nextPageUrl: $nextPageUrl, path: $path, perPage: $perPage, prevPageUrl: $prevPageUrl, to: $to, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is RadioStationsResponseData &&
      other.currentPage == currentPage &&
      listEquals(other.data, data) &&
      other.firstPageUrl == firstPageUrl &&
      other.from == from &&
      other.lastPage == lastPage &&
      other.lastPageUrl == lastPageUrl &&
      other.nextPageUrl == nextPageUrl &&
      other.path == path &&
      other.perPage == perPage &&
      other.prevPageUrl == prevPageUrl &&
      other.to == to &&
      other.total == total;
  }

  @override
  int get hashCode {
    return currentPage.hashCode ^
      data.hashCode ^
      firstPageUrl.hashCode ^
      from.hashCode ^
      lastPage.hashCode ^
      lastPageUrl.hashCode ^
      nextPageUrl.hashCode ^
      path.hashCode ^
      perPage.hashCode ^
      prevPageUrl.hashCode ^
      to.hashCode ^
      total.hashCode;
  }
}

class RadioStationsData {
    RadioStationsData({
        this.id,
        this.name,
        this.description,
        this.sourceId,
        this.cover,
    });

    final int? id;
    final String? name;
    final String? description;
    final int? sourceId;
    final Cover? cover;

  RadioStationsData copyWith({
    int? id,
    String? name,
    String? description,
    int? sourceId,
    Cover? cover,
  }) {
    return RadioStationsData(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      sourceId: sourceId ?? this.sourceId,
      cover: cover ?? this.cover,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'sourceId': sourceId,
      'cover': cover?.toMap(),
    };
  }

  factory RadioStationsData.fromMap(Map<String, dynamic> map) {
    return RadioStationsData(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      description: map['description'] != null ? map['description'] as String : null,
      sourceId: map['source_id'] != null ? map['source_id'] as int : null,
      cover: map['cover'] != null ? Cover.fromMap(map['cover'] as Map<String, dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RadioStationsData.fromJson(String source) => RadioStationsData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RadioStationsData(id: $id, name: $name, description: $description, sourceId: $sourceId, cover: $cover)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is RadioStationsData &&
      other.id == id &&
      other.name == name &&
      other.description == description &&
      other.sourceId == sourceId &&
      other.cover == cover;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      sourceId.hashCode ^
      cover.hashCode;
  }
}

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
      id: map['id'] != null ? map['id'] as int: null,
      coverableId: map['coverable_id'] != null ? map['coverable_id'] as int : null,
      image: map['image'] != null ? map['image'] as String : null,
      imgUrl: map['img_url'] != null ? map['img_url'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Cover.fromJson(String source) => Cover.fromMap(json.decode(source) as Map<String, dynamic>);

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
