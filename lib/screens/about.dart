import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.blue,
            child: Icon(
              Icons.contacts,
              size: 50,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Contact Management App',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const Text(
            'Version 1.0.0',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          _buildInfoCard(
            title: 'Developer',
            content: 'Kwamena Duker',
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            title: 'Student ID',
            content: '79242025',
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            title: 'Description',
            content: 'A Flutter-based contact management application that allows users to create, read, update, and delete contacts. The app demonstrates the implementation of REST API integration, state management, and modern UI/UX practices.',
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            title: 'Features',
            content: '''
• Contact list with pull-to-refresh
• Add new contacts
• Edit existing contacts
• Delete contacts
''',
          ),
          const SizedBox(height: 32),
          const Text(
            ' 2025 Contact Management App',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String content,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
