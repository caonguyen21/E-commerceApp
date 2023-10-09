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
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
    var url = Uri.http(Config.apiUrl, Config.loginUrl);
    var response = await client.post(url, headers: requestHeaders, body: jsonEncode(model.toJson()));
    print('Login API Response: ${response.statusCode}');
    print('Login API Response Body: ${response.body}');
    if (response.statusCode == 200) {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      String userToken = loginResponseModelFromJson(response.body).token;
      String userId = loginResponseModelFromJson(response.body).id;
      await pref.setString('token', userToken);
      await pref.setString('userId', userId);
      await pref.setBool('isLogged', true);
      return true;
    } else {
      throw false;
    }
  }

  Future<bool> signup(SignupModel model) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
    var url = Uri.http(Config.apiUrl, Config.signupUrl);
    var response = await client.post(url, headers: requestHeaders, body: jsonEncode(model.toJson()));
    if (response.statusCode == 201) {
      return true;
    } else {
      throw false;
    }
  }

  Future<ProfileRes> getProfile() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? userToken = pref.getString('token');
    Map<String, String> requestHeaders = {'Content-Type': 'application/json', 'token': 'Bearer $userToken'};
    var url = Uri.http(Config.apiUrl, Config.getUserUrl);
    var response = await client.post(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      var profile = profileResFromJson(response.body);
      return profile;
    } else {
      throw Exception("Failed get the profile");
    }
  }
}
