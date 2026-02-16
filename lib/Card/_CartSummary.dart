import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Order/iorder_repository.dart';
import '../Order/order_model.dart';
import '../Order/order_bloc.dart';
import '../uesr/auth_bloc.dart';
import 'cart_bloc.dart';

class _CartSummary extends StatelessWidget {
  final double totalPrice;
  final List cartItems; // لیست محصولاتی که در CartScreen از State گرفته شده

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
                const Text("مبلغ قابل پرداخت:",
                    style: TextStyle(color: Colors.grey, fontSize: 13)),
                Text("${totalPrice.toInt()} تومان",
                    style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Colors.green)),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => _showConfirmDialog(context),
              child: const Text("تکمیل سفارش",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }

  // نمایش دیالوگ تایید قبل از پرداخت
  void _showConfirmDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (builderContext) => Container(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("تایید نهایی خرید",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Text(
                "مبلغ ${totalPrice.toInt()} تومان از حساب شما کسر و سفارش در بخش 'انتظار پردازش' ثبت خواهد شد."),
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
                  _processOrder(context); // شروع عملیات ثبت واقعی
                },
                child: const Text("ثبت و پرداخت نهایی"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // منطق اصلی ثبت سفارش و انتقال به دیتابیس
  Future<void> _processOrder(BuildContext context) async {
    // ۱. نمایش لودینگ
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) =>
        const Center(child: CircularProgressIndicator(color: Colors.black)));

    try {
      // ۲. استخراج آی‌دی کاربر از وضعیت Auth
      final authState = context.read<AuthBloc>().state;
      String userId = "";
      if (authState is AuthAuthenticated) {
        userId = authState.user.id;
      }

      if (userId.isEmpty) throw Exception("لطفاً ابتدا وارد حساب کاربری شوید");

      // ۳. تبدیل محصولات سبد خرید به آیتم‌های مدل Order
      final List<OrderItem> orderItems = cartItems.map((item) {
        return OrderItem(
          name: item.product.name,
          price: item.product.price.toDouble(),
          qty: item.quantity,
        );
      }).toList();

      // ۴. آماده‌سازی مدل نهایی برای ارسال به PocketBase
      final order = OrderModel(
        id: '', // در سرور تولید می‌شود
        userId: userId,
        totalPrice: totalPrice,
        status: 'pending', // وضعیت انتظار پردازش
        created: DateTime.now(),
        items: orderItems,
      );

      // ۵. فراخوانی ریپازیتوری برای ذخیره در کالکشن orders
      await context.read<IOrderRepository>().saveNewOrder(order);

      // ۶. کارهای پس از موفقیت
      if (context.mounted) {
        Navigator.pop(context); // بستن لودینگ

        // رفرش کردن بلاک سفارشات برای نمایش دیتای جدید در لیست
        context.read<OrderBloc>().add(LoadOrdersEvent());

        // پاکسازی سبد خرید (اگر ایونت آن را تعریف کرده‌اید)
        // context.read<CartBloc>().add(ClearCartEvent());

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("سفارش شما با موفقیت ثبت شد! ✅"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ));

        // انتقال به صفحه لیست سفارشات (OrderListPage)
        Navigator.pushReplacementNamed(context, '/orders');
      }
    } catch (e) {
      // مدیریت خطا (بستن لودینگ و نمایش پیام خطا)
      if (context.mounted) Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("خطا در ثبت سفارش: ${e.toString()}"),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ));
    }
  }
}