import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/router/router.dart';
import 'app/theme/app_theme.dart';
import 'data/api/services/crashlytics_service.dart';
import 'data/bloc/app_bloc.dart';
import 'data/command/app/bootstrap_command.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Run the bootstrap sequence (inits storage, api, auth, and container).
  // If Firebase is selected, it is initialized inside this command.
  final container = await BootstrapCommand.execute();

  // Configure global handlers after bootstrap so Crashlytics is available
  // when Firebase was selected, and AppLogger is used otherwise.
  CrashlyticsService.setupErrorHandlers();

  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(appBlocProvider.select((s) => s.themeMode));

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'ABCD Architecture',
      themeMode: themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}
