import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/core/base_api_service.dart';
import '../api/local/local_storage_service.dart';
import '../api/providers.dart';
import '../bloc/app_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/purchase_bloc.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/user_bloc.dart';

/// The foundation for all business logic.
///
/// Screens never pass [Ref] to commands. Instead, [BaseCommand] uses a static
/// [ProviderContainer] set during app bootstrap.
///
/// Every feature command (e.g. [AuthCommand]) extends this class to get instant
/// access to the API, Local Storage, and all Blocs via `ref`.
abstract class BaseCommand {
  static late ProviderContainer _container;

  /// Initialize the global container for commands.
  static void init(ProviderContainer container) {
    _container = container;
  }

  @protected
  ProviderContainer get ref => _container;

  // ── Services ─────────────────────────────────────────────

  BaseApiService get api => ref.read(apiServiceProvider);
  LocalStorageService get localStorage => ref.read(localStorageProvider);

  // ── Blocs ────────────────────────────────────────────────

  AppBloc get appBloc => ref.read(appBlocProvider.notifier);
  AuthBloc get authBloc => ref.read(authBlocProvider.notifier);
  TodoBloc get todoBloc => ref.read(todoBlocProvider.notifier);
  UserBloc get userBloc => ref.read(userBlocProvider.notifier);
  PurchaseBloc get purchaseBloc => ref.read(purchaseBlocProvider.notifier);
}
