import 'package:json_annotation/json_annotation.dart';

part 'gorivo.g.dart';

@JsonSerializable(explicitToJson: true)
class Gorivo {
   int? id;
   int? obveznikId;
   String? naziv;
   int? vrstaGorivaId;

   factory Gorivo.fromJson(Map<String, dynamic> json) => _$GorivoFromJson(json);

   Map<String, dynamic> toJson() => _$GorivoToJson(this);

   Gorivo();
}