import 'package:chatx/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final _fireStore = Firestore.instance;
FirebaseUser _loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = '/chat';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  String _messageText;
  //final _fireStore = Firestore.instance; //We moved to the global state
  final _messageTextController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    // _getMessages();
  }

  void _getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        _loggedInUser = user;
        print(_loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  void _getMessages() async {
    final messages = await _fireStore.collection('messages').getDocuments();
    if (messages != null) {
      for (var message in messages.documents) {
        print(message.data);
      }
    }
  }

  //this method will be called again when there is new data in the stream
  //like we are subscribed to that collection == stream we get notified when a new change happens through some sort of event
  // and our function will run again as a callback every time
  //
  void _getMessagesStream() async {
    await for (var snapshot in _fireStore.collection('messages').snapshots()) {
      for (var message in snapshot.documents) {
        print(message.data);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //MessagesStream(fireStore: _fireStore),
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _messageTextController,
                      onChanged: (value) {
                        //Do something with the user input.
                        this._messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      _messageTextController.clear();
                      //Implement send functionality.
                      _fireStore.collection('messages').add(
                        {
                          'text': _messageText,
                          'sender': _loggedInUser.email,
                        },
                      );
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
//  const MessagesStream({
//    Key key,
//    @required Firestore fireStore,
//  })  : _fireStore = fireStore,
//        super(key: key);
//
//  final Firestore _fireStore;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blueAccent,
            ),
          );
        }
        final messages = snapshot.data.documents.reversed; //we should reverse it to make the latest message as last element
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final _text = message.data['text'];
          final _sender = message.data['sender'];
          final messageBubble = MessageBubble(
            sender: _sender,
            message: _text,
            isMe: _sender == _loggedInUser.email,
          );
          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true, //to display the end of the list as the main thing
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        ); //Column(children: messagesWidget);
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String sender;
  final String message;
  final bool isMe;
  MessageBubble({this.sender, this.message, this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: this.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            this.sender,
            style: TextStyle(fontSize: 14.0, color: Colors.grey),
          ),
          Material(
            elevation: 5.0,
            borderRadius: BorderRadius.only(
              topLeft: isMe ? Radius.circular(25.0) : Radius.zero,
              bottomLeft: Radius.circular(25.0),
              bottomRight: Radius.circular(25.0),
              topRight: isMe ? Radius.zero : Radius.circular(25.0),
            ),
            color: isMe ? Colors.indigo.withOpacity(0.98) : Colors.purple,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                this.message,
                softWrap: true,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
