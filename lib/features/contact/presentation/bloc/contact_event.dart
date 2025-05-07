abstract class ContactEvent {}

class FetchContacts extends ContactEvent {}

class AddContact extends ContactEvent {
  final String email;
  AddContact(this.email);
}

class CheckCreateConversation extends ContactEvent {
 final String contactId;
 final String contactName;
 CheckCreateConversation(this.contactId, this.contactName);
}
