import 'package:flutter/foundation.dart';
// ignore: depend_on_referenced_packages

import '../model/message.dart';

class HomeProvider extends ChangeNotifier {
  final List<Message> _messages = [];

  List<Message> get messages => _messages;

  addNewMessage(Message message) {
    _messages.add(message);
    notifyListeners();
  }
}
