import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:provider/provider.dart';

import '../model/message.dart';
import '../providers/chat.dart';

class HomeScreen extends StatefulWidget {
  final String username;
  const HomeScreen({Key? key, required this.username}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late IO.Socket _socket;
  final TextEditingController _messageInputController = TextEditingController();

  _sendMessage() {
    _socket.emit('message', {
      'message': _messageInputController.text.trim(),
      'sender': widget.username
    });
    _messageInputController.clear();
  }

  _connectSocket() {
    _socket.onConnect((data) => print('Connection established'));
    _socket.onConnectError((data) => print('Connect Error: $data'));
    _socket.onDisconnect((data) => print('Socket.IO server disconnected'));
    _socket.on(
      'message',
      (data) => Provider.of<HomeProvider>(context, listen: false).addNewMessage(
        Message.fromJson(data),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    //Important: If your server is running on localhost and you are testing your app on Android then replace http://localhost:3000 with http://10.0.2.2:3000
    _socket = IO.io(
      'http://192.168.0.108:4000',
      IO.OptionBuilder().setTransports(['websocket']).setQuery(
          {'username': widget.username}).build(),
    );
    _connectSocket();
  }

  @override
  void dispose() {
    _messageInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeProvider(), // 添加提供者
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16, top: 16),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.purple,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage('path_to_user_avatar_image'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Consumer<HomeProvider>(
                builder: (_, provider, __) => ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final message = provider.messages[index];
                    return Wrap(
                      alignment: message.senderUsername == widget.username
                          ? WrapAlignment.end
                          : WrapAlignment.start,
                      children: [
                        Card(
                          color: message.senderUsername == widget.username
                              ? Theme.of(context).primaryColorLight
                              : Color.fromARGB(255, 231, 138, 138),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment:
                                  message.senderUsername == widget.username
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                              children: [
                                Text(message.message),
                                Text(
                                  DateFormat('hh:mm a').format(message.sentAt),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  },
                  separatorBuilder: (_, index) => const SizedBox(
                    height: 5,
                  ),
                  itemCount: provider.messages.length,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 2,
              ),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, // 将子部件水平居中
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () {
                        // 相機圖示的點擊事件處理
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10), // 設定方形圓角的半徑
                          color:
                              Color.fromARGB(255, 253, 150, 210), // 設定圖示的背景顏色
                        ),
                        child: Icon(Icons.camera_alt,
                            color:
                                Color.fromARGB(255, 255, 255, 255)), // 設定圖示的顏色
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () {
                        // 相冊圖示的點擊事件處理
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10), // 設定方形圓角的半徑
                          color:
                              Color.fromARGB(255, 253, 150, 210), // 設定圖示的背景顏色
                        ),
                        child: Icon(Icons.photo,
                            color:
                                Color.fromARGB(255, 255, 255, 255)), // 設定圖示的顏色
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextField(
                          controller: _messageInputController,
                          decoration: InputDecoration(
                            hintText: 'Type your message here...',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 174, 0, 255),
                                  width: 10),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10), // 增加垂直方向的数值以填充整个输入框
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_messageInputController.text.trim().isNotEmpty) {
                          _sendMessage();
                        }
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromARGB(255, 253, 150, 210),
                        ),
                        child: Icon(Icons.send, color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
