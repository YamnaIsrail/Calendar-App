import 'package:hive/hive.dart';

part 'auth_model.g.dart'; // Run `flutter packages pub run build_runner build` to generate this file.

@HiveType(typeId: 3)
class AuthData {
  @HiveField(0)
  String? password;

  @HiveField(1)
  String? pin;

  @HiveField(2)
  bool usePassword; // True for password, false for PIN.

  AuthData({this.password, this.pin, this.usePassword = true});
}
