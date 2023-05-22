import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:modernlogintute/components/my_button.dart';
import 'package:modernlogintute/pages/creatname.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/dob_textfield.dart';
import '../components/email_textfield.dart';
import '../components/password_textfield copy.dart';
import 'package:http/http.dart' as http;

import '../components/phone_textfild.dart';
import 'login_page.dart';

class CreatAccount extends StatelessWidget {
  CreatAccount({super.key});

  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final birthdayController = TextEditingController();

  // sign user in method
  void signUp(BuildContext context) async {
    final url = Uri.parse('http://192.168.0.108:3000/user/signup');
    final data = {
      'email': emailController.text,
      'password': passwordController.text,
      'phonenumber': phoneController.text,
      'dob': birthdayController.text,
    };
    Future<void> saveToken(String token) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
    }

    ;
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 201) {
      final token = jsonDecode(response.body)['token'];
      await saveToken(token);
    }
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

  void navigateToHomePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreatAvatar()),
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
          Positioned(
            top: 10,
            left: 10,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: 35,
              ),
              onPressed: () {
                navigateToLoginScreen(context);
              },
            ),
          ),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  const Icon(
                    Icons.people,
                    size: 100,
                  ),

                  const SizedBox(height: 30),

                  // welcome back, you've been missed!
                  Text(
                    'Welcome to join us',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 20,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // username textfield
                  EmailTextField(
                    controller: emailController,
                    hintText: 'User Email',
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),

                  // password textfield
                  PasswordTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),

                  const SizedBox(height: 10),

                  // password textfield
                  PhoneTextField(
                    controller: phoneController,
                    hintText: 'your phone number',
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),

                  // password textfield
                  DobTextField(
                    controller: birthdayController,
                    hintText: 'your birthday  xxxx-xx-xx',
                    obscureText: false,
                  ),

                  const SizedBox(height: 40),

                  // sign in button
                  MyButton2(
                    onTap: () => signUp(context),
                  ),
                  const SizedBox(height: 150),
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
