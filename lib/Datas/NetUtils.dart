import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:task_manager_assignment/main.dart';
import 'package:task_manager_assignment/login_Signup/login.dart';
import 'package:task_manager_assignment/Datas/auth-utils.dart';

class NetworkUtils {

  Future<dynamic> getMethod(String url,
      {Map<String, String>? body, VoidCallback? onUnAuthorize}) async {
    try {
      final http.Response response = await http.get(Uri.parse(url), headers: {
        'Content-type': 'application/json',
        'token': AuthUtils.token ?? ''
      });
      log(response.body);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        if (onUnAuthorize != null) {
          onUnAuthorize();
        } else {
          moveToLogin();
        }
      } else {
        log('Something went wrong ${response.statusCode}');
      }
    } catch (e) {
      log('Error $e');
    }
  }

  Future<dynamic> postMethod(String url,
      {Map<String, String>? body, VoidCallback? onUnAuthorize}) async {
    try {
      final http.Response response = await http.post(Uri.parse(url),
          headers: {
            'Content-type': 'application/json',
            'token': AuthUtils.token ?? ''
          },
          body: jsonEncode(body));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        if (onUnAuthorize != null) {
          onUnAuthorize();
        } else {
          moveToLogin();
        }
      } else {
        log('Something went wrong ${response.statusCode}');
      }
    } catch (e) {
      log('Error $e');
    }
  }

  Future<dynamic> deleteMethod(String url,
      {Map<String, String>? body, VoidCallback? onUnAuthorize}) async {
    try {
      final http.Response response = await http.get(Uri.parse(url), headers: {
        'Content-type': 'application/json',
        'token': AuthUtils.token ?? ''
      });

      if (response.statusCode == 200 && jsonDecode(response.body)['status'] == 'success') {
        return true;
        //return true;
      } else if (response.statusCode == 401) {
        if (onUnAuthorize != null) {
          onUnAuthorize();
        }
      } else {
        log('Something went wrong ${response.statusCode}');
      }
    } catch (e) {
      log('Error $e');
    }
  }

  Future<void> moveToLogin() async {
    await AuthUtils.clearData();
    Navigator.pushAndRemoveUntil(
        TaskManager.globalKey.currentContext!,
        MaterialPageRoute(builder: (context) => const login()),
        (route) => false);
  }
}
