import 'package:flutter/cupertino.dart';
import 'package:flutter_shopping_app/models/auth/login_model.dart';
import 'package:flutter_shopping_app/models/auth/signup_model.dart';
import 'package:flutter_shopping_app/services/auth_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginNotifier extends ChangeNotifier {
  bool _isObsecure = false;

  bool get isObsecure => _isObsecure;

  set isObsecure(bool newState) {
    _isObsecure = newState;
    notifyListeners();
  }

  bool _processing = false;

  bool get processing => _processing;

  set processing(bool newState) {
    _processing = newState;
    notifyListeners();
  }

  bool _loginResponseBool = false;

  bool get loginResponseBool => _loginResponseBool;

  set loginResponseBool(bool newState) {
    _loginResponseBool = newState;
    notifyListeners();
  }

  bool _responseBool = false;

  bool get responseBool => _responseBool;

  set responseBool(bool newState) {
    _responseBool = newState;
    notifyListeners();
  }

  bool? _login;

  bool get login => _login ?? false;

  set login(bool newState) {
    _login = newState;
    notifyListeners();
  }

  Future<bool> userLogin(LoginModel model) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    processing = true;
    bool response = await AuthHelper().login(model);
    processing = false;
    loginResponseBool = response;
    login = pref.getBool('isLogged') ?? false;
    return loginResponseBool;
  }

  logout() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    pref.remove('token');
    pref.remove('userId');
    pref.setBool('isLogged', false);
    login = pref.getBool('isLogged') ?? false;
  }

  Future<bool> registerUser(SignupModel model) async {
    responseBool = await AuthHelper().signup(model);
    return responseBool;
  }

  // Save the information loginIn.
  // When reload the app it will not be empty data of loginIn before
  getPrefs() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    login = pref.getBool('isLogged') ?? false;
  }
}
