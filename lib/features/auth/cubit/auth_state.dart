abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class ProfileLoading extends AuthState {}

class ProfileSuccsess extends AuthState {
  final String name;
  final String email;
  // final String address;

  ProfileSuccsess({
    required this.name,
    required this.email,
    // required this.address,
  });
}

class ProfileError extends AuthState {
  final String message;
  ProfileError(this.message);
}

class LogoutLoading extends AuthState {}

class LogoutSuccess extends AuthState {}

class LogoutError extends AuthState {
  final String message;
  LogoutError(this.message);
}
