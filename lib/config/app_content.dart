import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_gradients.dart';
import 'app_strings.dart';

class AppContent {
  // Home: Quick Access grid (icon, label, accent colour)
  static const homeFeatures = <(IconData, String, Color)>[
    (Icons.article_rounded, AppStrings.homeFeature1, AppColors.primary),
    (Icons.flash_on_rounded, AppStrings.homeFeature2, AppColors.accentPink),
    (Icons.recommend_rounded, AppStrings.homeFeature3, AppColors.accentTeal),
    (Icons.download_done_rounded, AppStrings.homeFeature4, AppColors.accentAmber),
  ];

  // Home: Popular content (title, subtitle, gradient)
  static const popularItems = <(String, String, LinearGradient)>[
    (AppStrings.popularItem1Title, AppStrings.popularItem1Sub, AppGradients.primary),
    (AppStrings.popularItem2Title, AppStrings.popularItem2Sub, AppGradients.warm),
    (AppStrings.popularItem3Title, AppStrings.popularItem3Sub, AppGradients.teal),
    (AppStrings.popularItem4Title, AppStrings.popularItem4Sub, AppGradients.cool),
  ];

  // Explore: image paths for categories (4 images available)
  static const categoryImagePaths = <String>[
    'lib/assets/image.png',
    'lib/assets/image1.png',
    'lib/assets/image2.png',
    'lib/assets/image3.png',
  ];

  // Explore: fallback gradients for categories that have no image
  static const categoryFallbackGradients = <LinearGradient>[
    AppGradients.primary,
    AppGradients.warm,
  ];

  // Explore: total number of category tiles shown in the grid
  static const exploreCategoryCount = 6;

  // Paywall: feature highlights (icon, label, accent colour)
  static const paywallFeatures = <(IconData, String, Color)>[
    (Icons.bolt_rounded, AppStrings.paywallFeature1, AppColors.primary),
    (Icons.block_rounded, AppStrings.paywallFeature2, AppColors.accentPink),
    (Icons.devices_rounded, AppStrings.paywallFeature3, AppColors.accentTeal),
  ];
}
