import 'package:flutter/material.dart';

class AddFriend extends StatefulWidget {
  const AddFriend({Key? key}) : super(key: key);

  @override
  State<AddFriend> createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  TextEditingController _idController = TextEditingController();
  bool _isSelected = false;

  void _searchFriend() {
    // Implement logic to search friend by ID and update the UI accordingly
    // You can fetch data from a database or any other data source
    // and update the UI with the found friend's details
    // For simplicity, I'm just updating the _isSelected value
    setState(() {
      _isSelected = true;
    });
  }

  void _sendFriendRequest() {
    // Implement logic to send friend request to the selected friend
    // You can perform actions like API calls or database operations here
    // For simplicity, I'm just showing a toast message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Friend request sent!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Friend'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _idController,
              decoration: const InputDecoration(
                labelText: 'Enter ID',
              ),
            ),
            ElevatedButton(
              onPressed: _searchFriend,
              child: const Text('Search'),
            ),
            if (_isSelected)
              Column(
                children: [
                  const SizedBox(height: 16.0),
                  CircleAvatar(
                    radius: 50,
                    // Replace with friend's profile image
                    child: const Icon(Icons.person),
                  ),
                  const SizedBox(height: 8.0),
                  // Replace with friend's name
                  Text('Friend Name'),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: _sendFriendRequest,
                        icon: const Icon(Icons.check),
                        color: Colors.green,
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _isSelected = false;
                          });
                        },
                        icon: const Icon(Icons.close),
                        color: Colors.red,
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
