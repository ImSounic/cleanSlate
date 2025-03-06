import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import 'family_screen.dart';
import 'schedule_screen.dart';
import 'login_screen.dart';
import '../controllers/theme_controller.dart';
import '../providers/user_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the theme controller
    final themeController = Provider.of<ThemeController>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Access the user provider for authentication
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    final isLoading = userProvider.isLoading;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // User Profile Card
                Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFFF8D7F6),
                      child: Text(
                        user?.fullName?.isNotEmpty == true
                            ? user!.fullName![0].toUpperCase()
                            : "U",
                        style: const TextStyle(
                          color: Color(0xFFD14BCA),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(user?.fullName ?? "User"),
                    subtitle:
                        Text(user?.email ?? user?.phone ?? "No contact info"),
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
                Text(
                  "Notifications",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  "Manage your notification preferences",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                ),
                const SizedBox(height: 8),
                _buildSettingsTile(
                  context,
                  icon: Icons.notifications,
                  title: "Push Notifications",
                  trailing: Switch(
                    value: true,
                    onChanged: (val) {},
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
                _buildSettingsTile(
                  context,
                  icon: Icons.alarm,
                  title: "Reminders",
                  trailing: Switch(
                    value: true,
                    onChanged: (val) {},
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),

                // Appearance Section
                Text("Appearance",
                    style: Theme.of(context).textTheme.titleLarge),
                Text(
                  "Customize how CleanSlate looks",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                ),
                const SizedBox(height: 8),
                _buildSettingsTile(
                  context,
                  icon: Icons.dark_mode,
                  title: "Dark Mode",
                  trailing: Switch(
                    value: isDarkMode,
                    onChanged: (val) {
                      themeController
                          .setThemeMode(val ? ThemeMode.dark : ThemeMode.light);
                    },
                    activeColor: Theme.of(context).colorScheme.primary,
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
                      MaterialPageRoute(
                          builder: (context) => const FamilyScreen()),
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
                  onTap: () => _handleLogout(context, userProvider),
                ),

                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      Text(
                        "CleanSlate v1.0.0",
                        style: TextStyle(color: Colors.grey),
                      ),
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
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
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
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                },
                child: _buildNavBarItem(context, Icons.home, 'Home', false),
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
                  context,
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
                child: _buildNavBarItem(
                  context,
                  Icons.people,
                  'Family',
                  false,
                ),
              ),
              // Settings - active
              _buildNavBarItem(context, Icons.settings, 'Settings', true),
            ],
          ),
        ),
      ),
    );
  }

  // Method to handle user logout with confirmation dialog
  Future<void> _handleLogout(
      BuildContext context, UserProvider userProvider) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content:
            const Text('Are you sure you want to log out of your account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Logging out..."),
            ],
          ),
        ),
      );

      // Perform logout
      try {
        await userProvider.logout();

        // Navigate to login screen
        if (context.mounted) {
          Navigator.pop(context); // Close loading dialog
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
        }
      } catch (e) {
        // Close loading dialog and show error
        if (context.mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Logout failed: ${e.toString()}")),
          );
        }
      }
    }
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    Widget? trailing,
    Color? iconColor,
    Color? textColor,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: iconColor ?? theme.iconTheme.color),
        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(color: textColor),
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  Widget _buildNavBarItem(
    BuildContext context,
    IconData icon,
    String label,
    bool isActive,
  ) {
    final theme = Theme.of(context);
    final activeColor = theme.colorScheme.primary;
    final inactiveColor = Colors.grey;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: isActive ? activeColor : inactiveColor),
        Text(
          label,
          style: TextStyle(
            color: isActive ? activeColor : inactiveColor,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
