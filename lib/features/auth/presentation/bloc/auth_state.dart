abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String message;
  AuthSuccess({required this.message});
}

class AuthFail extends AuthState {
  final String error;
  AuthFail({required this.error});
}

class AuthWait extends AuthState {
  final String email;

  AuthWait({required this.email});
}
