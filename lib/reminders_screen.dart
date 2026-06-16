import 'package:flutter/material.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({Key? key}) : super(key: key);

  @override
  _RemindersScreenState createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  String _selectedFilter = 'Today';
  // The nav bar index is now fixed to 2 to show "Reminders" as active
  final int _currentBottomNavIndex = 2;

  // Expanded sample data for reminders
  final Map<String, List<Map<String, String>>> _reminders = {
    'Today': [
      {'title': 'Follow up with Client A', 'time': '10:00 AM'},
      {'title': 'Submit project proposal for Q4', 'time': '02:30 PM'},
      {'title': 'Review marketing copy', 'time': '04:00 PM'},
    ],
    'Tomorrow': [
      {'title': 'Team brainstorming session', 'time': '11:00 AM'},
      {'title': 'Call with legal department', 'time': '03:00 PM'},
    ],
    'This Week': [
      {'title': 'Prepare weekly analytics report', 'time': 'Due Friday'},
      {'title': 'Dentist Appointment', 'time': 'Wed, 03:00 PM'},
      {'title': 'Finalize budget for next quarter', 'time': 'Due Thursday'},
      {'title': 'Onboarding session with new hire', 'time': 'Tues, 09:00 AM'},
    ],
    'This Month': [
      {'title': 'Pay monthly software subscriptions', 'time': 'Due by 25th'},
      {'title': 'Plan company offsite event', 'time': 'Coordination by 20th'},
      {'title': 'Performance reviews', 'time': 'End of Month'},
    ],
    'Period': [],
  };

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> filteredReminders = _reminders[_selectedFilter] ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Reminders', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.red,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: filteredReminders.isEmpty
                ? Center(
                    child: Text(
                      'No reminders for $_selectedFilter.',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  )
                : ListView.separated(
                    // Added bottom padding so the FAB doesn't hide content
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 80),
                    itemCount: filteredReminders.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final reminder = filteredReminders[index];
                      return _buildReminderCard(reminder);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement Add Reminder functionality
        },
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, size: 28, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildFilterBar() {
    final filters = ['Today', 'Tomorrow', 'This Week', 'This Month', 'Period'];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: filters.map((filter) {
            final bool isSelected = _selectedFilter == filter;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.red : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildReminderCard(Map<String, String> reminder) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 4,
          )
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications_active_outlined, color: Colors.red, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reminder['title']!,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 2),
                Text(
                  reminder['time']!,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
    );
  }

  // --- UPDATED BOTTOM NAVIGATION BAR ---
  BottomAppBar _buildBottomNavBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      color: Colors.white,
      elevation: 8.0,
      child: SizedBox(
        height: 65,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Files Icon: Navigates back to the Dashboard
            _navBarItem(Icons.folder, "Files", 0, onTap: () {
              Navigator.of(context).pop();
            }),

            // WorkFlows Icon: Does nothing
            _navBarItem(Icons.work_outline, "WorkFlows", 1, onTap: () {}),

            // Center space for the FAB
            const SizedBox(width: 40),

            // Reminders Icon: Does nothing (already on this screen)
            _navBarItem(Icons.notifications_none, "Reminders", 2, onTap: () {}),

            // Requests Icon: Does nothing
            _navBarItem(
              Icons.request_page_outlined,
              "Requests",
              3,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _navBarItem(
    IconData icon,
    String label,
    int index, {
    VoidCallback? onTap,
  }) {
    final bool isActive = _currentBottomNavIndex == index;
    final color = isActive ? Colors.red : Colors.black;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
