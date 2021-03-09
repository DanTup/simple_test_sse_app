import 'dart:html';

import 'package:sse/client/sse_client.dart';

void main() {
  var output = document.querySelector('#output');
  var channel = SseClient('/sseHandler');

  channel.stream.listen((s) {
    final msg = 'Client heard $s!';
    output.innerHtml += '<== $s<br />==> $msg<br />';
    channel.sink.add(msg);
  });
}
