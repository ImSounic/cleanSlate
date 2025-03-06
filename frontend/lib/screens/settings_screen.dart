import 'package:flutter/material.dart';
import '../widgets/settings_tile.dart'; // Import reusable widget

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // User Profile Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(child: Text("M")), // Placeholder avatar
              title: const Text("Mom"),
              subtitle: const Text("mom@family.com"),
              trailing: ElevatedButton(
                onPressed: () {}, // TODO: Add edit profile function
                child: const Text("Edit"),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Notifications Section
          const Text(
            "Notifications",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Text(
            "Manage your notification preferences",
            style: TextStyle(color: Colors.grey),
          ),
          SettingsTile(
            icon: Icons.notifications,
            title: "Push Notifications",
            trailing: Switch(
              value: true,
              onChanged: (val) {},
            ), // TODO: Implement switch state
          ),
          SettingsTile(
            icon: Icons.alarm,
            title: "Reminders",
            trailing: Switch(value: true, onChanged: (val) {}),
          ),
          const SizedBox(height: 16),

          // Appearance Section
          const Text(
            "Appearance",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Text(
            "Customize how CleanSlate looks",
            style: TextStyle(color: Colors.grey),
          ),
          SettingsTile(
            icon: Icons.dark_mode,
            title: "Dark Mode",
            trailing: Switch(value: false, onChanged: (val) {}),
          ),
          const SizedBox(height: 16),

          // Other Settings
          SettingsTile(
            icon: Icons.group,
            title: "Family Members",
            onTap: () {},
          ),
          SettingsTile(
            icon: Icons.language,
            title: "Language",
            trailing: const Text("English"),
          ),
          SettingsTile(icon: Icons.help, title: "Help & Support", onTap: () {}),
          SettingsTile(
            icon: Icons.logout,
            title: "Log Out",
            iconColor: Colors.red,
            textColor: Colors.red,
            onTap: () {},
          ),

          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                Text("CleanSlate v1.0.0", style: TextStyle(color: Colors.grey)),
                Text(
                  "© 2025 CleanSlate. All rights reserved.",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
