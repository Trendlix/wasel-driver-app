import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:wasel_driver/apps/core/di/app_service_locator.dart';
import 'package:wasel_driver/apps/core/enums/app_enums.dart';
import 'package:wasel_driver/apps/core/helpers/bloc_observer.dart';
import 'package:wasel_driver/apps/core/managers/connectivity_cubit.dart';
import 'package:wasel_driver/apps/core/routes/app_navigation_manager.dart';
import 'package:wasel_driver/apps/core/routes/app_route_names.dart';
import 'package:wasel_driver/apps/core/routes/navigation_manager.dart';
import 'package:wasel_driver/apps/core/services/network_connectivity_service.dart';
import 'package:wasel_driver/apps/core/utils/constants/app_constants.dart';
import 'package:wasel_driver/apps/core/widgets/no_internet_screen.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/di/profile_service_locator.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/presentation/manager/profile_cubit.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await AppServiceLocator().initServiceLocator();
  Bloc.observer = MyBlocObserver();
  // Initialize network service globally
  await NetworkConnectivityService.instance.initialize();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
  runApp(const WaselDriverApp());
}

class WaselDriverApp extends StatefulWidget {
  const WaselDriverApp({super.key});

  @override
  State<WaselDriverApp> createState() => _WaselDriverAppState();
}

class _WaselDriverAppState extends State<WaselDriverApp> {
  @override
  void initState() {
    super.initState();
    ProfileServiceLocator().initServiceLocator();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileCubit>(
      create: (context) => serviceLocator<ProfileCubit>(),
      child: BlocProvider(
        create: (context) => ConnectivityCubit(),
        child: BlocListener<ConnectivityCubit, NetworkStatus>(
          listener: (context, status) {
            // Handle connectivity status changes if needed
          },
          child: BlocBuilder<ConnectivityCubit, NetworkStatus>(
            builder: (context, status) {
              return MaterialApp(
                navigatorKey: GetIt.instance<NavigationManager>().navigatorKey,
                scaffoldMessengerKey: scaffoldMessengerKey,
                title: 'Wasel Driver app ',
                debugShowCheckedModeBanner: false,
                theme: ThemeData(fontFamily: AppConstants.appFont),
                onGenerateRoute: AppNavigatorManager.getRoute,
                initialRoute: AppRouteNames.splashScreen,
                builder: (context, child) {
                  if (status == NetworkStatus.noInternet) {
                    return const NoInternetScreen();
                  }
                  return child!;
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
