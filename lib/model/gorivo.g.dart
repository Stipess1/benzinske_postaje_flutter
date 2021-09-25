// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gorivo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Gorivo _$GorivoFromJson(Map<String, dynamic> json) {
  return Gorivo()
    ..id = json['id'] as int?
    ..obveznikId = json['obveznikId'] as int?
    ..naziv = json['naziv'] as String?
    ..vrstaGorivaId = json['vrstaGorivaId'] as int?;
}

Map<String, dynamic> _$GorivoToJson(Gorivo instance) => <String, dynamic>{
      'id': instance.id,
      'obveznikId': instance.obveznikId,
      'naziv': instance.naziv,
      'vrstaGorivaId': instance.vrstaGorivaId,
    };
