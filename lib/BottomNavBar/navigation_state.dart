part of 'navigation_cubit.dart';

@immutable
sealed class NavigationState {
  final int currentIndex;
  const NavigationState(this.currentIndex);
}

// وضعیت اولیه: ایندکس ۰ را به سوپرکلاس پاس می‌دهد
final class NavigationInitial extends NavigationState {
  const NavigationInitial() : super(0);
}

// وضعیتی که هنگام جابجایی بین تب‌ها منتشر می‌شود
final class NavigationChanged extends NavigationState {
  const NavigationChanged(super.currentIndex);
}