import 'dart:async';
import 'package:test_project/core/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'dart:convert';
import 'package:http/http.dart' as _http;
import 'package:http/http.dart' show Response;

class http {
  static bool mobile = false;
  static Future<bool> hasNetwork() async {
    final result = await (Connectivity().checkConnectivity());
    mobile = result == ConnectivityResult.mobile;
    return result != ConnectivityResult.none;
  }

  static dynamic getWheather(String city) async {
    final promise = Completer<dynamic>();

    if (!await hasNetwork()) {
      Alert.errorAgain(
        text:
            'Network connection is not enabled. \nPlease turn on the network to continue using the application then tap on "Try Again".',
        accept: () {
          getWheather(city)
              .then(promise.complete)
              .catchError(promise.completeError);
        },
      );
      return promise.future;
    }

    Uri uri = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=fb81584e4c3bb0618bae325a349a5247&units=metric&lang=ru');

    final headers = {'Content-Type': 'application/json'};

    Response response = await _http.get(
      uri,
      headers: headers,
    );

    try {
      Map<String, dynamic> result = json.decode(response.body);
      return result;
    } catch (e) {
      throw 'Response Error: $e';
    }
  }
}
