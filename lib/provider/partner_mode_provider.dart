import 'package:flutter/material.dart';

class PartnerModeProvider with ChangeNotifier {
  String _partnerNickname = '';

  String _myNickname = '';

  String get partnerNickname => _partnerNickname;
  String get myNickname => _myNickname;

  void setPartnerNickname(String nickname) {
    _partnerNickname = nickname;
    notifyListeners();
  }

  void setMyNickname(String mynickname) {
    _myNickname = mynickname;
    notifyListeners();
  }
}
