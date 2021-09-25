import 'package:json_annotation/json_annotation.dart';

part 'cijenik.g.dart';

@JsonSerializable()
class Cijenik {
  int? id;
  int? gorivoId;
  double? cijena;
  String? naziv;
  int? vrstaGorivoId;


  factory Cijenik.fromJson(Map<String, dynamic> json) => _$CijenikFromJson(json);

  Map<String, dynamic> toJson() => _$CijenikToJson(this);

  Cijenik();
}