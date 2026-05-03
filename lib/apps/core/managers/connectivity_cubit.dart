import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel_driver/apps/core/enums/app_enums.dart';
import 'package:wasel_driver/apps/core/services/network_connectivity_service.dart';

class ConnectivityCubit extends Cubit<NetworkStatus> {
  ConnectivityCubit() : super(NetworkStatus.online) {
    _initializeConnectivity();
  }

  StreamSubscription<NetworkStatus>? _connectivitySubscription;

  void _initializeConnectivity() {
    // Get initial status
    _updateStatus(NetworkConnectivityService.instance.currentStatus);

    // Listen to connectivity changes
    _connectivitySubscription =
        NetworkConnectivityService.instance.onStatusChanged.listen(
      (status) {
        _updateStatus(status);
      },
      onError: (_) {
        _updateStatus(NetworkStatus.noInternet);
      },
    );
  }

  void _updateStatus(NetworkStatus status) {
    if (isClosed) return;
    emit(status);
  }

  Future<void> retryConnection() async {
    final status = await NetworkConnectivityService.instance.refresh();
    _updateStatus(status);
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
