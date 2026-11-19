import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/assets/mock_facilities.dart';
import '../../domain/entities/triage_models.dart';
import '../state/language_provider.dart';
import '../widgets/outpost_app_bar.dart';

/// Screen displaying mock nearest health facilities and emergency transport routes.
///
/// Designed to work completely offline with cached geospatial facility data
/// for rural districts (e.g., Upazila Health Complex, Community Clinics).
class NearestFacilityScreen extends ConsumerWidget {
  /// Creates the [NearestFacilityScreen].
  const NearestFacilityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(stringsProvider);

    return Scaffold(
      appBar: const OutpostAppBar(showBackButton: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.base),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.facilityTitle,
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          strings.facilitySubtitle,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.mdCompact,
                      vertical: 6.0,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: AppSpacing.badgeBorderRadius,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.cloud_off,
                          size: 14,
                          color: AppColors.primaryTeal,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          'Offline',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppColors.primaryTeal,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.base),
              // Simulated offline map card container
              Container(
                height: 140,
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
                      size: 64,
                      color: AppColors.outlineBorder,
                    ),
                    Positioned(
                      bottom: AppSpacing.md,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceWhite,
                          borderRadius: AppSpacing.badgeBorderRadius,
                          border: Border.all(color: AppColors.outlineBorder),
                        ),
                        child: Text(
                          'OpenStreetMap Offline Cache (Manda District)',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.base),
              // Facilities list from mock_facilities.dart
              Expanded(
                child: ListView.separated(
                  itemCount: mockFacilities.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSpacing.mdCompact),
                  itemBuilder: (context, index) {
                    final item = mockFacilities[index];
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
                        children: [
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
                                  ? Icons.local_hospital
                                  : item.type == FacilityType.pharmacy
                                      ? Icons.local_pharmacy_outlined
                                      : Icons.medical_services_outlined,
                              color: isHospital
                                  ? AppColors.emergencyRed
                                  : AppColors.primaryTeal,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.nameBn,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontSize: 15,
                                      ),
                                ),
                                Text(
                                  item.nameEn,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Row(
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
                                    const SizedBox(width: AppSpacing.sm),
                                    Text(
                                      '• $typeLabel',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.phone_outlined,
                              color: AppColors.primaryTeal,
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Dialing ${item.nameEn}...'),
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
              // Return to Home button
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.splash,
                    (route) => false,
                  );
                },
                child: Text(strings.navHome),
              ),
              const SizedBox(height: AppSpacing.base),
            ],
          ),
        ),
      ),
    );
  }
}
