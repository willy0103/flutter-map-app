import 'package:flutter/material.dart';

import 'addfriend.dart';
import 'friendchat.dart';
import 'maps.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 250, 202, 233),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30, left: 5, right: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop(MapsPage);
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        )),
                    Text(
                      "Messages",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.search,
                          color: Colors.black,
                        ))
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(top: 3, left: 20, right: 20),
              height: 200,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(223, 136, 250, 250),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40))),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Your Friend",
                        style: TextStyle(color: Colors.black),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddFriend()),
                            );
                          },
                          icon: const Icon(
                            Icons.person_add_alt,
                            color: Colors.black,
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 90,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        buildContacAvatar('Alla', 'img1.jpeg'),
                        buildContacAvatar('July', 'img2.jpeg'),
                        buildContacAvatar('Mikle', 'img3.jpeg'),
                        buildContacAvatar('Kler', 'img4.jpeg'),
                        buildContacAvatar('Moane', 'img5.jpeg'),
                        buildContacAvatar('Julie', 'img6.jpeg'),
                        buildContacAvatar('Allen', 'img7.jpeg'),
                        buildContacAvatar('John', 'img8.jpeg'),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
              top: 240,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)),
                  color: Color(0xFFEFFFFC),
                ),
                child: ListView(
                  padding: const EdgeInsets.only(left: 25),
                  children: [
                    buildConversationRow('Laura', '專題好難', 'img1.jpeg', 0),
                    buildConversationRow('Laura', '專題加油', 'img2.jpeg', 5),
                    buildConversationRow('趙偉翔', '專題快點寫出來!黃梓銨', 'img3.jpeg', 2),
                    buildConversationRow('梓銨的女友', '梓銨好帥', 'img4.jpeg', 0),
                    buildConversationRow('梓銨的小三', '梓銨後端好強', 'img5.jpeg', 1),
                    buildConversationRow('梓銨媽媽', '為甚麼不回家', 'img6.jpeg', 0),
                    buildConversationRow('Laura', '專題好難', 'img7.jpeg', 3),
                    buildConversationRow('Laura', '專題好難', 'img8.jpeg', 0),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  Column buildConversationRow(
      String name, String message, String filename, int msgCount) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            // 在點擊時導航到聊天頁面
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeScreen(
                        username: name,
                      )),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  UserAvatar(filename: filename),
                  SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(color: Colors.black),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        message,
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(right: 25, top: 5),
                child: Column(
                  children: [
                    Text(
                      '14:25',
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    if (msgCount > 0)
                      CircleAvatar(
                        radius: 7,
                        backgroundColor: Color.fromARGB(255, 193, 117, 255),
                        child: Text(
                          msgCount.toString(),
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      )
                  ],
                ),
              )
            ],
          ),
        ),
        Divider(
          indent: 70,
        )
      ],
    );
  }

  Padding buildContacAvatar(String name, String filename) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Column(
        children: [
          UserAvatar(filename: filename),
          SizedBox(
            height: 5,
          ),
          Text(
            name,
            style: TextStyle(color: Colors.black, fontSize: 16),
          )
        ],
      ),
    );
  }
}

class UserAvatar extends StatelessWidget {
  final String filename;
  const UserAvatar({
    super.key,
    required this.filename,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 32,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        radius: 29,
        backgroundImage: Image.asset('assets/images/$filename').image,
      ),
    );
  }
}
// Navigate to chat screen with selected friend
//Navigator.push(
// context,
// MaterialPageRoute(
//   builder: (context) => ChatScreen(friend: friend),
//  ),
// );

//class ChatScreen extends StatelessWidget {
// final String friend;

//  const ChatScreen({Key? key, required this.friend}) : super(key: key);

//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('Chat with $friend'),
//      ),
//     body: const Center(
//        child: Text('Chat screen'),
//      ),
//    );
//  }
//}
