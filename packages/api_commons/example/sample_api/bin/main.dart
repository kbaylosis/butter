import 'dart:async' as a;

import 'package:butter_api_commons/butter_api_commons.dart';
import 'package:sample_api/channel.dart';

Future main(List<String> args) =>
    a.runZoned(() async => BaseChannel.initApp<TestChannel>(args: args));
