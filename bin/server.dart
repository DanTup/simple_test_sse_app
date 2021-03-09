import 'dart:async';

import 'package:shelf/shelf_io.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_static/shelf_static.dart';
import 'package:sse/server/sse_handler.dart';

void main() async {
  var sseHandler = SseHandler(Uri.parse('/sseHandler'));

  sseHandler.connections.rest.listen((connection) {
    print('Got connection from client! Pinging every 1s...');
    connection.stream.listen((s) => print('<== $s'));
    Timer.periodic(const Duration(seconds: 1), (_) {
      print('==> ping');
      connection.sink.add('ping');
    });
  });

  var handler = Cascade()
      .add(sseHandler.handler)
      .add(createStaticHandler('web', defaultDocument: 'index.html'))
      .handler;

  var server = await serve(handler, 'localhost', 8080);

  print('Serving at http://${server.address.host}:${server.port}');
}
