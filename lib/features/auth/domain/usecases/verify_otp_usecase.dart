import 'package:chat_app/features/auth/domain/repositories/auth_repository.dart';

class VerifyOtpUsecase {
  final AuthRepository repository;

  VerifyOtpUsecase({required  this.repository});

  Future<void> call(String email, String otp) async {
    await repository.verifyOtp(email, otp);
  }
}
