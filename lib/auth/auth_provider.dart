import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'auth_model.dart';

class AuthProvider with ChangeNotifier {
  late Box<AuthData> _authBox;
  AuthData _authData = AuthData();

  AuthProvider() {
    _init();
  }

  Future<void> _init() async {
    _authBox = await Hive.openBox<AuthData>('authBox');
    _authData = _authBox.get('authData', defaultValue: AuthData())!;
    notifyListeners();
  }

  String? get password => _authData.password;
  String? get pin => _authData.pin;
  bool get usePassword => _authData.usePassword;

  Future<void> savePassword(String password) async {
    _authData = AuthData(password: password, usePassword: true);
    await _authBox.put('authData', _authData);
    notifyListeners();
  }

  Future<void> savePin(String pin) async {
    _authData = AuthData(pin: pin, usePassword: false);
    await _authBox.put('authData', _authData);
    notifyListeners();
  }

  void toggleAuthMode(bool isPassword) {
    _authData.usePassword = isPassword;
    _authBox.put('authData', _authData);
    notifyListeners();
  }
}
