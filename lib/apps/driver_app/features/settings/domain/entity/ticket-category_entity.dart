import 'package:equatable/equatable.dart';

class TicketCategoryEntity extends Equatable {
  final int id;
  final String name;

  const TicketCategoryEntity({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}
