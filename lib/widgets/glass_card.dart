import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? radius;
  final Color? borderColor;
  final Gradient? gradient;
  final List<BoxShadow>? shadows;
  final double blurSigma;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.radius,
    this.borderColor,
    this.gradient,
    this.shadows,
    this.blurSigma = 24,
  });

  @override
  Widget build(BuildContext context) {
    final r = radius ?? AppDimensions.cardRadius;
    return ClipRRect(
      borderRadius: BorderRadius.circular(r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          padding: padding ?? const EdgeInsets.all(AppDimensions.cardPadding),
          decoration: BoxDecoration(
            gradient: gradient,
            color: gradient == null ? AppColors.glassWhite : null,
            borderRadius: BorderRadius.circular(r),
            border: Border.all(
              color: borderColor ?? AppColors.glassBorder,
              width: 1,
            ),
            boxShadow: shadows,
          ),
          child: child,
        ),
      ),
    );
  }
}
