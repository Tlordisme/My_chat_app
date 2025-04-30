import 'package:chat_app/features/auth/data/datasource/auth_remote_source.dart';
import 'package:chat_app/features/auth/domain/entities/user_entity.dart';
import 'package:chat_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepoImplementation extends AuthRepository {
  final AuthRemoteSource authRemoteSource;

  AuthRepoImplementation({required this.authRemoteSource});

  @override
  Future<UserEntity> login(String email, String password) async {
    return await authRemoteSource.login(email: email, password: password);
  }

  @override
  Future<UserEntity> register(String username, String email, String password) async {
    return await authRemoteSource.register(username: username, email: email, password: password);
  }
  
  @override
  Future<void> verifyOtp(String email, String otp) async {
    // TODO: implement verifyOtp
    return await authRemoteSource.verifyOtp(email: email, otp: otp);
  }
}