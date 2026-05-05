import 'package:flutter/material.dart';
import '../base_command.dart';

class AppCommand extends BaseCommand {
  Future<void> completeOnboarding() async {
    await appBloc.markOnboardingComplete();
  }

  Future<void> changeTheme(ThemeMode mode) async {
    await appBloc.setThemeMode(mode);
  }
}
