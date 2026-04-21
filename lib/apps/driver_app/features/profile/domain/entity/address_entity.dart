import 'package:equatable/equatable.dart';

class AddressEntity extends Equatable {
  final int? id;
  final String? label;
  final String? type;
  final String? location;

  const AddressEntity({this.id, this.label, this.type, this.location});

  @override
  List<Object?> get props => [label, type, location];
}
