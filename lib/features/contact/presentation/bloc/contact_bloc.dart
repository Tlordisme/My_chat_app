import 'package:chat_app/features/contact/domain/usecases/add_contact_usecase.dart';
import 'package:chat_app/features/contact/domain/usecases/fetch_contacts_usecase.dart';
import 'package:chat_app/features/contact/presentation/bloc/contact_event.dart';
import 'package:chat_app/features/contact/presentation/bloc/contact_state.dart';
import 'package:chat_app/features/conversation/domain/usecases/check_create_conversation_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final FetchContactsUsecase fetchContactsUsecase;
  final AddContactUsecase addContactUsecase;
  final CheckCreateConversationUsecase checkCreateConversationUsecase;

  ContactBloc({
    required this.fetchContactsUsecase,
    required this.addContactUsecase,
    required this.checkCreateConversationUsecase,
  }) : super(ContactInitial()) {
    on<FetchContacts>(_onFetchContacts);
    on<AddContact>(_onAddContact);
    on<CheckCreateConversation>(_onCheckCreateConversation);
  }

  Future<void> _onFetchContacts(
    FetchContacts event,
    Emitter<ContactState> emit,
  ) async {
    emit(ContactLoading());
    try {
      final contacts = await fetchContactsUsecase();
      emit(ContactLoaded(contacts: contacts));
    } catch (error) {
      emit(ContactError('Failed to Load contacts.'));
    }
  }

  Future<void> _onAddContact(
    AddContact event,
    Emitter<ContactState> emit,
  ) async {
    emit(ContactLoading());
    try {
      await addContactUsecase(email: event.email);
      final contacts = await fetchContactsUsecase();
      final addedContact = contacts.firstWhere(
        (contact) => contact.email == event.email,
        orElse: () => throw Exception("Contact not found"),
      );
      final conversationId = await checkCreateConversationUsecase(
        contactId: addedContact.id,
      );
      emit(
        ConversationReady(
          conversationId: conversationId,
          contactName: addedContact.username,
        ),
      );

      // Load lại danh sách
      emit(ContactLoaded(contacts: contacts));
    } catch (error) {
      emit(ContactError('Failed to add contact.'));
    }
  }

  Future<void> _onCheckCreateConversation(
    CheckCreateConversation event,
    Emitter<ContactState> emit,
  ) async {
    try {
      emit(ContactLoading());
      final conversationId = await checkCreateConversationUsecase(
        contactId: event.contactId,
      );
      emit(
        ConversationReady(
          conversationId: conversationId,
          contactName: event.contactName,
        ),
      );

    } catch (error) {
      emit(ContactError('Failed to start new conversation'));
    }
  }
}
