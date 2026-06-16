import 'package:docuflow/widgets/pickers/start_end_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

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
      home: const MyDocumentsScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyDocumentsScreen extends StatefulWidget {
  const MyDocumentsScreen({Key? key}) : super(key: key);

  @override
  State<MyDocumentsScreen> createState() => _MyDocumentsScreenState();
}

class _MyDocumentsScreenState extends State<MyDocumentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int? expandedIndex;

  final List<Map<String, String>> files = [
    {
      'name': 'File 1',
      'date': '20 Sep 2025, 10:30 AM',
      'uploadedBy': 'Gautam Prakash',
      'status': 'Verified',
      'category': 'fe1c1b88-2f80-4696-99cb-2...',
      'client': '43174b64-7b5c-437b-a15...',
      'description': 'This is the first file.',
    },
    {
      'name': 'File 2',
      'date': '19 Sep 2025, 04:15 PM',
      'uploadedBy': 'Vishal Rajarathinam',
      'status': 'Pending',
      'category': 'cat-id-2',
      'client': 'client-id-2',
      'description': 'This is the second file.',
    },
    {
      'name': 'File 3',
      'date': '18 Sep 2025, 11:45 AM',
      'uploadedBy': 'Harini Krishnan',
      'status': 'Verified',
      'category': 'cat-id-3',
      'client': 'client-id-3',
      'description': 'This is the third file.',
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
      case 'Edit':
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return EditDocumentDialog(file: file);
          },
        );
        break;
      case 'Share':
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return ShareDocumentDialog(
              documentName: file['name'] ?? 'Unknown Document',
            );
          },
        );
        break;
      case 'Document Signature':
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const DocumentSignatureDialog();
          },
        );
        break;
      case 'Upload New Version file':
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const UploadNewVersionDialog();
          },
        );
        break;
      case 'Version History':
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return VersionHistoryDialog(fileName: file['name'] ?? 'Document');
          },
        );
        break;
      // ADDED: Handle new dialogs
      case 'Add Reminder':
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AddReminderDialog();
          },
        );
        break;
      case 'Comment':
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CommentDialog(fileName: file['name'] ?? 'Document');
          },
        );
        break;
      case 'Send Email':
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SendEmailDialog(
              attachmentName: file['name'] ?? 'Attachment',
            );
          },
        );
        break;
      case 'Archive':
        final bool? confirm = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return ConfirmArchiveDialog(
              fileName: file['name'] ?? 'this document',
            );
          },
        );
        if (confirm == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${file['name']} has been archived.')),
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
          {'icon': Icons.edit_outlined, 'text': 'Edit', 'color': Colors.indigo},
          {'icon': Icons.share_outlined, 'text': 'Share', 'color': Colors.teal},
          {
            'icon': Icons.link,
            'text': 'Get Shareable Link',
            'color': Colors.blue,
          },
          {
            'icon': Icons.edit_note,
            'text': 'Document Signature',
            'color': Colors.purple,
          },
          {
            'icon': Icons.upload_file,
            'text': 'Upload New Version file',
            'color': Colors.orange,
          },
          {
            'icon': Icons.history,
            'text': 'Version History',
            'color': Colors.deepPurple,
          },
          {
            'icon': Icons.comment_outlined,
            'text': 'Comment',
            'color': Colors.blueGrey,
          },
          {
            'icon': Icons.notifications_none,
            'text': 'Add Reminder',
            'color': Colors.redAccent,
          },
          {
            'icon': Icons.email_outlined,
            'text': 'Send Email',
            'color': Colors.green,
          },
          {
            'icon': Icons.archive_outlined,
            'text': 'Archive',
            'color': Colors.brown,
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
          'My Documents',
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
                              backgroundColor: primaryRed.withOpacity(0.1),
                              child: const Icon(
                                Icons.insert_drive_file,
                                color: primaryRed,
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
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.folder,
                                      color: Colors.blue,
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
                                          'Uploaded by: ${file['uploadedBy']}',
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
                                      color: file['status'] == 'Verified'
                                          ? Colors.green.shade50
                                          : Colors.orange.shade50,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: file['status'] == 'Verified'
                                            ? Colors.green
                                            : Colors.orange,
                                      ),
                                    ),
                                    child: Text(
                                      file['status']!,
                                      style: TextStyle(
                                        color: file['status'] == 'Verified'
                                            ? Colors.green
                                            : Colors.orange,
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

// Dialog for editing document
class EditDocumentDialog extends StatefulWidget {
  final Map<String, String> file;
  const EditDocumentDialog({Key? key, required this.file}) : super(key: key);

  @override
  _EditDocumentDialogState createState() => _EditDocumentDialogState();
}

class _EditDocumentDialogState extends State<EditDocumentDialog> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  String? _selectedCategory;
  String? _selectedClient;
  String? _selectedStatus;
  String? _selectedRetentionAction;

  final List<String> _categories = [
    'fe1c1b88-2f80-4696-99cb-2...',
    'cat-id-2',
    'cat-id-3',
    'General',
  ];
  final List<String> _clients = [
    '43174b64-7b5c-437b-a15...',
    'client-id-2',
    'client-id-3',
    'Internal',
  ];
  final List<String> _statuses = ['Verified', 'Pending', 'Rejected'];
  final List<String> _retentionActions = ['Archive', 'Delete', 'Keep'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.file['name']);
    _descriptionController = TextEditingController(
      text: widget.file['description'] ?? '',
    );
    _selectedCategory = widget.file['category'];
    _selectedClient = widget.file['client'];
    _selectedStatus = widget.file['status'];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Edit Document',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          IconButton(
            splashRadius: 20,
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTextField(label: 'Name', controller: _nameController),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildDropdownField(
                      label: 'Category',
                      value: _selectedCategory,
                      items: _categories,
                      onChanged: (v) => setState(() => _selectedCategory = v),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDropdownField(
                      label: 'Client',
                      value: _selectedClient,
                      items: _clients,
                      onChanged: (v) => setState(() => _selectedClient = v),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildTextField(label: 'Retention Period')),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDropdownField(
                      label: 'Retention Action',
                      value: _selectedRetentionAction,
                      items: _retentionActions,
                      onChanged: (v) =>
                          setState(() => _selectedRetentionAction = v),
                    ),
                  ),
                ],
              ),
              _buildTextField(
                label: 'Description',
                controller: _descriptionController,
                maxLines: 2,
              ),
              _buildDropdownField(
                label: 'Document Status',
                value: _selectedStatus,
                items: _statuses,
                onChanged: (v) => setState(() => _selectedStatus = v),
              ),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryRed,
            foregroundColor: Colors.white,
          ),
          child: const Text('Save'),
          onPressed: () {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Changes saved!')));
          },
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    TextEditingController? controller,
    int? maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: value,
            isExpanded: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
            ),
            hint: const Text('Select'),
            items: items
                .map(
                  (String item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(item, overflow: TextOverflow.ellipsis),
                  ),
                )
                .toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

// Dialog for sharing a document
class ShareDocumentDialog extends StatefulWidget {
  final String documentName;
  const ShareDocumentDialog({Key? key, required this.documentName})
    : super(key: key);

  @override
  _ShareDocumentDialogState createState() => _ShareDocumentDialogState();
}

class _ShareDocumentDialogState extends State<ShareDocumentDialog> {
  final List<_SharedUser> _sharedList = [];
  late List<_SharedUser> _filteredList;
  final TextEditingController _filterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredList = _sharedList;
    _filterController.addListener(_filterUsers);
  }

  void _filterUsers() {
    final query = _filterController.text.toLowerCase();
    setState(() {
      _filteredList = _sharedList.where((user) {
        return user.name.toLowerCase().contains(query) ||
            user.email.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _addUser() {
    setState(() {
      _sharedList.insert(
        0,
        _SharedUser(
          'New User',
          'user@example.com',
          'User',
          true,
          '2025-10-08',
          '2025-11-08',
        ),
      );
      _filterUsers();
    });
  }

  void _addRole() {
    setState(() {
      _sharedList.insert(
        0,
        _SharedUser(
          'Viewer Role',
          'role@example.com',
          'Role',
          false,
          '2025-10-08',
          'N/A',
        ),
      );
      _filterUsers();
    });
  }

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      titlePadding: const EdgeInsets.fromLTRB(24, 16, 12, 0),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Share Document',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          IconButton(
            splashRadius: 20,
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(),
              const SizedBox(height: 12),
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: [
                    const TextSpan(
                      text: 'Document Name: ',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    TextSpan(text: widget.documentName),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryRed,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Assign/share with users'),
                    onPressed: _addUser,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryRed,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Assign/share with roles'),
                    onPressed: _addRole,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _filterController,
                decoration: const InputDecoration(
                  hintText: 'Filter',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 20,
                  columns: const [
                    DataColumn(label: Text('Action')),
                    DataColumn(label: Text('Type')),
                    DataColumn(label: Text('Allow Download')),
                    DataColumn(label: Text('User/Role Name')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Start Date')),
                    DataColumn(label: Text('End Date')),
                  ],
                  rows: _filteredList
                      .map(
                        (user) => DataRow(
                          cells: [
                            DataCell(
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                onPressed: () => setState(() {
                                  _sharedList.remove(user);
                                  _filterUsers();
                                }),
                              ),
                            ),
                            DataCell(Text(user.type)),
                            DataCell(
                              Checkbox(
                                value: user.allowDownload,
                                onChanged: (val) =>
                                    setState(() => user.allowDownload = val!),
                              ),
                            ),
                            DataCell(Text(user.name)),
                            DataCell(Text(user.email)),
                            DataCell(Text(user.startDate)),
                            DataCell(Text(user.endDate)),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
              if (_filteredList.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text("No users or roles have been assigned."),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Data model for a shared user/role
class _SharedUser {
  _SharedUser(
    this.name,
    this.email,
    this.type,
    this.allowDownload,
    this.startDate,
    this.endDate,
  );
  final String name;
  final String email;
  final String type;
  bool allowDownload;
  final String startDate;
  final String endDate;
}

// Dialog for Document Signature
class DocumentSignatureDialog extends StatefulWidget {
  const DocumentSignatureDialog({Key? key}) : super(key: key);

  @override
  _DocumentSignatureDialogState createState() =>
      _DocumentSignatureDialogState();
}

class _DocumentSignatureDialogState extends State<DocumentSignatureDialog> {
  final TextEditingController _signatureController = TextEditingController();
  String? _fileName;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _fileName = result.files.single.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      titlePadding: const EdgeInsets.all(0),
      title: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Document Signature',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            IconButton(
              splashRadius: 20,
              icon: const Icon(Icons.close, size: 20),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Add Your Signature',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _signatureController,
                maxLines: 4,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ElevatedButton.icon(
                      onPressed: () => _signatureController.clear(),
                      icon: const Icon(Icons.delete, size: 16),
                      label: const Text('Clear'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text('Or', style: TextStyle(color: Colors.grey)),
              ),
              const SizedBox(height: 16),
              const Text(
                'Upload Your Signature',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _pickFile,
                    child: const Text('Choose File'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _fileName ?? 'No file chosen',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      actions: <Widget>[
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          icon: const Icon(Icons.save, size: 18),
          label: const Text('Save'),
          onPressed: () {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Signature saved!')));
          },
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          icon: const Icon(Icons.cancel, size: 18),
          label: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

// Dialog for uploading a new version of a file
class UploadNewVersionDialog extends StatefulWidget {
  const UploadNewVersionDialog({Key? key}) : super(key: key);

  @override
  _UploadNewVersionDialogState createState() => _UploadNewVersionDialogState();
}

class _UploadNewVersionDialogState extends State<UploadNewVersionDialog> {
  String? _fileName;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _fileName = result.files.single.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      titlePadding: const EdgeInsets.all(0),
      title: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                Text(
                  'Upload New Version file',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 4),
                Icon(Icons.help_outline, color: Colors.grey, size: 18),
              ],
            ),
            IconButton(
              splashRadius: 20,
              icon: const Icon(Icons.close, size: 20, color: Colors.red),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Document Upload',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: _pickFile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text(
                    'Choose File',
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _fileName ?? 'No file chosen',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      actions: <Widget>[
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          icon: const Icon(Icons.save, size: 18),
          label: const Text('Save'),
          onPressed: () {
            Navigator.of(context).pop();
            // Add save logic here
          },
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          icon: const Icon(Icons.cancel, size: 18),
          label: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

class ConfirmDeleteDialog extends StatelessWidget {
  const ConfirmDeleteDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      titlePadding: const EdgeInsets.fromLTRB(16, 16, 8, 0),
      contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            child: Text(
              "Are you sure you want to delete?",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.close, color: Colors.red, size: 26),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "By deleting the document, it will no longer be accessible in the future, and the following data will be deleted from the system:",
            style: TextStyle(color: Colors.red, fontSize: 15),
          ),
          SizedBox(height: 18),
          Text("• Version History", style: TextStyle(fontSize: 16)),
          Text("• Meta Tags", style: TextStyle(fontSize: 16)),
          Text("• Comment", style: TextStyle(fontSize: 16)),
          Text("• Notifications", style: TextStyle(fontSize: 16)),
          Text("• Reminders", style: TextStyle(fontSize: 16)),
          Text("• Permisssions", style: TextStyle(fontSize: 16)),
        ],
      ),
      actions: [
        ElevatedButton.icon(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.check_circle, color: Colors.white),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          label: const Text("Yes"),
        ),
        ElevatedButton.icon(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.cancel, color: Colors.white),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          label: const Text("Cancel"),
        ),
      ],
    );
  }
}

// Dialog for displaying the version history of a file
class VersionHistoryDialog extends StatefulWidget {
  final String fileName;
  const VersionHistoryDialog({Key? key, required this.fileName})
    : super(key: key);

  @override
  _VersionHistoryDialogState createState() => _VersionHistoryDialogState();
}

class _VersionHistoryDialogState extends State<VersionHistoryDialog> {
  String? _fileName;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _fileName = result.files.single.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      titlePadding: const EdgeInsets.all(0),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      title: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      "${widget.fileName}'s Version History",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.help_outline, color: Colors.grey, size: 18),
                ],
              ),
            ),
            IconButton(
              splashRadius: 20,
              icon: const Icon(Icons.close, size: 20, color: Colors.red),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Document Upload',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: _pickFile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      elevation: 0,
                    ),
                    child: const Text(
                      'Choose File',
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _fileName ?? 'No file chosen',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 20,
                headingRowHeight: 40,
                columns: const [
                  DataColumn(label: Text('Created Date')),
                  DataColumn(label: Text('Added By')),
                  DataColumn(label: Text('Signed By')),
                  DataColumn(label: Text('Sign Date')),
                  DataColumn(label: Text('Action')),
                ],
                rows: [
                  DataRow(
                    cells: [
                      const DataCell(Text('15/10/2025 14:56:21')),
                      const DataCell(Text('Admin .')),
                      const DataCell(Text('')), // Signed By
                      const DataCell(Text('')), // Sign Date
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Current Version',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.save),
          label: const Text('Save'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.cancel),
          label: const Text('Cancel'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}

// Dialog for confirming archive action
class ConfirmArchiveDialog extends StatelessWidget {
  final String fileName;
  const ConfirmArchiveDialog({Key? key, required this.fileName})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      contentPadding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      actionsPadding: const EdgeInsets.only(right: 16, bottom: 12),
      title: const Text(
        "Are you sure you want to archive?",
        style: TextStyle(
          color: Color(0xFFD32F2F), // Deep red color
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      content: Text(
        fileName,
        style: const TextStyle(fontSize: 14, color: Colors.black54),
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
      actions: [
        ElevatedButton.icon(
          onPressed: () => Navigator.of(context).pop(true),
          icon: const Icon(Icons.check, size: 18),
          label: const Text("Yes"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => Navigator.of(context).pop(false),
          icon: const Icon(Icons.cancel_outlined, size: 18),
          label: const Text("Cancel"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}

// NEW: Dialog for adding a reminder
class AddReminderDialog extends StatefulWidget {
  const AddReminderDialog({Key? key}) : super(key: key);

  @override
  _AddReminderDialogState createState() => _AddReminderDialogState();
}

class _AddReminderDialogState extends State<AddReminderDialog> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  bool _repeatReminder = false;
  bool _sendEmail = false;

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat(
      'MM/dd/yyyy hh:mm a',
    ).format(DateTime.now());
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
        builder: (context, child) {
          return Theme(
            data: redDialogTheme,
            child: child!,
          );
        }
    );
    if (picked != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
          builder: (context, child) {
            return Theme(
              data: redDialogTheme,
              child: child!,
            );
          }
      );
      if (time != null) {
        final DateTime finalDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          time.hour,
          time.minute,
        );
        setState(() {
          _dateController.text = DateFormat(
            'MM/dd/yyyy hh:mm a',
          ).format(finalDateTime);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Add Reminder',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Subject'),
            const SizedBox(height: 4),
            TextField(
              controller: _subjectController,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            const Text('Message'),
            const SizedBox(height: 4),
            TextField(
              controller: _messageController,
              maxLines: 3,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            Row(
              children: [
                Checkbox(
                  value: _repeatReminder,
                  onChanged: (bool? value) {
                    setState(() {
                      _repeatReminder = value!;
                    });
                  },
                ),
                const Text('Repeat Reminder'),
                const Spacer(),
                Checkbox(
                  value: _sendEmail,
                  onChanged: (bool? value) {
                    setState(() {
                      _sendEmail = value!;
                    });
                  },
                ),
                const Text('Send Email'),
                const SizedBox(width: 10),
              ],
            ),
            const Text('Reminder Date'),
            const SizedBox(height: 4),
            TextField(
              controller: _dateController,
              readOnly: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () => _selectDate(context),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: const Text('Save'),
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
        ElevatedButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}

// NEW: Dialog for adding a comment
class CommentDialog extends StatelessWidget {
  final String fileName;
  const CommentDialog({Key? key, required this.fileName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              "$fileName's Comment",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      content: const TextField(
        maxLines: 5,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter your comment here...',
        ),
      ),
      actions: <Widget>[
        ElevatedButton.icon(
          icon: const Icon(Icons.send),
          label: const Text('Add Comment'),
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.cancel),
          label: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}

// NEW: Dialog for sending an email
class SendEmailDialog extends StatelessWidget {
  final String attachmentName;
  const SendEmailDialog({Key? key, required this.attachmentName})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Send Email',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const TextField(
              decoration: InputDecoration(
                labelText: 'To',
                hintText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Subject',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            const Text('Body'),
            const SizedBox(height: 4),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        const Text('Paragraph'),
                        const VerticalDivider(),
                        IconButton(
                          icon: const Icon(Icons.format_bold),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.format_italic),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  const TextField(
                    maxLines: 6,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text('Attachment Document :: $attachmentName'),
          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: const Text('Send'),
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
