import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/providers.dart';
import '../data/app/app_state.dart';

final appBlocProvider = NotifierProvider<AppBloc, AppState>(AppBloc.new);

class AppBloc extends Notifier<AppState> {
  static const _onboardingKey = 'app_onboarding_complete';
  static const _themeKey = 'app_theme_mode'; // 'light', 'dark', 'system'

  @override
  AppState build() {
    // Read initial state synchronously from cache if possible
    final localStorage = ref.read(localStorageProvider);
    final isOnboardingComplete = localStorage.getBool(_onboardingKey) ?? false;

    final themeStr = localStorage.getString(_themeKey);
    ThemeMode themeMode = ThemeMode.system;
    if (themeStr == 'light') themeMode = ThemeMode.light;
    if (themeStr == 'dark') themeMode = ThemeMode.dark;

    return AppState(
      hasBootstrapped: false,
      isOnboardingComplete: isOnboardingComplete,
      themeMode: themeMode,
    );
  }

  void markBootstrapped() {
    state = state.copyWith(hasBootstrapped: true);
  }

  Future<void> markOnboardingComplete() async {
    state = state.copyWith(isOnboardingComplete: true);
    await ref.read(localStorageProvider).setBool(_onboardingKey, true);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    final str = mode == ThemeMode.light
        ? 'light'
        : mode == ThemeMode.dark
        ? 'dark'
        : 'system';
    await ref.read(localStorageProvider).setString(_themeKey, str);
  }
}
