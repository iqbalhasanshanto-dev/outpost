import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
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

    final mockFacilities = [
      (
        name: 'মান্দা উপজেলা স্বাস্থ্য কমপ্লেক্স',
        nameEn: 'Manda Upazila Health Complex',
        type: strings.facilityTypeHospital,
        distance: '১.৮ কিমি · 1.8 km',
        phone: '০১৭XXXXXXXX',
        hasEmergency: true,
      ),
      (
        name: 'কালিকাপুর কমিউনিটি ক্লিনিক',
        nameEn: 'Kalikapur Community Clinic',
        type: strings.facilityTypeClinic,
        distance: '৩.২ কিমি · 3.2 km',
        phone: '০১৮XXXXXXXX',
        hasEmergency: false,
      ),
      (
        name: 'জনসেবা ফার্মেসি ও প্রাথমিক চিকিৎসা',
        nameEn: 'Jonoseba Pharmacy & First Aid',
        type: strings.facilityTypePharmacy,
        distance: '০.৫ কিমি · 0.5 km',
        phone: '০১৯XXXXXXXX',
        hasEmergency: false,
      ),
    ];

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
              // Facilities list
              Expanded(
                child: ListView.separated(
                  itemCount: mockFacilities.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSpacing.mdCompact),
                  itemBuilder: (context, index) {
                    final item = mockFacilities[index];
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
                              color: item.hasEmergency
                                  ? AppColors.emergencyRedLight
                                  : AppColors.primaryLight,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              item.hasEmergency
                                  ? Icons.local_hospital
                                  : Icons.medical_services_outlined,
                              color: item.hasEmergency
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
                                  item.name,
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
                                      item.distance,
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
                                      '• ${item.type}',
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
                                  content: Text('Dialing ${item.name}...'),
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
