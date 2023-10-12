import 'dart:convert';

import 'package:flutter_shopping_app/models/auth/signup_model.dart';
import 'package:flutter_shopping_app/models/auth_response/login_res_model.dart';
import 'package:flutter_shopping_app/models/auth_response/profile_model.dart';
import 'package:flutter_shopping_app/services/config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/auth/login_model.dart';

class AuthHelper {
  static var client = http.Client();

  Future<bool> login(LoginModel model) async {
    try {
      Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
      var url = Uri.http(Config.apiUrl, Config.loginUrl);

      var response = await client.post(url, headers: requestHeaders, body: jsonEncode(model.toJson()));

      if (response.statusCode == 200 || response.statusCode == 307) {
        // If it's a redirect, get the new URL from the 'Location' header
        if (response.statusCode == 307) {
          String? redirectUrl = response.headers['location'];
          url = Uri.parse(redirectUrl!);
          response = await client.post(url, headers: requestHeaders, body: jsonEncode(model.toJson()));
        }

        final SharedPreferences pref = await SharedPreferences.getInstance();
        var loginResponse = loginResponseModelFromJson(response.body);
        await pref.setString('token', loginResponse.token);
        await pref.setString('userId', loginResponse.id);
        await pref.setBool('isLogged', true);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> signup(SignupModel model) async {
    try {
      Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
      var url = Uri.http(Config.apiUrl, Config.signupUrl);

      var response = await client.post(url, headers: requestHeaders, body: jsonEncode(model.toJson()));

      if (response.statusCode == 201 || response.statusCode == 307) {
        // If it's a redirect, get the new URL from the 'Location' header
        if (response.statusCode == 307) {
          String? redirectUrl = response.headers['location'];
          if (redirectUrl != null) {
            url = Uri.parse(redirectUrl);
            response = await client.post(url, headers: requestHeaders, body: jsonEncode(model.toJson()));
          } else {
            return false;
          }
        }

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<ProfileRes> getProfile() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? userToken = pref.getString('token');
    Map<String, String> requestHeaders = {'Content-Type': 'application/json', 'token': 'Bearer $userToken'};
    var url = Uri.http(Config.apiUrl, Config.getUserUrl);
    var response = await client.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      var profile = profileResFromJson(response.body);
      return profile;
    } else {
      throw Exception("Failed get the profile");
    }
  }
}
