// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cijenik.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cijenik _$CijenikFromJson(Map<String, dynamic> json) {
  return Cijenik()
    ..id = json['id'] as int?
    ..gorivoId = json['gorivoId'] as int?
    ..cijena = (json['cijena'] as num?)?.toDouble()
    ..naziv = json['naziv'] as String?
    ..vrstaGorivoId = json['vrstaGorivoId'] as int?;
}

Map<String, dynamic> _$CijenikToJson(Cijenik instance) => <String, dynamic>{
      'id': instance.id,
      'gorivoId': instance.gorivoId,
      'cijena': instance.cijena,
      'naziv': instance.naziv,
      'vrstaGorivoId': instance.vrstaGorivoId,
    };
