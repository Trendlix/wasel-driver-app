import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:wasel_driver/apps/core/enums/app_enums.dart';

class NetworkConnectivityService {
  NetworkConnectivityService._();

  static final NetworkConnectivityService _instance =
      NetworkConnectivityService._();
  static NetworkConnectivityService get instance => _instance;

  final Connectivity _connectivity = Connectivity();
  final InternetConnectionChecker _internetChecker =
      InternetConnectionChecker();

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  StreamSubscription<InternetConnectionStatus>? _internetSubscription;

  final StreamController<NetworkStatus> _networkStatusController =
      StreamController<NetworkStatus>.broadcast();

  NetworkStatus _currentStatus = NetworkStatus.offline;

  /// Get current network status
  NetworkStatus get currentStatus => _currentStatus;

  /// Stream of network status changes
  Stream<NetworkStatus> get onStatusChanged => _networkStatusController.stream;

  /// Check initial connectivity status
  static Future<NetworkStatus> checkConnectivity() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      final hasConnection = !connectivityResult.contains(
        ConnectivityResult.none,
      );

      if (!hasConnection) {
        return NetworkStatus.noInternet;
      }

      // Check actual internet connection
      final hasInternet = await InternetConnectionChecker().hasConnection;
      return hasInternet ? NetworkStatus.online : NetworkStatus.noInternet;
    } catch (e) {
      return NetworkStatus.noInternet;
    }
  }

  /// Initialize and start listening to network changes
  Future<void> initialize() async {
    // Check initial status
    _currentStatus = await checkConnectivity();
    _networkStatusController.add(_currentStatus);

    // Listen to connectivity changes (WiFi/Mobile data)
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _handleConnectivityChange,
      onError: (error) {
        _currentStatus = NetworkStatus.noInternet;
        _networkStatusController.add(_currentStatus);
      },
    );

    // Listen to actual internet connection changes
    _internetSubscription = _internetChecker.onStatusChange.listen(
      _handleInternetStatusChange,
      onError: (error) {
        _currentStatus = NetworkStatus.noInternet;
        _networkStatusController.add(_currentStatus);
      },
    );
  }

  /// Handle connectivity changes (WiFi/Mobile data)
  void _handleConnectivityChange(List<ConnectivityResult> results) async {
    final hasConnection = !results.contains(ConnectivityResult.none);

    if (!hasConnection) {
      _currentStatus = NetworkStatus.noInternet;
      _networkStatusController.add(_currentStatus);
      return;
    }

    // Even if we have WiFi/mobile data, verify actual internet
    try {
      final hasInternet = await _internetChecker.hasConnection;
      _currentStatus = hasInternet
          ? NetworkStatus.online
          : NetworkStatus.noInternet;
      _networkStatusController.add(_currentStatus);
    } catch (e) {
      _currentStatus = NetworkStatus.noInternet;
      _networkStatusController.add(_currentStatus);
    }
  }

  /// Handle internet connection status changes
  void _handleInternetStatusChange(InternetConnectionStatus status) {
    _currentStatus = status == InternetConnectionStatus.connected
        ? NetworkStatus.online
        : NetworkStatus.noInternet;
    _networkStatusController.add(_currentStatus);
  }

  /// Check if currently online
  bool get isOnline => _currentStatus == NetworkStatus.online;

  /// Check if currently offline
  bool get isOffline => _currentStatus != NetworkStatus.online;

  /// Dispose and clean up subscriptions
  void dispose() {
    _connectivitySubscription?.cancel();
    _internetSubscription?.cancel();
    _networkStatusController.close();
  }

  /// Force refresh network status
  Future<NetworkStatus> refresh() async {
    _currentStatus = await checkConnectivity();
    _networkStatusController.add(_currentStatus);
    return _currentStatus;
  }
}
