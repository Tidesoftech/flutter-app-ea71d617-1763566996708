import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(P.A.T.SApp());
}

class P.A.T.SApp extends StatelessWidget {
  final String initialUrl = 'https://p-a-t-s.com';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'P.A.T.S',
      theme: ThemeData(
        primarySwatch: MaterialColor(
          0xFF2563eb,
          <int, Color>{
            50: Color(0xFF2563eb),
            100: Color(0xFF2563eb),
            200: Color(0xFF2563eb),
            300: Color(0xFF2563eb),
            400: Color(0xFF2563eb),
            500: Color(0xFF2563eb),
            600: Color(0xFF2563eb),
            700: Color(0xFF2563eb),
            800: Color(0xFF2563eb),
            900: Color(0xFF2563eb),
          },
        ),
      ),
      home: WebViewWrapper(initialUrl: initialUrl),
    );
  }
}

class WebViewWrapper extends StatefulWidget {
  final String initialUrl;
  WebViewWrapper({required this.initialUrl});

  @override
  _WebViewWrapperState createState() => _WebViewWrapperState();
}

class _WebViewWrapperState extends State<WebViewWrapper> {
  late final WebViewController _controller;
  bool _canGoBack = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) async {
            bool canBack = await _controller.canGoBack();
            setState(() {
              _canGoBack = canBack;
              _isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.initialUrl));
  }

  Future<void> _reload() async {
    await _controller.reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('P.A.T.S'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _reload,
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      floatingActionButton: _canGoBack
          ? FloatingActionButton(
              onPressed: () async {
                if (await _controller.canGoBack()) {
                  await _controller.goBack();
                }
              },
              child: Icon(Icons.arrow_back),
              tooltip: 'Back',
            )
          : null,
    );
  }
}