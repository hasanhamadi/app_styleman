part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}
class LoginRequested extends AuthEvent { final String mobile, password; LoginRequested(this.mobile, this.password); }
class LogoutRequested extends AuthEvent {}