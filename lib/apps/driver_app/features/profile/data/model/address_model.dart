import 'package:wasel_driver/apps/driver_app/features/profile/domain/entity/address_entity.dart';

class AddressModel extends AddressEntity {
  const AddressModel({super.id, super.label, super.type, super.location});

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] ?? '',
      label: json['label'] ?? '',
      type: json['type'] ?? '',
      location: json['location'] ?? '',
    );
  }

  factory AddressModel.fromEntity(AddressEntity address) {
    return AddressModel(
      id: address.id,
      label: address.label,
      type: address.type,
      location: address.location,
    );
  }

  Map<String, dynamic> toJson() {
    return {'label': label, 'type': type, 'location': location};
  }
}
