import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'banner_repository.dart';

part 'banner_event.dart';
part 'banner_state.dart';

class BannerBloc extends Bloc<BannerEvent, BannerState> {
  final BannerRepository _repository;

  BannerBloc(this._repository) : super(BannerInitial()) {
    // ثبت هندلر اصلی
    on<BannerEvent>((event, emit) async {
      switch (event) {
        case BannerLoadStarted():
          await _onLoadStarted(emit);
        case BannerRefreshRequested():
          await _onRefreshRequested(emit);
      }
    });
  }

  Future<void> _onLoadStarted(Emitter<BannerState> emit) async {
    emit(BannerLoadInProgress());
    await _fetchData(emit, isRefresh: false);
  }

  Future<void> _onRefreshRequested(Emitter<BannerState> emit) async {
    // در ریفرش معمولاً وضعیت لودینگ را دوباره صادر نمی‌کنیم تا پرش تصویر نداشته باشیم
    await _fetchData(emit, isRefresh: true);
  }

  Future<void> _fetchData(Emitter<BannerState> emit, {required bool isRefresh}) async {
    try {
      final records = await _repository.getBanners(refresh: isRefresh);

      // تبدیل لیست رکوردها به لیست تخت آدرس تصاویر (Flatten)
      final List<String> allImages = records.expand((r) => r.images).toList();

      if (allImages.isEmpty) {
        emit(BannerEmpty());
      } else {
        emit(BannerLoadSuccess(imageUrls: allImages));
      }
    } catch (e) {
      emit(BannerLoadFailure(errorMessage: e.toString()));
    }
  }
}
