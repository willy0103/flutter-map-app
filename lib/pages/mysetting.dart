import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modernlogintute/components/my_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/name_textfield.dart';
import 'package:http/http.dart' as http;

import 'myhome.dart';

class mysetting extends StatefulWidget {
  const mysetting({Key? key}) : super(key: key);

  @override
  State<mysetting> createState() => _mysettingState();
}

class _mysettingState extends State<mysetting> {
  final nameController = TextEditingController();
  String _username = '';
  ImageProvider? _userImage;

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

  void navigateToHomePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const personal()),
    );
  }

  _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final croppedFilePath = await _cropImage(File(pickedFile.path));
      final croppedFile = File(croppedFilePath);
      setState(() {
        _userImage = FileImage(croppedFile);
      });

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final url = Uri.parse('http://192.168.0.108:3000/user/changeUserImg');
      final request = http.MultipartRequest('PUT', url)
        ..headers['Authorization'] = 'Bearer $token'
        ..files.add(
            await http.MultipartFile.fromPath('user_img', croppedFile.path));

      final response = await request.send();
      if (response.statusCode != 200) {
        throw Exception(
            'Failed to upload image. Status code: ${response.statusCode}');
      }
    }
  }

  _cropImage(File pickedFile) async {
    final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: "Image Cropper",
              toolbarColor: Color.fromARGB(255, 245, 196, 250),
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: "Image Cropper",
          )
        ]);

    return croppedFile?.path ?? pickedFile.path;
  }

  void _changeUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final response = await http.put(
      Uri.parse('http://192.168.0.108:3000/user/changeUserName'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'name': nameController.text}),
    );
    if (response.statusCode == 201) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          content: Container(
            padding: const EdgeInsets.all(16),
            height: 90,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 218, 176, 182),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: const Center(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "✶✶✶恭喜✶✶✶",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Spacer(),
                        Text(
                          "成功更換頭像與名子",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );
      // ignore: use_build_context_synchronously
      navigateToHomePage(context);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          content: Container(
            padding: const EdgeInsets.all(16),
            height: 90,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 218, 176, 182),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: const Center(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "☹更換失敗☹",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Spacer(),
                        Text(
                          "可能是格式錯誤✘✘",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              //背景顏色
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(226, 181, 230, 1),
                  Color.fromRGBO(230, 195, 228, 1),
                  Color.fromRGBO(179, 213, 233, 1),
                  Color.fromRGBO(162, 229, 238, 1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.2, 0.4, 0.7, 0.9],
              ),
            ),
          ),
          SafeArea(
            child: Container(
              margin: const EdgeInsets.only(left: 16),
              child: Text(
                '編輯個人帳戶',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // image textfield
                  const SizedBox(height: 100),
                  GestureDetector(
                    onTap: () {
                      _pickImage();
                    },
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: _userImage,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // username textfield
                  nameTextField1(
                    controller: nameController,
                    initialValue: _username,
                    obscureText: false,
                  ),
                  const SizedBox(height: 50),
                  // sign in button
                  MyButton4(
                    onTap: () => _changeUserName(),
                  ),
                  const SizedBox(height: 200),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 130,
          ),
          Positioned(
            bottom: 50,
            left: MediaQuery.of(context).size.width / 2 - 25,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
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
          ),
        ],
      ),
    );
  }
}
