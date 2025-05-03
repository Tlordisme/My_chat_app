import 'package:chat_app/features/contact/domain/repositories/contact_repository.dart';

class AddContactUsecase {
  final ContactRepository contactRepository;
  AddContactUsecase({required this.contactRepository});
  Future<void> call({required String email}) async {
    return await contactRepository.addContact(email: email);
  }
}
