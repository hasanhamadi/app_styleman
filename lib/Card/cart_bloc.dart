import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../products/product_model.dart';
import 'cart_item_model.dart';
import 'cart_repository.dart'; // حتما ریپازیتوری را ایمپورت کنید

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _cartRepository;
  String? _currentUserId; // ذخیره آیدی کاربر در حافظه بلاک

  CartBloc(this._cartRepository, [this._currentUserId]) : super(CartInitial()) {

    // مدیریت رویداد شروع با آیدی کاربر
    on<CartStarted>((event, emit) async {
      _currentUserId = event.userId; // بروزرسانی آیدی
      emit(CartLoading());
      try {
        final items = await _cartRepository.fetchCart(event.userId);
        emit(CartLoaded(items: items));
      } catch (e) {
        emit(CartError(e.toString()));
      }
    });

    on<CartItemAdded>((event, emit) async {
      if (_currentUserId == null) return;

      try {
        // ابتدا عملیات افزودن در ریپازیتوری
        await _cartRepository.addToCart(_currentUserId!, event.product.id, 1);
        // سپس بارگذاری مجدد لیست برای بروزرسانی UI
        add(CartStarted(userId: _currentUserId!));
      } catch (e) {
        emit(CartError("افزودن به سبد با خطا مواجه شد"));
      }
    });

    // سایر هندلرها (حذف و آپدیت) مشابه بالا پیاده می‌شوند
  }
}