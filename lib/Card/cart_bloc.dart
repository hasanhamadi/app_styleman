import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../products/product_model.dart';
import 'cart_item_model.dart';
import 'cart_repository.dart'; // حتما ریپازیتوری را ایمپورت کنید

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _cartRepository;
  String? _currentUserId;

  CartBloc(this._cartRepository) : super(CartInitial()) {

    on<CartStarted>((event, emit) async {
      _currentUserId = event.userId;
      if (_currentUserId == null || _currentUserId!.isEmpty) return;

      emit(CartLoading());
      try {
        final items = await _cartRepository.fetchCart(_currentUserId!);
        emit(CartLoaded(items: items));
      } catch (e) {
        emit(CartError("خطا در دریافت سبد خرید: ${e.toString()}"));
      }
    });

    on<CartItemAdded>((event, emit) async {
      // اگر آیدی نبود، عملیات را متوقف کن
      if (_currentUserId == null || _currentUserId!.isEmpty) {
        emit(CartError("ابتدا وارد حساب کاربری شوید"));
        return;
      }

      try {
        // ۱. افزودن به دیتابیس
        await _cartRepository.addToCart(_currentUserId!, event.product.id, 1);

        // ۲. دریافت مجدد لیست برای بروزرسانی UI بدون حالت Loading (تجربه کاربری بهتر)
        final items = await _cartRepository.fetchCart(_currentUserId!);
        emit(CartLoaded(items: items));
      } catch (e) {
        emit(CartError("افزودن به سبد با خطا مواجه شد"));
      }
    });

    // اینجا می‌توانید ایونت‌های Update و Delete را هم اضافه کنید
  }
}