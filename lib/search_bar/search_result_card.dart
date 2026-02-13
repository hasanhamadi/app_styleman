import 'package:flutter/material.dart';
import 'package:app_styleman/products/product_model.dart';
import 'package:app_styleman/products/product_detail_screen.dart';

class SearchResultCard extends StatelessWidget {
  final ProductModel item;
  const SearchResultCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ProductDetailScreen(product: item)),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          item.mainImageUrl,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported),
        ),
      ),
      title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text("${item.price} تومان", style: const TextStyle(color: Colors.blueGrey)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
    );
  }
}