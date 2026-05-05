import 'dart:developer';

import 'package:uuid/uuid.dart';

import '../../data/todo/todo_data.dart';
import '../../data/user/user_data.dart';
import '../core/base_api_service.dart';
import '../local/local_storage_service.dart';
import 'repo/mock_todo_repo.dart';
import 'repo/mock_user_repo.dart';

/// In-memory mock implementation of [BaseApiService] **with Hive persistence**.
///
/// - Auth: any email/phone works, OTP is always `123456`.
/// - CRUD: stored in memory maps, written through to [LocalStorageService].
/// - Zero backend dependencies — works offline, great for testing & demo.
///
/// Feature repos are mixed in:
///   - [MockUserRepo] — user CRUD
///   - [MockTodoRepo] — todo CRUD
class MockService extends BaseApiService with MockUserRepo, MockTodoRepo {
  static const _uuid = Uuid();
  static const _mockOtp = '123456';

  // Hive cache keys
  static const _usersCacheKey = 'mock_users';
  static const _todosCacheKey = 'mock_todos';
  static const _currentUserKey = 'mock_current_user_id';

  LocalStorageService? _storage;

  // In-memory stores (hydrated from Hive on init)
  final Map<String, UserData> _users = {};
  final Map<String, ToDoData> _todos = {};

  /// Exposed for repo mixins.
  @override
  Map<String, UserData> get users => _users;
  @override
  Map<String, ToDoData> get todos => _todos;

  // Auth state
  String? _currentUserId;
  String? _pendingDestination;

  @override
  Future<void> init() async {
    if (_storage != null) _hydrateFromCache();
    log(
      '[MockService] initialized (${_users.length} users, ${_todos.length} todos cached)',
    );
  }

  /// Inject the already-initialized local storage.
  void setStorage(LocalStorageService storage) {
    _storage = storage;
  }

  // ── Persistence helpers ──────────────────────────────────

  void _hydrateFromCache() {
    // Restore current user ID
    _currentUserId = _storage?.getString(_currentUserKey);

    // Restore users
    final usersJson = _storage?.getCachedJsonList(_usersCacheKey);
    if (usersJson != null) {
      for (final json in usersJson) {
        final user = UserData.fromJson(json);
        _users[user.id] = user;
      }
    }

    // Restore todos
    final todosJson = _storage?.getCachedJsonList(_todosCacheKey);
    if (todosJson != null) {
      for (final json in todosJson) {
        final todo = ToDoData.fromJson(json);
        _todos[todo.id] = todo;
      }
    }
  }

  @override
  Future<void> persistUsers() async {
    await _storage?.cacheJsonList(
      _usersCacheKey,
      _users.values.map((u) => u.toJson()).toList(),
    );
  }

  @override
  Future<void> persistTodos() async {
    await _storage?.cacheJsonList(
      _todosCacheKey,
      _todos.values.map((t) => t.toJson()).toList(),
    );
  }

  Future<void> _persistAuthState() async {
    if (_currentUserId != null) {
      await _storage?.setString(_currentUserKey, _currentUserId!);
    } else {
      await _storage?.remove(_currentUserKey);
    }
  }

  // ── Auth ──────────────────────────────────────────────────

  @override
  Future<String?> sendOtp({
    required String destination,
    required bool isEmail,
  }) async {
    _pendingDestination = destination;
    final verificationId = _uuid.v4();
    log(
      '[MockService] OTP sent to $destination (use "$_mockOtp"). '
      'verificationId=$verificationId',
    );
    return verificationId;
  }

  @override
  Future<String?> verifyOtp({
    required String otp,
    required String verificationId,
  }) async {
    if (otp != _mockOtp) {
      log('[MockService] Invalid OTP');
      return null;
    }

    // Create or find user by destination
    final dest = _pendingDestination ?? 'mock@example.com';
    final existingUser = _users.values.where((u) {
      return u.email == dest || u.phone == dest;
    }).firstOrNull;

    if (existingUser != null) {
      _currentUserId = existingUser.id;
    } else {
      final newUser = UserData(
        id: _uuid.v4(),
        name: 'User',
        email: dest.contains('@') ? dest : '',
        phone: dest.contains('@') ? '' : dest,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      _users[newUser.id] = newUser;
      _currentUserId = newUser.id;
      await persistUsers();
    }

    await _persistAuthState();
    log('[MockService] Verified. userId=$_currentUserId');
    return _currentUserId;
  }

  @override
  Future<String?> signInWithGoogle() async {
    // Simulate Google sign in — always succeeds
    final user = UserData(
      id: _uuid.v4(),
      name: 'Google User',
      email: 'google@example.com',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _users[user.id] = user;
    _currentUserId = user.id;
    await persistUsers();
    await _persistAuthState();
    log('[MockService] Google sign-in. userId=${user.id}');
    return user.id;
  }

  @override
  Future<String?> signInWithApple() async {
    final user = UserData(
      id: _uuid.v4(),
      name: 'Apple User',
      email: 'apple@example.com',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _users[user.id] = user;
    _currentUserId = user.id;
    await persistUsers();
    await _persistAuthState();
    log('[MockService] Apple sign-in. userId=${user.id}');
    return user.id;
  }

  @override
  Future<void> signOut() async {
    log('[MockService] Signed out. was=$_currentUserId');
    _currentUserId = null;
    await _persistAuthState();
  }

  @override
  bool get isSignedIn => _currentUserId != null;

  @override
  String? get currentUserId => _currentUserId;

  // ── Storage ───────────────────────────────────────────────

  @override
  Future<String?> uploadFile(String localPath, String remotePath) async {
    log('[MockService] uploadFile: $localPath → $remotePath');
    return 'https://mock.storage/$remotePath';
  }

  @override
  Future<bool> deleteFile(String remotePath) async {
    log('[MockService] deleteFile: $remotePath');
    return true;
  }
}
