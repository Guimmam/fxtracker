import 'dart:convert';
import 'package:fxtracker/models/currency_model.dart';
import 'package:http/http.dart';

import '../models/currency_rates.dart';

class CurrencyList {
  String endpoint = "https://api.nbp.pl/api/exchangerates/tables/A?format=json";
  Future<List<CurrencyModel>> getCurrencyList() async {
    Response response = await get(Uri.parse(endpoint));

    if (response.statusCode == 200) {
      final List result = jsonDecode(response.body)[0]["rates"];

      return result.map((e) => CurrencyModel.fromJson(e)).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}

class CurrencyDetails {
  Future<CurrencyRates> getCurrencyRates(String code, String days) async {
    String endpoint =
        "http://api.nbp.pl/api/exchangerates/rates/A/$code/last/$days/";
    Response response = await get(Uri.parse(endpoint));

    if (response.statusCode == 200) {
      final Map<String, dynamic> result = jsonDecode(response.body)[0];

      return CurrencyRates.fromJson(result);
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}