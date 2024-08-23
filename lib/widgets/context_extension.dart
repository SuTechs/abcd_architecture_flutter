import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../data/bloc/app_bloc.dart';
import '../data/bloc/purchase_bloc.dart';

extension ContextExtension on BuildContext {
  AppBloc get appBloc => read<AppBloc>();

  bool get watchIsPremium =>
      select<PurchaseBloc, bool>((PurchaseBloc bloc) => bloc.isPremium);

  bool get readIsPremium => read<PurchaseBloc>().isPremium;

  // network
  bool get watchIsOffline =>
      select<PurchaseBloc, bool>((PurchaseBloc bloc) => bloc.isOffline);

  bool get readIsOffline => read<PurchaseBloc>().isOffline;

// // night mode
// bool get watchIsNightMode =>
//     select<NightMode, bool>((NightMode bloc) => bloc.isNight);
}
