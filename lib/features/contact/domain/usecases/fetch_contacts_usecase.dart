import 'package:chat_app/features/contact/domain/entities/contact_entity.dart';
import 'package:chat_app/features/contact/domain/repositories/contact_repository.dart';

class FetchContactsUsecase {
  final ContactRepository contactRepository;
  FetchContactsUsecase({required this.contactRepository});

  Future<List<ContactEntity>> call() async {
    return await contactRepository.fetchContacts();
  }
}
