import 'package:flutter/material.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            Text(
              "FAQs",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "• How to reset my password?\nGo to Settings > Account > Change Password.",
            ),
            SizedBox(height: 10),
            Text(
              "• How to contact support?\nYou can email us at support@example.com.",
            ),
            SizedBox(height: 10),
            Text(
              "• How to delete my account?\nPlease contact support for account deletion.",
            ),
            SizedBox(height: 30),
            Text(
              "Contact Us",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text("📧 Email: support@example.com"),
            Text("📞 Phone: +1 (555) 123-4567"),
            Text("🌐 Website: www.example.com"),
          ],
        ),
      ),
    );
  }
}
