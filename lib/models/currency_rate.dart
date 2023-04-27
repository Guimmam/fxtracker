import 'dart:convert';

class CurrencyRate {
  CurrencyRate({
    required this.table,
    required this.currency,
    required this.code,
    required this.rates,
  });

  final String table;
  final String currency;
  final String code;
  final List<Rate> rates;

  factory CurrencyRate.fromRawJson(String str) =>
      CurrencyRate.fromJson(json.decode(str));

  factory CurrencyRate.fromJson(Map<String, dynamic> json) => CurrencyRate(
        table: json["table"],
        currency: json["currency"],
        code: json["code"],
        rates: List<Rate>.from(json["rates"].map((x) => Rate.fromJson(x))),
      );
}

class Rate {
  Rate({
    required this.no,
    required this.effectiveDate,
    required this.mid,
  });

  final String no;
  final DateTime effectiveDate;
  final double mid;

  factory Rate.fromRawJson(String str) => Rate.fromJson(json.decode(str));

  factory Rate.fromJson(Map<String, dynamic> json) => Rate(
        no: json["no"],
        effectiveDate: DateTime.parse(json["effectiveDate"]),
        mid: json["mid"]?.toDouble(),
      );
}
