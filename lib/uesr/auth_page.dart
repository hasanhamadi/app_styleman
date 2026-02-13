import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_bloc.dart';


class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _mobileController = TextEditingController();
  final _passController = TextEditingController();

  // متغیری برای کنترل وضعیت فعال بودن دکمه
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    // گوش دادن به تغییرات فیلدها برای بررسی اعتبار
    _mobileController.addListener(_validateInput);
    _passController.addListener(_validateInput);
  }

  void _validateInput() {
    final mobile = _mobileController.text;
    final pass = _passController.text;

    // شرط: موبایل دقیقاً ۱۱ رقم و پسورد حداقل ۸ کاراکتر
    final bool isValid = mobile.length == 11 && pass.length >= 8;

    if (isValid != _isButtonEnabled) {
      setState(() {
        _isButtonEnabled = isValid;
      });
    }
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("خوش آمدید!")),
            );
          }
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("ورود به استایل‌من",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),

              // فیلد شماره موبایل
              TextField(
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                maxLength: 11, // محدودیت ورود کاراکتر
                decoration: const InputDecoration(
                  labelText: "شماره موبایل",
                  border: OutlineInputBorder(),
                  counterText: "", // مخفی کردن عدد شمارنده پایین فیلد
                ),
              ),
              const SizedBox(height: 15),

              // فیلد رمز عبور
              TextField(
                controller: _passController,
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: "رمز عبور (حداقل ۸ رقم)",
                    border: OutlineInputBorder()
                ),
              ),
              const SizedBox(height: 30),

              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthLoading) return const CircularProgressIndicator();

                  return SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      // اگر فرم معتبر نباشد، مقدار null دکمه را غیرفعال می‌کند
                      onPressed: _isButtonEnabled
                          ? () {
                        context.read<AuthBloc>().add(
                            LoginRequested(_mobileController.text, _passController.text)
                        );
                      }
                          : null,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("تایید و ادامه"),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}