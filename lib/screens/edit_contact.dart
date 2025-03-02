import 'package:flutter/material.dart';

class EditContactScreen extends StatefulWidget {
  final String contactName;
  final String contactPhone;

  const EditContactScreen({
    super.key,
    required this.contactName,
    required this.contactPhone,
  });

  @override
  EditContactScreenState createState() => EditContactScreenState();
}

class EditContactScreenState extends State<EditContactScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.contactName);
    _phoneController = TextEditingController(text: widget.contactPhone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveContact() {
    // Here you would send the updated contact info to the backend
    debugPrint("Updated Contact: ${_nameController.text}, ${_phoneController.text}");
    Navigator.pop(context); // Go back to the previous screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Contact')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _saveContact, child: Text('Save')),
          ],
        ),
      ),
    );
  }
}
