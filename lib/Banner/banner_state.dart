part of 'banner_bloc.dart';

@immutable
sealed class BannerState {
  const BannerState();
}

final class BannerInitial extends BannerState {}

final class BannerLoadInProgress extends BannerState {}

final class BannerLoadSuccess extends BannerState {
  final List<String> imageUrls;
  const BannerLoadSuccess({required this.imageUrls});
}

final class BannerLoadFailure extends BannerState {
  final String errorMessage;
  const BannerLoadFailure({required this.errorMessage});
}

final class BannerEmpty extends BannerState {}