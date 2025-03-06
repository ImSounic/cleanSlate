import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'family_screen.dart';
import 'schedule_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
              leading: CircleAvatar(
                backgroundColor: const Color(0xFFF8D7F6),
                child: const Text(
                  "M",
                  style: TextStyle(
                    color: Color(0xFFD14BCA),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: const Text("Test"),
              subtitle: const Text("test@email.com"),
              trailing: ElevatedButton(
                onPressed: () {}, // TODO: Add edit profile function
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9D4EDD),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Edit"),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Notifications Section
          const Text(
            "Notifications",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Text(
            "Manage your notification preferences",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 8),
          _buildSettingsTile(
            context,
            icon: Icons.notifications,
            title: "Push Notifications",
            trailing: Switch(
              value: true,
              onChanged: (val) {},
              activeColor: const Color(0xFF9D4EDD),
            ),
          ),
          _buildSettingsTile(
            context,
            icon: Icons.alarm,
            title: "Reminders",
            trailing: Switch(
              value: true,
              onChanged: (val) {},
              activeColor: const Color(0xFF9D4EDD),
            ),
          ),
          const SizedBox(height: 16),

          // Appearance Section
          const Text(
            "Appearance",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Text(
            "Customize how CleanSlate looks",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 8),
          _buildSettingsTile(
            context,
            icon: Icons.dark_mode,
            title: "Dark Mode",
            trailing: Switch(
              value: false,
              onChanged: (val) {},
              activeColor: const Color(0xFF9D4EDD),
            ),
          ),
          const SizedBox(height: 16),

          // Other Settings
          _buildSettingsTile(
            context,
            icon: Icons.group,
            title: "Family Members",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FamilyScreen()),
              );
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.language,
            title: "Language",
            trailing: const Text("English"),
          ),
          _buildSettingsTile(
            context,
            icon: Icons.help,
            title: "Help & Support",
            onTap: () {},
          ),
          _buildSettingsTile(
            context,
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
      // Bottom Navigation & Floating Action Button
      floatingActionButton: Container(
        width: 60,
        height: 60,
        decoration: const BoxDecoration(
          color: Color(0xFF9D4EDD),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(Icons.add, color: Colors.white),
          onPressed: () {
            // Add action
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Home
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
                child: _buildNavBarItem(Icons.home, 'Home', false),
              ),
              // Schedule
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ScheduleScreen(),
                    ),
                  );
                },
                child: _buildNavBarItem(
                  Icons.calendar_today,
                  'Schedule',
                  false,
                ),
              ),
              const SizedBox(width: 60), // Space for FAB
              // Family
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FamilyScreen(),
                    ),
                  );
                },
                child: _buildNavBarItem(Icons.people, 'Family', false),
              ),
              // Settings - active
              _buildNavBarItem(Icons.settings, 'Settings', true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    Widget? trailing,
    Color iconColor = Colors.black,
    Color textColor = Colors.black,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(title, style: TextStyle(color: textColor)),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  Widget _buildNavBarItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: isActive ? const Color(0xFF9D4EDD) : Colors.grey),
        Text(
          label,
          style: TextStyle(
            color: isActive ? const Color(0xFF9D4EDD) : Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
