import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as p;

class SingleFilePicker extends StatefulWidget {
  final File? file;
  final ValueChanged<File?> onChanged;

  const SingleFilePicker({
    super.key,
    required this.file,
    required this.onChanged,
  });

  @override
  _SingleFilePickerState createState() => _SingleFilePickerState();
}

class _SingleFilePickerState extends State<SingleFilePicker> {
  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);

    if (result != null && result.files.single.path != null) {
      widget.onChanged(File(result.files.single.path!));
    }
  }

  void removeFile() {
    widget.onChanged(null);
  }

  void openFile() {
    if (widget.file != null) {
      OpenFilex.open(widget.file!.path);
    }
  }

  IconData getFileIcon(File file) {
    final ext = file.path.split('.').last.toLowerCase();
    if (ext == "pdf") return Icons.picture_as_pdf;
    if (["xls", "xlsx"].contains(ext)) return Icons.table_chart;
    if (["jpg", "png", "jpeg", "bmp", "gif"].contains(ext)) return Icons.photo;
    if (ext == "csv") return Icons.grid_on;
    if (["doc", "docx"].contains(ext)) return Icons.description;
    return Icons.insert_drive_file;
  }

  @override
  Widget build(BuildContext context) {
    final file = widget.file;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: file == null ? pickFile : openFile,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 100,
            width: 100,
            alignment: Alignment.center, // ensure child is centered
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: isDark ? Colors.grey[700]! : Colors.grey.shade300),
            ),
            child: file == null
                ? Icon(
              Icons.attach_file,
              size: 40,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            )
                : Stack(
              alignment: Alignment.center, // <-- this ensures children are centered
              children: [
                Container(
                  height: 100, // same as parent
                  width: 100,
                  alignment: Alignment.center,
                  child: Icon(
                    getFileIcon(file),
                    size: 40,
                    color: isDark ? Colors.teal[300] : Colors.blueGrey,
                  ),
                ),
                Positioned(
                  right: 4,
                  top: 4,
                  child: GestureDetector(
                    onTap: removeFile,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark ? Colors.white24 : Colors.black54,
                      ),
                      child: Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (file != null)
            Text(
              p.basename(file.path),
              style: TextStyle(
                color: theme.textTheme.bodyMedium!.color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }
}
