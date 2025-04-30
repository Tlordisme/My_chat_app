import 'dart:convert';
import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:http/http.dart' as http;

class AuthRemoteSource {
  final String baseUrl = 'http://192.168.1.13:8000/auth';
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    // try {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: jsonEncode({'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );
    //   if (response.statusCode == 201) {
    return UserModel.fromJson(jsonDecode(response.body)['user']);
    //   } else {
    //     throw Exception('Failed to log in user');
    //   }
    // } catch (e) {
    //   throw Exception('Network error: $e');
    // }
  }

  Future<UserModel> register({
    required String username,
    required String email,
    required String password,
  }) async {
    // try {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    print("Response body: ${response.body}");
    return UserModel.fromJson(jsonDecode(response.body)['user']);
    //   if (response.statusCode == 201) {
    //     return UserModel.fromJson(jsonDecode(response.body)['user']);
    //   } else {
    //     throw Exception('Failed to register user');
    //   }
    // } catch (e) {
    //   throw Exception('Network error: $e');
    // }

    
  }

  Future<void> verifyOtp({required String email, required otp}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'otp': otp}),
    );
    if (response.statusCode != 200) {
      throw Exception('Xác thực OTP thất bại');
    }
  }
}
