import 'package:chat_app/features/contact/presentation/bloc/contact_bloc.dart';
import 'package:chat_app/features/contact/presentation/bloc/contact_event.dart';
import 'package:chat_app/features/contact/presentation/bloc/contact_state.dart';
import 'package:chat_app/features/message/presentation/pages/message_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});
  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ContactBloc>(context).add(FetchContacts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocListener<ContactBloc, ContactState>(
        listener: (context, state) async {
          final contactBloc = BlocProvider.of<ContactBloc>(context);
          if (state is ConversationReady) {
            var res = await Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => MessagePage(
                      conversationId: state.conversationId,
                      mate: state.contactName,
                    ),
              ),
            );
            if (res == null) {
              contactBloc.add(FetchContacts());
            }
          }
        },
        child: BlocBuilder<ContactBloc, ContactState>(
          builder: (context, state) {
            if (state is ContactLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ContactLoaded) {
              return ListView.builder(
                itemCount: state.contacts.length,
                itemBuilder: (context, index) {
                  final contact = state.contacts[index];
                  return ListTile(
                    title: Text(contact.username),
                    subtitle: Text(contact.email),
                    onTap: () {
                      BlocProvider.of<ContactBloc>(context).add(
                        CheckCreateConversation(contact.id, contact.username),
                      );
                    },
                  );
                },
              );
            } else if (state is ContactError) {
              return Center(child: Text(state.error));
            }
            return Center(child: Text('No Contact'));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddContactDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddContactDialog(BuildContext context) {
    final emailController = TextEditingController();
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: Text(
              'Add context',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            content: TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Enter email: ',
                hintStyle: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final email = emailController.text.trim();
                  if (email.isNotEmpty) {
                    BlocProvider.of<ContactBloc>(
                      context,
                    ).add(AddContact(email));
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  'Add',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
    );
  }
}
