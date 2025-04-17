import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/contact.dart';
import '../services/contact_service.dart';

class EditContactScreen extends StatefulWidget {
  final Contact contact;

  const EditContactScreen({
    super.key,
    required this.contact,
  });

  @override
  EditContactScreenState createState() => EditContactScreenState();
}

class EditContactScreenState extends State<EditContactScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  final ContactService _contactService = ContactService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.contact.pname);
    _phoneController = TextEditingController(text: widget.contact.pphone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a name';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    }
    // Basic phone number validation
    if (!RegExp(r'^\+?[\d\s-]+$').hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  Future<void> _saveContact() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await _contactService.updateContact(
        widget.contact.pid!,
        _nameController.text,
        _phoneController.text,
      );

      if (result.toLowerCase() == 'success') {
        Fluttertoast.showToast(msg: 'Contact updated successfully');
        if (mounted) {
          Navigator.pop(context, true); // true indicates successful update
        }
      } else {
        throw Exception('Failed to update contact');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error updating contact');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Contact'),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              validator: _validateName,
              enabled: !_isLoading,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              validator: _validatePhone,
              enabled: !_isLoading,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _saveContact(),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveContact,
              child: Text(_isLoading ? 'Saving...' : 'Save Changes'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
