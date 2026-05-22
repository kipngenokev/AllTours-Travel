import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Wraps Supabase auth and exposes it as a [ChangeNotifier] so the UI can
/// react to login/logout. Used as the app's auth gate.
class AuthService extends ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;
  late final Stream<AuthState> _authStream;

  AuthService() {
    _authStream = _client.auth.onAuthStateChange;
    _authStream.listen((_) => notifyListeners());
  }

  User? get currentUser => _client.auth.currentUser;
  bool get isLoggedIn => currentUser != null;

  String? get displayName {
    final meta = currentUser?.userMetadata;
    return (meta?['full_name'] as String?) ?? currentUser?.email;
  }

  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    await _client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}
