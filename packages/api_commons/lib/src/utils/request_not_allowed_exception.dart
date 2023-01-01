import 'package:conduit/conduit.dart';

class RequestNotAllowedException<T> implements HandlerException {
  RequestNotAllowedException(
    this.error, {
    this.message,
    this.notFound = false,
  });

  RequestNotAllowedException.code(
    T code, {
    this.message,
    this.notFound = false,
  }) : error = code.toString();

  final String? error;
  final String? message;
  final bool notFound;

  @override
  Response get response => notFound
      ? Response.notFound(body: {
          'error': error,
          'message': message,
        })
      : Response.badRequest(body: {
          'error': error,
          'message': message,
        });

  @override
  String toString() => error!;
}
