// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usluga.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Usluga _$UslugaFromJson(Map<String, dynamic> json) {
  return Usluga(
    json['opcijaId'] as int,
  )
    ..usluga = json['usluga'] as String?
    ..img = json['img'] as String?;
}

Map<String, dynamic> _$UslugaToJson(Usluga instance) => <String, dynamic>{
      'usluga': instance.usluga,
      'opcijaId': instance.opcijaId,
      'img': instance.img,
    };
