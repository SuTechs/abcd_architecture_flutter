import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/config.dart';

/// Raw Supabase operations wrapper (No app-specific models)
class SupabaseNative {
  SupabaseClient get client => Supabase.instance.client;

  // Auth
  User? get currentUser => client.auth.currentUser;
  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;

  Future<void> signInWithOtp({
    required String phoneOrEmail,
    required bool isEmail,
  }) async {
    if (isEmail) {
      await client.auth.signInWithOtp(email: phoneOrEmail);
    } else {
      await client.auth.signInWithOtp(phone: phoneOrEmail);
    }
  }

  Future<AuthResponse> verifyOtp({
    required String phoneOrEmail,
    required String otp,
    required bool isEmail,
  }) async {
    return await client.auth.verifyOTP(
      type: isEmail ? OtpType.email : OtpType.sms,
      token: otp,
      email: isEmail ? phoneOrEmail : null,
      phone: !isEmail ? phoneOrEmail : null,
    );
  }

  /// Sign in with Google using native [GoogleSignIn] + Supabase token exchange.
  ///
  /// Requires Google OAuth to be configured in Supabase Dashboard.
  Future<AuthResponse> signInWithGoogle() async {
    // Web client ID should be configured for your project
    final webClientId = AppConfig.instance.supabaseGoogleWebClientId;

    final googleSignIn = GoogleSignIn(serverClientId: webClientId);

    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      throw Exception('Google sign-in cancelled');
    }

    final googleAuth = await googleUser.authentication;
    final idToken = googleAuth.idToken;
    final accessToken = googleAuth.accessToken;

    if (idToken == null) {
      throw Exception('No ID token received from Google');
    }

    return await client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  /// Sign in with Apple using native [SignInWithApple] + Supabase token exchange.
  ///
  /// Requires Apple Sign-In to be configured in Supabase Dashboard.
  Future<AuthResponse> signInWithApple() async {
    // Generate a secure random nonce
    final rawNonce = _generateNonce();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: hashedNonce,
    );

    final idToken = credential.identityToken;
    if (idToken == null) {
      throw Exception('No ID token received from Apple');
    }

    return await client.auth.signInWithIdToken(
      provider: OAuthProvider.apple,
      idToken: idToken,
      nonce: rawNonce,
    );
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  // Database
  Future<Map<String, dynamic>?> selectOne(String table, String id) async {
    return await client.from(table).select().eq('id', id).maybeSingle();
  }

  Future<List<Map<String, dynamic>>> selectWhere(
    String table,
    String field,
    dynamic value,
  ) async {
    return await client.from(table).select().eq(field, value);
  }

  Future<void> insert(String table, Map<String, dynamic> data) async {
    await client.from(table).insert(data);
  }

  Future<void> upsert(String table, Map<String, dynamic> data) async {
    await client.from(table).upsert(data);
  }

  Future<void> delete(String table, String id) async {
    await client.from(table).delete().eq('id', id);
  }

  // Storage
  Future<String> uploadFile(
    String bucket,
    String localPath,
    String remotePath,
  ) async {
    final file = File(localPath);
    await client.storage.from(bucket).upload(remotePath, file);
    return client.storage.from(bucket).getPublicUrl(remotePath);
  }

  Future<void> deleteFile(String bucket, String remotePath) async {
    await client.storage.from(bucket).remove([remotePath]);
  }

  // ── Helpers ───────────────────────────────────────────────

  /// Generates a cryptographically secure random nonce for Apple Sign-In.
  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }
}
