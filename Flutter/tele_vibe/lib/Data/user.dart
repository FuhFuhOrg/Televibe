
class User {
  static int? _anonId;

  static int? get chats => _anonId;

  static set anonId(int? value) {
    _anonId = value;
  }
}
