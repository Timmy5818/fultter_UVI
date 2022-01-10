import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Station {
  String siteName = '';
  int aqi = -1;

  Station({required this.siteName});

  Station.fromJson(Map<String, dynamic> json) {
    siteName = json['SiteName'];
    aqi = int.tryParse(json['UVI']) ?? 0;
  }
}

Future<List<Station>> fetchAQI() async {
  List<Station> stations = [];
  final response = await http.get(Uri.parse(
      'https://data.epa.gov.tw/api/v1/uv_s_01?format=json&limit=5&api_key=1909f878-5d76-4093-9da5-1372086fa7f6'));

  debugPrint('response gotten');
  if (response.statusCode == 200) {
    debugPrint('result gotten');
    var res = jsonDecode(response.body);
    List<dynamic> stationsInJson = res['records'];
    for (var station in stationsInJson) {
      debugPrint(station['locationName']);
      stations.add(Station.fromJson(station));
    }
    debugPrint('${stations.length} stations gotten');
  } else {
    debugPrint('status code:${response.statusCode}');
    throw Exception('Failed to load data');
  }
  return stations;
}
