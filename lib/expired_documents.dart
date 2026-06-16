import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Define the primary color from the screenshot for reuse.
const Color primaryRed = Color(0xFFE53935);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Document Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryRed),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryRed,
          foregroundColor: Colors.white,
          elevation: 1,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      home: const ExpiredDocumentsScreenOld(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ExpiredDocumentsScreenOld extends StatefulWidget {
  const ExpiredDocumentsScreenOld({Key? key}) : super(key: key);

  @override
  State<ExpiredDocumentsScreenOld> createState() => _MyDocumentsScreenState();
}

class _MyDocumentsScreenState extends State<ExpiredDocumentsScreenOld>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int? expandedIndex;

  final List<Map<String, String>> files = [
    {
      'name': 'Expired File 1',
      'date': '15 Aug 2025, 09:00 AM',
      'uploadedBy': 'Gautam Prakash',
      'status': 'Archived',
      'category': 'fe1c1b88-2f80-4696-99cb-2...',
      'client': '43174b64-7b5c-437b-a15...',
      'description': 'This is an archived file.',
    },
    {
      'name': 'Old Project Plan',
      'date': '10 Jul 2025, 02:30 PM',
      'uploadedBy': 'Vishal Rajarathinam',
      'status': 'Archived',
      'category': 'cat-id-2',
      'client': 'client-id-2',
      'description': 'This project plan is outdated.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void toggleExpansion(int index) {
    setState(() {
      expandedIndex = expandedIndex == index ? null : index;
    });
  }

  void handleOption(String option, Map<String, String> file) async {
    Navigator.pop(context); // Close the bottom sheet first

    switch (option) {
      case 'Unarchive':
        final bool? confirm = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return ConfirmUnarchiveDialog(
              fileName: file['name'] ?? 'this document',
            );
          },
        );
        if (confirm == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${file['name']} has been unarchived.')),
          );
        }
        break;
      case 'Delete':
        showDialog(
          context: context,
          builder: (context) => const ConfirmDeleteDialog(),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$option action for: ${file['name']}')),
        );
    }
  }

  void showModernOptions(BuildContext context, Map<String, String> file) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) {
        final List<Map<String, dynamic>> options = [
          {
            'icon': Icons.unarchive_outlined,
            'text': 'Unarchive',
            'color': Colors.green,
          },
          {'icon': Icons.delete_outline, 'text': 'Delete', 'color': Colors.red},
        ];

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            left: 16,
            right: 16,
            top: 12,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const Text(
                  "Document Actions",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                ...options.map(
                  (opt) => ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 0,
                    ),
                    leading: Icon(opt['icon'], color: opt['color'], size: 22),
                    title: Text(
                      opt['text'],
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () => handleOption(opt['text'], file),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Expired Documents',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        backgroundColor: primaryRed,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            color: Colors.white,
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search documents...',
                hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
              ),
            ),
          ),
          TabBar(
            controller: _tabController,
            labelColor: primaryRed,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(fontWeight: FontWeight.w600),
            indicatorColor: primaryRed,
            tabs: const [
              Tab(text: 'All Documents'),
              Tab(text: 'Category 1'),
              Tab(text: 'Category 2'),
              Tab(text: 'Category 3'),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: List.generate(
                4,
                (tabIndex) => ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: files.length,
                  itemBuilder: (context, index) {
                    final file = files[index];
                    final isExpanded = expandedIndex == index;
                    return Card(
                      elevation: 2,
                      color: Colors.white,
                      shadowColor: Colors.grey.withOpacity(0.1),
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              radius: 22,
                              backgroundColor: Colors.grey.withOpacity(0.1),
                              child: const Icon(
                                Icons.archive,
                                color: Colors.grey,
                              ),
                            ),
                            title: Text(
                              file['name']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Text(
                              file['date']!,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            trailing: InkWell(
                              onTap: () => toggleExpansion(index),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  isExpanded ? 'Close' : 'View',
                                  style: const TextStyle(
                                    color: primaryRed,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (isExpanded)
                            Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.folder,
                                      color: Colors.grey,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          file['name']!,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Archived by: ${file['uploadedBy']}',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          file['date']!,
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    child: Text(
                                      file['status']!,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  InkWell(
                                    onTap: () =>
                                        showModernOptions(context, file),
                                    child: const Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Icon(Icons.more_vert, size: 20),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Dialog to confirm unarchiving a document
class ConfirmUnarchiveDialog extends StatelessWidget {
  final String fileName;
  const ConfirmUnarchiveDialog({Key? key, required this.fileName})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Unarchive'),
      content: Text('Are you sure you want to unarchive "$fileName"?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Unarchive', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

// Dialog to confirm deletion
class ConfirmDeleteDialog extends StatelessWidget {
  const ConfirmDeleteDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Deletion'),
      content: const Text(
        'Are you sure you want to permanently delete this document?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: primaryRed),
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Document permanently deleted!')),
            );
          },
          child: const Text('Delete', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
