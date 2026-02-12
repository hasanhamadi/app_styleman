import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  // مقدار دهی اولیه با NavigationInitial
  NavigationCubit() : super(const NavigationInitial());

  void updateIndex(int index) {
    emit(NavigationChanged(index));
  }
}