import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/extensions.dart';
import '../../data/command/auth/auth_command.dart';
import '../../widgets/loading_overlay.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final _controller = TextEditingController();

  Future<void> _verify() async {
    final otp = _controller.text.trim();
    if (otp.isEmpty) return;

    final verificationId = GoRouterState.of(context).extra as String?;
    if (verificationId == null) {
      context.showSnackBar('Invalid session', isError: true);
      return;
    }

    LoadingOverlay.show(context);
    final success = await AuthCommand().verifyOtp(otp, verificationId);
    LoadingOverlay.hide();

    if (!success && mounted) {
      context.showSnackBar('Invalid OTP', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Enter the 6-digit code sent to you.\n(Hint: For mock backend, use "123456")',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'OTP',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 6,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _verify,
              child: const Text('Verify & Login'),
            ),
          ],
        ),
      ),
    );
  }
}
