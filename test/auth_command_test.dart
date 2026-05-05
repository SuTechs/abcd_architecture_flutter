import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:abcd_architecture_flutter/data/api/providers.dart';
import 'package:abcd_architecture_flutter/data/api/mock/mock_service.dart';
import 'package:abcd_architecture_flutter/data/command/base_command.dart';
import 'package:abcd_architecture_flutter/data/command/auth/auth_command.dart';
import 'package:abcd_architecture_flutter/data/data/app/app_constants.dart';

import 'helpers/memory_local_storage_service.dart';

void main() {
  test('AuthCommand login flow', () async {
    // Setup
    final storage = MemoryLocalStorageService();
    await storage.init();

    final mockApi = MockService();
    mockApi.setStorage(storage);
    await mockApi.init();

    final container = ProviderContainer(
      overrides: [
        apiServiceProvider.overrideWithValue(mockApi),
        localStorageProvider.overrideWithValue(storage),
      ],
    );
    addTearDown(container.dispose);

    BaseCommand.init(container);
    final authCommand = AuthCommand();

    // Test sendOtp
    final vid = await authCommand.sendOtp(AuthMethod.email, 'test@example.com');
    expect(vid, isNotNull);

    // Test verifyOtp
    final success = await authCommand.verifyOtp('123456', vid!);
    expect(success, isTrue);

    expect(mockApi.isSignedIn, isTrue);

    // Test logout
    await authCommand.logout();
    expect(mockApi.isSignedIn, isFalse);
    expect(storage.getBool('is_guest_session'), isNull);
  });
}
