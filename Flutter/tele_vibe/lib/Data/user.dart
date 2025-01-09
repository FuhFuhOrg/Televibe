
class Anon {
  static int? _anonId;
  static String? _anonPassword;

  static int? get anonIdGet => _anonId;
  static String? get anonPasswordGet => _anonPassword;

  static set anonId(int? value) {
    _anonId = value;
  }
  static set anonPassword(String? value) {
    _anonPassword = value;
  }
}
