import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'order_bloc.dart';
import 'order_detail_page.dart';
import 'order_model.dart';

class OrderListPage extends StatelessWidget {
  const OrderListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("سفارشات من", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.black));
          }

          if (state is OrderLoaded) {
            if (state.orders.isEmpty) {
              return const Center(child: Text("هنوز سفارشی ثبت نکرده‌اید."));
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: state.orders.length,
              itemBuilder: (context, index) {
                return OrderCard(order: state.orders[index]);
              },
            );
          }

          if (state is OrderError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("خطا: ${state.message}"),
                  TextButton(
                    onPressed: () => context.read<OrderBloc>().add(LoadOrdersEvent()),
                    child: const Text("تلاش مجدد"),
                  )
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

// --- ویجت کارت سفارش که در کد قبلی جا مانده بود ---
class OrderCard extends StatelessWidget {
  final OrderModel order;
  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          // هدایت به صفحه جزئیات سفارش با دیتای واقعی
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailPage(order: order),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // نمایش 8 کاراکتر اول ID سفارش
                  Text(
                    "سفارش #${order.id.isEmpty ? 'نامشخص' : order.id.substring(0, 8)}",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  _StatusBadge(status: order.status),
                ],
              ),
              const Divider(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("مبلغ کل:", style: TextStyle(color: Colors.grey, fontSize: 14)),
                  Text(
                    "${order.totalPrice.toInt()} تومان",
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.blueAccent,
                      fontSize: 16,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

// --- ویجت نشان وضعیت ---
class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;

    switch (status) {
      case 'pending':
        color = Colors.orange;
        text = "در انتظار";
        break;
      case 'completed':
        color = Colors.green;
        text = "تکمیل شده";
        break;
      case 'cancelled':
        color = Colors.red;
        text = "لغو شده";
        break;
      default:
        color = Colors.grey;
        text = "نامشخص";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}