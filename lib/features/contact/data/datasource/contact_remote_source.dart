import 'dart:convert';

import 'package:chat_app/features/contact/data/models/contact_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ContactRemoteSource {
  final String baseUrl = 'http://192.168.0.2:8000';
  final _storage = FlutterSecureStorage();

  Future<List<ContactModel>> fetchContacts() async {
    String token = await _storage.read(key: 'token') ?? '';
    final response = await http.get(
      Uri.parse('$baseUrl/contacts'),
      headers: {'Authorization': 'Beared $token'},
    );
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((json) => ContactModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch contacts');
    }
  }

  Future<void> addContact({required String email}) async {
    String token = await _storage.read(key: 'token') ?? '';
    final response = await http.post(
      Uri.parse('$baseUrl/contacts'),
      body: jsonEncode({'contactEmail': email}),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Beared $token',
      },
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add contact');
    }
    ;
  }
}
