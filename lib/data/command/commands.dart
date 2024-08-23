import 'dart:developer';

import '../api/firebase/firebase_service.dart';
import '../api/hive/hive_service.dart';
import '../bloc/app_bloc.dart';
import '../bloc/other_bloc.dart';
import '../bloc/purchase_bloc.dart';
import '../data/user/user.dart';
import '../utils/time_utils.dart';
import 'app/set_current_user_command.dart';

export '../api/firebase/service_extension.dart';

abstract class BaseAppCommand {
  static bool _init = false;

  static late final FirebaseService _firebase;

  static late final HiveService _hive;

  static final blocApp = AppBloc(_firebase, _hive);

  static final purchase = PurchaseBloc();

  static final blocOther = OtherBloc();

  /// add other blocs here

  // getters for sub classes of BaseAppCommand
  FirebaseService get firebase => _firebase;

  HiveService get hive => _hive;

  AppBloc get appBloc => blocApp;

  PurchaseBloc get purchaseBloc => purchase;

  OtherBloc get otherBloc => blocOther;

  /// init

  Future<void> init() async {
    if (_init) return;

    final futures = <Future>[
      FirebaseFactory.create().then((value) => _firebase = value),
      HiveFactory.create().then((value) => _hive = value),
    ];

    await Future.wait(futures);

    // // Initialize the Mobile Ads SDK
    // MobileAds.instance.initialize();

    ///

    log("Bootstrap Started, v${AppBloc.kVersion}");
    // Load AppBloc ASAP
    // appBloc.load();

    log("BootstrapCommand - AppModel Loaded, user = ${appBloc.currentUser} and login status = ${firebase.isSignedIn}");

    final user = appBloc.currentUser;

    /// initialize guest user first time
    if (user.id != "guest") {
      // If we have a user, but it's not the guest user, we need to make sure we have a valid user in firebase.
      // If we don't, we need to clear the user data.

      if (firebase.isSignedIn == false) {
        log("Ran into 001auth problems = ${appBloc.currentUser}");
        // If we previously has a user, it's unexpected that firebase has lost auth. Give it some extra time.
        await Future<void>.delayed(const Duration(seconds: 1));
        // See if we don't have auth now...
        if (firebase.isSignedIn == false) {
          //Still no auth, clear the stale user data and set it to guest.
          appBloc.currentUser = UserData(
            id: "guest",
            name: "Guest",
            phone: '',
            createdAt: TimeUtils.nowMillis,
            updatedAt: TimeUtils.nowMillis,
          );
        }
      } else {
        // login?
        log("BootstrapCommand - Set current user");
        await SetCurrentUserCommand().run(appBloc.currentUser);
      }
    }

    log("BootstrapCommand - Init services");
    // Init services
    // firebaseNotification.init();

    appBloc.hasBootstrapped = true;
    log("BootstrapCommand - Complete");
    _init = true;
  }
}
