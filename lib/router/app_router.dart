import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../constants.dart';
import '../providers/subscription_provider.dart';
import '../screens/onboarding/onboarding_screen_1.dart';
import '../screens/onboarding/onboarding_screen_2.dart';
import '../screens/paywall/paywall_screen.dart';
import '../screens/home/home_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final isSubscribed = ref.read(subscriptionProvider);

  return GoRouter(
    initialLocation: isSubscribed ? AppRoutes.home : AppRoutes.onboarding1,
    routes: [
      GoRoute(
        path: AppRoutes.onboarding1,
        builder: (context, state) => const OnboardingScreen1(),
      ),
      GoRoute(
        path: AppRoutes.onboarding2,
        pageBuilder: (context, state) => _sheetPage(state, const OnboardingScreen2()),
      ),
      GoRoute(
        path: AppRoutes.paywall,
        pageBuilder: (context, state) => _sheetPage(state, const PaywallScreen()),
      ),
      GoRoute(
        path: AppRoutes.home,
        pageBuilder: (context, state) => _sheetPage(state, const HomeScreen()),
      ),
    ],
  );
});

CustomTransitionPage<void> _sheetPage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 480),
    reverseTransitionDuration: const Duration(milliseconds: 320),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final slide = Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      ));

      final fade = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: animation,
          curve: const Interval(0, 0.4, curve: Curves.easeOut),
        ),
      );

      final scaleOut = Tween<double>(begin: 1, end: 0.94).animate(
        CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeInCubic),
      );

      return ScaleTransition(
        scale: scaleOut,
        child: FadeTransition(
          opacity: fade,
          child: SlideTransition(position: slide, child: child),
        ),
      );
    },
  );
}
