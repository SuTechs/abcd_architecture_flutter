import '../core/base_api_service.dart';
import 'http_init.dart';
import 'http_native.dart';
import 'repo/http_todo_repo.dart';
import 'repo/http_user_repo.dart';

/// HTTP (REST API) implementation of [BaseApiService].
///
/// Core auth & storage live here. Feature repos are mixed in:
///   - [HttpUserRepo] — user CRUD
///   - [HttpTodoRepo] — todo CRUD
class HttpService extends BaseApiService with HttpUserRepo, HttpTodoRepo {
  final HttpNative _native = HttpNative();
  String? _currentUserId;

  /// Exposed for repo mixins to access raw HTTP operations.
  @override
  HttpNative get native => _native;

  @override
  Future<void> init() async {
    await HttpInit.initialize();
  }

  @override
  bool get isSignedIn => _currentUserId != null;

  @override
  String? get currentUserId => _currentUserId;

  // ── Auth ─────────────────────────────────────────────────

  @override
  Future<String?> sendOtp({
    required String destination,
    required bool isEmail,
  }) async {
    try {
      final res = await _native.post(
        '/auth/send-otp',
        data: {'destination': destination, 'type': isEmail ? 'email' : 'phone'},
      );
      return res.data['verificationId'] as String?;
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
      final res = await _native.post(
        '/auth/verify-otp',
        data: {'otp': otp, 'verificationId': verificationId},
      );
      final token = res.data['token'] as String?;
      final userId = res.data['userId'] as String?;

      if (token != null && userId != null) {
        _native.setAuthToken(token);
        _currentUserId = userId;
        return userId;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String?> signInWithGoogle() async {
    throw UnimplementedError(
      'Requires native Google Sign-In and sending token to custom backend',
    );
  }

  @override
  Future<String?> signInWithApple() async {
    throw UnimplementedError('Requires sending token to custom backend');
  }

  @override
  Future<void> signOut() async {
    _native.clearAuthToken();
    _currentUserId = null;
  }

  // ── Storage ──────────────────────────────────────────────

  @override
  Future<String?> uploadFile(String localPath, String remotePath) async {
    throw UnimplementedError('Requires multipart request implementation');
  }

  @override
  Future<bool> deleteFile(String remotePath) async {
    try {
      await _native.delete('/files', data: {'path': remotePath});
      return true;
    } catch (e) {
      return false;
    }
  }
}
