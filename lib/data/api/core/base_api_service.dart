import 'todo_api_extension.dart';
import 'user_api_extension.dart';

/// The API contract that every backend must implement.
///
/// Core methods (auth, storage) live here.
/// Feature-specific methods are added via mixins:
///   - [UserApiMixin] — user CRUD
///   - [TodoApiMixin] — todo CRUD
///
/// To add a new feature:
///   1. Create `core/xyz_api_extension.dart` with a mixin
///   2. Add `with XyzApiMixin` below
///   3. Compiler forces all backends to implement it ✅
abstract class BaseApiService with UserApiMixin, TodoApiMixin {
  /// Initialize the backend (Firebase.initializeApp, Supabase.initialize, etc.)
  Future<void> init();

  // ── Auth ─────────────────────────────────────────────────

  /// Send OTP to email or phone. Returns a verification ID (or session token).
  Future<String?> sendOtp({required String destination, required bool isEmail});

  /// Verify OTP. Returns user ID on success, null on failure.
  Future<String?> verifyOtp({
    required String otp,
    required String verificationId,
  });

  /// Sign in with Google. Returns user ID on success, null on failure.
  /// Throws [UnimplementedError] if not configured for the backend.
  Future<String?> signInWithGoogle();

  /// Sign in with Apple. Returns user ID on success, null on failure.
  /// Throws [UnimplementedError] if not configured for the backend.
  Future<String?> signInWithApple();

  /// Sign out the current user.
  Future<void> signOut();

  /// Whether a user is currently signed in.
  bool get isSignedIn;

  /// The current user's ID, or null if not signed in.
  String? get currentUserId;

  // ── Storage ──────────────────────────────────────────────

  /// Upload a file and return its download URL.
  Future<String?> uploadFile(String localPath, String remotePath);

  /// Delete a remote file. Returns true on success.
  Future<bool> deleteFile(String remotePath);
}
