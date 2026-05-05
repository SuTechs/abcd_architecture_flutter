import '../core/base_api_service.dart';
import 'supabase_init.dart';
import 'supabase_native.dart';
import 'repo/supabase_todo_repo.dart';
import 'repo/supabase_user_repo.dart';

/// Supabase implementation of [BaseApiService].
///
/// Core auth & storage live here. Feature repos are mixed in:
///   - [SupabaseUserRepo] — user CRUD
///   - [SupabaseTodoRepo] — todo CRUD
class SupabaseService extends BaseApiService
    with SupabaseUserRepo, SupabaseTodoRepo {
  late final SupabaseNative _native;
  String? _lastDestination;
  bool _lastWasEmail = false;

  /// Exposed for repo mixins to access raw Supabase operations.
  @override
  SupabaseNative get native => _native;

  @override
  Future<void> init() async {
    final initialized = await SupabaseInit.initialize();
    if (!initialized) {
      throw StateError('Supabase failed to initialize.');
    }
    _native = SupabaseNative();
  }

  @override
  bool get isSignedIn => native.currentUser != null;

  @override
  String? get currentUserId => native.currentUser?.id;

  // ── Auth ─────────────────────────────────────────────────

  @override
  Future<String?> sendOtp({
    required String destination,
    required bool isEmail,
  }) async {
    try {
      await native.signInWithOtp(phoneOrEmail: destination, isEmail: isEmail);
      _lastDestination = destination;
      _lastWasEmail = isEmail;
      return destination; // Use destination as verificationId
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String?> verifyOtp({
    required String otp,
    required String verificationId,
  }) async {
    try {
      final dest = _lastDestination ?? verificationId;
      final res = await native.verifyOtp(
        phoneOrEmail: dest,
        otp: otp,
        isEmail: _lastWasEmail,
      );
      return res.user?.id;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String?> signInWithGoogle() async {
    try {
      final res = await native.signInWithGoogle();
      return res.user?.id;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String?> signInWithApple() async {
    try {
      final res = await native.signInWithApple();
      return res.user?.id;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    await native.signOut();
  }

  // ── Storage ──────────────────────────────────────────────

  @override
  Future<String?> uploadFile(String localPath, String remotePath) async {
    try {
      return await native.uploadFile('public', localPath, remotePath);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> deleteFile(String remotePath) async {
    try {
      await native.deleteFile('public', remotePath);
      return true;
    } catch (e) {
      return false;
    }
  }
}
