import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:modernlogintute/components/my_button.dart';
import 'package:modernlogintute/components/square_tile.dart';
import '../components/email_textfield.dart';
import '../components/password_textfield copy.dart';
import 'package:http/http.dart' as http;
import 'maps.dart';
import 'creataccount.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final String email;
  final String password;
  // 其他需要保存的使用者資訊

  User({required this.email, required this.password});

  // 將使用者資訊轉換為 JSON 格式
  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };

  static fromJson(decode) {}
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final userData = prefs.getString('user');
  if (userData != null) {
    final user = User.fromJson(json.decode(userData));
    signUserInAutomatically(user); // 加入自動登入的相關邏輯
  } else {
    // 顯示登入介面
    runApp(LoginPage());
  }
}

void signUserInAutomatically(User user) async {
  final url = Uri.parse('http://192.168.0.108:3000/user/login');
  final response = await http.post(
    url,
    body: {'username': user.email, 'password': user.password},
  );
  if (response.statusCode == 200) {
    // 將取得的使用者資料轉換為 User 物件
    final responseData = json.decode(response.body);
    final loggedInUser = User.fromJson(responseData);

    // 將使用者資料儲存在 SharedPreferences 中
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', json.encode(loggedInUser.toJson()));

    // 導航到主畫面
    // ignore: prefer_typing_uninitialized_variables
    var context;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MapsPage()),
    );
  }
}

void signUserOut(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('user');
  navigateToLoginPage(context);
}

void navigateToLoginPage(BuildContext context) {
  Navigator.pushReplacementNamed(context, '/login');
}

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //登入成功與失敗
  void signUserIn(BuildContext context) async {
    final url = Uri.parse('http://192.168.0.108:3000/user/login');
    final data = {
      'email': emailController.text,
      'password': passwordController.text,
    };
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      final user = User(
        email: emailController.text,
        password: passwordController.text,
        // 其他需要保存的使用者資訊
      );

      Future<void> saveToken(String token) async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
      }

      final token = jsonDecode(response.body)['token'];
      await saveToken(token);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', json.encode(user.toJson()));
      // ignore: use_build_context_synchronously
      navigateToMapsPage(context);
    } else {
      // 登入失敗
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
                          "☹登入失敗☹",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Spacer(),
                        Text(
                          "帳號或密碼輸入錯誤✘✘",
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

  //導入定位程式
  void navigateToMapsPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MapsPage()),
    );
  }

  //創建帳號
  void signUserUp(BuildContext context) async {
    gateTOCreatPage(context);
  }

  void gateTOCreatPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreatAccount()),
    );
  }

  @override
  //UI登入介面
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
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
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                // 登入頁面的鎖
                const Icon(
                  Icons.lock,
                  size: 100,
                ),

                const SizedBox(height: 40),

                // 主頁面歡迎字樣
                Text(
                  'Welcome back you\'ve been missed!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                // Email 提示字樣
                EmailTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // 密碼提示字樣
                PasswordTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 15),
                //創建帳號與忘記密碼按鈕
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // create account
                      GestureDetector(
                        onTap: () => signUserUp(context),
                        child: Text(
                          'Create Account',
                          style: TextStyle(
                              color: Colors.grey[600],
                              decoration: TextDecoration.underline),
                        ),
                      ),

                      // forgot password?
                      Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                MyButton(
                  onTap: () => signUserIn(context),
                ),
                // 登入按鈕

                const SizedBox(height: 40),

                // 中間分段線
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[600],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // google + apple 登入按鈕
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // google button
                    SquareTile(imagePath: 'lib/images/google.png'),

                    SizedBox(width: 40),

                    // apple button
                    SquareTile(imagePath: 'lib/images/apple.png')
                  ],
                ),

                const SizedBox(height: 30),

                // not a member? register now
                //Row(
                //  mainAxisAlignment: MainAxisAlignment.center,
                //  children: [
                //    Text(
                //      'Not a member?',
                //     style: TextStyle(color: Colors.grey[700]),
                //    ),
                //    const SizedBox(width: 4),
                //    const Text(
                //      'Register now',
                //      style: TextStyle(
                //        color: Colors.blue,
                //        fontWeight: FontWeight.bold,
                //      ),
                //    ),
                //  ],
                //  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
