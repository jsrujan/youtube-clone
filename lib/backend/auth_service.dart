import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

 Future<void> signUp(String email, String password,) async {
    try {
      await _supabaseClient.auth.signUp(
        email: email,
        password: password,
      );
    } catch (e) {
      // Handle exception (e.g., log error, show user-friendly message)
      throw Exception('Sign up failed: $e');
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      // Handle exception
      throw Exception('Sign in failed: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _supabaseClient.auth.signOut();
    } catch (e) {
      // Handle exception
      throw Exception('Sign out failed: $e');
    }
  }
}
