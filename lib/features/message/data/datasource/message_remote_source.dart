import 'dart:convert';

import 'package:chat_app/features/message/data/models/message_model.dart';
import 'package:chat_app/features/message/domain/entities/message_entity.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class MessageRemoteSource {
  final String baseUrl = 'http://192.168.1.13:8000';
  final _storage = FlutterSecureStorage();
  
  Future<List<MessageEntity>> fetchMessage(String conversationId) async {
    String token = await _storage.read(key: 'token') ?? '';
    final response = await http.get(
      Uri.parse('$baseUrl/messages/$conversationId'),
      headers: {'Authorization' : 'Bearer $token'}
    );
    if(response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((json) => MessageModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch');
    }

  }
}