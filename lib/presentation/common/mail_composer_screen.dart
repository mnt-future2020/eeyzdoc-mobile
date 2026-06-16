import 'dart:convert';
import 'package:docuflow/data/models/request/mail_request.dart';
import 'package:docuflow/presentation/documents/controllers/document_details_controller.dart';
import 'package:docuflow/presentation/documents/controllers/documents_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class MailComposerScreen extends StatefulWidget {
  const MailComposerScreen({super.key});

  @override
  State<MailComposerScreen> createState() => _MailComposerScreenState();
}

enum HeadingLevel { h1, h2, h3, paragraph }

extension HeadingLevelExt on HeadingLevel {
  String get tag {
    switch (this) {
      case HeadingLevel.paragraph:
        return 'p';
      case HeadingLevel.h1:
        return 'h1';
      case HeadingLevel.h2:
        return 'h2';
      case HeadingLevel.h3:
        return 'h3';
    }
  }

  String get label {
    switch (this) {
      case HeadingLevel.paragraph:
        return 'Normal';
      case HeadingLevel.h1:
        return 'Heading 1';
      case HeadingLevel.h2:
        return 'Heading 2';
      case HeadingLevel.h3:
        return 'Heading 3';
    }
  }

  double get fontSize {
    switch (this) {
      case HeadingLevel.paragraph:
        return 16;
      case HeadingLevel.h1:
        return 28;
      case HeadingLevel.h2:
        return 24;
      case HeadingLevel.h3:
        return 20;
    }
  }

  FontWeight get fontWeight {
    switch (this) {
      case HeadingLevel.paragraph:
        return FontWeight.normal;
      case HeadingLevel.h1:
        return FontWeight.bold;
      case HeadingLevel.h2:
        return FontWeight.bold;
      case HeadingLevel.h3:
        return FontWeight.bold;
    }
  }
}

class TextSpanFormat {
  TextSpanFormat({
    this.headingLevel = HeadingLevel.paragraph,
    this.bold = false,
    this.italic = false,
  });

  HeadingLevel headingLevel;
  bool bold;
  bool italic;

  TextSpanFormat copyWith({
    HeadingLevel? headingLevel,
    bool? bold,
    bool? italic,
  }) {
    return TextSpanFormat(
      headingLevel: headingLevel ?? this.headingLevel,
      bold: bold ?? this.bold,
      italic: italic ?? this.italic,
    );
  }
}

class _MailComposerScreenState extends State<MailComposerScreen> {
  final toCtrl = TextEditingController();
  final subjectCtrl = TextEditingController();
  final bodyCtrl = TextEditingController();
  final DocumentDetailsController controller =
      Get.find<DocumentDetailsController>();
  final DocumentsController documentController =
      Get.find<DocumentsController>();

  HeadingLevel _currentHeadingLevel = HeadingLevel.paragraph;
  bool _bold = false;
  bool _italic = false;

  final FocusNode _bodyFocusNode = FocusNode();
  final List<TextSelection> _selections = [];

  @override
  void dispose() {
    toCtrl.dispose();
    subjectCtrl.dispose();
    bodyCtrl.dispose();
    _bodyFocusNode.dispose();
    super.dispose();
  }

  void _applyFormatToSelection() {
    final selection = bodyCtrl.selection;
    if (!selection.isValid || selection.isCollapsed) {
      setState(() {});
      return;
    }

    final text = bodyCtrl.text;
    final selectedText = selection.textInside(text);

    setState(() {});
  }

  void _applyFormatToAllText(
    HeadingLevel? headingLevel,
    bool? bold,
    bool? italic,
  ) {
    setState(() {
      if (headingLevel != null) _currentHeadingLevel = headingLevel;
      if (bold != null) _bold = bold;
      if (italic != null) _italic = italic;
    });
    _applyFormatToSelection();
  }

  String _escapeHtml(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#39;');
  }

  String _buildHtmlMessage() {
    final text = bodyCtrl.text.trim();
    if (text.isEmpty) return '';
    final paragraphs = text.split('\n');
    final buffer = StringBuffer();

    for (final paragraph in paragraphs) {
      if (paragraph.isEmpty) continue;

      String inner = _escapeHtml(paragraph);

      if (_bold) inner = "<strong>$inner</strong>";
      if (_italic) inner = "<i>$inner</i>";

      buffer.write(
        "<${_currentHeadingLevel.tag}>$inner</${_currentHeadingLevel.tag}>",
      );
    }

    return buffer.toString();
  }

  void _sendEmail() async {
    final htmlMessage = _buildHtmlMessage();

    final MailRequest request = MailRequest(
      documentId: documentController.selectedDocumentId.value,
      email: toCtrl.text.trim(),
      subject: subjectCtrl.text.trim(),
      message: htmlMessage,
    );

    final bool mailSent = await controller.sendMail(request);

    if (!mounted) return;

    if (!mailSent) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to send email.")));
      return;
    }

    final bool auditLogged = await documentController.operationMailAPi(
      documentId: documentController.selectedDocumentId.value,
    );

    if (!mounted) return;

    if (auditLogged) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Email sent successfully.")));
      GoRouter.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to log email operation.")),
      );
    }
  }

  Widget _inputField({
    required String label,
    required TextEditingController controller,
    TextInputType type = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
    );
  }

  Widget _buildFormattingToolbar() {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            DropdownButton<HeadingLevel>(
              value: _currentHeadingLevel,
              onChanged: (v) {
                if (v == null) return;
                _applyFormatToAllText(v, null, null);
              },
              items: HeadingLevel.values
                  .map((t) => DropdownMenuItem(value: t, child: Text(t.label)))
                  .toList(),
            ),
            const SizedBox(width: 10),
            IconButton(
              icon: Icon(
                Icons.format_bold,
                color: _bold ? Colors.blue : Colors.grey,
              ),
              onPressed: () => _applyFormatToAllText(null, !_bold, null),
              tooltip: 'Bold',
            ),

            IconButton(
              icon: Icon(
                Icons.format_italic,
                color: _italic ? Colors.blue : Colors.grey,
              ),
              onPressed: () => _applyFormatToAllText(null, null, !_italic),
              tooltip: 'Italic',
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Compose Email",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => GoRouter.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendEmail,
            tooltip: 'Send',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _inputField(
              label: "To",
              controller: toCtrl,
              type: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            _inputField(label: "Subject", controller: subjectCtrl),
            const SizedBox(height: 15),

            Row(
              children: [
                const Text(
                  "Body",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),

            _buildFormattingToolbar(),

            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: bodyCtrl,
                    focusNode: _bodyFocusNode,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: const InputDecoration(
                      hintText: "Type your message here...",
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      fontSize: _currentHeadingLevel.fontSize,
                      fontWeight: _bold
                          ? FontWeight.bold
                          : _currentHeadingLevel.fontWeight,
                      fontStyle: _italic ? FontStyle.italic : FontStyle.normal,
                    ),
                    onChanged: (_) {},
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
