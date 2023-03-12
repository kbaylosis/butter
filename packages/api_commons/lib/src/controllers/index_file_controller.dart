import 'dart:async';
import 'dart:io';

import 'package:conduit_core/conduit_core.dart';

class IndexFileController extends Controller {
  IndexFileController(this.revision);

  final String revision;

  @override
  FutureOr<RequestOrResponse> handle(Request request) async {
    if (request.method != 'GET') {
      return Response.badRequest();
    }

    final file = File('public/index.html');
    final contents = file.readAsStringSync();
    return Response.ok(contents.replaceAll('@@@revision@@@', revision))
      ..contentType = ContentType.html;
  }
}
