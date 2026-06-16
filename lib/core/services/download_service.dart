import 'dart:async';
import 'package:background_downloader/background_downloader.dart';
import 'package:docuflow/constants/PreferenceUtils.dart';
import 'package:docuflow/core/constants/app_constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
class DownloadItem {
  final String taskId;
  final String filename;
  TaskStatus status;        // ✅ remove final
  double progress;          // ✅ remove final
  final int? expectedFileSize;
  final String filePath;

  DownloadItem({
    required this.taskId,
    required this.filename,
    required this.status,
    required this.progress,
    this.expectedFileSize,
    required this.filePath,
  });

  bool get isCompleted => status == TaskStatus.complete;
  bool get isRunning => status == TaskStatus.running;
  bool get isFailed => status == TaskStatus.failed;
  bool get isCanceled => status == TaskStatus.canceled;
}

class DownloadService {
  static final DownloadService _instance = DownloadService._internal();
  factory DownloadService() => _instance;
  DownloadService._internal();

  bool _initialized = false;

  final Map<String, DownloadItem> _downloads = {};

  final _downloadsController = StreamController<List<DownloadItem>>.broadcast();
  Stream<List<DownloadItem>> get downloadsStream => _downloadsController.stream;

  void _emit() {
    _downloadsController.add(_downloads.values.toList());
  }
  void _listenToUpdates() {
    FileDownloader().updates.listen((update) {
      final taskId = update.task.taskId;
      final item = _downloads[taskId];
      if (item == null) return;

      if (update is TaskStatusUpdate) {
        item.status = update.status;
      }

      if (update is TaskProgressUpdate) {
        item.progress = update.progress;
      }

      _emit();
    });
  }

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    _listenToUpdates();

    await FileDownloader().trackTasks();
    FileDownloader().start();

    FileDownloader().updates.listen((update) {
      switch (update) {
        case TaskStatusUpdate():
          _handleStatus(update);
        case TaskProgressUpdate():
          _handleProgress(update);
      }
    });

    FileDownloader().configureNotification(
      running: TaskNotification('Downloading…', '{filename} - {progress}'),
      complete: TaskNotification('Done', '{filename}'),
      error: TaskNotification('Failed', '{filename}'),
      progressBar: true,
    );
  }

  void _handleStatus(TaskStatusUpdate update) {
    final old = _downloads[update.task.taskId];

    final updated = DownloadItem(
      taskId: update.task.taskId,
      filename: update.task.filename,
      status: update.status,
      progress: update.status == TaskStatus.complete ? 1.0 : old?.progress ?? 0.0,
      expectedFileSize: old?.expectedFileSize,
      filePath: old?.filePath ?? '', // preserve the path
    );

    _downloads[update.task.taskId] = updated;
    _emit();
  }

  void _handleProgress(TaskProgressUpdate update) {
    final old = _downloads[update.task.taskId];

    final updated = DownloadItem(
      taskId: update.task.taskId,
      filename: update.task.filename,
      status: old?.status ?? TaskStatus.running,
      progress: update.progress,
      expectedFileSize: update.expectedFileSize,
      filePath: old?.filePath ?? '', // preserve path
    );

    _downloads[update.task.taskId] = updated;
    _emit();
  }


  List<DownloadItem> get currentDownloads => _downloads.values.toList();

  Future<String?> enqueueDownload({
    required String url,
    required String filename,
  }) async {
    await init();
    final token = PreferenceUtils.getString(AppConstants.AUTH_TOKEN);

    final dir = await getApplicationDocumentsDirectory();
    final filePath = p.join(dir.path, 'docuflow_files', filename);

    final task = DownloadTask(
      url: url,
      filename: filename,
      directory: 'docuflow_files',
      baseDirectory: BaseDirectory.applicationDocuments,
      updates: Updates.statusAndProgress,
      headers: {'Accept': '*/*', "Authorization": "Bearer $token"},
      displayName: filename,
      retries: 3,
      allowPause: true,
    );

    final ok = await FileDownloader().enqueue(task);
    if (!ok) return null;

    _downloads[task.taskId] = DownloadItem(
      taskId: task.taskId,
      filename: filename,
      status: TaskStatus.enqueued,
      progress: 0.0,
      filePath: filePath, // store full path here
    );

    _emit();
    return task.taskId;
  }


  Future<void> pause(String taskId) async {
    final record = await FileDownloader().database.recordForId(taskId);
    if (record != null) {
      await FileDownloader().pause(record.task as DownloadTask);
    }
  }

  Future<void> resume(String taskId) async {
    final record = await FileDownloader().database.recordForId(taskId);
    if (record != null) {
      await FileDownloader().resume(record.task as DownloadTask);
    }
  }

  Future<void> cancel(String taskId) async {
    await FileDownloader().cancelTasksWithIds([taskId]);
  }

  Future<void> delete(String taskId) async {
    await FileDownloader().cancelTasksWithIds([taskId]);
    await FileDownloader().database.deleteRecordWithId(taskId);

    _downloads.remove(taskId);
    _emit();
  }
}
