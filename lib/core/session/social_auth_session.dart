class SocialAuthSession {
  String? _firebaseIdToken;

  String? get firebaseIdToken => _firebaseIdToken;

  set firebaseIdToken(String? token) {
    _firebaseIdToken = token;
  }

  void clearToken() {
    _firebaseIdToken = null;
  }
}
