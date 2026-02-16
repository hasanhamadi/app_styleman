import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'order_model.dart';

class OrderDetailPage extends StatelessWidget {
  final OrderModel order;
  const OrderDetailPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("جزئیات فاکتور")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildInfoRow("کد پیگیری", order.id),
            _buildInfoRow("تاریخ ثبت", order.created.toString().substring(0, 10)),
            const Divider(height: 40),
            Expanded(
              child: ListView.builder(
                itemCount: order.items.length,
                itemBuilder: (context, index) {
                  final item = order.items[index];
                  return ListTile(
                    title: Text(item.name),
                    trailing: Text("${item.qty} عدد"),
                    subtitle: Text("${item.price} تومان"),
                  );
                },
              ),
            ),
            const Divider(),
            _buildInfoRow("جمع کل", "${order.totalPrice} تومان", isBold: true),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
