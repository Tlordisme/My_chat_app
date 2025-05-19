
import 'dart:convert';
import 'dart:io';

import 'package:chat_app/features/message/data/models/message_model.dart';
import 'package:chat_app/features/message/domain/entities/message_entity.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;


class MessageRemoteSource {
  final String baseUrl = 'http://192.168.0.2:8000';
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

  Future<MessageEntity> uploadMedia({
    required String conversationId,
    required String senderId,
    required String content,
    required File file,
  }) async {
    final token = await _storage.read(key: 'token') ?? '';

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/messages/upload'),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['conversationId'] = conversationId;
    request.fields['senderId'] = senderId;
    request.fields['content'] = content;

    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    final res = await http.Response.fromStream(response);

    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      return MessageModel.fromJson(json);
    } else {
      throw Exception('Upload failed');
    }
  }


}