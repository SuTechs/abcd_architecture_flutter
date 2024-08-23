import '../../data/user/user.dart';
import '../commands.dart';
import 'set_current_user_command.dart';

class AuthenticateUserCommand extends BaseAppCommand {
  Future<void> signInWithGoogle() async {
    final userId = await firebase.signInWithGoogle();

    if (userId == null) return;

    await SetCurrentUserCommand().run(
      UserData(
        id: userId,
        name: '',
        createdAt: 0,
        updatedAt: 0,
      ),
    );

    // sync hive and firebase
    // refresh all data from firebase
    // fetch all firebase and sync with hive
    // fetch all hive and sync with firebase

    // // force server refresh library books
    // await LibraryCommand().refreshLibraryBooks(true);

    // // force server refresh user questions
    // final allUserQuestions = await firebase.getAllUserAttemptedQuestion(userId);
    // if (allUserQuestions != null && allUserQuestions.isNotEmpty) {
    //   hive.addAllUserQuestion(allUserQuestions);
    // }
  }
}
