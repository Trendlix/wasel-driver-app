import 'package:wasel_driver/apps/core/network/local/local_storage_service.dart';
import 'package:wasel_driver/apps/core/routes/app_route_names.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class NavigationManager {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void logoutAndNavigateToLogin() {
    GetIt.instance<LocalStorageService>().clearAll();
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      AppRouteNames.loginScreen,
      (route) => false,
    );
  }

  // You can also add other helper methods here:
  void navigateTo(String routeName, {Object? arguments}) {
    navigatorKey.currentState?.pushNamed(routeName, arguments: arguments);
  }

  void pop() {
    navigatorKey.currentState?.pop();
  }
}
