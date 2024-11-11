import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Bottom navigation tabs
static final List<Widget> _pages = <Widget>[
  PostsFeed(), // Placeholder for Home feed page
  MessagesPage(), // Placeholder for Messages page
  ContactsPage(), // Placeholder for Contacts/Sync page
  ProfilePage(), // Placeholder for Profile page
];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.blue[900],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: 'Contacts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[900],
        onTap: _onItemTapped,
      ),
    );
  }
}

// Feed Page (Posts from users)
class PostsFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final posts = snapshot.data!.docs;

        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            final String userName = post['userName'];
            final String postContent = post['content'];
            final String? postImageUrl = post['imageUrl'];

            return Card(
              margin: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(post['profilePicUrl']),
                    ),
                    title: Text(userName),
                    subtitle: Text('Posted at ${post['timestamp']}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(postContent),
                  ),
                  if (postImageUrl != null)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.network(postImageUrl),
                    ),
                  ButtonBar(
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.thumb_up_alt_outlined),
                        onPressed: () {
                          // Like functionality to be added
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.comment_outlined),
                        onPressed: () {
                          // Navigate to comments page (To be implemented)
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.share_outlined),
                        onPressed: () {
                          // Share functionality to be added
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// Placeholder for Messages Page
class MessagesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/messages'); // Assumes /messages route is set
        },
        child: const Text('Go to Messages'),
      ),
    );
  }
}

// Placeholder for Contacts Page
class ContactsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/contacts'); // Assumes /contacts route is set
        },
        child: const Text('Sync Contacts / Search Users'),
      ),
    );
  }
}

// Placeholder for Profile Page
class ProfilePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(user.photoURL ?? ''),
        ),
        const SizedBox(height: 20),
        Text(user.displayName ?? 'No name available'),
        const SizedBox(height: 10),
        Text(user.email ?? 'No email available'),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            _auth.signOut();
            Navigator.pushReplacementNamed(context, '/login');
          },
          child: const Text('Log Out'),
        ),
      ],
    );
  }
}
