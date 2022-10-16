// 参考
// https://github.com/mono0926/flutter_firestore_ref

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

class GeoPointConverter implements JsonConverter<GeoPoint, GeoPoint> {
  const GeoPointConverter();

  @override
  GeoPoint fromJson(GeoPoint geopoint) => geopoint;

  @override
  GeoPoint toJson(GeoPoint geopoint) => geopoint;
}
