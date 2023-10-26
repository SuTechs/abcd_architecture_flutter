import '../../data/user.dart';
import '../../utils/logger.dart';
import '../commands.dart';

class SetCurrentUserCommand extends BaseAppCommand {
  Future<void> run(UserData? user) async {
    log("SetCurrentUserCommand: $user");
    // Update appBloc with new user. If user is null, this acts as a logout command.
    firebase.userId = user?.id;
    appBloc.currentUser = user;

    // fetch the user data from firestore if given non null user id
    final id = firebase.userId;
    if (id != null) {
      UserData? user = await firebase.getUser(id);
      if (user != null) {
        appBloc.currentUser = user;
        log("User loaded from firebase: ${user.toJson()}");
      }
    }

    // If currentUser is null here, then we've either logged out, or auth failed.
    if (appBloc.currentUser == null) {
      appBloc.reset();
    }

    appBloc.save();
  }

  Future<void> logout() async {
    await firebase.signOut();
    await run(null);
  }
}
