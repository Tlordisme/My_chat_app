import 'package:chat_app/core/theme.dart';
import 'package:chat_app/features/contact/presentation/pages/contact_page.dart';
import 'package:chat_app/features/conversation/presentation/bloc/conversation_bloc.dart';
import 'package:chat_app/features/conversation/presentation/bloc/conversation_event.dart';
import 'package:chat_app/features/conversation/presentation/bloc/conversation_state.dart';
import 'package:chat_app/features/message/presentation/pages/message_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({super.key});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  @override
  void initState() {
    // TODO: implement ==
    super.initState();
    BlocProvider.of<ConversationBloc>(context).add(FetchConversations());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Message', style: Theme.of(context).textTheme.titleLarge),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 70,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15.0,
              vertical: 3.0,
            ),
            child: Text('Recent', style: Theme.of(context).textTheme.bodySmall),
          ),
          Container(
            height: 100,
            padding: EdgeInsets.all(4),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildRecentContact("Thanh dep trai", context),
                _buildRecentContact("Long", context),
                _buildRecentContact("Dao", context),
                _buildRecentContact("Thai", context),
                _buildRecentContact("Thanh dep trai", context),
                _buildRecentContact("Meo", context),
                _buildRecentContact("Thanh dep trai", context),
                _buildRecentContact("Thanh dep trai", context),
                _buildRecentContact("Thanh dep trai", context),
                _buildRecentContact("Thanh dep trai", context),
                _buildRecentContact("Thanh dep trai", context),
                _buildRecentContact("Thanh dep trai", context),
              ],
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: DefaultColors.messageListPage,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),

              child: BlocBuilder<ConversationBloc, ConversationState>(
                builder: (context, state) {
                  if (state is ConversationLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is ConversationLoaded) {
                    return ListView.builder(
                      itemCount: state.conversations.length,
                      itemBuilder: (context, index) {
                        final conversation = state.conversations[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => MessagePage(
                                      conversationId: conversation.id,
                                      mate: conversation.displayName,
                                    ),
                              ),
                            );
                          },
                          child: _buildMessageTile(
                            conversation.displayName,
                            conversation.lastMessage,
                            DateFormat(
                              'HH:mm dd/MM',
                            ).format(conversation.lastMessageTime!),
                          ),
                        );
                      },
                    );
                  } else if (state is ConversationError) {
                    return Center(child: Text(state.message));
                  }
                  return Center(child: Text('No conversations found'));
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ContactPage()),
          );
        },
        backgroundColor: DefaultColors.buttonColor,
        child: Icon(Icons.contacts),
      ),
    );
  }

  Widget _buildMessageTile(String name, String message, String time) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(
          'https://wallpapercave.com/wp/wp3262663.jpg',
        ),
      ),
      title: Text(
        name,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        message,
        style: TextStyle(color: Colors.grey),
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(time, style: TextStyle(color: Colors.grey)),
    );
  }

  Widget _buildRecentContact(String name, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(
              'https://wallpapercave.com/wp/wp3262663.jpg',
            ),
          ),
          SizedBox(height: 5),
          Text(name, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
