// To parse this JSON data, do
//
//     final currencyModel = currencyModelFromJson(jsonString);

import 'dart:convert';

class CurrencyModel {
  CurrencyModel({
    required this.currency,
    required this.code,
    required this.mid,
  });

  final String currency;
  final String code;
  final double mid;

  factory CurrencyModel.fromRawJson(String str) =>
      CurrencyModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CurrencyModel.fromJson(Map<String, dynamic> json) => CurrencyModel(
        currency: json["currency"],
        code: json["code"],
        mid: json["mid"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "currency": currency,
        "code": code,
        "mid": mid,
      };
}
