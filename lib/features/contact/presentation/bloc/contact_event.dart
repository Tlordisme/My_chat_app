abstract class ContactEvent {}

class FetchContacts extends ContactEvent {}

class AddContact extends ContactEvent {
  final String email;
  AddContact(this.email);
}
