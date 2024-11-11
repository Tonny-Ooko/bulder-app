import 'package:flutter/material.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final List<String> _reactions = ["👍", "❤️", "😂", "😮", "😢", "😡"];

  // Method to send a message
  void _sendMessage() {
    if (_messageController.text.isEmpty) return;

    setState(() {
      _messages.add({
        'text': _messageController.text,
        'isSent': true,
        'reaction': null,
      });
      _messageController.clear();
    });
  }

  // Method to react to a message
  void _addReaction(int index, String reaction) {
    setState(() {
      _messages[index]['reaction'] = reaction;
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  // Method to build each message tile
  Widget _buildMessageTile(int index, Map<String, dynamic> message) {
    bool isSent = message['isSent'];
    return Dismissible(
      key: Key(message['text'] + index.toString()),
      direction: DismissDirection.horizontal,
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          _messageController.text = "Replying to: ${message['text']}";
        }
      },
      background: Container(
        alignment: Alignment.centerRight,
        color: Colors.green,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: const Icon(Icons.reply, color: Colors.white),
      ),
      child: Row(
        mainAxisAlignment:
            isSent ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          GestureDetector(
            onLongPress: () {
              _showReactionDialog(index);
            },
            child: Container(
              padding: const EdgeInsets.all(10.0),
              margin: const EdgeInsets.symmetric(vertical: 5.0),
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.6),
              decoration: BoxDecoration(
                color: isSent ? Colors.blue : Colors.grey[300],
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message['text'],
                    style: TextStyle(
                      color: isSent ? Colors.white : Colors.black,
                    ),
                  ),
                  if (message['reaction'] != null)
                    Text(
                      message['reaction'],
                      style: TextStyle(
                        fontSize: 16,
                        color: isSent ? Colors.white : Colors.black,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Show a dialog to select an emoji reaction
  void _showReactionDialog(int messageIndex) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('React with Emoji'),
          content: Wrap(
            spacing: 10.0,
            children: _reactions.map((reaction) {
              return GestureDetector(
                onTap: () {
                  _addReaction(messageIndex, reaction);
                  Navigator.of(context).pop();
                },
                child: Text(
                  reaction,
                  style: const TextStyle(fontSize: 30),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        backgroundColor: Colors.blue[900],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageTile(index, _messages[index]);
              },
            ),
          ),
          _buildMessageInputField(),
        ],
      ),
    );
  }

  // Build message input field
  Widget _buildMessageInputField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message',
                fillColor: Colors.white,
                filled: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
