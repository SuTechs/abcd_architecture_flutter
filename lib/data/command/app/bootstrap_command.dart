import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/mock/mock_service.dart';
import '../../api/providers.dart';
import '../../../widgets/ads/ads_service.dart';
import '../../bloc/app_bloc.dart';
import '../../bloc/auth_bloc.dart';
import '../base_command.dart';
import '../purchase/purchase_command.dart';

/// Handles the entire app initialization sequence before `runApp`.
class BootstrapCommand {
  /// Initializes services, sets up the ProviderContainer, and wires BaseCommand.
  /// Returns the configured container to be passed to `UncontrolledProviderScope`.
  static Future<ProviderContainer> execute() async {
    // 1. Config is injected via --dart-define-from-file at compile-time

    // 2. Create Riverpod container
    // To switch backends, override here:
    // final container = ProviderContainer(overrides: [
    //   apiServiceProvider.overrideWithValue(FirebaseService()),
    // ]);
    final container = ProviderContainer();

    // 3. Initialize independent services in parallel
    //    Storage must init first so MockService can hydrate from cache.
    final localStorage = container.read(localStorageProvider);
    await localStorage.init();

    // 4. Inject storage into mock backend (if active) before API init
    final apiService = container.read(apiServiceProvider);
    if (apiService is MockService) {
      apiService.setStorage(localStorage);
    }
    await apiService.init();

    // 5. Wire the global container to BaseCommand so all commands have `ref`
    BaseCommand.init(container);

    // 6. Initialize monetization (IAP) & resolve auth state in parallel
    await Future.wait([
      PurchaseCommand().init(),
      container.read(authBlocProvider.future),
    ]);

    // 7. Initialize & preload ads (fire-and-forget — non-blocking)
    AdsService.initialize().then((_) {
      AdsService.loadInterstitial();
      AdsService.loadRewarded();
    });

    // 8. Mark app as fully bootstrapped to hide splash screen
    container.read(appBlocProvider.notifier).markBootstrapped();

    return container;
  }
}
