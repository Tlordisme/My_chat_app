import 'package:chat_app/features/contact/domain/entities/contact_entity.dart';

abstract class ContactRepository {
  Future<List<ContactEntity>> fetchContacts();
  Future<void> addContact({required String email});
}