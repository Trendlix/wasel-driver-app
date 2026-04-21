import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/domain/entity/ticket_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/domain/repository/settings_repository.dart';

class SubmitTicketUsecase {
  final SettingsRepository _ticketRepository;

  SubmitTicketUsecase(this._ticketRepository);

  Future<Either<String, String>> submitTicket(TicketEntity ticket) async {
    return await _ticketRepository.submitTicket(ticket);
  }
}
