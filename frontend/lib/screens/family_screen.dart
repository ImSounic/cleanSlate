import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import 'schedule_screen.dart';
import 'settings_screen.dart';
import '../controllers/theme_controller.dart';

class FamilyScreen extends StatefulWidget {
  const FamilyScreen({Key? key}) : super(key: key);

  @override
  State<FamilyScreen> createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  final List<Map<String, dynamic>> _familyMembers = [
    {
      'name': 'Mom',
      'email': 'mom@family.com',
      'role': 'Parent',
      'initial': 'M',
      'color': const Color(0xFFF8D7F6),
      'textColor': const Color(0xFFD14BCA),
      'stats': {
        'completed': '8/10',
        'completedPercent': 0.8,
        'onTime': '90%',
        'onTimePercent': 0.9,
      },
    },
    {
      'name': 'Dad',
      'email': 'dad@family.com',
      'role': 'Parent',
      'initial': 'D',
      'color': const Color(0xFFD7E5F8),
      'textColor': const Color(0xFF4B8CD1),
      'stats': {
        'completed': '6/8',
        'completedPercent': 0.75,
        'onTime': '85%',
        'onTimePercent': 0.85,
      },
    },
    {
      'name': 'Emma',
      'email': 'emma@family.com',
      'role': 'Child',
      'initial': 'E',
      'color': const Color(0xFFF8D7F6),
      'textColor': const Color(0xFFD14BCA),
      'stats': {
        'completed': '5/10',
        'completedPercent': 0.5,
        'onTime': '70%',
        'onTimePercent': 0.7,
      },
    },
    {
      'name': 'Jack',
      'email': 'jack@family.com',
      'role': 'Child',
      'initial': 'J',
      'color': const Color(0xFFD7F8E1),
      'textColor': const Color(0xFF4BD160),
      'stats': {
        'completed': '2/5',
        'completedPercent': 0.4,
        'onTime': '60%',
        'onTimePercent': 0.6,
      },
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Access the theme for dark mode support
    final themeController = Provider.of<ThemeController>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to home
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
        title: const Text(
          'Family Members',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Add button
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                // Show add family member dialog
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Family Members List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _familyMembers.length,
              itemBuilder: (context, index) {
                final member = _familyMembers[index];
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.dividerColor),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor: member['color'],
                      child: Text(
                        member['initial'],
                        style: TextStyle(
                          color: member['textColor'],
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      member['name'],
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member['email'],
                          style: theme.textTheme.bodyMedium,
                        ),
                        Text(
                          member['role'],
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.edit, color: theme.iconTheme.color),
                      onPressed: () {
                        // Edit family member
                      },
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // AI Chore Distribution
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.dark
                    ? Color(0xFF2D1A3D) // Darker purple for dark mode
                    : Color(0xFFF5F0FF), // Light purple for light mode
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'AI',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Chore Distribution',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Emma has 5 chores this week while Jack only has 2. Would you like me to suggest a more balanced distribution?',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Show suggestions
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('View Suggestions'),
                      ),
                      const SizedBox(width: 12),
                      TextButton(
                        onPressed: () {
                          // Dismiss suggestion
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: theme.textTheme.bodyLarge?.color,
                        ),
                        child: const Text('Dismiss'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Chore Statistics
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chore Statistics',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Statistics grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.5,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: _familyMembers.length,
                    itemBuilder: (context, index) {
                      final member = _familyMembers[index];
                      final stats = member['stats'];
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: theme.dividerColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundColor: member['color'],
                                  child: Text(
                                    member['initial'],
                                    style: TextStyle(
                                      color: member['textColor'],
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  member['name'],
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Completed',
                                  style: theme.textTheme.bodySmall,
                                ),
                                Text(
                                  stats['completed'],
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: stats['completedPercent'],
                                backgroundColor:
                                    theme.brightness == Brightness.dark
                                        ? Colors.grey.shade800
                                        : Colors.grey.shade200,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  theme.colorScheme.primary,
                                ),
                                minHeight: 8,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'On time',
                                  style: theme.textTheme.bodySmall,
                                ),
                                Text(
                                  stats['onTime'],
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: stats['onTimePercent'],
                                backgroundColor:
                                    theme.brightness == Brightness.dark
                                        ? Colors.grey.shade800
                                        : Colors.grey.shade200,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.green,
                                ),
                                minHeight: 8,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100), // Space for bottom navigation
          ],
        ),
      ),
      // Bottom Navigation & Floating Action Button
      floatingActionButton: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(Icons.add, color: Colors.white),
          onPressed: () {
            // Add family member or chore
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
                        builder: (context) => const ScheduleScreen()),
                  );
                },
                child:
                    _buildNavBarItem(Icons.calendar_today, 'Schedule', false),
              ),
              const SizedBox(width: 60), // Space for FAB
              // Family - active
              _buildNavBarItem(Icons.people, 'Family', true),
              // Settings
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsScreen()),
                  );
                },
                child: _buildNavBarItem(Icons.settings, 'Settings', false),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavBarItem(IconData icon, String label, bool isActive) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isActive ? theme.colorScheme.primary : Colors.grey,
        ),
        Text(
          label,
          style: TextStyle(
            color: isActive ? theme.colorScheme.primary : Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
