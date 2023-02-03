void printStacktrace() {
  try {
    throw Exception();
  } catch (e, stack) {
    // ignore: avoid_print
    print('[STACK] - $stack');
  }
}
