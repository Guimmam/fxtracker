import 'dart:convert';
import 'package:fxtracker/models/currency_model.dart';
import 'package:http/http.dart';

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
