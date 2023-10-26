import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/command/app/bootstrap_commands.dart';
import 'data/utils/logger.dart';
import 'screens/home.dart';
import 'theme.dart';

void main() {
  initLogger(
    () async {
      BootstrapCommand().init(
        (appBloc, quizBloc) async {
          // do something here

          runApp(
            MultiProvider(
              providers: [
                // AppBloc - Stores data related to global settings or app modes
                ChangeNotifierProvider.value(value: appBloc),
                // QuizBloc - Handle Quiz Logic
                ChangeNotifierProvider.value(value: appBloc),
              ],
              child: const MyApp(),
            ),
          );
        },
      );
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightColorScheme, darkColorScheme) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ABCD Architecture',
          theme: AppTheme.lightTheme(lightColorScheme),
          darkTheme: AppTheme.darkTheme(darkColorScheme),
          home: const Home(),
        );
      },
    );
  }
}
