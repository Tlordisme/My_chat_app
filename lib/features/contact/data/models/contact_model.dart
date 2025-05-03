import 'package:chat_app/features/contact/domain/entities/contact_entity.dart';

class ContactModel extends ContactEntity {
  ContactModel({required id, required username, required email})
    : super(id: id, username: username, email: email);
  
  
  
  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
    );
  }
}
