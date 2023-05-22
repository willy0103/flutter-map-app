import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'addfriend.dart';
import 'login_page.dart';
import 'mysetting.dart';

class personal extends StatefulWidget {
  const personal({Key? key}) : super(key: key);

  @override
  State<personal> createState() => _personalState();
}

class _personalState extends State<personal> {
  String _username = '';
  ImageProvider? _userImage;
  String _id = '';

  @override
  void initState() {
    super.initState();
    myFunction();
    getUserImage();
  }

  Future<void> myFunction() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final response = await http.get(
      Uri.parse('http://192.168.0.108:3000/user/getUserName'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    setState(() {
      final json = jsonDecode(response.body);
      _username = json['name'];
    });
  }

  Future<void> getUserImage() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final response = await http.get(
      Uri.parse('http://192.168.0.108:3000/user/getImg'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _userImage = MemoryImage(response.bodyBytes);
      });
    } else {
      throw Exception('Failed to load image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xffffffff),
      child: ListView(
        padding: EdgeInsets.all(12),
        physics: BouncingScrollPhysics(),
        children: [
          Container(
            height: 20,
          ),
          userTile(),
          divider(),
          colorTiles(),
          //bwTiles(),
          SizedBox(
            height: 130,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MapsPage()),
              );
            },
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Center(
                    child: Icon(Icons.cancel, color: Colors.red),
                  ),
                ),
                // 在此添加其他小部件
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget userTile() {
    return ListTile(
      leading: GestureDetector(
        onTap: () {
          _pickImage();
        },
        child: CircleAvatar(
          radius: 30,
          backgroundImage: _userImage,
        ),
      ),
      title: Text(
        _username,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      subtitle: Text(_id),
    );
  }

  Widget divider() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Divider(
        thickness: 3,
      ),
    );
  }

  Widget colorTiles() {
    return Column(
      children: [
        colortile(
          Icons.perm_contact_cal_outlined,
          Colors.deepPurple,
          "編輯個人帳戶",
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => mysetting()),
          ),
        ),
        SizedBox(height: 10),
        colortile(
          Icons.home,
          const Color.fromARGB(255, 58, 143, 183),
          "設置自己的位置",
          () {},
        ),
        SizedBox(height: 10),
        colortile(
          Icons.group_add,
          Color.fromARGB(255, 183, 133, 58),
          "添加好友",
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddFriend()),
          ),
        ),
        SizedBox(height: 10),
        colortile(
          Icons.quick_contacts_dialer_sharp,
          const Color.fromARGB(255, 183, 58, 166),
          "聯絡我們",
          () {},
        ),
        SizedBox(height: 10),
        colortile(
          Icons.article,
          Color.fromARGB(255, 62, 183, 58),
          "服務條款",
          () {},
        ),
        SizedBox(height: 10),
        colortile(
          Icons.delete_forever_outlined,
          const Color.fromARGB(255, 183, 58, 58),
          "刪除帳號",
          () {},
        ),
        SizedBox(height: 10),
        colortile(
          Icons.follow_the_signs_outlined,
          const Color.fromARGB(255, 183, 58, 135),
          "登出",
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget colortile(
    IconData icon,
    Color color,
    String text,
    VoidCallback onTapFunction,
  ) {
    return ListTile(
      leading: Container(
        child: Icon(icon, color: color),
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      title: Text(
        text,
        style: TextStyle(color: const Color.fromARGB(255, 0, 41, 75)),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Colors.black,
        size: 20,
      ),
      onTap: onTapFunction,
    );
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _userImage = FileImage(File(pickedFile.path));
      });
      final bytes = await pickedFile.readAsBytes();
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final response = await http.post(
        Uri.parse('http://192.168.0.108:3000/user/changeImg'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'image': base64Encode(bytes)}),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to upload image');
      }
    }
  }
}
