import 'package:app_styleman/products/product_model.dart';
import 'package:app_styleman/products/product_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'product_event.dart';
part 'product_state.dart';
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;

  ProductBloc(this.repository) : super(ProductInitial()) {

    // مدیریت رویداد بارگذاری محصولات
    on<LoadProductsEvent>((event, emit) async {
      emit(ProductLoading()); // نمایش لودینگ در UI
      try {
        final products = await repository.fetchAllProducts();
        if (products.isEmpty) {
          emit(ProductError("هیچ محصولی یافت نشد."));
        } else {
          emit(ProductLoaded(products)); // ارسال لیست محصولات به UI
        }
      } catch (e) {
        emit(ProductError("خطا در برقراری ارتباط با سرور"));
      }
    });

    // مدیریت رویداد رفرش (مشابه بارگذاری اما با منطق منعطف‌تر)
    on<RefreshProductsEvent>((event, emit) => add(LoadProductsEvent()));
  }
}