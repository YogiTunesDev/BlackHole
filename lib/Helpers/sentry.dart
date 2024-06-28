import 'package:sentry_flutter/sentry_flutter.dart';

class SentryService {
  // Singleton pattern
  SentryService._privateConstructor();
  static final SentryService _instance = SentryService._privateConstructor();
  static SentryService get instance => _instance;

  // Set user context
  void setUserContext(String userId, String name, String email) {
    Sentry.configureScope((scope) {
      scope.setUser(
        SentryUser(
          id: userId,
          name: name,
          email: email,
        ),
      );
    });
  }

  // Clear user context
  void clearUserContext() {
    Sentry.configureScope((scope) => scope.setUser(null));
  }
}
