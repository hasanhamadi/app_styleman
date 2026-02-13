import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // برای قابلیت کپی کردن خطا
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_styleman/products/product_model.dart';
import 'package:app_styleman/products/product_repository.dart';
import 'package:app_styleman/search_bar/search_bar_widget.dart';
import 'package:app_styleman/search_bar/search_result_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  List<ProductModel> _results = [];
  bool _isLoading = false;
  Timer? _debounce;

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (query.trim().isEmpty) {
      setState(() {
        _results = [];
        _isLoading = false;
      });
      return;
    }

    setState(() => _isLoading = true);

    _debounce = Timer(const Duration(milliseconds: 600), () async {
      try {
        final repo = context.read<ProductRepository>();
        final data = await repo.searchProducts(query);

        if (mounted) {
          setState(() {
            _results = data;
            _isLoading = false;
          });
        }
      } catch (e) {
        debugPrint("❌ Full Error Log: $e"); // نمایش در کنسول VS Code

        if (mounted) {
          setState(() => _isLoading = false);

          // نمایش خطای دقیق در پایین صفحه
          final errorText = e.toString().replaceAll("Exception: ", "");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorText),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(
                label: "کپی خطا",
                textColor: Colors.white,
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: e.toString()));
                },
              ),
            ),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("جستجوی محصولات", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBarWidget(
              controller: _controller,
              onChanged: _onSearchChanged,
            ),
          ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    if (_controller.text.isEmpty) {
      return _buildMessage(Icons.search, "نام محصول را تایپ کنید");
    }

    if (_results.isEmpty) {
      return _buildMessage(Icons.inventory_2_outlined, "نتیجه‌ای پیدا نشد");
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _results.length,
      itemBuilder: (context, index) => SearchResultCard(item: _results[index]),
    );
  }

  Widget _buildMessage(IconData icon, String msg) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 70, color: Colors.grey[300]),
          const SizedBox(height: 10),
          Text(msg, style: TextStyle(color: Colors.grey[400])),
        ],
      ),
    );
  }
}
