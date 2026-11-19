import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/assets/mock_facilities.dart';
import '../../domain/entities/triage_models.dart';
import '../state/language_provider.dart';
import '../state/triage_provider.dart';
import '../widgets/offline_status_banner.dart';
import '../widgets/outpost_app_bar.dart';

/// Screen displaying mock nearest health facilities and emergency transport routes.
///
/// Designed per Figma frame "10 · Nearby facilities". Works completely offline
/// with pre-cached geospatial facility data for rural upazilas (Upazila Health
/// Complex, Community Clinics, Union Sub-Centers, and Pharmacies).
class NearestFacilityScreen extends ConsumerWidget {
  /// Creates the [NearestFacilityScreen].
  const NearestFacilityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(stringsProvider);
    final isBangla = ref.watch(languageProvider).code == 'bn';

    // Sort facilities by distance ascending
    final sortedFacilities = List<FacilityItem>.from(mockFacilities)
      ..sort((a, b) => a.distanceKm.compareTo(b.distanceKm));

    return Scaffold(
      appBar: const OutpostAppBar(showBackButton: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.xs),
              const Center(child: OfflineStatusBanner(compact: true)),
              const SizedBox(height: AppSpacing.base),

              // Title Header
              Text(
                strings.facilityTitle,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                strings.facilitySubtitle,
                style: Theme.of(context).textTheme.bodySmall,
              ),

              const SizedBox(height: AppSpacing.md),

              // Offline Region Map Preview Card (Figma 10 · Nearby facilities)
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: AppSpacing.cardBorderRadius,
                  border: Border.all(color: AppColors.outlineBorder),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(
                      Icons.map_outlined,
                      size: 58,
                      color: AppColors.outlineBorder,
                    ),
                    Positioned(
                      bottom: AppSpacing.sm,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceWhite,
                          borderRadius: AppSpacing.badgeBorderRadius,
                          border: Border.all(color: AppColors.outlineBorder),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.location_on_rounded,
                              size: 14,
                              color: AppColors.primaryTeal,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              strings.offlineMapPreview,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.base),

              // Sorted Facilities List
              Expanded(
                child: ListView.separated(
                  itemCount: sortedFacilities.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSpacing.mdCompact),
                  itemBuilder: (context, index) {
                    final item = sortedFacilities[index];
                    final isHospital = item.type == FacilityType.hospital;

                    final typeLabel = switch (item.type) {
                      FacilityType.hospital => strings.facilityTypeHospital,
                      FacilityType.clinic => strings.facilityTypeClinic,
                      FacilityType.pharmacy => strings.facilityTypePharmacy,
                    };

                    return Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceCard,
                        borderRadius: AppSpacing.cardBorderRadius,
                        border: Border.all(color: AppColors.outlineBorder),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Facility icon badge
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.mdCompact),
                            decoration: BoxDecoration(
                              color: isHospital
                                  ? AppColors.emergencyRedLight
                                  : AppColors.primaryLight,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isHospital
                                  ? Icons.local_hospital_rounded
                                  : item.type == FacilityType.pharmacy
                                      ? Icons.local_pharmacy_rounded
                                      : Icons.medical_services_rounded,
                              color: isHospital
                                  ? AppColors.emergencyRed
                                  : AppColors.primaryTeal,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),

                          // Facility info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isBangla ? item.nameBn : item.nameEn,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Text(
                                  isBangla ? item.nameEn : item.nameBn,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Wrap(
                                  spacing: AppSpacing.sm,
                                  crossAxisAlignment:
                                      WrapCrossAlignment.center,
                                  children: [
                                    Text(
                                      '${item.distanceKm} km · ${item.travelTimeMin} min',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            color: AppColors.primaryTeal,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    Text(
                                      '• $typeLabel',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall,
                                    ),
                                    // Open status indicator
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: item.isOpenNow
                                            ? AppColors.homeCareGreenLight
                                            : AppColors.outlineBorder
                                                .withValues(alpha: 0.3),
                                        borderRadius:
                                            AppSpacing.badgeBorderRadius,
                                      ),
                                      child: Text(
                                        item.isOpenNow
                                            ? strings.statusOpenNow
                                            : strings.statusClosed,
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          color: item.isOpenNow
                                              ? AppColors.homeCareGreen
                                              : AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Direct Call Action button
                          IconButton.filledTonal(
                            style: IconButton.styleFrom(
                              backgroundColor: AppColors.primaryLight,
                              foregroundColor: AppColors.primaryTeal,
                            ),
                            icon: const Icon(
                              Icons.phone_rounded,
                              size: 20,
                            ),
                            tooltip: strings.callFacility,
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Simulated calling ${isBangla ? item.nameBn : item.nameEn} (${item.phone})',
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              // Action button to start new demo check
              ElevatedButton(
                onPressed: () {
                  ref.read(triageProvider.notifier).reset();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.splash,
                    (route) => false,
                  );
                },
                child: Text(strings.startNewCheck),
              ),
              const SizedBox(height: AppSpacing.base),
            ],
          ),
        ),
      ),
    );
  }
}
