import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../constants.dart';
import '../../providers/subscription_provider.dart';
import '../../widgets/animated_entrance.dart';
import '../../widgets/glass_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedTab = 0;

  static const _tabs = [
    (Icons.home_rounded, AppStrings.navHome),
    (Icons.explore_rounded, AppStrings.navExplore),
    (Icons.person_rounded, AppStrings.navProfile),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      extendBody: true,
      body: Stack(
        children: [
          _buildBackground(),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 320),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: child,
            ),
            child: _selectedTab == 0
                ? _HomeTab(key: const ValueKey(0))
                : _selectedTab == 1
                    ? _ExploreTab(key: const ValueKey(1))
                    : _ProfileTab(
                        key: const ValueKey(2),
                        onUnsubscribe: _handleUnsubscribe,
                      ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBackground() {
    return Stack(
      children: [
        Align(
          alignment: const Alignment(-1.2, -0.8),
          child: Container(
            width: 300,
            height: 300,
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
        Align(
          alignment: const Alignment(1.3, 0.6),
          child: Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.accentTeal.withValues(alpha: 0.12),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          height: AppDimensions.bottomNavHeight +
              MediaQuery.of(context).padding.bottom,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.75),
            border: Border(
              top: BorderSide(color: AppColors.glassBorder),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(_tabs.length, (i) {
              final isActive = i == _selectedTab;
              return GestureDetector(
                onTap: () => setState(() => _selectedTab = i),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.primary.withValues(alpha: 0.15)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        child: Icon(
                          _tabs[i].$1,
                          color: isActive
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 4),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 250),
                        style: TextStyle(
                          color: isActive
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          fontSize: 11,
                          fontWeight: isActive
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                        child: Text(_tabs[i].$2),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Future<void> _handleUnsubscribe() async {
    await ref.read(subscriptionProvider.notifier).unsubscribe();
    if (mounted) context.go(AppRoutes.onboarding1);
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom +
        AppDimensions.bottomNavHeight +
        16;

    return CustomScrollView(
      slivers: [
        _buildAppBar(),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            AppDimensions.screenPadding,
            20,
            AppDimensions.screenPadding,
            bottomPad,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              AnimatedEntrance(child: _buildGreeting()),
              const SizedBox(height: 24),
              AnimatedEntrance(
                delay: const Duration(milliseconds: 80),
                child: _buildSectionTitle(AppStrings.homeSectionQuickAccess),
              ),
              const SizedBox(height: 12),
              AnimatedEntrance(
                delay: const Duration(milliseconds: 120),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: AppContent.homeFeatures.map(_buildFeatureCard).toList(),
                ),
              ),
              const SizedBox(height: 24),
              AnimatedEntrance(
                delay: const Duration(milliseconds: 180),
                child: _buildSectionTitle(AppStrings.homeSectionPopular),
              ),
              const SizedBox(height: 12),
              ...List.generate(
                AppContent.popularItems.length,
                (i) => AnimatedEntrance(
                  delay: Duration(milliseconds: 220 + i * 50),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _buildContentItem(AppContent.popularItems[i]),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      pinned: true,
      elevation: 0,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            color: AppColors.bg.withValues(alpha: 0.65),
          ),
        ),
      ),
      title: const Text(
        AppStrings.homeTitle,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildGreeting() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppGradients.greetingCard,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGlow,
            blurRadius: 28,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.workspace_premium_rounded,
                color: Colors.white,
                size: 28,
              ),
              const SizedBox(width: 10),
              Text(
                AppStrings.premiumLabel,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            AppStrings.homeGreeting,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            AppStrings.homeSubGreeting,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.78),
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.3,
      ),
    );
  }

  Widget _buildFeatureCard((IconData, String, Color) feature) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: feature.$3.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(
                color: feature.$3.withValues(alpha: 0.28),
              ),
            ),
            child: Icon(feature.$1, color: feature.$3, size: 22),
          ),
          const SizedBox(height: 12),
          Text(
            feature.$2,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            AppStrings.homeMaterialCount,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentItem((String, String, LinearGradient) item) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: item.$3,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.play_arrow_rounded,
                color: Colors.white, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.$1,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.$2,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.bookmark_border_rounded,
            color: AppColors.textMuted,
            size: 20,
          ),
        ],
      ),
    );
  }
}

class _ExploreTab extends StatelessWidget {
  const _ExploreTab({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom +
        AppDimensions.bottomNavHeight +
        16;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.transparent,
          pinned: true,
          elevation: 0,
          flexibleSpace: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(color: AppColors.bg.withValues(alpha: 0.65)),
            ),
          ),
          title: const Text(
            AppStrings.navExplore,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            AppDimensions.screenPadding,
            20,
            AppDimensions.screenPadding,
            bottomPad,
          ),
          sliver: SliverGrid.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
            children: List.generate(
              AppContent.exploreCategoryCount,
              (i) => AnimatedEntrance(
                delay: Duration(milliseconds: i * 50),
                child: GlassCard(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: i < AppContent.categoryImagePaths.length
                              ? Image.asset(
                                  AppContent.categoryImagePaths[i],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    gradient: AppContent.categoryFallbackGradients[
                                        i - AppContent.categoryImagePaths.length],
                                  ),
                                  child: const Center(
                                    child: Text(
                                      r'\o/',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${AppStrings.exploreCategoryPrefix} ${i + 1}',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Text(
                        AppStrings.exploreMaterialCount,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileTab extends StatelessWidget {
  final VoidCallback onUnsubscribe;
  const _ProfileTab({super.key, required this.onUnsubscribe});

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom +
        AppDimensions.bottomNavHeight +
        16;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.transparent,
          pinned: true,
          elevation: 0,
          flexibleSpace: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(color: AppColors.bg.withValues(alpha: 0.65)),
            ),
          ),
          title: const Text(
            AppStrings.navProfile,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            AppDimensions.screenPadding,
            20,
            AppDimensions.screenPadding,
            bottomPad,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              AnimatedEntrance(
                child: GlassCard(
                  child: Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          gradient: AppGradients.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryGlow,
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        AppStrings.profileTitle,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        AppStrings.profileSubtitle,
                        style: TextStyle(
                          color: AppColors.accentTeal,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              AnimatedEntrance(
                delay: const Duration(milliseconds: 80),
                child: GlassCard(
                  child: Column(
                    children: [
                      _buildMenuItem(Icons.notifications_rounded, AppStrings.profileNotifications),
                      const Divider(color: AppColors.glassBorder, height: 1),
                      _buildMenuItem(Icons.language_rounded, AppStrings.profileLanguage),
                      const Divider(color: AppColors.glassBorder, height: 1),
                      _buildMenuItem(Icons.help_outline_rounded, AppStrings.profileSupport),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              AnimatedEntrance(
                delay: const Duration(milliseconds: 140),
                child: GlassCard(
                  child: _buildMenuItem(
                    Icons.logout_rounded,
                    AppStrings.homeUnsubscribe,
                    color: AppColors.accentPink,
                    onTap: onUnsubscribe,
                  ),
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String label, {
    Color color = AppColors.textPrimary,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textMuted,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
