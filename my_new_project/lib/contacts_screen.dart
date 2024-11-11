import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<Contact> _contacts = [];

  @override
  void initState() {
    super.initState();
    _getContactsPermission();
  }

  // Request permission to access contacts
  Future<void> _getContactsPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted) {
      permission = await Permission.contacts.request();
    }

    if (permission.isGranted) {
      _fetchContacts();
    } else {
      // Show message if permission is denied
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Permission to access contacts is denied'),
      ));
    }
  }

  // Fetch contacts from the phone
  Future<void> _fetchContacts() async {
    try {
      final contacts = await ContactsService.getContacts();
      setState(() {
        _contacts = contacts.toList();
      });
    } catch (e) {
      print('Error fetching contacts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
        backgroundColor: Colors.blue[900],
      ),
      body: _contacts == null || _contacts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          final contact = _contacts[index];

          // Check if contact.phones is null or empty
          final hasPhone = contact.phones != null && contact.phones!.isNotEmpty;
          final phone = hasPhone
              ? contact.phones!.first.value ?? 'No Phone'
              : 'No Phone';

          return ListTile(
            title: Text(contact.displayName ?? 'No Name'),
            subtitle: Text(phone),
          );
        },
      ),
    );
  }
}
