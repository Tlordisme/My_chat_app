import 'package:chat_app/core/theme.dart';
import 'package:chat_app/features/message/presentation/bloc/message_bloc.dart';
import 'package:chat_app/features/message/presentation/bloc/message_event.dart';
import 'package:chat_app/features/message/presentation/bloc/message_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MessagePage extends StatefulWidget {
  final String conversationId;
  final String mate;
  const MessagePage({
    super.key,
    required this.conversationId,
    required this.mate,
  });

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final TextEditingController _messageController = TextEditingController();
  final _storage = FlutterSecureStorage();
  String userId = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<MessageBloc>(
      context,
    ).add(LoadMessageEvent(widget.conversationId));
    fetchUserId();
  }

  void fetchUserId() async {
    String storedUserId = await _storage.read(key: 'userId') ?? '';
    setState(() {
      userId = storedUserId;
    });
    BlocProvider.of<MessageBloc>(context).add(
    LoadMessageEvent(widget.conversationId),
  );

    print('+++++++++++++++++++=USER: $userId+++++++++++++++++++++++++++++=');
  }
  // void fetchUserId() async {
  //   final storedUserId = await _storage.read(key: 'userId');
  //   print("==> STORAGE RETURNED: $storedUserId"); // in ra xem có không
  //   if (storedUserId != null && storedUserId.isNotEmpty) {
  //     setState(() {
  //       userId = storedUserId;
  //     });
  //     BlocProvider.of<MessageBloc>(
  //       context,
  //     ).add(LoadMessageEvent(widget.conversationId));
  //   } else {
  //     print("==> userId trong storage đang rỗng hoặc chưa được lưu.");
  //   }
  // }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final content = _messageController.text.trim();
    print("Sending message: $content");
    if (content.isNotEmpty) {
      BlocProvider.of<MessageBloc>(
        context,
      ).add(SendMessageEvent(widget.conversationId, content));
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userId.isEmpty) {
      // hoặc return CircularProgressIndicator();
      return Scaffold(
        appBar: AppBar(
          title: Text("Đang tải..."),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                'https://wallpapercave.com/wp/wp3262663.jpg',
              ),
            ),
            SizedBox(width: 10),
            Text(
              '${widget.mate}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<MessageBloc, MessageState>(
              builder: (context, state) {
                if (state is MessageLoadingState) {
                  // return Center(child: Text("Ảo thật đấy"));
                  return Center(child: CircularProgressIndicator());
                } else if (state is MessageLoadedState) {
                  return ListView.builder(
                    padding: EdgeInsets.all(20),
                    itemCount: state.message.length,
                    itemBuilder: (context, index) {
                      final message = state.message[index];
                      final isSentMessage = message.senderId == userId;
                      print("senderId: ${message.senderId}, userId: $userId");

                      if (isSentMessage) {
                        print("senderId: ${message.senderId}, userId: $userId");
                        return _buildSendMessage(context, message.content);
                      } else {
                        return _buildReceivedMessage(context, message.content);
                      }
                    },
                  );
                } else if (state is MessageErrorState) {
                  return Center(child: Text(state.message));
                }
                return Center(child: Text("No message"));
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildReceivedMessage(BuildContext context, String message) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(right: 30, top: 5, bottom: 5),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: DefaultColors.receiverMessage,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(message, style: Theme.of(context).textTheme.bodyMedium),
      ),
    );
  }

  Widget _buildSendMessage(BuildContext context, String message) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(top: 5, bottom: 5),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: DefaultColors.senderMessage,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(message, style: Theme.of(context).textTheme.bodyMedium),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      decoration: BoxDecoration(
        color: DefaultColors.sentMessageInput,
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          GestureDetector(
            child: Icon(Icons.camera_alt, color: Colors.grey),
            onTap: () {},
          ),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Message",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            child: Icon(Icons.send, color: Colors.grey),
            onTap: _sendMessage,
          ),
        ],
      ),
    );
  }
}
