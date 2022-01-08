import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Station {
  String siteName = '';
  int aqi = -1;

  Station({required this.siteName});

  Station.fromJson(Map<String, dynamic> json) {
    siteName = json['locationName'];
    aqi = int.tryParse(json['parameterName']) ?? -1;
  }
}

Future<List<Station>> fetchAQI() async {
  List<Station> stations = [];
  final response = await http.get(Uri.parse(
      'https://opendata.cwb.gov.tw/fileapi/v1/opendataapi/F-C0032-001?Authorization=rdec-key-123-45678-011121314&format=JSON'));

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
