import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../config.dart';
import '../provider/auth.dart';
import '../query/chatroom.dart';
import '../utils/navigator.dart';

class ChatButton extends StatefulWidget {
  final double iconSize;
  const ChatButton({required this.iconSize, super.key});

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

  Widget chatIcon(int chatroomId, double size) {
    return IconButton(
      onPressed: () => goToChat(
        context,
        chatroomId,
        (value) {
          setState(() {});
        },
      ),
      icon: Icon(Icons.chat_bubble_outline, size: size),
    );
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
                        chatIcon(chatroomId, widget.iconSize),
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
                    return chatIcon(chatroomId, widget.iconSize);
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
