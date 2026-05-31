import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../constants.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/animated_entrance.dart';

class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          _GlowBackground(
            blobs: const [
              _GlowBlob(
                alignment: Alignment(-1.1, -1.2),
                color: AppColors.primary,
                size: 380,
                opacity: 0.22,
              ),
              _GlowBlob(
                alignment: Alignment(1.3, 1.2),
                color: AppColors.accentPink,
                size: 280,
                opacity: 0.14,
              ),
            ],
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.screenPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(flex: 2),
                  AnimatedEntrance(
                    duration: const Duration(milliseconds: 700),
                    child: _buildIllustration(),
                  ),
                  const SizedBox(height: 52),
                  AnimatedEntrance(
                    delay: const Duration(milliseconds: 120),
                    child: _buildText(),
                  ),
                  const Spacer(flex: 3),
                  AnimatedEntrance(
                    delay: const Duration(milliseconds: 220),
                    child: _buildPageIndicator(0),
                  ),
                  const SizedBox(height: 20),
                  AnimatedEntrance(
                    delay: const Duration(milliseconds: 280),
                    child: PrimaryButton(
                      label: AppStrings.onboarding1Button,
                      onTap: () => context.go(AppRoutes.onboarding2),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIllustration() {
    return Center(
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppGradients.primary,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGlow,
              blurRadius: 70,
              spreadRadius: 10,
            ),
          ],
        ),
        child: const Icon(
          Icons.auto_awesome_rounded,
          size: 76,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildText() {
    return Column(
      children: [
        const Text(
          AppStrings.onboarding1Title,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 36,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.8,
            height: 1.1,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        const Text(
          AppStrings.onboarding1Body,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 17,
            height: 1.6,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPageIndicator(int activePage) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(2, (i) {
        final isActive = i == activePage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 28 : 8,
          height: 8,
          decoration: BoxDecoration(
            gradient: isActive ? AppGradients.primary : null,
            color: isActive ? null : AppColors.textMuted,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

class _GlowBackground extends StatelessWidget {
  final List<_GlowBlob> blobs;
  const _GlowBackground({required this.blobs});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: blobs
          .map((b) => Align(
                alignment: b.alignment,
                child: Container(
                  width: b.size,
                  height: b.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        b.color.withValues(alpha: b.opacity),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }
}

class _GlowBlob {
  final AlignmentGeometry alignment;
  final Color color;
  final double size;
  final double opacity;

  const _GlowBlob({
    required this.alignment,
    required this.color,
    required this.size,
    required this.opacity,
  });
}
