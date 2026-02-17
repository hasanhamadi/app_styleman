part of 'banner_bloc.dart';

@immutable
sealed class BannerEvent {
  const BannerEvent();
}

final class BannerLoadStarted extends BannerEvent {}

final class BannerRefreshRequested extends BannerEvent {}