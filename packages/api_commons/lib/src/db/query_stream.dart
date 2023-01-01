import 'package:conduit/conduit.dart';

Stream<List<T>> queryStream<T extends ManagedObject>(int limit,
    {List<T>? details, Query<T>? query}) async* {
  if (details == null) {
    if (query != null) {
      List<T> results = [];
      int offset = 0;
      do {
        results = await (query
              ..fetchLimit = limit
              ..offset = offset)
            .fetch();
        yield results;
        offset += limit;
      } while (results.isNotEmpty);
    }
  } else {
    yield details;
    if (details.isNotEmpty) {
      yield [];
    }
  }
}
