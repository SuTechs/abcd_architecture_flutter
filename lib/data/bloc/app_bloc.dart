import '../api/firebase/firebase_service.dart';
import '../api/hive/hive_service.dart';
import '../data/user.dart';
import 'abstract.dart';

class AppBloc extends AbstractBloc {
  static const kVersion = "BETA 1.0.0+1";

  AppBloc(this._firebase, this._hive);

  // State
  final FirebaseService _firebase;
  final HiveService _hive;

  void reset() {
    currentUser = null;
  }

  /// Startup
  // to be used to bootstrap the app
  bool _hasBootstrapped = false;

  bool get hasBootstrapped => _hasBootstrapped;

  set hasBootstrapped(bool value) => notify(() => _hasBootstrapped = value);

  /// Auth
  // Current User
  UserData? _currentUser;

  UserData? get currentUser => _currentUser;

  set currentUser(UserData? currentUser) {
    notify(() => _currentUser = currentUser);
  }

  bool get isFirebaseSignedIn => _firebase.isSignedIn;

  bool get hasUser => currentUser != null;

  bool get isAuthenticated => hasUser && isFirebaseSignedIn;

  String? get currentUserId => currentUser?.id;

  Future<void> save() async {
    final user = currentUser;
    if (user != null) {
      await _hive.saveUser(user);
    }
  }

  Future<void> load() async {
    final user = _hive.getSavedUserData;
    if (user != null) {
      currentUser = user;
    }
  }
}
