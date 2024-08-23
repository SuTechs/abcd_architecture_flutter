import 'dart:developer';

import '../../data/user/user.dart';
import '../commands.dart';

class SetCurrentUserCommand extends BaseAppCommand {
  Future<void> run(UserData user) async {
    log("SetCurrentUserCommand: $user");
    // Update appBloc with new user. If user is null, this acts as a logout command.
    firebase.userId = user.id;
    appBloc.currentUser = user;

    // fetch the user data from firestore if given non null user id
    final id = firebase.userId;
    if (appBloc.isAuthenticated && id != null && id != "guest") {
      UserData? user = await firebase.getUser(id);
      if (user != null) {
        appBloc.currentUser = user;
        log("User loaded from firebase: ${user.toJson()}");
      }
    }

    appBloc.save();
  }

  Future<void> logout() async {
    await firebase.signOut();

    // reset other bloc as well
    // otherBloc.reset();

    // reset app bloc
    appBloc.reset();
  }
}
