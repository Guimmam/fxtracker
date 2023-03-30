import 'dart:convert';

class CurrencyRates {
  CurrencyRates({
    required this.table,
    required this.currency,
    required this.code,
    required this.rates,
  });

  final String table;
  final String currency;
  final String code;
  final List<Rate> rates;

  factory CurrencyRates.fromRawJson(String str) =>
      CurrencyRates.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CurrencyRates.fromJson(Map<String, dynamic> json) => CurrencyRates(
        table: json["table"],
        currency: json["currency"],
        code: json["code"],
        rates: List<Rate>.from(json["rates"].map((x) => Rate.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "table": table,
        "currency": currency,
        "code": code,
        "rates": List<dynamic>.from(rates.map((x) => x.toJson())),
      };
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

  String toRawJson() => json.encode(toJson());

  factory Rate.fromJson(Map<String, dynamic> json) => Rate(
        no: json["no"],
        effectiveDate: DateTime.parse(json["effectiveDate"]),
        mid: json["mid"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "no": no,
        "effectiveDate":
            "${effectiveDate.year.toString().padLeft(4, '0')}-${effectiveDate.month.toString().padLeft(2, '0')}-${effectiveDate.day.toString().padLeft(2, '0')}",
        "mid": mid,
      };
}
