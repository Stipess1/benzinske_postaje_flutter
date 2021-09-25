import 'package:json_annotation/json_annotation.dart';

part 'radno_vrijeme.g.dart';

@JsonSerializable()
class RadnoVrijeme {
  String? ponPet = "";
  String? sub = "";
  String? ned = "";
  String? praznik = "";

  factory RadnoVrijeme.fromJson(Map<String, dynamic> json) => _$RadnoVrijemeFromJson(json);

  Map<String, dynamic> toJson() => _$RadnoVrijemeToJson(this);

  RadnoVrijeme();
}