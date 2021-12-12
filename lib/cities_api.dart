import 'dart:convert';

import 'package:http/http.dart';

String apiKey = '7bfcd67a94e349748012d96dfda4bf79';

Future<String> fetchCity(String lat, String lon) async {
  final res = await get(Uri.parse(
      'https://api.opencagedata.com/geocode/v1/json?q=$lat+$lon&key=$apiKey'));

  if (res.statusCode == 200) {
    var data = json.decode(res.body);
    var results = data['results'][0];

    if (results['components']['town'] != null) {
      return results['components']['town'];
    } else {
      if (results['components']['state_district'] != null) {
        return results['components']['state_district'];
      } else {
        return results['components']['state'];
      }
    }
  }

  throw Exception();
}
