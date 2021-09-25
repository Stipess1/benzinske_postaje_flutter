// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'postaja.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Postaja _$PostajaFromJson(Map<String, dynamic> json) {
  return Postaja()
    ..adresa = json['adresa'] as String?
    ..cijenici = (json['cijenici'] as List<dynamic>)
        .map((e) => Cijenik.fromJson(e as Map<String, dynamic>))
        .toList()
    ..opcije = (json['opcije'] as List<dynamic>)
        .map((e) => Usluga.fromJson(e as Map<String, dynamic>))
        .toList()
    ..id = json['id'] as int?
    ..lat = (json['lat'] as num?)?.toDouble()
    ..lon = (json['lon'] as num?)?.toDouble()
    ..mjesto = json['mjesto'] as String?
    ..naziv = json['naziv'] as String?
    ..obveznikId = json['obveznikId'] as int?
    ..obveznik = json['obveznik'] as String?
    ..otvoreno = json['otvoreno'] as bool?
    ..img = json['img'] as String?
    ..trenutnoRadnoVrijeme = json['trenutnoRadnoVrijeme'] as String?
    ..radnaVremena = json['radnaVremena'] == null
        ? null
        : RadnoVrijeme.fromJson(json['radnaVremena'] as Map<String, dynamic>)
    ..udaljenost = (json['udaljenost'] as num?)?.toDouble()
    ..gorivo = json['gorivo'] as String?;
}

Map<String, dynamic> _$PostajaToJson(Postaja instance) => <String, dynamic>{
      'adresa': instance.adresa,
      'cijenici': instance.cijenici.map((e) => e.toJson()).toList(),
      'opcije': instance.opcije.map((e) => e.toJson()).toList(),
      'id': instance.id,
      'lat': instance.lat,
      'lon': instance.lon,
      'mjesto': instance.mjesto,
      'naziv': instance.naziv,
      'obveznikId': instance.obveznikId,
      'obveznik': instance.obveznik,
      'otvoreno': instance.otvoreno,
      'img': instance.img,
      'trenutnoRadnoVrijeme': instance.trenutnoRadnoVrijeme,
      'radnaVremena': instance.radnaVremena?.toJson(),
      'udaljenost': instance.udaljenost,
      'gorivo': instance.gorivo,
    };
