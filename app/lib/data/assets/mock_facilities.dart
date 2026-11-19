import '../../domain/entities/triage_models.dart';

/// Realistic mock health facilities data for Phase 1 offline prototype demonstration.
///
/// Models healthcare facilities in a typical rural Bangladesh upazila (Manda, Naogaon),
/// including primary community clinics, union sub-centers, secondary upazila complexes,
/// private pharmacies, and tertiary district hospitals.
const List<FacilityItem> mockFacilities = [
  FacilityItem(
    id: 'manda_uhc',
    nameBn: 'মান্দা উপজেলা স্বাস্থ্য কমপ্লেক্স',
    nameEn: 'Manda Upazila Health Complex',
    type: FacilityType.hospital,
    distanceKm: 1.8,
    travelTimeMin: 12,
    phone: '০১৭XXXXXXXX',
    isOpenNow: true,
  ),
  FacilityItem(
    id: 'kalikapur_cc',
    nameBn: 'কালিকাপুর কমিউনিটি ক্লিনিক',
    nameEn: 'Kalikapur Community Clinic',
    type: FacilityType.clinic,
    distanceKm: 1.2,
    travelTimeMin: 8,
    phone: '০১৮XXXXXXXX',
    isOpenNow: true,
  ),
  FacilityItem(
    id: 'kusumba_usc',
    nameBn: 'কুসুম্বা ইউনিয়ন স্বাস্থ্য ও পরিবার কল্যাণ কেন্দ্র',
    nameEn: 'Kusumba Union Health Sub-Center',
    type: FacilityType.clinic,
    distanceKm: 3.5,
    travelTimeMin: 20,
    phone: '০১৭XXXXXXXX',
    isOpenNow: false,
  ),
  FacilityItem(
    id: 'jonoseba_pharmacy',
    nameBn: 'জনসেবা ফার্মেসি ও প্রাথমিক চিকিৎসা কেন্দ্র',
    nameEn: 'Jonoseba Pharmacy & First Aid Post',
    type: FacilityType.pharmacy,
    distanceKm: 0.6,
    travelTimeMin: 5,
    phone: '০১৯XXXXXXXX',
    isOpenNow: true,
  ),
  FacilityItem(
    id: 'naogaon_dh',
    nameBn: 'নওগাঁ ২৫০ শয্যা বিশিষ্ট জেলা সদর হাসপাতাল',
    nameEn: 'Naogaon 250-Bed District Sadar Hospital',
    type: FacilityType.hospital,
    distanceKm: 8.4,
    travelTimeMin: 35,
    phone: '০৭৪১XXXXX',
    isOpenNow: true,
  ),
];
