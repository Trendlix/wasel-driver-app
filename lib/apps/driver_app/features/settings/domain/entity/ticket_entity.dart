import 'dart:io';

import 'package:equatable/equatable.dart';

class TicketEntity extends Equatable {
  final String subject;
  final String category;
  final String priority;
  final String description;
  final List<File> files;

  const TicketEntity({
    required this.subject,
    required this.category,
    required this.priority,
    required this.description,
    required this.files,
  });

  @override
  List<Object?> get props => [subject, category, priority, description, files];
}
