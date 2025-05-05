import 'package:chat_app/features/contact/data/datasource/contact_remote_source.dart';
import 'package:chat_app/features/contact/domain/entities/contact_entity.dart';
import 'package:chat_app/features/contact/domain/repositories/contact_repository.dart';

class ContactRepoImplementation extends ContactRepository {
  final ContactRemoteSource contactRemoteSource;
  ContactRepoImplementation({required this.contactRemoteSource});
  @override
  Future<void> addContact({required String email}) async {
    await contactRemoteSource.addContact(email: email);
  }

  @override
  Future<List<ContactEntity>> fetchContacts() async {
    return await contactRemoteSource.fetchContacts();
  }
}
