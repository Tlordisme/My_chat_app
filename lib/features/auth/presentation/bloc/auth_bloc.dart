// import 'package:chat_app/features/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:chat_app/features/auth/domain/usecases/verify_otp_usecase.dart';
import "package:flutter_bloc/flutter_bloc.dart";
import 'package:chat_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:chat_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:chat_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:chat_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUsecase registerUsecase;
  final LoginUsecase loginUsecase;
  final VerifyOtpUsecase verifyOtpUsecase;
  final _storage = FlutterSecureStorage();

  AuthBloc({
    required this.verifyOtpUsecase,
    required this.registerUsecase,
    required this.loginUsecase,
  }) : super(AuthInitial()) {
    on<RegisterEvent>(_onRegister);
    on<LoginEvent>(_onLogin);
    on<VerifyOtpEvent>(_onVerifyOtp);
  }
  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await registerUsecase.call(
        event.username,
        event.email,
        event.password,
      );
      print("Dang ki thanh cong: ${user}");
      emit(AuthWait(email: event.email));
    } catch (e) {
      print("Register error: $e");
      emit(AuthFail(error: 'Failed regis'));
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    try {
      final user = await loginUsecase.call(event.email, event.password);
      if (user == null || user.token == null) {
        throw Exception("Invalid credentials");
      }
      await _storage.write(key: 'token', value: user.token);
      await _storage.write(key: 'userId', value: user.id);
      print('token: ${user.token}');
      emit(AuthSuccess(message: "Success"));
    } catch (e) {
      emit(AuthFail(error: e.toString()));
    }
  }

  Future<void> _onVerifyOtp(
    VerifyOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await verifyOtpUsecase.call(event.email, event.otp);
      print("Sending request with: email=${event.email}, otp=${event.otp}");

      emit(AuthSuccess(message: "Hoàn tất OTP"));
      emit(AuthInitial());
    } catch (e) {
      print("Verify OTP error: $e");
      emit(AuthFail(error: 'OTP Verification Failed'));
    }
  }
}