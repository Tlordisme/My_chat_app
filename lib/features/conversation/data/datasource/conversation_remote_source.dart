import 'dart:convert';

import 'package:chat_app/features/conversation/data/models/conversation_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ConversationRemoteSource {
  final String baseUrl = 'http://192.168.1.13:8000';
  final _storage = FlutterSecureStorage();

  Future<List<ConversationModel>> fetchConversations() async {
    String token = await _storage.read(key: 'token') ?? '';
    // String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImQ4ZjUzMjA1LWU3ZTktNGM5Yy05ZWI0LWY4MDliZThlMjYzYyIsImlhdCI6MTc0NDgyNDM2NiwiZXhwIjoxNzQ0ODI3OTY2fQ.06OBEpKRw2RiFOf7Mwg15FqYft4ZmOd0kuluG74gA2U";
    final response = await http.get(
      Uri.parse('$baseUrl/conversations'),
      headers: {'Authorization': 'Bearer $token'},
    );

    print(response.body);
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((json) => ConversationModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch conversations');
    }
  }
}
