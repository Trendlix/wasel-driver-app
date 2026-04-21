import 'package:equatable/equatable.dart';

class TruckTypeEntity extends Equatable {
  final int? id;
  final String? name;
  final String? description;
  final int? widthInCm;
  final int? heightInCm;
  final int? lengthInCm;
  final int? capacity;
  final String? capacityUnit;

  const TruckTypeEntity({
    this.id,
    this.name,
    this.description,
    this.widthInCm,
    this.heightInCm,
    this.lengthInCm,
    this.capacity,
    this.capacityUnit,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    widthInCm,
    heightInCm,
    lengthInCm,
    capacity,
    capacityUnit,
  ];
}
