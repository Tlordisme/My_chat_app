import 'package:chat_app/features/contact/presentation/bloc/contact_bloc.dart';
import 'package:chat_app/features/contact/presentation/bloc/contact_event.dart';
import 'package:chat_app/features/contact/presentation/bloc/contact_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contacts')),
      body: BlocBuilder<ContactBloc, ContactState>(
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
                    Navigator.pop(context, contact);
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
            title: Text('Add context'),
            content: TextField(
              controller: emailController,
              decoration: InputDecoration(hintText: 'Enter email: '),
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
                    BlocProvider.of<ContactBloc>(context).add(AddContact(email));
                    Navigator.pop(context);
                  }
                },
                child: Text('Add'),
              ),
            ],
          ),
    );
  }
}
