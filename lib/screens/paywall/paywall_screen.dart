import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../constants.dart';
import '../../providers/subscription_provider.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/subscription_card.dart';
import '../../widgets/animated_entrance.dart';

enum _Plan { month, year }

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  _Plan _selectedPlan = _Plan.year;

  Future<void> _handlePurchase() async {
    await ref.read(subscriptionProvider.notifier).subscribe();
    if (mounted) context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.screenPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20),
                        AnimatedEntrance(child: _buildHeader()),
                        const SizedBox(height: 32),
                        AnimatedEntrance(
                          delay: const Duration(milliseconds: 80),
                          child: _buildFeatures(),
                        ),
                        const SizedBox(height: 36),
                        AnimatedEntrance(
                          delay: const Duration(milliseconds: 140),
                          child: _buildPlanTitle(),
                        ),
                        const SizedBox(height: 12),
                        AnimatedEntrance(
                          delay: const Duration(milliseconds: 180),
                          child: SubscriptionCard(
                            label: AppStrings.yearPlanLabel,
                            price: AppStrings.yearPlanPrice,
                            period: AppStrings.yearPlanPeriod,
                            badge: AppStrings.yearPlanBadge,
                            subtitle: AppStrings.yearPlanMonthly,
                            isSelected: _selectedPlan == _Plan.year,
                            onTap: () =>
                                setState(() => _selectedPlan = _Plan.year),
                          ),
                        ),
                        const SizedBox(height: 10),
                        AnimatedEntrance(
                          delay: const Duration(milliseconds: 220),
                          child: SubscriptionCard(
                            label: AppStrings.monthPlanLabel,
                            price: AppStrings.monthPlanPrice,
                            period: AppStrings.monthPlanPeriod,
                            isSelected: _selectedPlan == _Plan.month,
                            onTap: () =>
                                setState(() => _selectedPlan = _Plan.month),
                          ),
                        ),
                        const SizedBox(height: 28),
                      ],
                    ),
                  ),
                ),
                _buildBottomActions(),
              ],
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
          alignment: const Alignment(-0.6, -1.3),
          child: Container(
            width: 360,
            height: 360,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.28),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: const Alignment(1.4, 0.2),
          child: Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.accentPink.withValues(alpha: 0.18),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            gradient: AppGradients.primary,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryGlow,
                blurRadius: 24,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(
            Icons.workspace_premium_rounded,
            color: Colors.white,
            size: 32,
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          AppStrings.appName,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          AppStrings.paywallSubtitle,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  Widget _buildFeatures() {
    const features = AppContent.paywallFeatures;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
          decoration: BoxDecoration(
            color: AppColors.glassWhite,
            borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: features
                .map(
                  (f) => Column(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: f.$3.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: f.$3.withValues(alpha: 0.25),
                          ),
                        ),
                        child: Icon(f.$1, color: f.$3, size: 24),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        f.$2,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildPlanTitle() {
    return const Text(
      AppStrings.paywallTitle,
      style: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.3,
      ),
    );
  }

  Widget _buildBottomActions() {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.screenPadding,
            16,
            AppDimensions.screenPadding,
            32,
          ),
          decoration: BoxDecoration(
            color: AppColors.bg.withValues(alpha: 0.7),
            border: Border(
              top: BorderSide(color: AppColors.glassBorder),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedEntrance(
                delay: const Duration(milliseconds: 260),
                child: PrimaryButton(
                  label: AppStrings.paywallButton,
                  onTap: _handlePurchase,
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {},
                child: const Text(
                  AppStrings.paywallRestore,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
