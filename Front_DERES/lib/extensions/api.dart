import 'dart:convert';

import 'package:http/http.dart' as http;

extension ApiCall on http.Client {
  Future<Map<String, dynamic>> fetchData({
    required String url,
    Map<String, String>? headers,
  }) async {
    final response = await get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception(
          'Failed to load data from the API. Status: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> postData({
    required String url,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    final response = await post(
      Uri.parse(url),
      headers: headers,
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception(
          'Failed to post data to the API. Status: ${response.statusCode}');
    }
  }
}
