import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'auth_model.dart';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AuthProvider with ChangeNotifier {
  late Box<AuthData> _authBox;
  AuthData _authData = AuthData();
  bool isInitialized = false; // Indicates if initialization is done

  AuthProvider() {
    _init();
  }

  Future<void> _init() async {
    _authBox = await Hive.openBox<AuthData>('authBox');
    _authData = _authBox.get('authData', defaultValue: AuthData())!;
    isInitialized = true;
    // Mark initialization as complete
    notifyListeners();
  }

  String? get password => _authData.password;
  String? get pin => _authData.pin;
  bool get usePassword => _authData.usePassword;

  // Save password securely
  Future<void> savePassword(String password) async {
    _authData = AuthData(password: password, usePassword: true);
    await _authBox.put('authData', _authData);
    notifyListeners();
  }

  // Save PIN securely
  Future<void> savePin(String pin) async {
    _authData = AuthData(pin: pin, usePassword: false);
    await _authBox.put('authData', _authData);
    notifyListeners();
  }

  // Handle the auth mode toggle
  void toggleAuthMode(bool isPassword) {
    _authData.usePassword = isPassword;
    _authBox.put('authData', _authData);
    notifyListeners();
  }

  // Getter to check if either password or pin is set
  bool get hasPasswordOrPin {
    return (_authData.password != null && _authData.password!.isNotEmpty) ||
        (_authData.pin != null && _authData.pin!.isNotEmpty);
  }
}
