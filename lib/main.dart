import 'dart:ui';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/api/firebase/analytics_repository.dart';
import 'data/bloc/app_bloc.dart';
import 'data/command/app/bootstrap_commands.dart';
import 'data/command/commands.dart';
import 'screens/home.dart';
import 'screens/onboarding/get_started_screen.dart';
import 'theme.dart';

void main() async {
  await BootstrapCommand().init();

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // MobileAds.instance.initialize();

  runApp(
    MultiProvider(
      providers: [
        // App Bloc - handle global app state
        ChangeNotifierProvider.value(value: BaseAppCommand.blocApp),

        // Purchase Bloc - handle in-app purchases
        ChangeNotifierProvider.value(value: BaseAppCommand.purchase),

        // Other Blocs -- test
        ChangeNotifierProvider.value(value: BaseAppCommand.blocOther),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightColorScheme, darkColorScheme) {
        return MaterialApp(
          navigatorObservers: [
            AnalyticsRepository.observer,
          ],
          debugShowCheckedModeBanner: false,
          title: 'ABCD Architecture Flutter',
          theme: AppTheme.lightTheme(lightColorScheme),
          darkTheme: AppTheme.darkTheme(darkColorScheme),
          home: const _AppBootstrapper(),
        );
      },
    );
  }
}

class _AppBootstrapper extends StatelessWidget {
  const _AppBootstrapper();

  @override
  Widget build(BuildContext context) {
    final isAuthenticated =
        context.select<AppBloc, bool>((bloc) => bloc.isAuthenticated);

    // Handle if guest user is onboarded
    // final isOnboardingCompleted =
    // context.select((AppBloc bloc) => bloc.selectedBookId != null);
    //
    // if (isOnboardingCompleted) return const HomeScreen();
    //
    // if (isAuthenticated) {
    //   return const SelectBookOnboarding();
    // }

    if (isAuthenticated) return const HomeScreen();

    return const GetStartedScreen();
  }
}
