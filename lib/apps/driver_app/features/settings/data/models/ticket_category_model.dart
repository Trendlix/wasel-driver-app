import 'package:wasel_driver/apps/driver_app/features/settings/domain/entity/ticket-category_entity.dart';

class TicketCategoryModel extends TicketCategoryEntity {
  const TicketCategoryModel({required super.id, required super.name});

  factory TicketCategoryModel.fromJson(Map<String, dynamic> json) {
    return TicketCategoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
