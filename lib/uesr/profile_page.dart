import 'package:app_styleman/uesr/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_bloc.dart';
import 'auth_page.dart';

class ProfilePage extends StatelessWidget {
  final UserModel user;

  const ProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("پروفایل کاربری", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          // دکمه خروج از حساب
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthInitial) {
                // هدایت به صفحه لاگین پس از خروج موفق
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => AuthPage()),
                      (route) => false,
                );
              }
            },
            child: IconButton(
              onPressed: () {
                _showLogoutDialog(context);
              },
              icon: const Icon(Icons.logout, color: Colors.red),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // هدر پروفایل با آیکون کاربر
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blueGrey,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "${user.name} ${user.lestname}", // استفاده از فیلد با غلط املایی دیتابیس
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(user.username, style: const TextStyle(color: Colors.grey)), // شماره موبایل

            const SizedBox(height: 30),

            // کارت اطلاعات سکونتی
            _buildInfoCard(
              title: "اطلاعات تماس و آدرس",
              items: [
                _infoRow(Icons.location_city, "استان و شهر", "${user.province} - ${user.city}"),
                _infoRow(Icons.map_outlined, "آدرس دقیق", user.adderss), // مطابق دیتابیس شما
                _infoRow(Icons.post_add, "کد پستی", user.zipcode),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ویجت ساخت کارت اطلاعات
  Widget _buildInfoCard({required String title, required List<Widget> items}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
          const Divider(height: 25),
          ...items,
        ],
      ),
    );
  }

  // ردیف نمایش هر فیلد اطلاعاتی
  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Text("$label: ", style: const TextStyle(color: Colors.grey)),
          Expanded(
            child: Text(
              value.isEmpty ? "ثبت نشده" : value,
              style: const TextStyle(fontWeight: FontWeight.w500),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  // دیالوگ تایید خروج
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (innerContext) => AlertDialog(
        title: const Text("خروج از حساب"),
        content: const Text("آیا مطمئن هستید که می‌خواهید از حساب کاربری خود خارج شوید؟"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(innerContext), child: const Text("انصراف")),
          TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
              Navigator.pop(innerContext);
            },
            child: const Text("خروج", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}