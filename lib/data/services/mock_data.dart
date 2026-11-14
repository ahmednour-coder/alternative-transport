import '../../core/constants/app_constants.dart';
import '../models/reservation.dart';
import '../models/user_document.dart';
import '../models/vehicle.dart';

/// Jeu de données de démonstration, aligné sur les maquettes du projet.
abstract final class MockData {
  static const vehicles = <Vehicle>[
    Vehicle(
      id: 'v-bika-01',
      name: 'Bika',
      brand: 'Bika',
      type: 'Électrique',
      rangeKm: 120,
      maxSpeed: 80,
      seats: 4,
      pricePerDay: 12,
      pricePerHour: 3,
      distanceKm: 2.3,
      battery: 100,
      imageAsset: AppConstants.carBika,
      equipment: ['Climatisation', 'Bluetooth', 'GPS', 'Caméra de recul'],
      rating: 4.8,
      reviews: 32,
      pin: Offset2(0.18, 0.46),
    ),
    Vehicle(
      id: 'v-dacia-02',
      name: 'Dacia Spring',
      brand: 'Dacia',
      type: 'Électrique',
      rangeKm: 230,
      maxSpeed: 125,
      seats: 4,
      pricePerDay: 18,
      pricePerHour: 4.5,
      distanceKm: 1.1,
      battery: 86,
      imageAsset: AppConstants.carDacia,
      equipment: ['Climatisation', 'Bluetooth', 'Recharge rapide'],
      rating: 4.6,
      reviews: 18,
      pin: Offset2(0.79, 0.66),
    ),
    Vehicle(
      id: 'v-twizy-03',
      name: 'Renault Twizy',
      brand: 'Renault',
      type: 'Petite',
      rangeKm: 90,
      maxSpeed: 80,
      seats: 2,
      pricePerDay: 9,
      pricePerHour: 2.5,
      distanceKm: 3.2,
      battery: 72,
      imageAsset: AppConstants.carBika,
      equipment: ['Bluetooth', 'GPS'],
      rating: 4.4,
      reviews: 12,
      pin: Offset2(0.62, 0.22),
    ),
  ];

  static List<Reservation> reservations() {
    final now = DateTime.now();
    return [
      Reservation(
        id: 'r-1003',
        vehicle: vehicles[0],
        start: DateTime(now.year, now.month, now.day - 1, 10, 0),
        end: DateTime(now.year, now.month, now.day - 1, 14, 0),
        total: 14,
        status: ReservationStatus.completed,
      ),
      Reservation(
        id: 'r-1002',
        vehicle: vehicles[0],
        start: DateTime(now.year, now.month, now.day - 3, 14, 30),
        end: DateTime(now.year, now.month, now.day - 3, 16, 30),
        total: 8,
        status: ReservationStatus.completed,
      ),
      Reservation(
        id: 'r-1001',
        vehicle: vehicles[1],
        start: DateTime(now.year, now.month, now.day - 5, 9, 0),
        end: DateTime(now.year, now.month, now.day - 5, 12, 0),
        total: 12,
        status: ReservationStatus.completed,
      ),
    ];
  }

  static const documents = <UserDocument>[
    UserDocument(
      id: 'doc-cin',
      label: 'Carte d’identité nationale',
      status: DocumentStatus.validated,
      description:
          'Recto et verso vérifiés. Les informations correspondent à votre profil.',
      reference: 'CIN • 09xxxxxx',
    ),
    UserDocument(
      id: 'doc-permis',
      label: 'Permis de conduire',
      status: DocumentStatus.validated,
      description:
          'Permis scanné et validé. Catégorie B, valable jusqu’en 2029.',
      reference: 'Permis • 12xxxxxx',
    ),
    UserDocument(
      id: 'doc-domicile',
      label: 'Justificatif de domicile',
      status: DocumentStatus.pending,
      description:
          'Document reçu. La vérification est en cours, elle prend en général moins de 24 heures.',
    ),
  ];

  static const brands = ['Tous', 'Bika', 'Dacia', 'Renault'];
  static const types = ['Tous', 'Électrique', 'Petite'];
  static const equipment = [
    'Climatisation',
    'Bluetooth',
    'GPS',
    'Caméra de recul',
    'Recharge rapide',
  ];
}
