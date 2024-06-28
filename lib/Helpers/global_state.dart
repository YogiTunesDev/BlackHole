class GlobalState {
  // Private constructor
  GlobalState._privateConstructor();

  // Singleton instance
  static final GlobalState _instance = GlobalState._privateConstructor();

  // Factory constructor
  factory GlobalState() {
    return _instance;
  }

  // Mutable global state
  bool _isLoggedIn = false;

  bool _isSentryServiceSet = false;

  // Getter
  bool get isLoggedIn => _isLoggedIn;

  bool get isSentryServiceSet => _isSentryServiceSet;

  // Setter
  set isLoggedIn(bool value) {
    _isLoggedIn = value;
  }

  set isSentryServiceSet(bool value) {
    _isSentryServiceSet = value;
  }
}
