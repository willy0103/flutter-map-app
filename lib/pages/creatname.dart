import 'dart:io';

import 'package:flutter/material.dart';
import 'package:modernlogintute/components/my_button.dart';
import 'package:modernlogintute/pages/maps.dart';
import '../components/image_textfild.dart';
import '../components/name_textfield.dart';
import 'package:http/http.dart' as http;

import 'login_page.dart';

// ignore: must_be_immutable
class CreatAvatar extends StatefulWidget {
  const CreatAvatar({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CreatAvatarState createState() => _CreatAvatarState();
}

class _CreatAvatarState extends State<CreatAvatar> {
  final nameController = TextEditingController();
  File? _imageFile;

  void gotomap(BuildContext context) async {
    final url = Uri.parse('http://192.168.0.108:3000/user/signup/nameAndphoto');

    final request = http.MultipartRequest('POST', url);

    final file =
        await http.MultipartFile.fromPath('user_img', _imageFile!.path);
    request.fields['name'] = nameController.text;

    request.files.add(file);

    final response = await request.send();

    if (response.statusCode == 200) {
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
                          "帳號創建成功✔✔",
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
                          "☹創建失敗☹",
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

  void _setImageFile(File? file) {
    setState(() {
      _imageFile = file;
    });
  }

  void navigateToHomePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MapsPage()),
    );
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
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // image textfield
                  const SizedBox(height: 50),

                  Container(
                      child: MyImage(
                    imageUrl: '',
                    obscureText: false,
                    imageFile: _imageFile,
                    onImagePicked: _setImageFile,
                  )),
                  const SizedBox(height: 30),
                  // username textfield
                  nameTextField(
                    controller: nameController,
                    hintText: 'Your Name',
                    obscureText: false,
                  ),
                  const SizedBox(height: 50),
                  // sign in button

                  MyButton3(
                    onTap: () => gotomap(context),
                  ),
                  const SizedBox(height: 200),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void navigateToLoginScreen(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => LoginPage()),
  );
}
