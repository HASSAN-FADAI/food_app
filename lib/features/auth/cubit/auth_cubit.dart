import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hunhry_food/core/errors/failure.dart';
import 'package:hunhry_food/features/auth/cubit/auth_state.dart';
import 'package:hunhry_food/features/auth/data/auth_repo.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  final AuthRepo authRepo = AuthRepo();
  // SignUp Fuction
  Future signUp({
    required String email,
    required String password,
    String? name,
    String? phone,
  }) async {
    emit(AuthLoading());
    try {
      final result = await authRepo.register(
        email: email,
        password: password,
        name: name,
      );
      if (result.failure != null) {
        emit(AuthError(result.failure!.messages));
      } else {
        emit(AuthSuccess());
      }
    } catch (e) {
      emit(AuthError('أحيانا تحدث أخطاء'));
    }
  }

  // LogIn Function
  Future login({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      final result = await authRepo.login(email: email, password: password);
      if (result.failure != null) {
        emit(AuthError(result.failure!.messages));
      } else {
        emit(AuthSuccess());
      }
    } catch (e) {
      emit(AuthError('أحيانا تحدث أخطاء'));
    }
  }

  Future<void> getUserProfile() async {
    emit(ProfileLoading());
    try {
      final result = await authRepo.getUserProfile();

      if (result.failure != null) {
        emit(ProfileError(result.failure!.messages));
      } else if (result.userData != null) {
        emit(
          ProfileSuccsess(
            name: result.userData!['name'],
            email: result.userData!['email'],
          ),
        );
      }
    } catch (e) {
      emit(ProfileError('أحيانا تحدث أخطاء'));
    }
  }

  Future<void> logout() async {
    emit(LogoutLoading());
    try {
      final result = await authRepo.logout();
      if (result.isSuccess) {
        emit(LogoutSuccess());
      } else {
        emit(LogoutError(result.failure!.messages));
      }
    } catch (e) {
      emit(LogoutError('أحيانا تحدث أخطاء'));
    }
  }
}
