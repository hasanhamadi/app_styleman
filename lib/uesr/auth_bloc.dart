import 'package:app_styleman/uesr/storage_helper.dart';
import 'package:app_styleman/uesr/user_model.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final data = await repository.loginOrSignUp(event.mobile, event.password);
        final user = UserModel.fromJson(data['record']);
        await StorageHelper.saveAuthData(data['token'], user.id);
        emit(AuthAuthenticated(user));
      } catch (e) {
        emit(AuthError("خطا در ورود یا ثبت‌نام"));
      }
    });

    on<LogoutRequested>((event, emit) async {
      await StorageHelper.clearAll();
      emit(AuthInitial());
    });
  }
}