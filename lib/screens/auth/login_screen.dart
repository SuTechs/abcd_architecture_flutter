import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/routes.dart';
import '../../app/theme/extensions.dart';
import '../../data/command/auth/auth_command.dart';
import '../../data/data/app/app_constants.dart';
import '../../widgets/loading_overlay.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();
  AuthMethod _method = AuthMethod.email;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    final value = _controller.text.trim();
    if (value.isEmpty) return;

    LoadingOverlay.show(context);
    final verificationId = await AuthCommand().sendOtp(_method, value);
    LoadingOverlay.hide();

    if (verificationId != null) {
      if (mounted) {
        context.push(AppRoutes.verifyOtp, extra: verificationId);
      }
    } else {
      if (mounted) context.showSnackBar('Failed to send OTP', isError: true);
    }
  }

  Future<void> _socialLogin(bool isGoogle) async {
    LoadingOverlay.show(context);
    final success = isGoogle
        ? await AuthCommand().signInWithGoogle()
        : await AuthCommand().signInWithApple();
    LoadingOverlay.hide();

    if (!success && mounted) {
      context.showSnackBar('Sign in failed', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => AuthCommand().signInAsGuest(),
            child: const Text('Skip'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primary.withValues(alpha: 0.08),
              colorScheme.surface,
              colorScheme.tertiary.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Branding ──
                    Icon(
                      Icons.architecture_rounded,
                      size: 64,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'ABCD Architecture',
                      textAlign: TextAlign.center,
                      style: context.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Sign in to continue',
                      textAlign: TextAlign.center,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // ── Auth Method Toggle ──
                    SegmentedButton<AuthMethod>(
                      segments: const [
                        ButtonSegment(
                          value: AuthMethod.email,
                          label: Text('Email'),
                          icon: Icon(Icons.email_outlined),
                        ),
                        ButtonSegment(
                          value: AuthMethod.phone,
                          label: Text('Phone'),
                          icon: Icon(Icons.phone_outlined),
                        ),
                      ],
                      selected: {_method},
                      onSelectionChanged: (set) =>
                          setState(() => _method = set.first),
                    ),
                    const SizedBox(height: 24),

                    // ── Input ──
                    TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        labelText: _method == AuthMethod.email
                            ? 'Email Address'
                            : 'Phone Number',
                        prefixIcon: Icon(
                          _method == AuthMethod.email
                              ? Icons.email_outlined
                              : Icons.phone_outlined,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: colorScheme.surfaceContainerLowest,
                      ),
                      keyboardType: _method == AuthMethod.email
                          ? TextInputType.emailAddress
                          : TextInputType.phone,
                    ),
                    const SizedBox(height: 20),

                    // ── Send OTP ──
                    FilledButton(
                      onPressed: _sendOtp,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Send OTP',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // ── Divider ──
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'OR',
                            style: context.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // ── Google Sign-In ──
                    _SocialButton(
                      onPressed: () => _socialLogin(true),
                      icon: _googleLogo(),
                      label: 'Continue with Google',
                      backgroundColor: colorScheme.surfaceContainerLow,
                      foregroundColor: colorScheme.onSurface,
                    ),
                    const SizedBox(height: 12),

                    // ── Apple Sign-In ──
                    _SocialButton(
                      onPressed: () => _socialLogin(false),
                      icon: Icon(
                        Icons.apple,
                        size: 24,
                        color: colorScheme.onSurface,
                      ),
                      label: 'Continue with Apple',
                      backgroundColor: colorScheme.surfaceContainerLow,
                      foregroundColor: colorScheme.onSurface,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _googleLogo() {
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(painter: _GoogleLogoPainter()),
    );
  }
}

// ── Google "G" Logo Painter ──────────────────────────────────

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final double strokeWidth = w * 0.22;
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    final Rect rect = Rect.fromCenter(
      center: Offset(w / 2, h / 2),
      width: w - strokeWidth,
      height: h - strokeWidth,
    );

    const double rad = 3.14159 / 180;

    // Red (top)
    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(rect, 180 * rad, 135 * rad, false, paint);

    // Yellow (left)
    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(rect, 135 * rad, 50 * rad, false, paint);

    // Green (bottom)
    paint.color = const Color(0xFF34A853);
    canvas.drawArc(rect, 45 * rad, 95 * rad, false, paint);

    // Blue (right arc)
    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(rect, 0, 50 * rad, false, paint);

    // Blue horizontal bar
    paint.style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTRB(
        w * 0.45,
        h / 2 - strokeWidth / 2,
        w,
        h / 2 + strokeWidth / 2,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Social Login Button ──────────────────────────────────────

class _SocialButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget icon;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  const _SocialButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        side: BorderSide(color: foregroundColor.withValues(alpha: 0.15)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
