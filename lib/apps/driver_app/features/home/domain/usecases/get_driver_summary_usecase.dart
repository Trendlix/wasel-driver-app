import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/home/data/models/driver_summary_model.dart';
import 'package:wasel_driver/apps/driver_app/features/home/domain/entities/driver_summary_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/home/domain/repositories/home_repository.dart';

class GetDriverSummaryUsecase {
  final HomeRepository? _homeRepository;

  GetDriverSummaryUsecase({required HomeRepository? homeRepository})
    : _homeRepository = homeRepository;

  Future<Either<String, DriverSummaryEntity>> call() async {
    return await _homeRepository!.getDriverSummary();
  }
}
