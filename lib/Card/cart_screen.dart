import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_bloc.dart';
import 'cart_item_tile.dart';
// ایمپورت‌های مورد نیاز برای بخش سفارش
import '../Order/iorder_repository.dart';
import '../Order/order_model.dart';
import '../Order/order_bloc.dart';
import '../uesr/auth_bloc.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("سبد خرید", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CartLoaded) {
            if (state.items.isEmpty) {
              return const Center(
                child: Text("سبد خرید شما در حال حاضر خالی است."),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      return CartItemTile(item: state.items[index]);
                    },
                  ),
                ),
                // پاس دادن قیمت کل و لیست آیتم‌ها به ویجت خلاصه
                _CartSummary(
                  totalPrice: state.totalPrice,
                  cartItems: state.items, // بسیار مهم برای ثبت سفارش
                ),
              ],
            );
          }

          if (state is CartError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  final double totalPrice;
  final List cartItems; // اضافه شدن لیست آیتم‌ها

  const _CartSummary({required this.totalPrice, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          )
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("مبلغ قابل پرداخت:", style: TextStyle(color: Colors.grey, fontSize: 13)),
                Text("${totalPrice.toInt()} تومان",
                    style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => _showConfirmDialog(context),
              child: const Text("تکمیل سفارش", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }

  void _showConfirmDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (builderContext) => Container(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("تایید نهایی خرید", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Text("مبلغ ${totalPrice.toInt()} تومان به لیست سفارشات شما اضافه خواهد شد."),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15)),
                onPressed: () {
                  Navigator.pop(builderContext);
                  _processOrder(context); // اجرای لاجیک ثبت
                },
                child: const Text("ثبت و پرداخت نهایی"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _processOrder(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator(color: Colors.black)));

    try {
      final authState = context.read<AuthBloc>().state;
      String userId = "";
      if (authState is AuthAuthenticated) {
        userId = authState.user.id;
      }

      if (userId.isEmpty) throw Exception("لطفاً وارد حساب کاربری شوید");

      // ساخت مدل سفارش از آیتم‌های واقعی سبد خرید
      final order = OrderModel(
        id: '',
        userId: userId,
        totalPrice: totalPrice,
        status: 'pending',
        created: DateTime.now(),
        items: cartItems.map((item) => OrderItem(
          name: item.product.name,
          price: item.product.price.toDouble(),
          qty: item.quantity,
        )).toList(),
      );

      // ثبت در دیتابیس
      await context.read<IOrderRepository>().saveNewOrder(order);

      if (context.mounted) {
        Navigator.pop(context); // بستن لودینگ

        // رفرش کردن لیست سفارشات در بلاک
        context.read<OrderBloc>().add(LoadOrdersEvent());

        // انتقال به صفحه سفارشات
        Navigator.pushReplacementNamed(context, '/orders');

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("سفارش با موفقیت ثبت شد ✅"), backgroundColor: Colors.green)
        );
      }
    } catch (e) {
      if (context.mounted) Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("خطا: ${e.toString()}"), backgroundColor: Colors.red)
      );
    }
  }
}