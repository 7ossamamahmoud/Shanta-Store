import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class API {
  Future<dynamic> get({
    required String url,
    dynamic body,
    @required String? token,
  }) async {
    dynamic headers = {};
    try {
      if (token != null) {
        headers.addAll({
          'Authorization': 'Bearer $token',
        });
      }
      Response response = await Dio().get(url,
          data: body,
          options: Options(
              followRedirects: false,
              validateStatus: (status) {
                return status! < 500;
              }));
      print("Response status code: ${response.statusCode}");
      print("Response data: ${response.data}");
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(
            "There was an error in GET with Status Code of ${response.statusCode}");
      }
    } catch (e) {
      log("GET Error is: $e");
    }
  }

  Future<dynamic> post({
    required String url,
    @required dynamic body,
    @required String? token,
  }) async {
    dynamic headers = {};
    try {
      if (token != null) {
        headers.addAll({
          'Authorization': 'Bearer $token',
        });
      }
      Response response = await Dio().post(url,
          data: body,
          options: Options(
            headers: headers,
          ));
      print("Response status code: ${response.statusCode}");
      print("Response data: ${response.data}");
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(
            "There was an error in GET with Status Code of ${response.statusCode}");
      }
    } catch (e) {
      log("POST Error is: $e");
    }
  }

  Future<dynamic> put({
    required String url,
    @required dynamic body,
    @required String? token,
  }) async {
    try {
      Response response = await Dio().put(
        url,
        data: body,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      print("Response status code: ${response.statusCode}");
      print("Response data: ${response.data}");
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Invalid response format: ${response.data}");
      }
    } catch (e) {
      log("PUT Error is: $e");
    }
  }
}
