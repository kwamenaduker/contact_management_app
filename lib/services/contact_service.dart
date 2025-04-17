import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/contact.dart';

class ContactService {
  static const String baseUrl = 'https://apps.ashesi.edu.gh/contactmgt/actions';

  // Get all contacts
  Future<List<Contact>> getAllContacts() async {
    final response = await http.get(Uri.parse('$baseUrl/get_all_contact_mob'));
    
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Contact.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load contacts');
    }
  }

  // Get single contact
  Future<Contact> getContact(String contid) async {
    final response = await http.get(
      Uri.parse('$baseUrl/get_a_contact_mob?contid=$contid'),
    );
    
    if (response.statusCode == 200) {
      final dynamic jsonData = json.decode(response.body);
      return Contact.fromJson(jsonData);
    } else {
      throw Exception('Failed to load contact');
    }
  }

  // Add new contact
  Future<String> addContact(String name, String phone) async {
    final response = await http.post(
      Uri.parse('$baseUrl/add_contact_mob'),
      body: {
        'ufullname': name,
        'uphonename': phone,
      },
    );
    
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to add contact');
    }
  }

  // Update contact
  Future<String> updateContact(String id, String name, String phone) async {
    final response = await http.post(
      Uri.parse('$baseUrl/update_contact'),
      body: {
        'cid': id,
        'cname': name,
        'cnum': phone,
      },
    );
    
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to update contact');
    }
  }

  // Delete contact
  Future<bool> deleteContact(String id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/delete_contact'),
      body: {
        'cid': id,
      },
    );
    
    if (response.statusCode == 200) {
      // The API might return 'true', 'false', or other values
      // Consider any 200 status code as success
      return true;
    } else {
      throw Exception('Failed to delete contact');
    }
  }
}