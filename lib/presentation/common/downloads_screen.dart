import 'package:flutter/material.dart';
import 'package:background_downloader/background_downloader.dart';
import 'package:docuflow/core/services/download_service.dart';
import 'package:open_filex/open_filex.dart' show OpenFilex, ResultType;
import '../../core/utils/scaffold_message.dart';

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});

  String _status(TaskStatus status) {
    switch (status) {
      case TaskStatus.running:
        return "Downloading";
      case TaskStatus.paused:
        return "Paused";
      case TaskStatus.complete:
        return "Completed";
      case TaskStatus.failed:
        return "Failed";
      case TaskStatus.canceled:
        return "Canceled";
      case TaskStatus.waitingToRetry:
        return "Retrying...";
      case TaskStatus.enqueued:
        return "Queued";
      default:
        return status.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = DownloadService();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Downloads',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
      body: StreamBuilder<List<DownloadItem>>(
        stream: service.downloadsStream,
        initialData: service.currentDownloads,
        builder: (context, snapshot) {
          final items = snapshot.data ?? [];

          if (items.isEmpty) {
            return const Center(child: Text("No downloads"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: items.length,
            itemBuilder: (_, i) {
              final item = items[i];
              final progress = item.progress.clamp(0.0, 1.0);
              final percent = (progress * 100).toStringAsFixed(0);

              Color statusColor;
              switch (item.status) {
                case TaskStatus.complete:
                  statusColor = Colors.green;
                  break;
                case TaskStatus.failed:
                  statusColor = Colors.red;
                  break;
                case TaskStatus.paused:
                  statusColor = Colors.orange;
                  break;
                default:
                  statusColor = Colors.blue;
              }

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // File Name + Status Badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.filename,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 10,),
                          Container(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _status(item.status),
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Gradient Progress Bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 8,
                          backgroundColor: Colors.grey.shade300,
                          valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.redAccent.shade400),
                        ),
                      ),

                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "$percent%",
                          style: const TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Action Buttons
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          if (item.isRunning)
                            _btn(label: "Pause", color: Colors.orange, onTap: () => service.pause(item.taskId)),
                          if (item.status == TaskStatus.paused)
                            _btn(label: "Resume", color: Colors.blue, onTap: () => service.resume(item.taskId)),
                          if (!item.isCompleted)
                            _btn(label: "Cancel", color: Colors.red, onTap: () => service.cancel(item.taskId)),
                          if (item.isCompleted)
                            _btn(label: "Open", color: Colors.green, onTap: () async {
                              final filePath = item.filePath;
                              if (filePath.isEmpty) {
                                ScaffoldMessageShow.show('File path not found');
                                return;
                              }
                               print("File Path : $filePath");
                              final result = await OpenFilex.open(filePath);

                              if (result.type != ResultType.done) {

                                ScaffoldMessageShow.show('Unable to open');

                              }
                            }),
                          _btn(label: "Delete", color: Colors.grey, onTap: () => service.delete(item.taskId)),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _btn({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 36,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 2,
        ),
        onPressed: onTap,
        child: Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }


}
