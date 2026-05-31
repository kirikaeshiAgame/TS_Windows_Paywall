import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../constants.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/animated_entrance.dart';

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          _buildBackground(),
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
                    delay: const Duration(milliseconds: 100),
                    child: _buildText(),
                  ),
                  const Spacer(flex: 3),
                  AnimatedEntrance(
                    delay: const Duration(milliseconds: 200),
                    child: _buildPageIndicator(1),
                  ),
                  const SizedBox(height: 20),
                  AnimatedEntrance(
                    delay: const Duration(milliseconds: 260),
                    child: PrimaryButton(
                      label: AppStrings.onboarding2Button,
                      onTap: () => context.go(AppRoutes.paywall),
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

  Widget _buildBackground() {
    return Stack(
      children: [
        Align(
          alignment: const Alignment(1.2, -1.0),
          child: Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.accentTeal.withValues(alpha: 0.2),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: const Alignment(-1.3, 1.1),
          child: Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.18),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIllustration() {
    return Center(
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppGradients.teal,
          boxShadow: [
            BoxShadow(
              color: AppColors.accentTeal.withValues(alpha: 0.35),
              blurRadius: 70,
              spreadRadius: 8,
            ),
          ],
        ),
        child: const Icon(
          Icons.collections_bookmark_rounded,
          size: 76,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildText() {
    return const Column(
      children: [
        Text(
          AppStrings.onboarding2Title,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 36,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.8,
            height: 1.1,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16),
        Text(
          AppStrings.onboarding2Body,
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
