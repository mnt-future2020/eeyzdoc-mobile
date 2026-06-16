import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class FileWebViewViewer extends StatelessWidget {
  final String url;

  const FileWebViewViewer({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    print("Viewing: $url");

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "View Document",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(url)),
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
          allowsInlineMediaPlayback: true,
          supportZoom: true,
          useShouldOverrideUrlLoading: true,
        ),
      ),
    );
  }
}
