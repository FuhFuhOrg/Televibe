
import 'package:flutter/widgets.dart';

class Anon {
  static int? _anonId;
  static String? _anonPassword;
  static String username = "anon";
  static Image image = Image.asset('assets/ppp.jpg');

  static int? get anonIdGet => _anonId;
  static String? get anonPasswordGet => _anonPassword;

  static set anonId(int? value) {
    _anonId = value;
  }
  static set anonPassword(String? value) {
    _anonPassword = value;
  }
}
