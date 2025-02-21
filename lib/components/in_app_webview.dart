import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';

class InAppWebViewPage extends StatelessWidget {
  final String url;

  const InAppWebViewPage({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebView'),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(url)),
        onLoadStop: (controller, newUrl) async {
          if (newUrl != null &&
              newUrl.toString().startsWith('com.example.fatcherappv2://')) {
            context.pop(newUrl.toString());
          }
        },
      ),
    );
  }
}
