import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';

// ═══════════════════════════════════════════════
// OTP VERIFICATION SCREEN
// ═══════════════════════════════════════════════
class OtpVerificationScreen extends StatefulWidget {
  final String phoneOrEmail;

  const OtpVerificationScreen({
    super.key,
    required this.phoneOrEmail,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  int _secondsLeft = 150;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic));
    _animCtrl.forward();

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft > 0) {
        setState(() => _secondsLeft--);
      } else {
        t.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _animCtrl.dispose();
    super.dispose();
  }

  String get _timerDisplay {
    final m = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final s = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const BackButton(color: AppColors.textPrimary),
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.pagePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.xl),

                // Icon
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.accent.withOpacity(0.14),
                        AppColors.accent.withOpacity(0.06),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.accent.withOpacity(0.18),
                    ),
                  ),
                  child: const Icon(
                    Icons.shield_outlined,
                    size: 34,
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),

                Text(
                  'Verification\nCode 🔐',
                  style: AppTypography.displayMedium.copyWith(height: 1.15),
                ),
                const SizedBox(height: AppSpacing.md),
                RichText(
                  text: TextSpan(
                    style: AppTypography.bodyMedium.copyWith(fontSize: 15),
                    children: [
                      const TextSpan(text: 'We sent a 6-digit code to\n'),
                      TextSpan(
                        text: widget.phoneOrEmail,
                        style: AppTypography.labelLarge.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xxxl),

                // OTP Input
                OtpInput(onCompleted: (otp) {}),
                const SizedBox(height: AppSpacing.xxl),

                // Timer card
                _TimerCard(display: _timerDisplay, expired: _secondsLeft == 0),
                const SizedBox(height: AppSpacing.xl),

                // Resend
                Center(
                  child: _secondsLeft == 0
                      ? GestureDetector(
                          onTap: () {
                            setState(() => _secondsLeft = 150);
                            _startTimer();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.accent.withOpacity(0.1),
                              borderRadius:
                                  BorderRadius.circular(AppRadius.pill),
                            ),
                            child: Text(
                              'Resend Code',
                              style: AppTypography.labelMedium.copyWith(
                                color: AppColors.accent,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        )
                      : RichText(
                          text: TextSpan(
                            style: AppTypography.bodyMedium,
                            children: [
                              const TextSpan(text: "Didn't receive code? "),
                              TextSpan(
                                text: 'Resend',
                                style: AppTypography.labelMedium.copyWith(
                                  color: AppColors.textHint,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),

                const Spacer(),

                // Verify button
                _VerifyButton(),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Timer Card ──────────────────────────────────
class _TimerCard extends StatelessWidget {
  final String display;
  final bool expired;

  const _TimerCard({required this.display, required this.expired});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: expired
            ? AppColors.error.withOpacity(0.06)
            : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: expired
              ? AppColors.error.withOpacity(0.2)
              : AppColors.divider,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.timer_outlined,
                size: 18,
                color: expired ? AppColors.error : AppColors.textHint,
              ),
              const SizedBox(width: 8),
              Text(
                expired ? 'Code expired' : 'Code expires in',
                style: AppTypography.bodyMedium.copyWith(
                  color: expired ? AppColors.error : null,
                ),
              ),
            ],
          ),
          Text(
            display,
            style: AppTypography.labelLarge.copyWith(
              color: expired ? AppColors.error : AppColors.accent,
              fontWeight: FontWeight.w700,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Verify Button ───────────────────────────────
class _VerifyButton extends StatefulWidget {
  @override
  State<_VerifyButton> createState() => _VerifyButtonState();
}

class _VerifyButtonState extends State<_VerifyButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0,
      upperBound: 0.04,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.97).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: GestureDetector(
        onTapDown: (_) => _ctrl.forward(),
        onTapUp: (_) => _ctrl.reverse(),
        onTapCancel: () => _ctrl.reverse(),
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: AppColors.accentGradient,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            boxShadow: AppColors.accentShadow,
          ),
          child: Center(
            child: Text(
              'Verify & Continue',
              style: AppTypography.buttonLarge.copyWith(
                color: AppColors.white,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════
// OTP INPUT WIDGET — Animated boxes
// ═══════════════════════════════════════════════
class OtpInput extends StatefulWidget {
  final int length;
  final Function(String) onCompleted;

  const OtpInput({
    super.key,
    this.length = 6,
    required this.onCompleted,
  });

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  final List<TextEditingController> _controllers = [];
  final List<FocusNode> _focusNodes = [];
  final List<String> _values = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.length; i++) {
      _controllers.add(TextEditingController());
      _focusNodes.add(FocusNode());
      _values.add('');
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        widget.length,
        (i) => _OtpBox(
          controller: _controllers[i],
          focusNode: _focusNodes[i],
          onChanged: (v) {
            _values[i] = v;
            if (v.isNotEmpty && i < widget.length - 1) {
              _focusNodes[i + 1].requestFocus();
            } else if (v.isEmpty && i > 0) {
              _focusNodes[i - 1].requestFocus();
            }
            if (_values.every((e) => e.isNotEmpty)) {
              widget.onCompleted(_values.join());
            }
          },
        ),
      ),
    );
  }
}

class _OtpBox extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  State<_OtpBox> createState() => _OtpBoxState();
}

class _OtpBoxState extends State<_OtpBox> {
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(() {
      if (mounted) setState(() => _isFocused = widget.focusNode.hasFocus);
    });
  }

  @override
  Widget build(BuildContext context) {
    final filled = widget.controller.text.isNotEmpty;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 48,
      height: 58,
      decoration: BoxDecoration(
        color: _isFocused
            ? AppColors.accent.withOpacity(0.06)
            : filled
                ? AppColors.accent.withOpacity(0.04)
                : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: _isFocused
              ? AppColors.accent
              : filled
                  ? AppColors.accent.withOpacity(0.4)
                  : AppColors.divider,
          width: _isFocused ? 2 : 1.5,
        ),
        boxShadow: _isFocused ? AppColors.accentShadow : null,
      ),
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        maxLength: 1,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: AppTypography.h2.copyWith(
          color: AppColors.accent,
          fontWeight: FontWeight.w700,
        ),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        onChanged: widget.onChanged,
      ),
    );
  }
}