import 'package:app_styleman/uesr/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_bloc.dart';

class ProfilePage extends StatefulWidget {
  final UserModel user;
  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // کنترلرهایی که حتما قبل از استفاده مقداردهی می‌شوند
  late TextEditingController nameController;
  late TextEditingController lastNameController;
  late TextEditingController addressController;

  String? selectedProvince;
  String? selectedCity;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // مقداردهی اولیه فیلدها بر اساس دیتای موجود در UserModel
    nameController = TextEditingController(text: widget.user.name);
    lastNameController = TextEditingController(text: widget.user.lestname);
    addressController = TextEditingController(text: widget.user.adderss);

    selectedProvince = widget.user.province.isEmpty ? null : widget.user.province;
    selectedCity = widget.user.city.isEmpty ? null : widget.user.city;
  }

  @override
  void dispose() {
    nameController.dispose();
    lastNameController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("پروفایل کاربری", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _showLogoutDialog(context),
            icon: const Icon(Icons.logout_rounded, color: Colors.red),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildAvatarHeader(),
            const SizedBox(height: 30),

            // بخش اطلاعات شخصی (بدون ایمیل)
            _buildSectionCard(
              title: "اطلاعات فردی",
              children: [
                _buildTextField(nameController, "نام", Icons.person_outline),
                _buildTextField(lastNameController, "نام خانوادگی", Icons.person_outline),
                _buildReadOnlyField(widget.user.username, "شماره موبایل", Icons.phone_android),
              ],
            ),

            const SizedBox(height: 20),

            // بخش موقعیت مکانی
            _buildSectionCard(
              title: "آدرس و موقعیت",
              children: [
                _buildLocationPicker("استان", selectedProvince ?? "انتخاب استان", Icons.map_outlined, () => _selectProvince()),
                _buildLocationPicker("شهر", selectedCity ?? "انتخاب شهر", Icons.location_city, () => _selectCity(),
                    enabled: selectedProvince != null),
                _buildTextField(addressController, "آدرس دقیق", Icons.home_outlined, maxLines: 2),
              ],
            ),

            const SizedBox(height: 40),

            // دکمه ذخیره تغییرات
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarHeader() {
    return Column(
      children: [
        const CircleAvatar(
          radius: 55,
          backgroundColor: Colors.black87,
          child: Icon(Icons.person, size: 55, color: Colors.white),
        ),
        const SizedBox(height: 10),
        Text("${widget.user.name} ${widget.user.lestname}",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSectionCard({required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
          const Divider(height: 25),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 20),
          filled: true,
          fillColor: const Color(0xFFF8F9FA),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String value, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        initialValue: value,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 20),
          suffixIcon: const Icon(Icons.lock_outline, size: 16, color: Colors.grey),
          filled: true,
          fillColor: const Color(0xFFF1F3F5),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildLocationPicker(String label, String value, IconData icon, VoidCallback onTap, {bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: enabled ? onTap : null,
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: enabled ? const Color(0xFFF8F9FA) : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: enabled ? Colors.black54 : Colors.grey),
              const SizedBox(width: 10),
              Text(value, style: TextStyle(color: enabled ? Colors.black87 : Colors.grey)),
              const Spacer(),
              const Icon(Icons.arrow_drop_down, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        onPressed: _isSaving ? null : _handleSave,
        child: _isSaving
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Text("ذخیره تغییرات", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  // متدهای انتخاب استان و شهر
  void _selectProvince() {
    _showListModal("انتخاب استان", ["تهران", "فارس", "اصفهان", "خراسان رضوی"], (val) {
      setState(() {
        selectedProvince = val;
        selectedCity = null;
      });
    });
  }

  void _selectCity() {
    List<String> cities = selectedProvince == "تهران" ? ["تهران", "شهریار", "ری"] : ["شیراز", "مرودشت"];
    _showListModal("انتخاب شهر", cities, (val) => setState(() => selectedCity = val));
  }

  void _showListModal(String title, List<String> items, Function(String) onSelect) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const Divider(height: 20),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(items[index], textAlign: TextAlign.center),
                  onTap: () { onSelect(items[index]); Navigator.pop(context); },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSave() async {
    setState(() => _isSaving = true);

    context.read<AuthBloc>().add(
      UserUpdateRequested(
        userId: widget.user.id,
        updatedData: {
          "name": nameController.text,
          "lestname": lastNameController.text,
          "province": selectedProvince ?? "",
          "city": selectedCity ?? "",
          "adderss": addressController.text,
        },
      ),
    );

    await Future.delayed(const Duration(seconds: 1)); // شبیه‌سازی لودینگ نمایشی
    if (mounted) setState(() => _isSaving = false);
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("خروج"),
        content: const Text("آیا مطمئن هستید؟"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("خیر")),
          TextButton(onPressed: () {
            context.read<AuthBloc>().add(LogoutRequested());
            Navigator.pop(context);
          }, child: const Text("بله", style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}