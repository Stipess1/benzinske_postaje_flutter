// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'radno_vrijeme.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RadnoVrijeme _$RadnoVrijemeFromJson(Map<String, dynamic> json) {
  return RadnoVrijeme()
    ..ponPet = json['ponPet'] as String?
    ..sub = json['sub'] as String?
    ..ned = json['ned'] as String?
    ..praznik = json['praznik'] as String?;
}

Map<String, dynamic> _$RadnoVrijemeToJson(RadnoVrijeme instance) =>
    <String, dynamic>{
      'ponPet': instance.ponPet,
      'sub': instance.sub,
      'ned': instance.ned,
      'praznik': instance.praznik,
    };
