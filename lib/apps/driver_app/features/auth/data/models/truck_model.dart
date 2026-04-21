import 'package:wasel_driver/apps/driver_app/features/auth/domain/entities/truck_entity.dart';

class TruckTypeModel extends TruckTypeEntity {
  const TruckTypeModel({
    super.id,
    super.name,
    super.description,
    super.widthInCm,
    super.heightInCm,
    super.lengthInCm,
    super.capacity,
    super.capacityUnit,
  });

  factory TruckTypeModel.fromJson(Map<String, dynamic> json) {
    return TruckTypeModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      widthInCm: json['width_in_cm'] as int?,
      heightInCm: json['height_in_cm'] as int?,
      lengthInCm: json['length_in_cm'] as int?,
      capacity: json['capacity'] as int?,
      capacityUnit: json['capacity_unit'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'width_in_cm': widthInCm,
      'height_in_cm': heightInCm,
      'length_in_cm': lengthInCm,
      'capacity': capacity,
      'capacity_unit': capacityUnit,
    };
  }
}
