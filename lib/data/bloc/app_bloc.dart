import '../../constants.dart';
import '../api/firebase/firebase_service.dart';
import '../api/hive/hive_service.dart';
import '../api/hive/service_extension.dart';
import '../data/user/user.dart';
import '../utils/time_utils.dart';
import 'abstract.dart';

class AppBloc extends AbstractBloc {
  static const kVersion = kAppVersion;

  AppBloc(this._firebase, this._hive);

  // State
  final FirebaseService _firebase;
  final HiveService _hive;

  void reset() {
    // on reset create a new guest user
    currentUser = UserData(
      id: "guest",
      name: "Guest",
      createdAt: TimeUtils.nowMillis,
      updatedAt: TimeUtils.nowMillis,
    );

    // reset library and hive stuff
    _hive.reset();
  }

  /// Startup
  // to be used to bootstrap the app
  bool _hasBootstrapped = false;

  bool get hasBootstrapped => _hasBootstrapped;

  set hasBootstrapped(bool value) => notify(() => _hasBootstrapped = value);

  /// Auth
  // Current User
  late UserData _currentUser = _hive.getSavedUserData ??
      UserData(
        id: "guest",
        name: "Guest",
        phone: '',
        createdAt: TimeUtils.nowMillis,
        updatedAt: TimeUtils.nowMillis,
      );

  UserData get currentUser => _currentUser;

  set currentUser(UserData currentUser) {
    notify(() => _currentUser = currentUser);
  }

  bool get isFirebaseSignedIn => _firebase.isSignedIn;

  bool get isGuestUser => currentUser.id == "guest";

  bool get isAuthenticated => isFirebaseSignedIn && !isGuestUser;

  bool get isShowOnboarding => _hive.getIsShowOnboarding();

  String get currentUserId => currentUser.id;

  Future<void> save() async {
    final user = currentUser;
    await _hive.saveUser(user);
  }
}
