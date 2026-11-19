import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// Low-literacy friendly symptom selection card.
///
/// Features a prominent medical icon, bilingual or clear bold label,
/// and a high-contrast selected state with checkmark indicator.
class SymptomCard extends StatelessWidget {
  /// Creates a [SymptomCard].
  const SymptomCard({
    super.key,
    required this.id,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  /// Unique symptom identifier.
  final String id;

  /// Display text label.
  final String label;

  /// Prominent visual icon.
  final IconData icon;

  /// Whether this symptom is currently selected.
  final bool isSelected;

  /// Callback when user taps the card.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSpacing.cardBorderRadius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.mdCompact,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryLight : AppColors.surfaceCard,
            borderRadius: AppSpacing.cardBorderRadius,
            border: Border.all(
              color: isSelected ? AppColors.primaryTeal : AppColors.outlineBorder,
              width: isSelected ? 2.0 : 1.0,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primaryTeal.withValues(alpha: 0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: 34,
                      color: isSelected
                          ? AppColors.primaryTeal
                          : AppColors.textPrimary,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 14,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w600,
                            color: isSelected
                                ? AppColors.primaryTeal
                                : AppColors.textPrimary,
                          ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Positioned(
                  top: 2,
                  right: 2,
                  child: Icon(
                    Icons.check_circle,
                    size: 18,
                    color: AppColors.primaryTeal,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
