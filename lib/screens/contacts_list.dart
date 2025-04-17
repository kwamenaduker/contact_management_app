import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/contact.dart';
import '../services/contact_service.dart';
import 'edit_contact.dart';

class ContactsListScreen extends StatefulWidget {
  const ContactsListScreen({super.key});

  @override
  State<ContactsListScreen> createState() => _ContactsListScreenState();
}

class _ContactsListScreenState extends State<ContactsListScreen> {
  final ContactService _contactService = ContactService();
  List<Contact> _contacts = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      
      final contacts = await _contactService.getAllContacts();
      setState(() {
        _contacts = contacts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load contacts: ${e.toString()}';
        _isLoading = false;
      });
      Fluttertoast.showToast(msg: 'Error loading contacts');
    }
  }

  Future<void> _deleteContact(Contact contact) async {
    try {
      final success = await _contactService.deleteContact(contact.pid!);
      if (success) {
        setState(() {
          _contacts.removeWhere((c) => c.pid == contact.pid);
        });
        Fluttertoast.showToast(msg: 'Contact deleted successfully');
        _loadContacts();
      } else {
        Fluttertoast.showToast(msg: 'Failed to delete contact');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error deleting contact');
      _loadContacts();
    }
  }

  Future<void> _showDeleteConfirmation(Contact contact) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Contact'),
        content: Text('Are you sure you want to delete ${contact.pname}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (result == true) {
      await _deleteContact(contact);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadContacts,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_error!),
                      ElevatedButton(
                        onPressed: _loadContacts,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadContacts,
                  child: _contacts.isEmpty
                      ? const Center(
                          child: Text('No contacts found'),
                        )
                      : ListView.builder(
                          itemCount: _contacts.length,
                          itemBuilder: (context, index) {
                            final contact = _contacts[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: ListTile(
                                title: Text(contact.pname),
                                subtitle: Text(contact.pphone),
                                leading: CircleAvatar(
                                  child: Text(
                                    contact.pname[0].toUpperCase(),
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      color: Colors.blue,
                                      onPressed: () async {
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EditContactScreen(
                                              contact: contact,
                                            ),
                                          ),
                                        );
                                        if (result == true) {
                                          _loadContacts();
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      color: Colors.red,
                                      onPressed: () => _showDeleteConfirmation(contact),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
    );
  }
}
