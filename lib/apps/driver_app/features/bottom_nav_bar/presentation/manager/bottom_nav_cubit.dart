import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel_driver/apps/driver_app/features/bottom_nav_bar/presentation/manager/bottom_nav_state.dart';

class BottomNavCubit extends Cubit<BottomNavState> {
  BottomNavCubit() : super(const BottomNavState());

  void navigateTo(int index) {
    if (index != state.currentIndex) {
      emit(state.copyWith(currentIndex: index));
    }
  }
}
