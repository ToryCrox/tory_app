import 'package:flutter/material.dart';
import 'package:tory_base/app/logger.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CommonWebViewPage extends StatefulWidget {
  const CommonWebViewPage({
    super.key,
    required this.url,
  });

  final String url;

  @override
  State<CommonWebViewPage> createState() => _CommonWebViewPageState();
}

class _CommonWebViewPageState extends State<CommonWebViewPage> {
  late final WebViewController _controller;

  String title = '';

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      // ：JS 执行模式（是否允许 JS 执行），默认为JavascriptMode.disable只能执行静态页面，设置为JavascriptMode.unrestricted即可解决；
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onUrlChange: _onUrlChange,
          onProgress: _onProgressChanged,
          onPageStarted: _onPageStarted,
          onPageFinished: _onPageFinished,
          onWebResourceError: _onWebResourceError,
          onNavigationRequest: _onNavigationRequest,
        ),
      );
    final uri = Uri.tryParse(widget.url);
    if (uri != null) {
      _controller.loadRequest(uri);
    }
  }

  void _onUrlChange(UrlChange change) {
    logger.d('_onUrlChange url: ${change.url}');
  }

  void _onProgressChanged(int progress) {
    logger.d('progress: $progress');
  }

  void _onPageStarted(String url) {
    logger.d('_onPageStarted url: $url');
  }

  Future _onPageFinished(String url) async {
    logger.d('_onPageFinished url: $url');
    title = (await _controller.getTitle()) ?? '';
  }

  void _onWebResourceError(WebResourceError error) {
    final msg =
        '_onWebResourceError: url: ${error.url}, isForMainFrame: ${error.isForMainFrame}'
        ' errorCode: ${error.errorCode}, '
        'description: ${error.description}, errorType: ${error.errorType}';
    if (error.isForMainFrame == true) {
      logger.e(msg);
    } else {
      logger.w(msg);
    }
  }

  NavigationDecision _onNavigationRequest(NavigationRequest request) {
    final uri = Uri.tryParse(request.url);
    logger.d(
        '_onNavigationRequest: isMainFrame: ${request.isMainFrame}, url:${request.url}, isUri: ${uri != null}');
    if (uri == null) {
      return NavigationDecision.prevent;
    }
    return NavigationDecision.navigate;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await _controller.canGoBack()) {
          _controller.goBack();
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Stack(
          children: [
            //_buildLoading(),
            WebViewWidget(controller: _controller),
          ],
        ),
      ),
    );
  }
}
