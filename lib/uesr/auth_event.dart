part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}
class LoginRequested extends AuthEvent {
  final String mobile;
  final String password;
  LoginRequested(this.mobile, this.password);
}

class LogoutRequested extends AuthEvent {}

// ایونت جدید
class UserUpdateRequested extends AuthEvent {
  final String userId;
  final Map<String, dynamic> updatedData;
  UserUpdateRequested({required this.userId, required this.updatedData});
}