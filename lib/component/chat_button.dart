import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../config.dart';
import '../provider/auth.dart';
import '../query/chatroom.dart';
import '../screen/chat_screen.dart';

class ChatButton extends StatefulWidget {
  const ChatButton({super.key});

  @override
  State<ChatButton> createState() => ChatButtonState();
}

class ChatButtonState extends State<ChatButton> {
  int? chatroomId;
  late WebSocketChannel _channel;

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  void _goToChat(BuildContext context, int chatroomId) async {
    // Map<String, dynamic> chatroom = await fetchChatroom();
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (BuildContext context) => ChatScreen(
          chatroomId: chatroomId,
        ),
      ),
    )
        .then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (context, auth, child) {
        return FutureBuilder(
          future: fetchChatroom(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              int chatroomId = snapshot.data?["chatroom_id"];

              _channel = IOWebSocketChannel.connect(
                Uri.parse(
                    "$WEBSOCKET_SERVER_URL/message/unread/count/ws/$chatroomId?token=${auth.token}"),
              );

              return StreamBuilder(
                stream: _channel.stream,
                builder: (context, snapshot) {
                  int unreadMessageCount = 0;
                  if (snapshot.hasData) {
                    unreadMessageCount = json.decode(snapshot.data);
                  }
                  if (unreadMessageCount > 0) {
                    return Stack(
                      children: [
                        FloatingActionButton(
                          onPressed: () => _goToChat(context, chatroomId),
                          backgroundColor: Colors.grey.shade900,
                          child: const Icon(Icons.chat_bubble_rounded),
                        ),
                        Container(
                          width: 20.0,
                          height: 20.0,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          child: Text(unreadMessageCount.toString()),
                        ),
                      ],
                    );
                  } else {
                    return FloatingActionButton(
                      onPressed: () => _goToChat(context, chatroomId),
                      backgroundColor: Colors.grey.shade900,
                      child: const Icon(Icons.chat_bubble_rounded),
                    );
                  }
                },
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        );
      },
    );
  }
}
