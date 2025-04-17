import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/contact_service.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _contactService = ContactService();
  bool _isLoading = false;

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

  void _clearForm() {
    _nameController.clear();
    _phoneController.clear();
    if (mounted) {
      _formKey.currentState?.reset();
    }
  }

  Future<void> _addContact() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await _contactService.addContact(
        _nameController.text,
        _phoneController.text,
      );

      if (result.toLowerCase() == 'success') {
        Fluttertoast.showToast(msg: 'Contact added successfully');
        _clearForm();
      } else {
        throw Exception('Failed to add contact');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error adding contact');
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
        title: const Text('Add Contact'),
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
                prefixIcon: Icon(Icons.person),
              ),
              validator: _validateName,
              enabled: !_isLoading,
              textInputAction: TextInputAction.next,
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
              validator: _validatePhone,
              enabled: !_isLoading,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _addContact(),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _addContact,
                    icon: const Icon(Icons.save),
                    label: Text(_isLoading ? 'Adding...' : 'Add Contact'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                ),
                if (!_isLoading) ...[
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: _clearForm,
                    icon: const Icon(Icons.clear),
                    tooltip: 'Clear form',
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
