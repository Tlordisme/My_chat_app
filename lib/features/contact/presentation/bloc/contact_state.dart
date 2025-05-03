import 'package:chat_app/features/contact/domain/entities/contact_entity.dart';

abstract class ContactState {}

class ContactInitial extends ContactState{}

class ContactLoading extends ContactState{}
class ContactLoaded extends ContactState{
  final List<ContactEntity> contacts;
  ContactLoaded({required this.contacts});
}

class ContactError extends ContactState{
  final String error;
  ContactError(this.error);
}
class ContactAdded extends ContactState{
}