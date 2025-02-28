import 'package:flutter/material.dart';
import 'edit_contact.dart';

class ContactsListScreen extends StatelessWidget {
  final List<Map<String, String>> contacts = const [
    {"name": "John Doe", "phone": "123-456-7890"},
    {"name": "Jane Smith", "phone": "987-654-3210"},
    {"name": "Michael Brown", "phone": "555-666-7777"},
  ];

  const ContactsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contacts List')),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(contacts[index]["name"]!),
            subtitle: Text(contacts[index]["phone"]!),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                // Navigate to Edit Contact Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditContactScreen(
                      contactName: contacts[index]["name"]!,
                      contactPhone: contacts[index]["phone"]!,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
