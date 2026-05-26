import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:project_1_prm/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    HttpOverrides.global = _TestHttpOverrides();
  });

  tearDown(() {
    HttpOverrides.global = null;
  });

  testWidgets('renders the reader app shell', (WidgetTester tester) async {
    await tester.pumpWidget(const ScientificPaperReaderApp());
    await tester.pumpAndSettle();

    expect(find.text('Scientific Paper Reader'), findsOneWidget);
    expect(find.text('Documents & Topics'), findsOneWidget);
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
  final Uri url;
  _MockHttpClientRequest(this.url);

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<HttpClientResponse> close() async {
    return _MockHttpClientResponse(
      statusCode: 200,
      body: utf8.encode('[]'),
    );
  }
}

class _MockHttpClientResponse extends Stream<List<int>> implements HttpClientResponse {
  final int _statusCode;
  final List<int> body;

  _MockHttpClientResponse({
    required int statusCode,
    required this.body,
  }) : _statusCode = statusCode;

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
