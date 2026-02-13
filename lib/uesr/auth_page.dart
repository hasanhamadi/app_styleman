
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_bloc.dart';
class AuthPage extends StatelessWidget {
  final _mobile = TextEditingController();
  final _pass = TextEditingController();

  AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        // ۱. گوش دادن به تغییرات وضعیت برای جابجایی
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            // وقتی کاربر با موفقیت احراز هویت شد
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("خوش آمدید!")),
            );

            /* نکته: چون AuthPage درون MainWrapper قرار دارد،
            با تغییر State به AuthAuthenticated، خودِ MainWrapper
            به صورت خودکار صفحه را عوض می‌کند. اما اگر بخواهید به یک صفحه کاملاً مجزا بروید:
            Navigator.pushReplacementNamed(context, '/home');
            */
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
              const Text("ورود به استایل‌من", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              TextField(controller: _mobile, decoration: const InputDecoration(labelText: "شماره موبایل", border: OutlineInputBorder())),
              const SizedBox(height: 15),
              TextField(controller: _pass, decoration: const InputDecoration(labelText: "رمز عبور", border: OutlineInputBorder()), obscureText: true),
              const SizedBox(height: 30),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthLoading) return const CircularProgressIndicator();
                  return SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_mobile.text.isNotEmpty && _pass.text.isNotEmpty) {
                          context.read<AuthBloc>().add(LoginRequested(_mobile.text, _pass.text));
                        }
                      },
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