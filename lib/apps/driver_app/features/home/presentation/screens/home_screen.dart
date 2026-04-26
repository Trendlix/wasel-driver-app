import 'dart:async';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wasel_driver/apps/core/enums/app_enums.dart';
import 'package:wasel_driver/apps/core/enums/request_status.dart';
import 'package:wasel_driver/apps/core/routes/app_route_names.dart';
import 'package:wasel_driver/apps/core/services/network_connectivity_service.dart';
import 'package:wasel_driver/apps/core/utils/constants/app_colors.dart';
import 'package:wasel_driver/apps/core/widgets/error_retry_widget.dart';
import 'package:wasel_driver/apps/driver_app/features/home/domain/entities/request_categories_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:wasel_driver/apps/driver_app/features/home/presentation/cubit/home_states.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/entity/profile_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/presentation/manager/profile_cubit.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/presentation/cubit/driver_trip_cubit.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/presentation/cubit/driver_trip_states.dart';
import 'package:wasel_driver/apps/features/app_permissions/service/app_permission_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isOnline = true;
  String _latitude = '';
  String _longitude = '';
  String activeTripId = '';

  StreamSubscription<NetworkStatus>? _networkSubscription;
  NetworkStatus _networkStatus = NetworkStatus.offline;

  @override
  void initState() {
    super.initState();

    _initializeNetworkService();

    context.read<HomeCubit>().getDriverProfile();
    context.read<HomeCubit>().getDriverSummary();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final appPermission = await PermissionService.requestLocation();
      if (appPermission.isGranted) {
        final location = await PermissionService.getSavedLocation();
        _latitude = location?.lat.toString() ?? '';
        _longitude = location?.lng.toString() ?? '';
        if (location != null) {
          if (!mounted) return;
          context.read<HomeCubit>().getDriverRequests(
            location.lat,
            location.lng,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _networkSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initializeNetworkService() async {
    await NetworkConnectivityService.instance.initialize();

    final initialStatus = NetworkConnectivityService.instance.currentStatus;
    setState(() {
      _networkStatus = initialStatus;
      if (initialStatus != NetworkStatus.online) {
        _isOnline = false;
      }
    });

    _networkSubscription = NetworkConnectivityService.instance.onStatusChanged
        .listen((status) {
          if (!mounted) return;
          setState(() {
            _networkStatus = status;
            if (status != NetworkStatus.online) {
              _isOnline = false;
            }
          });
        });
  }

  Future<void> _onRefresh() async {
    final futures = <Future<void>>[
      context.read<HomeCubit>().getDriverProfile(),
      context.read<HomeCubit>().getDriverSummary(),
      activeTripId.isNotEmpty
          ? context.read<DriverTripCubit>().getDriverTripById(
              int.parse(activeTripId),
            )
          : Future.value(),
    ];
    if (_latitude.isNotEmpty && _longitude.isNotEmpty) {
      futures.add(
        context.read<HomeCubit>().getDriverRequests(
          double.parse(_latitude),
          double.parse(_longitude),
        ),
      );
    }
    await Future.wait(futures);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DriverTripCubit, DriverTripStates>(
          listenWhen: (previous, current) =>
              previous.cancelDriverTripStatus != current.cancelDriverTripStatus,
          listener: (context, state) {
            if (state.cancelDriverTripStatus == RequestStatus.success) {
              _onRefresh();
            } else if (state.cancelDriverTripStatus == RequestStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.cancelDriverTripMessage ?? 'An error occurred',
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
        BlocListener<HomeCubit, HomeStates>(
          listenWhen: (previous, current) =>
              previous.getDriverProfileRequestStatus !=
                  current.getDriverProfileRequestStatus &&
              current.getDriverProfileRequestStatus == RequestStatus.success,
          listener: (context, state) {
            if (state.driverProfileModel != null) {
              setState(() {
                _isOnline =
                    (state.driverProfileModel?.isOnline ?? false) &&
                    _networkStatus == NetworkStatus.online;
              });
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(190),
          child: _buildHeader(),
        ),
        body: SafeArea(
          child: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  // ── Requests Section ──────────────────────────────────
                  if (!_isOnline)
                    _buildActiveTripCard()
                  else
                    BlocBuilder<HomeCubit, HomeStates>(
                      builder: (context, state) {
                        if (state.driverRequestsRequestStatus ==
                            RequestStatus.loading) {
                          return _buildRequestsShimmer();
                        }

                        if (state.driverRequestsRequestStatus ==
                            RequestStatus.error) {
                          return ErrorRetryWidget(
                            message: state.driverRequestsErrorMessage ?? '',
                            onRetry: () async {
                              final location =
                                  await PermissionService.getSavedLocation();
                              if (location != null && context.mounted) {
                                context.read<HomeCubit>().getDriverRequests(
                                  location.lat,
                                  location.lng,
                                );
                              }
                            },
                          );
                        }

                        if (state.driverRequestsRequestStatus ==
                            RequestStatus.success) {
                          final requests = state.driverRequestsModel?.all ?? [];
                          final preview = requests.take(4).toList();

                          if (preview.isEmpty) {
                            return _buildEmptyRequests(
                              'No requests available',
                              'New requests will appear here',
                            );
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionHeader(
                                'New Requests',
                                'Select a trip to view details',
                                badge: '${requests.length} New',
                              ),
                              const SizedBox(height: 12),
                              ...preview.map(
                                (req) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _buildTripCard(
                                    onClick: () => Navigator.pushNamed(
                                      context,
                                      AppRouteNames.requestDetailsScreen,
                                      arguments: {
                                        'requestId': req.id,
                                        'lat': _latitude,
                                        'long': _longitude,
                                      },
                                    ),
                                    avatarWidget:
                                        (req.user?.avatar != null &&
                                            req.user!.avatar!.isNotEmpty)
                                        ? CircleAvatar(
                                            radius: 22,
                                            backgroundImage: NetworkImage(
                                              req.user!.avatar!,
                                            ),
                                            backgroundColor: const Color(
                                              0xFFE5E7EB,
                                            ),
                                          )
                                        : Container(
                                            width: 44,
                                            height: 44,
                                            decoration: const BoxDecoration(
                                              color: AppColors.primary,
                                              shape: BoxShape.circle,
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              _getInitials(req.user!.name!),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                    driverName: req.user!.name!,
                                    rating: req.user!.rating!.toString(),
                                    totalPrice:
                                        '${req.currency} ${req.price!.toStringAsFixed(0)}',
                                    yourEarnings:
                                        '${req.currency} ${req.amountGoesToDriver}',
                                    pickup: req.pickup!,
                                    dropoff: req.dropOff!.isNotEmpty
                                        ? req.dropOff!.first
                                        : '—',
                                    distance:
                                        '${req.distanceBetween!.toStringAsFixed(1)} km',
                                    time: '${req.estimatedTime} mins',
                                    category: req.typeOfGoods!,
                                    categoryIcon: _getCategoryIcon(
                                      req.typeOfGoods!,
                                    ),
                                    isUrgent:
                                        req.label?.toLowerCase() == 'urgent',
                                    earningsPercent:
                                        '${req.amountGoesToDriverPercentage?.toInt()}% goes to you',
                                    platformFee:
                                        '${req.currency} ${req.platformFees}',
                                    dateOfRequest: req.dateOfRequest ?? '',
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildViewAllButton(
                                totalCount: requests.length,
                                categories: state.driverRequestsModel!,
                              ),
                            ],
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),

                  // ── Today's Summary ───────────────────────────────────
                  const SizedBox(height: 24),
                  _buildSectionHeader("Today's Summary", null),
                  const SizedBox(height: 12),
                  _buildSummaryGrid(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Container(
      color: AppColors.primary,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BlocBuilder<HomeCubit, HomeStates>(
                builder: (context, state) {
                  if (state.getDriverProfileRequestStatus ==
                      RequestStatus.loading) {
                    return Shimmer.fromColors(
                      baseColor: Colors.white.withOpacity(0.4),
                      highlightColor: Colors.white.withOpacity(0.8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 100,
                                height: 13,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                width: 150,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (state.getDriverProfileRequestStatus ==
                      RequestStatus.error) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Welcome back,',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                state.errorMessage ?? 'Error loading profile',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () =>
                              context.read<HomeCubit>().getDriverProfile(),
                          icon: const Icon(
                            Icons.refresh,
                            color: Colors.white,
                            size: 18,
                          ),
                          label: const Text(
                            'Retry',
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            backgroundColor: Colors.white.withOpacity(0.2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else if (state.getDriverProfileRequestStatus ==
                      RequestStatus.success) {
                    final profile = state.driverProfileModel;
                    activeTripId = profile?.activeTripId == null
                        ? ''
                        : profile!.activeTripId!.toString();
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Welcome back,',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              profile?.driverName ?? 'unknown',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 23, 117, 241),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          clipBehavior: Clip.hardEdge,
                          child:
                              profile?.profileImg != null &&
                                  profile!.profileImg!.isNotEmpty
                              ? Image.network(
                                  profile.profileImg!,
                                  width: 44,
                                  height: 44,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Text(
                                      _getInitials(profile.driverName),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    );
                                  },
                                )
                              : Text(
                                  _getInitials(profile?.driverName),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 16),
              _buildStatusToggle(),
            ],
          ),
        ),
      ),
    );
  }

  String _getInitials(String? name) {
    if (name == null || name.trim().isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length > 1) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name
        .trim()
        .substring(0, name.trim().length >= 2 ? 2 : 1)
        .toUpperCase();
  }

  // ── Status Toggle ────────────────────────────────────────────────────────────

  Widget _buildStatusToggle() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: _isOnline ? const Color.fromARGB(255, 1, 67, 154) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _isOnline
              ? const Color.fromARGB(255, 1, 67, 154)
              : Colors.white,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: _isOnline
                  ? const Color(0xFF22C55E)
                  : const Color(0xFF9CA3AF),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isOnline ? 'You are Online' : 'You are Offline',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: _isOnline ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _isOnline
                      ? 'Receiving trip requests'
                      : 'Not receiving trip requests',
                  style: TextStyle(
                    fontSize: 12,
                    color: _isOnline ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: 0.85,
            child: Switch(
              value: _isOnline,
              onChanged: (value) {
                setState(() => _isOnline = value);
                context.read<ProfileCubit>().updateDriverBasicInfo(
                  DriverBasicInfoEntity(
                    id: null,
                    name: null,
                    email: null,
                    phone: null,
                    isOnline: _isOnline,
                  ),
                );
                if (activeTripId.isNotEmpty) {
                  context.read<DriverTripCubit>().getDriverTripById(
                    int.parse(activeTripId),
                  );
                }
              },
              activeColor: Colors.white,
              activeTrackColor: const Color(0xFF22C55E),
            ),
          ),
        ],
      ),
    );
  }

  // ── Category Icon Helper ─────────────────────────────────────────────────────

  IconData _getCategoryIcon(String typeOfGoods) {
    final type = typeOfGoods.toLowerCase();
    if (type.contains('furniture') || type.contains('chair')) {
      return Icons.chair_outlined;
    } else if (type.contains('build') || type.contains('material')) {
      return Icons.construction_outlined;
    } else if (type.contains('food')) {
      return Icons.fastfood_outlined;
    } else if (type.contains('electronic')) {
      return Icons.devices_outlined;
    } else if (type.contains('cloth')) {
      return Icons.checkroom_outlined;
    }
    return Icons.inventory_2_outlined;
  }

  // ── Requests Shimmer ─────────────────────────────────────────────────────────

  Widget _buildRequestsShimmer() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE5E7EB),
      highlightColor: const Color(0xFFF9FAFB),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 120,
                height: 18,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              Container(
                width: 60,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...List.generate(
            4,
            (_) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Empty State ──────────────────────────────────────────────────────────────

  Widget _buildEmptyRequests(String title, String description) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.inbox_outlined, size: 48, color: Color(0xFF9CA3AF)),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF9CA3AF),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ── Active Trip Card ─────────────────────────────────────────────────────────

  Widget _buildActiveTripCard() {
    if (activeTripId.isEmpty) {
      return _buildEmptyRequests(
        'No active trip',
        'You can view your active trip details here',
      );
    }
    return BlocBuilder<DriverTripCubit, DriverTripStates>(
      builder: (context, state) {
        if (state.getDriverTripByIdStatus == RequestStatus.loading) {
          return _buildRequestsShimmer();
        } else if (state.getDriverTripByIdStatus == RequestStatus.error) {
          return ErrorRetryWidget(
            message: state.getDriverTripByIdMessage ?? '',
            onRetry: () async {
              if (context.mounted) {
                context.read<DriverTripCubit>().getDriverTripById(
                  int.parse(activeTripId),
                );
              }
            },
          );
        } else if (state.getDriverTripByIdStatus == RequestStatus.success) {
          final activeTrip = state.trip;
          if (activeTrip == null ||
              (activeTrip.status == 'scheduled' ||
                  activeTrip.status == 'completed' ||
                  activeTrip.status == 'cancelled' ||
                  activeTrip.subStatus == null)) {
            return _buildEmptyRequests(
              'No active trip',
              'You can view your active trip details here',
            );
          }
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Active Trip',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'IN PROGRESS',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildActiveTripLocationRow(
                  icon: Icons.location_on_rounded,
                  iconColor: const Color(0xFF22C55E),
                  iconBgColor: const Color(0xFFDCFCE7),
                  label: 'PICKUP',
                  value: activeTrip.pickup,
                ),
                if (activeTrip.dropOff.isNotEmpty)
                  ...activeTrip.dropOff.map(
                    (dropOffItem) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 19,
                            top: 2,
                            bottom: 2,
                          ),
                          child: Container(
                            width: 1.5,
                            height: 20,
                            color: const Color(0xFFE5E7EB),
                          ),
                        ),
                        _buildActiveTripLocationRow(
                          icon: Icons.location_on_rounded,
                          iconColor: const Color(0xFFEF4444),
                          iconBgColor: const Color(0xFFFEE2E2),
                          label: 'DROP-OFF',
                          value: dropOffItem,
                        ),
                      ],
                    ),
                  )
                else ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 19, top: 2, bottom: 2),
                    child: Container(
                      width: 1.5,
                      height: 20,
                      color: const Color(0xFFE5E7EB),
                    ),
                  ),
                  _buildActiveTripLocationRow(
                    icon: Icons.location_on_rounded,
                    iconColor: const Color(0xFFEF4444),
                    iconBgColor: const Color(0xFFFEE2E2),
                    label: 'DROP-OFF',
                    value: 'N/A',
                  ),
                ],
                const SizedBox(height: 20),
                const Divider(height: 1, color: Color(0xFFF3F4F6)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildActiveTripStat(
                        'Distance',
                        '${activeTrip.distanceBetween ?? 0} km',
                        const Color(0xFF1A1A2E),
                      ),
                    ),
                    Expanded(
                      child: _buildActiveTripStat(
                        'Time',
                        '${activeTrip.estimatedTime} mins',
                        const Color(0xFF1A1A2E),
                      ),
                    ),
                    Expanded(
                      child: _buildActiveTripStat(
                        'Earning',
                        '${activeTrip.currency} ${activeTrip.price}',
                        const Color(0xFF22C55E),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () => Navigator.of(context).pushNamed(
                    AppRouteNames.navigateToPickupScreen,
                    arguments: activeTrip,
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.navigation_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Navigate to Pickup',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Builder(
                  builder: (context) {
                    final hasPhone =
                        activeTrip.user.phone != null &&
                        activeTrip.user.phone!.trim().isNotEmpty;
                    return InkWell(
                      onTap: hasPhone
                          ? () async {
                              final phone = activeTrip.user.phone!.replaceAll(
                                ' ',
                                '',
                              );
                              final Uri uri = Uri.parse('tel:$phone');
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri);
                              } else {
                                debugPrint('Could not launch call for $phone');
                              }
                            }
                          : null,
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        width: double.infinity,
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F7FA),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.phone_outlined,
                              color: Colors.black,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Call Customer',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                Visibility(
                  visible: activeTrip.subStatus != 'picked_up',
                  child: InkWell(
                    onTap: () {
                      if (state.cancelDriverTripStatus !=
                          RequestStatus.loading) {
                        context.read<DriverTripCubit>().cancelDriverTrip(
                          activeTrip.id,
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.cancelRequest),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 8),
                          state.cancelDriverTripStatus == RequestStatus.loading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: AppColors.cancelRequest,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Text(
                                  'Cancel Request',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.cancelRequest,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildActiveTripLocationRow({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(color: iconBgColor, shape: BoxShape.circle),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFF9CA3AF),
                letterSpacing: 0.5,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A2E),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActiveTripStat(String label, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  // ── Section Header ───────────────────────────────────────────────────────────

  Widget _buildSectionHeader(String title, String? subtitle, {String? badge}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A2E),
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
              ),
            ],
          ],
        ),
        if (badge != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              badge,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }

  // ── Trip Card ────────────────────────────────────────────────────────────────

  Widget _buildTripCard({
    required Widget avatarWidget,
    required String driverName,
    required String rating,
    required String totalPrice,
    required String yourEarnings,
    required String pickup,
    required String dropoff,
    required String distance,
    required String time,
    required String category,
    required IconData categoryIcon,
    required bool isUrgent,
    required String earningsPercent,
    required String platformFee,
    required String dateOfRequest,
    required VoidCallback onClick,
  }) {
    return InkWell(
      onTap: onClick,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      avatarWidget,
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              driverName,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1A2E),
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  size: 13,
                                  color: Color(0xFFE8A020),
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  rating,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            totalPrice,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1A1A2E),
                            ),
                          ),
                          const Text(
                            'Total Price',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            yourEarnings,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF22C55E),
                            ),
                          ),
                          const Text(
                            'Your Earnings',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 12,
                            color: Colors.black,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _formatDate(dateOfRequest),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildLocationRow(
                    icon: Icons.circle,
                    iconColor: const Color(0xFF22C55E),
                    label: 'PICKUP',
                    value: pickup,
                  ),
                  const SizedBox(height: 8),
                  _buildLocationRow(
                    icon: Icons.location_on,
                    iconColor: const Color(0xFFEF4444),
                    label: 'DROP-OFF',
                    value: dropoff,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatChip(
                          Icons.navigation_outlined,
                          distance,
                          'Distance',
                          AppColors.primary,
                          AppColors.primary.withOpacity(0.1),
                        ),
                      ),
                      Expanded(
                        child: _buildStatChip(
                          Icons.access_time_outlined,
                          time,
                          'Time',
                          AppColors.secondary,
                          AppColors.secondary.withOpacity(0.1),
                        ),
                      ),
                      Expanded(
                        child: _buildStatChip(
                          categoryIcon,
                          category,
                          '',
                          AppColors.greenColor,
                          AppColors.greenColor.withOpacity(0.1),
                        ),
                      ),
                    ],
                  ),
                  if (isUrgent) ...[
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFFEF4444).withOpacity(0.3),
                          ),
                        ),
                        child: const Text(
                          '🔴  URGENT REQUEST',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFEF4444),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // ── Bottom Earnings Bar ─────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: const BoxDecoration(
                color: AppColors.noteCardColor,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.trending_up_rounded,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: earningsPercent,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const TextSpan(
                          text: '  •  Platform fee: ',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: platformFee,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Icon(icon, size: 12, color: iconColor),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF9CA3AF),
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A2E),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatChip(
    IconData icon,
    String value,
    String label,
    Color iconColor,
    Color containerColor,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: containerColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 14, color: iconColor),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (label.isNotEmpty)
                Text(
                  label,
                  style: const TextStyle(fontSize: 10, color: Colors.black),
                ),
            ],
          ),
        ),
      ],
    );
  }

  // ── View All Button ──────────────────────────────────────────────────────────

  Widget _buildViewAllButton({
    int totalCount = 0,
    required RequestCategoriesEntity categories,
  }) {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(
        AppRouteNames.newRequestsScreen,
        arguments: {
          'categories': categories,
          'latitude': double.parse(_latitude),
          'longitude': double.parse(_longitude),
        },
      ),
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'View All Requests ($totalCount)',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  // ── Today's Summary Grid ─────────────────────────────────────────────────────

  Widget _buildSummaryGrid() {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        if (state.driverSummaryRequestStatus == RequestStatus.loading) {
          return _buildSummaryShimmer();
        } else if (state.driverSummaryRequestStatus == RequestStatus.error) {
          return ErrorRetryWidget(
            onRetry: () {
              context.read<HomeCubit>().getDriverSummary();
            },
            message: state.driverSummaryErrorMessage ?? 'something went wrong',
          );
        } else if (state.driverSummaryRequestStatus == RequestStatus.success) {
          final summary = state.driverSummaryModel;
          return GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.7,
            children: [
              _buildSummaryCard(
                icon: Icons.attach_money_rounded,
                iconColor: const Color(0xFF22C55E),
                label: 'Earnings',
                value: 'EGP ${summary!.earnings}',
                valueColor: const Color(0xFF22C55E),
                backgroundColor: const Color.fromARGB(255, 224, 253, 235),
              ),
              _buildSummaryCard(
                icon: Icons.route_rounded,
                iconColor: const Color(0xFF3B82F6),
                label: 'Trips',
                value: '${summary.trips}',
                valueColor: const Color(0xFF3B82F6),
                backgroundColor: const Color.fromARGB(255, 213, 232, 252),
              ),
              _buildSummaryCard(
                icon: Icons.access_time_rounded,
                iconColor: const Color(0xFF8B5CF6),
                label: 'Hours',
                value: '${summary.timeInMinutes}',
                valueColor: const Color(0xFF8B5CF6),
                backgroundColor: const Color.fromARGB(255, 235, 224, 251),
              ),
              _buildSummaryCard(
                icon: Icons.location_on_outlined,
                iconColor: const Color(0xFFEF4444),
                label: 'Distance',
                value: '${summary.distanceInKm} km',
                valueColor: const Color(0xFFEF4444),
                backgroundColor: const Color.fromARGB(255, 250, 220, 220),
              ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required Color valueColor,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: iconColor),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: valueColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  // ── Summary Shimmer ──────────────────────────────────────────────────────────

  Widget _buildSummaryShimmer() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE5E7EB),
      highlightColor: const Color(0xFFF9FAFB),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.7,
        children: List.generate(
          4,
          (_) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '—';
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final requestDate = DateTime(date.year, date.month, date.day);

      if (requestDate == today) {
        return 'Today';
      } else {
        return DateFormat('dd MMM yyyy').format(date);
      }
    } catch (e) {
      return dateStr;
    }
  }
}
