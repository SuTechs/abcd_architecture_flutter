import '../api/firebase/firebase_service.dart';
import '../api/hive/hive_service.dart';
import '../bloc/app_bloc.dart';
import '../bloc/quiz_bloc.dart';
import '../utils/logger.dart';
import 'app/set_current_user_command.dart';

typedef AppBuilder = Future<void> Function(AppBloc appBloc, QuizBloc quizBloc);

abstract class BaseAppCommand {
  static bool _init = false;

  static late final FirebaseService _firebase;

  static late final HiveService _hive;

  static final _appBloc = AppBloc(_firebase, _hive);

  static final _quizBloc = QuizBloc();

  // getters

  FirebaseService get firebase => _firebase;

  HiveService get hive => _hive;

  AppBloc get appBloc => _appBloc;

  QuizBloc get quizBloc => _quizBloc;

  /// init

  Future<void> init(AppBuilder appBuilder) async {
    if (_init) return;

    _firebase = await FirebaseFactory.create();
    _hive = await HiveFactory.create();

    ///

    log("Bootstrap Started, v${AppBloc.kVersion}");
    // Load AppBloc ASAP
    appBloc.load();

    log("BootstrapCommand - AppModel Loaded, user = ${appBloc.currentUser} and login status = ${firebase.isSignedIn}");

    if (firebase.isSignedIn == false && appBloc.currentUser != null) {
      log("Ran into 005auth problems = ${appBloc.currentUser}");
      // If we previously has a user, it's unexpected that firebase has lost auth. Give it some extra time.
      await Future<void>.delayed(const Duration(seconds: 1));
      // See if we don't have auth now...
      if (firebase.isSignedIn == false) {
        //Still no auth, clear the stale user data.
        // TODO: Can we try some sort of re-auth here instead of just bailing
        appBloc.currentUser = null;
      }
    }

    log("BootstrapCommand - Init services");
    // Init services
    // firebaseNotification.init();

    // Login?
    if (appBloc.currentUser != null) {
      log("BootstrapCommand - Set current user");
      await SetCurrentUserCommand().run(appBloc.currentUser);
    }

    appBloc.hasBootstrapped = true;
    log("BootstrapCommand - Complete");

    appBuilder(appBloc, quizBloc);
    _init = true;
  }
}
