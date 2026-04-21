import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/driver_app/features/home/domain/repositories/home_repository.dart';

class SendDriverOfferUsecase {
  final HomeRepository? _homeRepository;

  SendDriverOfferUsecase({required HomeRepository? homeRepository})
    : _homeRepository = homeRepository;

  Future<Either<String, bool>> call(
    int requestId,
    int pricebyDriver,
    double locationLat,
    double locationLong,
  ) {
    return _homeRepository!.sendDriverOffer(
      requestId,
      pricebyDriver,
      locationLat,
      locationLong,
    );
  }
}
