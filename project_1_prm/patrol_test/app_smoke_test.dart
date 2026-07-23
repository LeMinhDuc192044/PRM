import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:project_1_prm/main.dart';

void main() {
  setUp(() {
    HttpOverrides.global = _TestHttpOverrides();
  });

  tearDown(() {
    HttpOverrides.global = null;
  });

  patrolTest('renders reader shell and auth entry point', ($) async {
    await $.pumpWidgetAndSettle(const ScientificPaperReaderApp());

    expect($('Scientific Paper Reader'), findsWidgets);
    expect($('Documents & Topics'), findsOneWidget);
    expect($('Sign in'), findsOneWidget);
  });

  patrolTest('opens notification center from app bar', ($) async {
    await $.pumpWidgetAndSettle(const ScientificPaperReaderApp());

    await $(find.byTooltip('Notifications')).tap();
    await $.pumpAndSettle();

    expect($('Notification Center'), findsOneWidget);
    expect($('FCM Token'), findsOneWidget);
    expect($('No notifications yet'), findsOneWidget);
  });
}

class _TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _MockHttpClient();
  }
}

class _MockHttpClient implements HttpClient {
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<HttpClientRequest> getUrl(Uri url) async {
    return _MockHttpClientRequest(url);
  }
}

class _MockHttpClientRequest implements HttpClientRequest {
  _MockHttpClientRequest(this.url);

  final Uri url;

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<HttpClientResponse> close() async {
    return _MockHttpClientResponse(statusCode: 200, body: utf8.encode('[]'));
  }
}

class _MockHttpClientResponse extends Stream<List<int>>
    implements HttpClientResponse {
  _MockHttpClientResponse({required int statusCode, required this.body})
    : _statusCode = statusCode;

  final int _statusCode;
  final List<int> body;

  @override
  int get contentLength => body.length;

  @override
  int get statusCode => _statusCode;

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.fromIterable(<List<int>>[body]).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
