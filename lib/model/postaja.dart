
import 'package:benzinske_postaje/model/cijenik.dart';
import 'package:benzinske_postaje/model/radno_vrijeme.dart';
import 'package:benzinske_postaje/model/usluga.dart';
import 'package:json_annotation/json_annotation.dart';

part 'postaja.g.dart';

@JsonSerializable(explicitToJson: true)
class Postaja {

  String? adresa;
  List<Cijenik> cijenici = [];
  List<Usluga> opcije = [];
  int? id;
  double? lat;
  double? lon;
  String? mjesto;
  String? naziv;
  int? obveznikId;
  String? obveznik;
  bool? otvoreno = false;
  String? img;
  String? trenutnoRadnoVrijeme;
  RadnoVrijeme? radnaVremena;
  double? udaljenost;
  String? gorivo = "";

  factory Postaja.fromJson(Map<String, dynamic> json) => _$PostajaFromJson(json);

  Map<String, dynamic> toJson() => _$PostajaToJson(this);
  //
  Postaja();

}