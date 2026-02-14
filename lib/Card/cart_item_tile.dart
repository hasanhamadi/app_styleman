import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_bloc.dart';
import 'cart_item_model.dart';

class CartItemTile extends StatelessWidget {
  final CartItemModel item;

  const CartItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // دریافت اطلاعات محصول از فیلد expand
    final product = item.product;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // نمایش تصویر محصول
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                product?.mainImageUrl ?? '',
                width: 90,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image, size: 50, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 16),

            // بخش اطلاعات و کنترل تعداد
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product?.name ?? "نام محصول یافت نشد",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${product?.price ?? 0} تومان",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                  const SizedBox(height: 12),

                  // ردیف دکمه‌های کنترل تعداد و حذف
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // کنترلر افزایش/کاهش
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            _QtyButton(
                              icon: Icons.add,
                              onPressed: () {
                                // اصلاح نام ایونت به CartUpdateQuantity برای هماهنگی با فایل‌های قبلی
                                context.read<CartBloc>().add(CartUpdateQuantity(
                                  itemId: item.id,
                                  quantity: item.quantity + 1,
                                ));
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                item.quantity.toString(),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            _QtyButton(
                              icon: Icons.remove,
                              onPressed: () {
                                if (item.quantity > 1) {
                                  context.read<CartBloc>().add(CartUpdateQuantity(
                                    itemId: item.id,
                                    quantity: item.quantity - 1,
                                  ));
                                }
                              },
                            ),
                          ],
                        ),
                      ),

                      // دکمه حذف سطر
                      IconButton(
                        onPressed: () {
                          // هماهنگ با ایونت CartItemRemoved
                          context.read<CartBloc>().add(CartItemRemoved(itemId: item.id));
                        },
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ویجت کمکی برای دکمه‌های مثبت و منفی
class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _QtyButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      visualDensity: VisualDensity.compact,
      icon: Icon(icon, size: 18, color: Colors.black87),
      onPressed: onPressed,
    );
  }
}