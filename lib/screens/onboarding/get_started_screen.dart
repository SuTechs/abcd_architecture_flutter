import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/bloc/app_bloc.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isShowOnboarding =
        context.select((AppBloc bloc) => bloc.isShowOnboarding);

    if (isShowOnboarding) {
      return const Placeholder(
        child: Text('Onboarding Placeholder'),
      );
    }

    return const Placeholder(
      child: Text('Get Started (Login) Placeholder'),
    );
  }
}
